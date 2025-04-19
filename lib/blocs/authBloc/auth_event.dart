abstract class AuthEvent {}

class AuthLoginEvent extends AuthEvent {}

class AuthLoginRequestedEvent extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequestedEvent({required this.email, required this.password});
}

class AuthForgetPasswordEvent extends AuthEvent {}

class AuthSignUpEvent extends AuthEvent {}
