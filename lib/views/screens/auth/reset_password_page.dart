import 'package:badikwa/blocs/resetPasswordBloc/reset_password_bloc.dart';
import 'package:badikwa/blocs/resetPasswordBloc/reset_password_event.dart';
import 'package:badikwa/blocs/resetPasswordBloc/reset_password_state.dart';
import 'package:badikwa/core/utils/app_messages.dart';
import 'package:badikwa/views/widgets/buttons.dart';
import 'package:badikwa/views/widgets/decorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password")),
      body: BlocProvider(
        create: (context) => ResetPasswordBloc(),
        child: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
          listener: (context, state) {
            if (state is ResetPasswordSuccess) {
              appMessageShower(
                context,
                "Reset mail is sent",
                "Check your email to reset your password",
              );
            } else if (state is ResetPasswordError) {
              appMessageShower(context, "Error", state.message);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    TextFormField(
                      controller: _emailController,
                      decoration: AppInputDecorations.inputField(
                        hintText: 'Email address',
                        icon: Icons.email_outlined,
                      ),
                      validator: (v) => v!.isEmpty ? "Enter your email" : null,
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap:
                          () => {
                            if (_formKey.currentState!.validate())
                              {
                                BlocProvider.of<ResetPasswordBloc>(context).add(
                                  SendResetPasswordEmailEvent(
                                    _emailController.text,
                                  ),
                                ),
                              },
                          },
                      child: PrimaryButton(
                        child:
                            state is ResetPasswordLoading
                                ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                                : Text(
                                  "Reset password",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
