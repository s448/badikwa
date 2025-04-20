abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthLoginSuccessState extends AuthState {}

class AuthFailureState extends AuthState {
  final String? message;
  AuthFailureState({this.message});
}
