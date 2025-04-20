import 'dart:async';
import 'dart:developer';
import 'package:badikwa/core/utils/app_messages.dart';
import 'package:badikwa/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthData {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<({bool success, String? message})> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        return (
          success: false,
          message: "User not found. Please check your credentials.",
        );
      }
      return (success: true, message: "User logged in successfully");
    } on FirebaseAuthException catch (e) {
      log('Login failed: ${e.message}');
      return (
        success: false,
        message: e.message ?? "Authentication error occurred.",
      );
    } catch (e) {
      log('An error occurred: $e');
      return (success: false, message: "Unexpected error: ${e.toString()}");
    }
  }

  Future<({bool success, String? message})> registerAndLoginUser(
    User user,
  ) async {
    try {
      // Check if phone number already exists
      final phoneQuery =
          await FirebaseFirestore.instance
              .collection('users')
              .where('phoneNumber', isEqualTo: user.phoneNumber)
              .get();

      if (phoneQuery.docs.isNotEmpty) {
        return (success: false, message: "Phone number is already registered.");
      }
      //create user
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: user.email,
            password: user.password,
          );
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        return (
          success: false,
          message: "User creation failed. Please try again.",
        );
      }
      // Save user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.id).set({
        'name': user.name,
        'phoneNumber': user.phoneNumber,
        'email': user.email,
        'password': user.password,
        'id': user.id,
      });
      return (success: true, message: "User created successfully");
    } on FirebaseAuthException catch (e) {
      log('Registration failed: ${e.message}');
      return (
        success: false,
        message: e.message ?? "Authentication error occurred.",
      );
    } catch (e) {
      log('An error occurred: $e');
      return (success: false, message: "Unexpected error: ${e.toString()}");
    }
  }

  bool checkAutoLogin() {
    final currentUser = FirebaseAuth.instance.currentUser;
    log(currentUser?.uid ?? "No user logged in");
    return currentUser != null;
  }

  Future<({bool success, String? message})> sendResetPasswordEmail(
    String email,
  ) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return (success: true, message: "Password reset email sent.");
    } catch (e) {
      log('Error sending password reset email: $e');
      return (success: false, message: cleanFirebaseMessage(e.toString()));
    }
  }

  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      log('Error signing out: $e');
      return false;
    }
  }
}
