import 'package:flutter/material.dart';
import 'package:prufcoach/core/utils/colors.dart';
import 'package:prufcoach/views/widgets/buttons.dart';
import 'package:prufcoach/views/widgets/decorations.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  bool _passwordVisibility = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set New Password'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
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
                  (v) =>
                      v != _passwordController.text
                          ? "Passwords does not match"
                          : null,
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              child: const Text(
                'Set New Password',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                // Handle new password submission
                // For example, you can call a function to update the password
                // and navigate to the login page or show a success message.
                print("New password set: ${_passwordController.text}");
              },
            ),
          ],
        ),
      ),
    );
  }
}
