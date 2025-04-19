import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../data/auth_data.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthData authData = AuthData();

  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequestedEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final result = await authData.loginWithEmailAndPassword(
          event.email,
          event.password,
        );
        if (result == true) {
          emit(AuthLoginSuccessState());
        } else {
          emit(AuthFailureState());
        }
      } catch (e) {
        emit(AuthFailureState());
      }
    });
  }
}
