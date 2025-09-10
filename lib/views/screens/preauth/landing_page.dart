import 'package:flutter/cupertino.dart';
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
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/illusts/landing.png",
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                GestureDetector(
                  onTap:
                      () => Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.login,
                      ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryGreen,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.transparent,
                      ),
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          if (state is AuthLoadingState) {
                            return const CupertinoActivityIndicator(
                              radius: 15,
                              color: AppColors.primaryGreen,
                            );
                          } else {
                            return Text(
                              "Anmelden",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryGreen,
                                fontSize: 18,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
