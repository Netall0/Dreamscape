part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {
  const AuthEvent({this.email, this.password, this.user});

  final String? email;
  final String? password;
  final User? user;
}

final class AuthUserChanged extends AuthEvent {
  const AuthUserChanged(this.user);

  @override
  final User? user;

  @override
  int get hashCode => Object.hashAll([user]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AuthUserChanged && user == other.user;
}

final class AuthChechRequested extends AuthEvent {
  const AuthChechRequested({required super.email, required super.password});

  @override
  int get hashCode => Object.hashAll([email, password]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthChechRequested &&
          email == other.email &&
          password == other.password;
}

class AuthSignInRequested extends AuthEvent {
  const AuthSignInRequested({required this.email, required this.password});

  @override
  final String email;

  @override
  final String password;

  @override
  int get hashCode => Object.hashAll([email, password]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthChechRequested &&
          email == other.email &&
          password == other.password;
}

class AuthSignUpRequested extends AuthEvent {
  const AuthSignUpRequested({required this.email, required this.password});

  @override
  final String email;

  @override
  final String password;

  @override
  int get hashCode => Object.hashAll([email, password]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthSignUpRequested &&
          email == other.email &&
          password == other.password;
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();

  @override
  int get hashCode => Object.hashAll([email, password]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthChechRequested &&
          email == other.email &&
          password == other.password;
}
