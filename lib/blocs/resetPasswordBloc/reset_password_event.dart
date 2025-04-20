abstract class ResetPasswordEvent {}

class SendResetPasswordEmailEvent extends ResetPasswordEvent {
  final String email;

  SendResetPasswordEmailEvent(this.email);
}
