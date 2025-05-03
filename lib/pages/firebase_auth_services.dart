import 'package:firebase_auth/firebase_auth.dart';

import 'toast.dart'; // Assuming showToast is defined here or imported correctly

class FirebaseAuthService {
  // Singleton pattern
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();

  factory FirebaseAuthService() {
    return _instance;
  }

  FirebaseAuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: 'The email address is already in use.');
      } else if (e.code == 'invalid-email') {
        showToast(message: 'Invalid email format.');
      } else if (e.code == 'weak-password') {
        showToast(message: 'The password provided is too weak.');
      } else {
        showToast(message: 'Sign up failed. An error occurred: ${e.code}');
      }
    } catch (e) {
      print('Error during sign up: $e');
      showToast(message: 'Sign up failed. Please try again later.');
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Invalid email or password.');
      } else if (e.code == 'invalid-email') {
        showToast(message: 'Invalid email format.');
      } else {
        showToast(message: 'Sign in failed. An error occurred: ${e.code}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      showToast(message: 'Sign in failed. Please try again later.');
    }
    return null;
  }
}
