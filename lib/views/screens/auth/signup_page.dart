import 'dart:developer';

import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:prufcoach/blocs/createAccountBloc/create_acc_bloc.dart';
import 'package:prufcoach/blocs/createAccountBloc/create_acc_event.dart';
import 'package:prufcoach/blocs/createAccountBloc/create_acc_state.dart';
import 'package:prufcoach/core/routes.dart';
import 'package:prufcoach/core/utils/app_messages.dart';
import 'package:prufcoach/core/utils/colors.dart';
import 'package:prufcoach/models/user_model.dart';
import 'package:prufcoach/views/widgets/buttons.dart';
import 'package:prufcoach/views/widgets/decorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _passwordVisibility = true;
  bool _confirmPasswordVisibility = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<CreateAccBloc, CreateAccState>(
        listener: (context, state) {
          if (state is CreateAccSuccessState) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else if (state is CreateAccFailedState) {
            log("Failed to create account: ${state.msg}");
            appMessageShower(
              context,
              "Failed to create account",
              "${state.msg}",
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.038),
                  SizedBox(
                    child: Image.asset(
                      "assets/icons/logo.png",
                      height: MediaQuery.of(context).size.width * 0.3,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),

                  Text(
                    "Registrieren",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),

                  Text(
                    "Dein Deutsch-Abenteuer wartet, jetzt registrieren!",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  TextFormField(
                    controller: _fullNameController,
                    decoration: AppInputDecorations.inputField(
                      hintText: 'Ihr Name',
                      icon: Icons.person_outline_outlined,
                    ),
                    validator: (v) => v!.isEmpty ? "Enter name" : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: AppInputDecorations.inputField(
                      hintText: 'E-Mail-Adresse',
                      icon: Icons.email_outlined,
                    ),
                    validator:
                        (v) =>
                            !RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(v!)
                                ? "Invalid E-Mail-Adresse"
                                : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: AppInputDecorations.inputField(
                      hintText: 'Passwort',
                      icon: Icons.lock_outline_rounded,
                      isPassword: true,
                      togglePasswordVisibility: () {
                        setState(() {
                          _passwordVisibility = !_passwordVisibility;
                        });
                      },
                      obscureText: _passwordVisibility,
                    ),
                    obscureText: _passwordVisibility,
                    validator:
                        (v) => v!.length < 6 ? "At least 6 characters" : null,
                  ),
                  SizedBox(height: 16),

                  TextFormField(
                    decoration: AppInputDecorations.inputField(
                      hintText: 'Passwort bestätigen',
                      icon: Icons.lock_outline_rounded,
                      isPassword: true,
                      togglePasswordVisibility: () {
                        setState(() {
                          _confirmPasswordVisibility =
                              !_confirmPasswordVisibility;
                        });
                      },
                      obscureText: _confirmPasswordVisibility,
                    ),
                    obscureText: _confirmPasswordVisibility,
                    validator:
                        (v) =>
                            v != _passwordController.text
                                ? "Passwords does not match"
                                : null,
                  ),
                  SizedBox(height: 32),
                  GestureDetector(
                    onTap: () {
                      // final email = _emailController.text.trim();
                      // final password = _passwordController.text.trim();
                      if (_formKey.currentState!.validate()) {
                        context.read<CreateAccBloc>().add(
                          SignupRequested(
                            user: User(
                              Uuid().v4(),
                              _emailController.text,
                              _passwordController.text,
                              _fullNameController.text,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill in all fields')),
                        );
                      }
                    },
                    child: BlocBuilder<CreateAccBloc, CreateAccState>(
                      builder: (context, state) {
                        final isLoading = state is CreateAccLoadingState;
                        return PrimaryButton(
                          child:
                              isLoading
                                  ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CupertinoActivityIndicator(
                                      radius: 15,
                                      color: Colors.white,
                                    ),
                                  )
                                  : Text(
                                    "Registrieren",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Text(
                    "Order weiter mit",
                    style: TextStyle(
                      color: AppColors.primaryGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GoogleAuthButton(
                        onPressed: () {},
                        themeMode: ThemeMode.light,
                        materialStyle: ButtonStyle(),
                        style: AuthButtonStyle(
                          iconBackground: Colors.transparent,
                          buttonType: AuthButtonType.icon,
                          iconType: AuthIconType.secondary,
                        ),
                      ),
                      const SizedBox(width: 15),
                      FacebookAuthButton(
                        onPressed: () {},
                        themeMode: ThemeMode.light,
                        materialStyle: ButtonStyle(),
                        style: AuthButtonStyle(
                          iconBackground: Colors.transparent,
                          buttonType: AuthButtonType.icon,
                          iconType: AuthIconType.secondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Text(
                    "Hasu du kein konto ?",
                    style: TextStyle(
                      color: AppColors.darkText,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Text(
                        "Jetzet Anmelden",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
