import 'package:flutter/material.dart';
import 'package:ideal_skills/resources/auth_methods.dart';
import 'package:ideal_skills/models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User get getuser => _user!;

  final AuthMethods _authMethods = AuthMethods();

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
