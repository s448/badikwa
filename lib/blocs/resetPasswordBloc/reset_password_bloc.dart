import 'package:badikwa/blocs/resetPasswordBloc/reset_password_event.dart';
import 'package:badikwa/blocs/resetPasswordBloc/reset_password_state.dart';
import 'package:badikwa/data/auth_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordBloc<T>
    extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final AuthData _authData = AuthData();

  ResetPasswordBloc() : super(ResetPasswordInitial()) {
    on<SendResetPasswordEmailEvent>((event, emit) async {
      emit(ResetPasswordLoading());
      try {
        final result = await _authData.sendResetPasswordEmail(event.email);
        if (result.success == true) {
          emit(ResetPasswordSuccess());
        } else {
          emit(ResetPasswordError(result.message ?? "An error occurred."));
        }
      } catch (e) {
        emit(ResetPasswordError("An error occurred: $e"));
      }
    });
  }
}
