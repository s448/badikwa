import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:prufcoach/blocs/authBloc/auth_bloc.dart';
import 'package:prufcoach/blocs/authBloc/auth_event.dart';
import 'package:prufcoach/blocs/authBloc/auth_state.dart';
import 'package:prufcoach/core/routes.dart';
import 'package:prufcoach/core/utils/app_messages.dart';
import 'package:prufcoach/core/utils/colors.dart';
import 'package:prufcoach/views/widgets/buttons.dart';
import 'package:prufcoach/views/widgets/decorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _passwordVisibility = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoginSuccessState) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else if (state is AuthFailureState) {
            appMessageShower(
              context,
              "Failed to create account",
              "${state.message}",
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                SizedBox(
                  child: Image.asset(
                    "assets/icons/logo.png",
                    height: MediaQuery.of(context).size.width * 0.35,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                Text(
                  "Anmelden",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),

                Text(
                  "Dein Deutsch-Abenteuer wartet, jetzt anmelden!",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryGreen,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                TextField(
                  cursorColor: AppColors.primaryGreen,
                  controller: _emailController,
                  decoration: AppInputDecorations.inputField(
                    hintText: 'E-mail-adresse',
                    icon: Icons.email_outlined,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16),
                TextField(
                  cursorColor: AppColors.primaryGreen,
                  controller: _passwordController,
                  decoration: AppInputDecorations.inputField(
                    hintText: 'Passwort',
                    icon: Icons.password,
                    isPassword: true,
                    togglePasswordVisibility: () {
                      setState(() {
                        _passwordVisibility = !_passwordVisibility;
                      });
                    },
                    obscureText: _passwordVisibility,
                  ),
                  obscureText: _passwordVisibility,
                ),
                SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed:
                        () => Navigator.pushNamed(
                          context,
                          AppRoutes.resetpassword,
                        ),
                    child: Text(
                      "passwort vergessen?",
                      style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();
                    if (email.isNotEmpty && password.isNotEmpty) {
                      context.read<AuthBloc>().add(
                        AuthLoginRequestedEvent(
                          email: email,
                          password: password,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill in all fields')),
                      );
                    }
                  },
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoadingState;
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
                                  "Anmelden",
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
                  "Noch kein konto ?",
                  style: TextStyle(
                    color: AppColors.darkText,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.signup);
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Text(
                      "Jetzet Registrieren",
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
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
