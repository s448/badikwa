import 'package:badikwa/views/screens/auth/login_page.dart';
import 'package:badikwa/views/screens/auth/signp_page.dart';
import 'package:badikwa/views/screens/home/home_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String signup = '/signup';
  static const String home = '/home';
  static const String login = '/login';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signup:
        return MaterialPageRoute(builder: (_) => SignupPage());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());

      default:
        return MaterialPageRoute(builder: (_) => LoginPage());
    }
  }
}
