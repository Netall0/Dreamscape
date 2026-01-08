import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dreamscape/core/util/bloc/bloc_transformers.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/features/auth/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> with LoggerMixin {
  final AuthRepository _authRepository;
  late StreamSubscription _authSubscription;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthInitial()) {
    _authSubscription = authRepository.getAuthStateChanges().listen(
      (user) => add(AuthUserChanged(user)),
    );

    on<AuthEvent>((event, emit) {
      return switch (event) {
        AuthChechRequested() => _authChechRequested(event, emit),
        AuthSignInRequested() => _authSignInRequested(event, emit),
        AuthSignUpRequested() => _authSignUpRequested(event, emit),
        AuthLogoutRequested() => _authLogoutRequested(event, emit),
        AuthUserChanged() => _onAuthUserChanged(event, emit),
      };
    }, transformer: BlocTransformer.sequential());
  }

  void _onAuthUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    final user = event.user;
    user != null
        ? emit(AuthAuthenticated(user: user))
        : emit(AuthUnauthenticated());
  }

  Future<void> _authLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
    } on Object catch (e) {
      emit(AuthError(errorMessage: e.toString()));
    }
  }

  Future<void> _authSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.signUpWithEmail(event.email, event.password);
    } on Object catch (e) {
      emit(AuthError(errorMessage: e.toString()));
    }
  }

  Future<void> _authSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.signInWithEmail(event.email, event.password);
    } on Object catch (e) {
      emit(AuthError(errorMessage: e.toString()));
    }
  }

  Future<void> _authChechRequested(
    AuthChechRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = _authRepository.getCurrentUser();
      user == null
          ? emit(AuthUnauthenticated())
          : emit(AuthAuthenticated(user: user));
    } on Object catch (e, st) {
      logger.error('Error in _authChechRequested: $e', stackTrace: st);
      emit(AuthError(errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
