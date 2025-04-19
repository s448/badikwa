import 'dart:async';
import 'dart:developer';
import 'package:badikwa/core/utils/app_messages.dart';
import 'package:badikwa/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthData {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      log('Login failed: ${e.message}');
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> registerAndLoginUser(User user) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: user.email,
            password: user.password,
          );

      // Save user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .set({
            'name': user.name,
            'phoneNumber': user.phoneNumber,
            'email': user.email,
            'password': user.password,
            'id': user.id,
          })
          .then((_) {
            appMessageShower(
              "User created successfuly",
              userCredential.credential?.token?.toString() ??
                  "No token available",
            );
          });
      return true;
    } on FirebaseAuthException catch (e) {
      log('Registration failed: ${e.message}');
      return false;
    } catch (e) {
      log('An error occurred: $e');
      return false;
    }
  }
}
