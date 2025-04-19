import 'package:badikwa/blocs/authBloc/auth_state.dart';
import 'package:badikwa/blocs/createAccountBloc/create_acc_state.dart';
import 'package:badikwa/core/routes.dart';
import 'package:badikwa/core/utils/app_messages.dart';
import 'package:badikwa/core/utils/colors.dart';
import 'package:flutter/material.dart';
import '../data/auth_data.dart';

class AuthController {
  final BuildContext context;
  AuthData authData = AuthData();

  AuthController(this.context);

  void handleAuthState(AuthState state) {
    if (state is AuthFailureState) {
    } else if (state is AuthLoginSuccessState) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  void handleSignUpState(CreateAccState state) {
    if (state is CreateAccLoadingState) {
      CircularProgressIndicator(color: AppColors.primaryRed);
    } else if (state is CreateAccFailedState) {
      appMessageShower("Failed to create account", state.msg.toString());
    } else if (state is CreateAccSuccessState) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }
}
