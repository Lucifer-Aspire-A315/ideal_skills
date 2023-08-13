import 'package:flutter/material.dart';
import 'package:ideal_skills/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _user;
  final AuthMethods _authMethods = AuthMethods();
  Map<String, dynamic> get getUser => _user!;

  Future<void> refreshUser() async {
    Map<String, dynamic>? user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}

// class UserProvider with ChangeNotifier {
//   User? _user;
//   final AuthMethods _authMethods = AuthMethods();
//   User get getUser => _user!;

//   Future<void> refreshUser() async {
//     User? user = await _authMethods.getUserDetails();
//     _user = user;
//     notifyListeners();
//   }
// }
