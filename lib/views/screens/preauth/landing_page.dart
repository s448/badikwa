import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prufcoach/blocs/authBloc/auth_bloc.dart';
import 'package:prufcoach/blocs/authBloc/auth_state.dart';
import 'package:prufcoach/core/routes.dart';
import 'package:prufcoach/core/utils/colors.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoginSuccessState) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Image.asset(
              "assets/illusts/landing.png",
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
            GestureDetector(
              onTap:
                  () =>
                      Navigator.pushReplacementNamed(context, AppRoutes.login),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: EdgeInsets.all(16),
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryGreen, width: 1),
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.transparent,
                  ),
                  child: Text(
                    "Anmelden",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          ],
        ),
      ),
    );
  }
}
