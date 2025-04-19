abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoginSuccessState extends AuthState {}

class AuthFailureState extends AuthState {
  final String? message;
  AuthFailureState({this.message});
}
