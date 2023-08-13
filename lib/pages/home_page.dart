import 'package:flutter/material.dart';
import 'package:ideal_skills/models/user.dart';
import 'package:ideal_skills/provider/user_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final User usr = Provider.of<UserProvider>(context, listen: false).getUser;

    return Scaffold(
      body: Center(
          // child: Text(usr.photoUrl),
          ),
    );
  }
}
