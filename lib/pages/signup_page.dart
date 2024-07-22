import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ideal_skills/pages/login_page.dart';
import 'package:image_picker/image_picker.dart';

import '../resources/auth_methods.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/colors.dart';
import '../utils/image_utils.dart';
import '../widgets/text_field_input.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => SigninPageState();
}

class SigninPageState extends State<SigninPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void signUpUser() async {
    if (_image == null) {
      showSnackBar("Please select an image", context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ResponsiveLayout(
          webScreenLayout: WebScreenLayout(),
          mobileScreenLayout: MobileScreenLayout(),
        ),
      ));
    }
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
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
                height: 40,
              ),
              // Circular Avatar
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 55,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 55,
                          backgroundImage: AssetImage("assets/user_image.jpg"),
                        ),
                  Positioned(
                    bottom: -8,
                    left: 73,
                    child: IconButton(
                      visualDensity: VisualDensity.comfortable,
                      iconSize: 30,
                      onPressed: selectImage,
                      icon: const Icon(Icons.camera_alt_rounded,
                          color: Color.fromARGB(255, 36, 37, 37)),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              // Text field input for username
              TextFieldInput(
                texteditingcontroller: _usernameController,
                hintText: "Enter Your UserName",
                textinputtype: TextInputType.name,
              ),
              const SizedBox(
                height: 25,
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
              // Text field input for bio
              TextFieldInput(
                texteditingcontroller: _bioController,
                hintText: "Enter Your Bio",
                textinputtype: TextInputType.multiline,
              ),
              const SizedBox(
                height: 25,
              ),
              // Button
              InkWell(
                onTap: () => signUpUser(),
                child: Container(
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
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : const Text("Sign Up"),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    child: const Text(
                      "Already have an Account ? ",
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: const Text(
                        "Log In ",
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


// // ignore_for_file: use_build_context_synchronously

// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:ideal_skills/pages/login_page.dart';
// import 'package:image_picker/image_picker.dart';

// import '../resources/auth_methods.dart';
// import '../responsive/mobile_screen_layout.dart';
// import '../responsive/responsive_layout.dart';
// import '../responsive/web_screen_layout.dart';
// import '../utils/colors.dart';
// import '../utils/image_utils.dart';
// import '../widgets/text_field_input.dart';

// class SigninPage extends StatefulWidget {
//   const SigninPage({super.key});

//   @override
//   State<SigninPage> createState() => SigninPageState();
// }

// class SigninPageState extends State<SigninPage> {
//   final TextEditingController _emailcontroller = TextEditingController();
//   final TextEditingController _passwordcontroller = TextEditingController();
//   final TextEditingController _biocontroller = TextEditingController();
//   final TextEditingController _usernamecontroller = TextEditingController();
//   Uint8List? _image;
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     super.dispose();
//     _emailcontroller.dispose();
//     _passwordcontroller.dispose();
//     _biocontroller.dispose();
//     _usernamecontroller.dispose();
//   }

//   void signUpUser() async {
//     setState(() {
//       _isLoading = true;
//     });
//     String res = await AuthMethods().signUpUser(
//       email: _emailcontroller.text,
//       password: _passwordcontroller.text,
//       username: _usernamecontroller.text,
//       bio: _biocontroller.text,
//       file: _image!,
//     );
//     setState(() {
//       _isLoading = false;
//     });

//     if (res != 'success') {
//       showSnackBar(res, context);
//     } else {
//       Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (context) => const ResponsiveLayout(
//                 webScreenLayout: WebScreenLayout(),
//                 mobileScreenLayout: MobileScreenLayout(),
//               )));
//     }
//   }

//   void selectImage() async {
//     Uint8List im = await pickImage(ImageSource.gallery);
//     setState(() {
//       _image = im;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 32),
//           width: double.infinity,
//           child: Column(
//             // crossAxisAlignment: CrossAxisAlignment.center,
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
//                 height: 40,
//               ),
//               //Circular Avatar
//               Stack(
//                 children: [
//                   _image != null
//                       ? CircleAvatar(
//                           radius: 55,
//                           backgroundImage: MemoryImage(_image!),
//                         )
//                       : const CircleAvatar(
//                           radius: 55,
//                           backgroundImage: AssetImage("assets/user_image.jpg"),
//                         ),
//                   Positioned(
//                     bottom: -8,
//                     left: 73,
//                     child: IconButton(
//                       visualDensity: VisualDensity.comfortable,
//                       iconSize: 30,
//                       onPressed: selectImage,
//                       icon: const Icon(Icons.camera_alt_rounded,
//                           color: Color.fromARGB(255, 36, 37, 37)),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 25,
//               ), //Text field input for username
//               TextFieldInput(
//                 texteditingcontroller: _usernamecontroller,
//                 hintText: "Enter Your UserName",
//                 textinputtype: TextInputType.name,
//               ),
//               const SizedBox(
//                 height: 25,
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
//               //Text field input for bio
//               TextFieldInput(
//                 texteditingcontroller: _biocontroller,
//                 hintText: "Enter Your Bio",
//                 textinputtype: TextInputType.multiline,
//               ),
//               const SizedBox(
//                 height: 25,
//               ),
//               //Button
//               InkWell(
//                 onTap: () => signUpUser(),
//                 child: Container(
//                   width: double.infinity,
//                   alignment: Alignment.center,
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   decoration: const ShapeDecoration(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(4),
//                       ),
//                     ),
//                     color: blueColor,
//                   ),
//                   child: _isLoading
//                       ? const Center(
//                           child: CircularProgressIndicator(
//                             color: primaryColor,
//                           ),
//                         )
//                       : const Text("Sign Up"),
//                 ),
//               ),
//               const SizedBox(
//                 height: 25,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 8,
//                     ),
//                     child: const Text(
//                       "Already have an Account ? ",
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => const LoginPage(),
//                       ));
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 8,
//                       ),
//                       child: const Text(
//                         "Log In ",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 25,
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
