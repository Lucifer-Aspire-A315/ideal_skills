import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final User usr = Provider.of<UserProvider>(context, listen: false).getUser;

    return const Scaffold(
      body: Center(
          // child: Text(usr.photoUrl),
          ),
    );
  }
}
