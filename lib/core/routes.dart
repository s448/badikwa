import 'package:prufcoach/views/screens/auth/login_page.dart';
import 'package:prufcoach/views/screens/auth/new_password_page.dart';
import 'package:prufcoach/views/screens/auth/otp_verification_page.dart';
import 'package:prufcoach/views/screens/auth/reset_password_page.dart';
import 'package:prufcoach/views/screens/auth/signup_page.dart';
import 'package:prufcoach/views/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:prufcoach/views/screens/preauth/landing_page.dart';

class AppRoutes {
  static const String signup = '/signup';
  static const String home = '/home';
  static const String login = '/login';
  static const String resetpassword = '/resetpassword';
  static const String otp = '/otp-verification';
  static const String newpassword = '/new-password';
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signup:
        return MaterialPageRoute(builder: (_) => SignupPage());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case resetpassword:
        return MaterialPageRoute(builder: (_) => ForgotPasswordPage());
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case otp:
        return MaterialPageRoute(
          builder:
              (_) => OtpVerificationPage(email: settings.arguments as String),
        );
      case newpassword:
        return MaterialPageRoute(
          builder: (_) => NewPasswordPage(email: settings.arguments as String),
        );
      default:
        return MaterialPageRoute(builder: (_) => LandingPage());
    }
  }
}
