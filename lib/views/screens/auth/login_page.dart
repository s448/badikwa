import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prufcoach/blocs/authBloc/auth_bloc.dart';
import 'package:prufcoach/blocs/authBloc/auth_event.dart';
import 'package:prufcoach/blocs/authBloc/auth_state.dart';
import 'package:prufcoach/core/routes.dart';
import 'package:prufcoach/core/utils/app_messages.dart';
import 'package:prufcoach/core/utils/colors.dart';
import 'package:prufcoach/views/widgets/buttons.dart';
import 'package:prufcoach/views/widgets/decorations.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _passwordVisibility = true;

  // login attempt management
  static const int maxAttempts = 3;
  static const int cooldownSeconds = 60;
  int _failedAttempts = 0;
  int _remainingCooldown = 0;
  Timer? _timer;

  void _startCooldown() {
    _remainingCooldown = cooldownSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingCooldown <= 0) {
        timer.cancel();
        setState(() {
          _failedAttempts = 0;
          _remainingCooldown = 0;
        });
      } else {
        setState(() {
          _remainingCooldown--;
        });
      }
    });
  }

  void _handleFailure(String message) {
    _failedAttempts++;
    if (_failedAttempts >= maxAttempts) {
      _startCooldown();
      appMessageShower(
        context,
        "Login gesperrt",
        "Zu viele Fehlversuche. Bitte warte 60 Sekunden.",
      );
    } else {
      appMessageShower(
        context,
        "Failed to login",
        "$message (Versuche: $_failedAttempts von $maxAttempts)",
      );
    }
  }

  void _handleSuccess() {
    _failedAttempts = 0;
    _timer?.cancel();
    _remainingCooldown = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    });
  }

  void _onLoginPressed() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte alle Felder ausfüllen')),
      );
      return;
    }
    if (_remainingCooldown > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Bitte warte $_remainingCooldown Sekunden vor erneutem Versuch",
          ),
        ),
      );
      return;
    }
    context.read<AuthBloc>().add(
      AuthLoginRequestedEvent(email: email, password: password),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoginSuccessState) {
            _handleSuccess();
          } else if (state is AuthFailureState) {
            log(state.message.toString());
            _handleFailure(state.message ?? "Unbekannter Fehler");
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

                // logo
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

                // email
                TextField(
                  cursorColor: AppColors.primaryGreen,
                  controller: _emailController,
                  decoration: AppInputDecorations.inputField(
                    hintText: 'E-mail-adresse',
                    icon: Icons.email_outlined,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // password
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
                const SizedBox(height: 15),

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

                // login button
                GestureDetector(
                  onTap: _onLoginPressed,
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoadingState;
                      return PrimaryButton(
                        child:
                            isLoading
                                ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CupertinoActivityIndicator(
                                    radius: 15,
                                    color: Colors.white,
                                  ),
                                )
                                : Text(
                                  _remainingCooldown > 0
                                      ? "Bitte warten ($_remainingCooldown s)"
                                      : "Anmelden",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // show attempts info
                if (_remainingCooldown == 0 && _failedAttempts > 0)
                  Text(
                    "Fehlversuche: $_failedAttempts von $maxAttempts",
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                if (_remainingCooldown > 0)
                  Text(
                    "Login gesperrt für $_remainingCooldown Sekunden",
                    style: const TextStyle(color: Colors.red, fontSize: 13),
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
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Text(
                      "Jetzet Registrieren",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
