import 'package:prufcoach/models/user_model.dart';

abstract class CreateAccState {}

class CreateAccInitialState extends CreateAccState {
  final User? user;
  CreateAccInitialState({this.user});
}

class CreateAccLoadingState extends CreateAccState {}

class CreateAccFailedState extends CreateAccState {
  final String? msg;
  CreateAccFailedState({this.msg});
}

class CreateAccSuccessState extends CreateAccState {}
