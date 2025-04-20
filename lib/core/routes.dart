import 'package:badikwa/blocs/resetPasswordBloc/reset_password_bloc.dart';
import 'package:badikwa/views/screens/auth/login_page.dart';
import 'package:badikwa/views/screens/auth/reset_password_page.dart';
import 'package:badikwa/views/screens/auth/signup_page.dart';
import 'package:badikwa/views/screens/home/home_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String signup = '/signup';
  static const String home = '/home';
  static const String login = '/login';
  static const String resetpassword = '/resetpassword';
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signup:
        return MaterialPageRoute(builder: (_) => SignupPage());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case resetpassword:
        return MaterialPageRoute(builder: (_) => ForgotPasswordPage());
      default:
        return MaterialPageRoute(builder: (_) => LoginPage());
    }
  }
}
