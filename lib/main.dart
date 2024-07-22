import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ideal_skills/pages/login_page.dart';
import 'package:ideal_skills/provider/user_provider.dart';
import 'package:ideal_skills/responsive/mobile_screen_layout.dart';
import 'package:ideal_skills/responsive/responsive_layout.dart';
import 'package:ideal_skills/responsive/web_screen_layout.dart';
import 'package:ideal_skills/utils/colors.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        title: 'ideal_skills',
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            // If the user is authenticated, fetch user details
            Provider.of<UserProvider>(context, listen: false).refreshUser();
            return const ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          );
        }

        return const LoginPage();
      },
    );
  }
}




// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:ideal_skills/pages/login_page.dart';
// import 'package:ideal_skills/provider/user_provider.dart';
// import 'package:ideal_skills/responsive/mobile_screen_layout.dart';
// import 'package:ideal_skills/responsive/responsive_layout.dart';
// import 'package:ideal_skills/responsive/web_screen_layout.dart';
// import 'package:ideal_skills/utils/colors.dart';
// import 'package:provider/provider.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   if (kIsWeb) {
//     await Firebase.initializeApp(
//       options: const FirebaseOptions(
//         apiKey: "AIzaSyBVg47YBeR9hCKgfCqxRfhWlVctLtf9J_c",
//         appId: "1:315339841884:web:0d26558dd1ce533361e199",
//         messagingSenderId: "315339841884",
//         projectId: "ideal-skills",
//         storageBucket: "ideal-skills.appspot.com",
//       ),
//     );
//     // await FirebaseFirestore.instance
//     //     .enablePersistence(const PersistenceSettings(synchronizeTabs: true));
//   } else {
//     await Firebase.initializeApp();
//     // await FirebaseFirestore.setLoggingEnabled(true);
//     // FirebaseFirestore.instance.settings.persistenceEnabled;
//   }
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//         providers: [
//           ChangeNotifierProvider(
//             create: (_) => UserProvider(),
//           ),
//         ],
//         child: MaterialApp(
//           debugShowCheckedModeBanner: false,
//           theme: ThemeData.dark()
//               .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
//           title: 'ideal_skills ',
//           // home: const ResponsiveLayout(
//           //   webScreenLayout: WebScreenLayout(),
//           //   mobileScreenLayout: MobileScreenLayout(),
//           home: StreamBuilder(
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.active) {
//                   if (snapshot.hasData) {
//                     return const ResponsiveLayout(
//                       webScreenLayout: WebScreenLayout(),
//                       mobileScreenLayout: MobileScreenLayout(),
//                     );
//                   } else if (snapshot.hasError) {
//                     return Center(
//                       child: Text('${snapshot.error}'),
//                     );
//                   }
//                 }
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(
//                     child: CircularProgressIndicator(
//                       color: primaryColor,
//                     ),
//                   );
//                 }

//                 return const LoginPage();
//               },
//               stream: FirebaseAuth.instance.authStateChanges()),
//         ));
//   }


//flutter build web --web-renderer html --release

//flutter run -d chrome --web-renderer html


// for android
//flutter run -d devicename or id
