abstract class ResetPasswordEvent {}

class SendResetPasswordEmailEvent extends ResetPasswordEvent {
  final String email;

  SendResetPasswordEmailEvent(this.email);
}

class VerifyOtpEvent extends ResetPasswordEvent {
  final String otp;
  final String email;
  VerifyOtpEvent(this.email, this.otp);
}

class ResetPasswordEventWithNewPassword extends ResetPasswordEvent {
  final String newPassword;
  final String email;

  ResetPasswordEventWithNewPassword(this.email, this.newPassword);
}
