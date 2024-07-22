import 'package:flutter/material.dart';
import 'package:ideal_skills/pages/signup_page.dart';
import 'package:ideal_skills/utils/image_utils.dart';
import '../resources/auth_methods.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/colors.dart';
import '../widgets/text_field_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (res == "success") {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ResponsiveLayout(
          webScreenLayout: WebScreenLayout(),
          mobileScreenLayout: MobileScreenLayout(),
        ),
      ));
    } else {
      if (!mounted) return;
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              // Logo Image
              Image.asset(
                "assets/login_pg.jpeg",
                height: 64,
              ),
              const SizedBox(
                height: 64,
              ),
              // Text field input for Email
              TextFieldInput(
                texteditingcontroller: _emailController,
                hintText: "Enter Your Email",
                textinputtype: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 25,
              ),
              // Text field input for Password
              TextFieldInput(
                texteditingcontroller: _passwordController,
                hintText: "Enter Your Password",
                textinputtype: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(
                height: 25,
              ),
              // Button
              InkWell(
                onTap: () => loginUser(),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          color: blueColor,
                        ),
                        child: const Text("Log In"),
                      ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    child: const Text(
                      "Don't have an Account ? ",
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SigninPage(),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:ideal_skills/pages/signup_page.dart';
// import 'package:ideal_skills/utils/image_utils.dart';

// import '../resources/auth_methods.dart';
// import '../responsive/mobile_screen_layout.dart';
// import '../responsive/responsive_layout.dart';
// import '../responsive/web_screen_layout.dart';
// import '../utils/colors.dart';
// import '../widgets/text_field_input.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _emailcontroller = TextEditingController();
//   final TextEditingController _passwordcontroller = TextEditingController();
//   bool _isLoading = false;

//   void loginUser() async {
//     setState(() {
//       _isLoading = true;
//     });
//     String res = await AuthMethods().loginUser(
//       email: _emailcontroller.text,
//       password: _passwordcontroller.text,
//     );

//     if (res == "success") {
//       //
//       // ignore: use_build_context_synchronously
//       Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (context) => const ResponsiveLayout(
//                 webScreenLayout: WebScreenLayout(),
//                 mobileScreenLayout: MobileScreenLayout(),
//               )));
//       // Navigator.of(context).pushReplacement(MaterialPageRoute(
//       //   builder: (context) => HomePage(),
//       // ));
//     } else {
//       //
//       // ignore: use_build_context_synchronously
//       showSnackBar(res, context);
//     }
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _emailcontroller.dispose();
//     _passwordcontroller.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 32),
//           width: double.infinity,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Flexible(
//                 flex: 2,
//                 child: Container(),
//               ),

//               //Logo Image

//               Image.asset(
//                 "assets/login_pg.jpeg",
//                 // color: primaryColor,
//                 height: 64,
//               ),
//               const SizedBox(
//                 height: 64,
//               ),

//               //Text field input for Email

//               TextFieldInput(
//                 texteditingcontroller: _emailcontroller,
//                 hintText: "Enter Your Email",
//                 textinputtype: TextInputType.emailAddress,
//               ),
//               const SizedBox(
//                 height: 25,
//               ),
//               //Text field input for Password
//               TextFieldInput(
//                 texteditingcontroller: _passwordcontroller,
//                 hintText: "Enter Your Password",
//                 textinputtype: TextInputType.text,
//                 isPass: true,
//               ),
//               const SizedBox(
//                 height: 25,
//               ),
//               //Button
//               InkWell(
//                 onTap: () => loginUser(),
//                 child: _isLoading
//                     ? const Center(
//                         child: CircularProgressIndicator(
//                           color: primaryColor,
//                         ),
//                       )
//                     : Container(
//                         width: double.infinity,
//                         alignment: Alignment.center,
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         decoration: const ShapeDecoration(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(4),
//                             ),
//                           ),
//                           color: blueColor,
//                         ),
//                         child: const Text("Log In"),
//                       ),
//               ),
//               const Spacer(),

//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 8,
//                     ),
//                     child: const Text(
//                       "Don't have an Account ? ",
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => const SigninPage(),
//                       ));
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 8,
//                       ),
//                       child: const Text(
//                         "Sign In ",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
