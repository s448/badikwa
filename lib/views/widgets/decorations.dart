import 'package:flutter/material.dart';

class AppInputDecorations {
  static InputDecoration inputField({
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    VoidCallback? togglePasswordVisibility,
    bool obscureText = false,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(icon, color: Colors.grey.shade600),
      suffixIcon:
          isPassword
              ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey.shade600,
                ),
                onPressed: togglePasswordVisibility,
              )
              : null,
      filled: true,
      fillColor: Colors.grey.shade200,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 18.0,
        horizontal: 16.0,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    );
  }
}
