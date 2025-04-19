import 'package:badikwa/models/user_model.dart';

abstract class CreateAccEventInit {}

class SignupRequested extends CreateAccEventInit {
  final User? user;
  SignupRequested({this.user});
}
