import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/util/bloc/bloc_transformers.dart';
import '../../../../core/util/logger/logger.dart';
import '../../repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> with LoggerMixin {

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthInitial()) {
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
  final AuthRepository _authRepository;
  late StreamSubscription _authSubscription;

  void _onAuthUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    final User? user = event.user;
    user != null
        ? emit(AuthAuthenticated(user: user))
        : emit(const AuthUnauthenticated());
  }

  Future<void> _authLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
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
    emit(const AuthLoading());
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
    emit(const AuthLoading());
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
    emit(const AuthLoading());
    try {
      final User? user = _authRepository.getCurrentUser();
      user == null
          ? emit(const AuthUnauthenticated())
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
