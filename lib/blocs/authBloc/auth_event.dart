abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class AuthLoginRequestedEvent extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequestedEvent({required this.email, required this.password});
}

class SignOutEvent extends AuthEvent {}
