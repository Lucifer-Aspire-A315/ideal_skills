import 'package:flutter/material.dart';
import 'package:ideal_skills/pages/login_page.dart';
import 'package:ideal_skills/pages/signup_page.dart';
import 'package:ideal_skills/responsive/mobile_screen_layout.dart';
import 'package:ideal_skills/responsive/responsive_layout.dart';
import 'package:ideal_skills/responsive/web_screen_layout.dart';
import 'package:ideal_skills/utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
      title: 'ideal_skills ',
      // home: const ResponsiveLayout(
      //   webScreenLayout: WebScreenLayout(),
      //   mobileScreenLayout: MobileScreenLayout(),
      home: const SigninPage(),
    );
  }
}
