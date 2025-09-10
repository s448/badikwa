import 'package:flutter/material.dart';

Widget buildProfileField({
  required String label,
  required String value,
  IconData? icon,
  bool editable = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: value,
          readOnly: !editable,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            isDense: true,
            suffixIcon: icon != null ? Icon(icon, size: 20) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    ),
  );
}
