part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  const AuthState({this.user, this.errorMessage});
  final User? user;
  final String? errorMessage;
}

final class AuthInitial extends AuthState {
  const AuthInitial({super.user, super.errorMessage});
}

final class AuthLoading extends AuthState {
  const AuthLoading({super.user, super.errorMessage});
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.user, super.errorMessage});

  @override
  // TODO: implement user
  final User user;

  @override
  int get hashCode => Object.hashAll([user]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthAuthenticated && user == other.user;
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({super.user, super.errorMessage});
}

final class AuthError extends AuthState {
  const AuthError({super.user, required this.errorMessage});

  @override
  // TODO: implement errorMessage
  final String errorMessage;

  @override
  int get hashCode => Object.hashAll([errorMessage]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthAuthenticated && errorMessage == other.errorMessage;
}
