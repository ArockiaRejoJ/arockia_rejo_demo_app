import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String? _email;

  // Getter for checking if the user is authenticated
  bool get isAuth {
    return email != null;
  }

  // Getter for email
  String? get email {
    if (_email != null) {
      return _email;
    }
    return null;
  }

  // Function for user signup
  Future signup(String email, String password) async {
    try {
      // Create a new user with Firebase Auth
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _email = credential.user!.email;

      // Store user data locally
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'userEmail': _email,
      });
      prefs.setString('userData', userData);
      notifyListeners();
      return;
    } on FirebaseAuthException catch (e) {
      // Error handling for signup process
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        throw 'The account already exists for that email';
      }
    } catch (e) {
      rethrow;
    }
  }

  // Function for user sign-in
  Future signIn(String email, String password) async {
    try {
      // Sign in existing user with Firebase Auth
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _email = credential.user!.email;

      // Store user data locally
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'userEmail': _email,
      });
      prefs.setString('userData', userData);
      notifyListeners();
      return;
    } on FirebaseAuthException catch (e) {
      // Error handling for sign-in process
      if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        throw 'Wrong password provided for that user.';
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Function to attempt auto-login based on saved data
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    // Retrieve stored user data and set email
    final extractedUserData = json.decode(prefs.getString('userData')!);
    _email = extractedUserData['userEmail'] as String?;
    notifyListeners();
    return true;
  }

  // Logout from the device and clear stored data
  Future<void> logout() async {
    // Set the email to null (user is logged out)
    _email = null;
    notifyListeners(); // Notify listeners that the email has been cleared

    // Get an instance of SharedPreferences to access the stored data
    final prefs = await SharedPreferences.getInstance();

    // Remove stored categories and their timestamp from SharedPreferences
    prefs.remove('categories');
    prefs.remove('categoriesTimestamp');

    // Remove stored products and their timestamp from SharedPreferences
    prefs.remove('products');
    prefs.remove('productsTimestamp');

    // Clear all data from SharedPreferences (logging out completely)
    prefs.clear();
  }
}
