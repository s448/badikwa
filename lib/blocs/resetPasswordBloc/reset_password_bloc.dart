import 'dart:developer';

import 'package:prufcoach/blocs/resetPasswordBloc/reset_password_event.dart';
import 'package:prufcoach/blocs/resetPasswordBloc/reset_password_state.dart';
import 'package:prufcoach/data/auth_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordBloc<T>
    extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final AuthData _authData = AuthData();
  ResetPasswordBloc() : super(ResetPasswordInitial()) {
    on<SendResetPasswordEmailEvent>((event, emit) async {
      emit(ResetPasswordLoading());
      try {
        final result = await _authData.sendOTPViaEmail(event.email);

        if (result.success == true) {
          emit(SentOtpVerificationSuccess(event.email));
        } else {
          emit(ResetPasswordError(result.message ?? "An error occurred."));
        }
      } catch (e) {
        emit(ResetPasswordError("An error occurred: $e"));
      }
    });
    on<VerifyOtpEvent>((event, emit) async {
      emit(ResetPasswordLoading());
      try {
        final result = await _authData.verifyOTP(event.email, event.otp);
        if (result == true) {
          log("OTP verified successfully for email: ${event.email}");
          emit(OtpVerificationSuccess(event.email));
        } else {
          emit(OtpVerificationError("Invalid OTP."));
        }
      } catch (e) {
        emit(OtpVerificationError("An error occurred: $e"));
      }
    });
    on<ResetPasswordEventWithNewPassword>((event, emit) async {
      emit(ResetPasswordLoading());
      try {
        final result = await _authData.resetPassword(
          event.email,
          event.newPassword,
        );
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
