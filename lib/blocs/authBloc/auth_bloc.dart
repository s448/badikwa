import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../data/auth_data.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthData authData = AuthData();

  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      await authData.validateToken() == true
          ? emit(AuthLoginSuccessState())
          : emit(AuthInitial());
    });
    on<AuthLoginRequestedEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final result = await authData.loginWithEmailAndPassword(
          event.email,
          event.password,
        );
        if (result.success == true) {
          emit(AuthLoginSuccessState());
        } else {
          emit(AuthFailureState(message: result.message));
        }
      } catch (e) {
        emit(AuthFailureState(message: "An error occurred: $e."));
      }
    });
    on<SignOutEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        await authData.signOut();
        emit(AuthInitial());
      } catch (e) {
        emit(AuthFailureState(message: "An error occurred: $e"));
      }
    });
  }
}
