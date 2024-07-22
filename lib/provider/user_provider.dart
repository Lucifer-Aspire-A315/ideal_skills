import 'package:flutter/material.dart';
import 'package:ideal_skills/resources/auth_methods.dart';
import 'package:ideal_skills/models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  // Getter for the user object with null check
  User? get getUser => _user;

  // Method to refresh the user details
  Future<void> refreshUser() async {
    try {
      User? user = await _authMethods.getUserDetails();
      if (user != null) {
        _user = user;
        notifyListeners();
      } else {
        print("No user is currently signed in.");
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }
}
