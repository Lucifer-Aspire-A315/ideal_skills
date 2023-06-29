import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ideal_skills/pages/login_page.dart';
import 'package:ideal_skills/pages/signup_page.dart';
import 'package:ideal_skills/responsive/mobile_screen_layout.dart';
import 'package:ideal_skills/responsive/responsive_layout.dart';
import 'package:ideal_skills/responsive/web_screen_layout.dart';
import 'package:ideal_skills/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBVg47YBeR9hCKgfCqxRfhWlVctLtf9J_c",
        appId: "1:315339841884:web:0d26558dd1ce533361e199",
        messagingSenderId: "315339841884",
        projectId: "ideal-skills",
        storageBucket: "ideal-skills.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
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
