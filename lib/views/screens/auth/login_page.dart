import 'package:badikwa/blocs/authBloc/auth_bloc.dart';
import 'package:badikwa/blocs/authBloc/auth_event.dart';
import 'package:badikwa/blocs/authBloc/auth_state.dart';
import 'package:badikwa/core/routes.dart';
import 'package:badikwa/core/utils/app_messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoginSuccessState) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else if (state is AuthFailureState) {
            appMessageShower("Failed to login", "try again");
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  final email = _emailController.text.trim();
                  final password = _passwordController.text.trim();
                  if (email.isNotEmpty && password.isNotEmpty) {
                    context.read<AuthBloc>().add(
                      AuthLoginRequestedEvent(email: email, password: password),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill in all fields')),
                    );
                  }
                },
                child: Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.signup);
                },
                child: Text('Don\'t have an account? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
