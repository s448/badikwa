import 'package:badikwa/blocs/createAccountBloc/create_acc_bloc.dart';
import 'package:badikwa/blocs/createAccountBloc/create_acc_event.dart';
import 'package:badikwa/blocs/createAccountBloc/create_acc_state.dart';
import 'package:badikwa/core/routes.dart';
import 'package:badikwa/core/utils/app_messages.dart';
import 'package:badikwa/core/utils/colors.dart';
import 'package:badikwa/models/user_model.dart';
import 'package:badikwa/views/widgets/buttons.dart';
import 'package:badikwa/views/widgets/decorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    var uid = Uuid().v4();
    if (_formKey.currentState!.validate()) {
      context.read<CreateAccBloc>().add(
        SignupRequested(
          user: User(
            uid,
            _emailController.text,
            _passwordController.text,
            _fullNameController.text,
            _phoneController.text,
          ),
        ),
      );
    }
  }

  bool _passwordVisibility = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<CreateAccBloc, CreateAccState>(
        listener: (context, state) {
          if (state is CreateAccSuccessState) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else if (state is CreateAccFailedState) {
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
            child: ListView(
              children: [
                SizedBox(
                  child: Image.asset(
                    "assets/logo.jpg",
                    height: MediaQuery.of(context).size.width * 0.6,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                TextFormField(
                  controller: _fullNameController,
                  decoration: AppInputDecorations.inputField(
                    hintText: 'Full Name',
                    icon: Icons.person_outline_outlined,
                  ),
                  validator: (v) => v!.isEmpty ? "Enter name" : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: AppInputDecorations.inputField(
                    hintText: 'Phone Number',
                    icon: Icons.phone_outlined,
                  ),
                  validator:
                      (v) =>
                          !RegExp(r'^\d{10,15}$').hasMatch(v!)
                              ? "Invalid phone number"
                              : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: AppInputDecorations.inputField(
                    hintText: 'Email address',
                    icon: Icons.email_outlined,
                  ),
                  validator:
                      (v) =>
                          !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v!)
                              ? "Invalid email"
                              : null,
                ),
                SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  decoration: AppInputDecorations.inputField(
                    hintText: 'Password',
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
                SizedBox(height: 32),
                GestureDetector(
                  onTap: () {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();
                    if (email.isNotEmpty && password.isNotEmpty) {
                      context.read<CreateAccBloc>().add(
                        SignupRequested(
                          user: User(
                            Uuid().v4(),
                            _emailController.text,
                            _passwordController.text,
                            _fullNameController.text,
                            _phoneController.text,
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
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                                : Text(
                                  "Sign up",
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
                SizedBox(height: 12),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.login,
                          );
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(color: AppColors.skyBlue),
                        ),
                      ),
                    ],
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
}
