import 'package:badikwa/core/utils/colors.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const PrimaryButton({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.tealBlue,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
