import 'package:prufcoach/blocs/authBloc/auth_bloc.dart';
import 'package:prufcoach/blocs/authBloc/auth_event.dart';
import 'package:prufcoach/blocs/authBloc/auth_state.dart';
import 'package:prufcoach/blocs/homeBloc/home_bloc.dart';
import 'package:prufcoach/blocs/homeBloc/home_event.dart';
import 'package:prufcoach/core/routes.dart';
import 'package:prufcoach/data/location_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(LocationService())..add(LoadUserLocationEvent()),
      child: Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthInitial) {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            }
          },
          child: Center(
            child: TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(SignOutEvent());
              },
              child: Text("Sign out"),
            ),
          ),
        ),
      ),
    );
  }
}
