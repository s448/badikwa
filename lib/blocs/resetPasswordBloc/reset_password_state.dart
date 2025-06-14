abstract class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class SentOtpVerificationSuccess extends ResetPasswordState {
  final String email;

  SentOtpVerificationSuccess(this.email);
}

class OtpVerificationSuccess extends ResetPasswordState {
  final String email;

  OtpVerificationSuccess(this.email);
}

class OtpVerificationError extends ResetPasswordState {
  final String? message;

  OtpVerificationError(this.message);
}

class ResetPasswordSuccess extends ResetPasswordState {}

class ResetPasswordError extends ResetPasswordState {
  final String message;

  ResetPasswordError(this.message);
}
