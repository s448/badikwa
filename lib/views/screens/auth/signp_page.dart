import 'package:badikwa/blocs/createAccountBloc/create_acc_bloc.dart';
import 'package:badikwa/blocs/createAccountBloc/create_acc_event.dart';
import 'package:badikwa/blocs/createAccountBloc/create_acc_state.dart';
import 'package:badikwa/controllers/auth_controller.dart';
import 'package:badikwa/models/user_model.dart';
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

  @override
  Widget build(BuildContext context) {
    AuthController controller = AuthController(context);

    return Scaffold(
      body: BlocListener<CreateAccBloc, CreateAccState>(
        listener: (context, state) => controller.handleSignUpState(state),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(labelText: 'Full Name'),
                  validator: (v) => v!.isEmpty ? "Enter name" : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator:
                      (v) =>
                          !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v!)
                              ? "Invalid email"
                              : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                  validator:
                      (v) =>
                          !RegExp(r'^\d{10,15}$').hasMatch(v!)
                              ? "Invalid phone number"
                              : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator:
                      (v) => v!.length < 6 ? "At least 6 characters" : null,
                ),
                SizedBox(height: 32),
                ElevatedButton(onPressed: _submitForm, child: Text("Sign Up")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
