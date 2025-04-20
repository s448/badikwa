import 'package:another_flushbar/flushbar.dart';
import 'package:badikwa/core/utils/colors.dart';
import 'package:flutter/material.dart';

void appMessageShower(BuildContext context, String title, String subtitle) {
  Flushbar(
    margin: EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(12),
    backgroundColor: AppColors.tealBlue,
    flushbarPosition: FlushbarPosition.TOP,
    animationDuration: Duration(milliseconds: 600),
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInCubic,
    duration: Duration(seconds: 3),
    padding: EdgeInsets.all(24),
    titleText: Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    messageText: Text(
      subtitle,
      style: TextStyle(fontSize: 16, color: Colors.white70),
    ),
  ).show(context);
}

String cleanFirebaseMessage(String rawMessage) {
  // Remove anything between brackets like [firebase_auth/invalid-email]
  return rawMessage.replaceAll(RegExp(r'\[.*?\]\s*'), '');
}
