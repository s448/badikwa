import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prufcoach/blocs/resetPasswordBloc/reset_password_bloc.dart';
import 'package:prufcoach/blocs/resetPasswordBloc/reset_password_event.dart';
import 'package:prufcoach/blocs/resetPasswordBloc/reset_password_state.dart';
import 'package:prufcoach/core/utils/app_messages.dart';
import 'package:prufcoach/core/utils/colors.dart';
import 'package:prufcoach/views/screens/auth/login_page.dart';
import 'package:prufcoach/views/widgets/buttons.dart';
import 'package:prufcoach/views/widgets/decorations.dart';

class NewPasswordPage extends StatefulWidget {
  final String email;
  const NewPasswordPage({super.key, required this.email});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  bool _passwordVisibility = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Set New Password',
          style: TextStyle(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<ResetPasswordBloc, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => BlocProvider.value(
                      value: BlocProvider.of<ResetPasswordBloc>(context),
                      child: LoginPage(),
                    ),
              ),
            );
            appMessageShower(context, "Success", "Password reset successful.");
            log("Password reset successful for email: ${widget.email}");
            // Navigate to login or show success message
          } else if (state is ResetPasswordError) {
            log("Password reset error: ${state.message}");
            // Show error message
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Create New Password',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your new password must be different from previous passwords.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
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
                TextFormField(
                  decoration: AppInputDecorations.inputField(
                    hintText: 'Passwort bestätigen',
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
                  validator:
                      (v) =>
                          v != _passwordController.text
                              ? "Passwords does not match"
                              : null,
                ),
                const SizedBox(height: 32),
                BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
                  builder: (context, state) {
                    return PrimaryButton(
                      child:
                          state is ResetPasswordLoading
                              ? const CupertinoActivityIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                'Set New Password',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ResetPasswordBloc>().add(
                            ResetPasswordEventWithNewPassword(
                              widget.email,
                              _passwordController.text,
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
