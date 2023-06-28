import 'package:flutter/material.dart';

import '../resources/auth_methods.dart';
import '../utils/colors.dart';
import '../widgets/text_field_input.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => SigninPageState();
}

class SigninPageState extends State<SigninPage> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _biocontroller = TextEditingController();
  final TextEditingController _usernamecontroller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _biocontroller.dispose();
    _usernamecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),

              //Logo Image

              Image.asset(
                "assets/login_pg.jpeg",
                // color: primaryColor,
                height: 64,
              ),
              const SizedBox(
                height: 64,
              ),
              //Circular Avatar
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage("assets/login_pg.jpeg"),
                  ),
                  Positioned(
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.cameraswitch),
                      color: blueColor,
                    ),
                    bottom: -10,
                    left: 100,
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ), //Text field input for username
              TextFieldInput(
                texteditingcontroller: _usernamecontroller,
                hintText: "Enter Your UserName",
                textinputtype: TextInputType.name,
              ),
              const SizedBox(
                height: 25,
              ),

              //Text field input for Email

              TextFieldInput(
                texteditingcontroller: _emailcontroller,
                hintText: "Enter Your Email",
                textinputtype: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 25,
              ),
              //Text field input for Password
              TextFieldInput(
                texteditingcontroller: _passwordcontroller,
                hintText: "Enter Your Password",
                textinputtype: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(
                height: 25,
              ),
              //Text field input for bio
              TextFieldInput(
                texteditingcontroller: _biocontroller,
                hintText: "Enter Your Bio",
                textinputtype: TextInputType.multiline,
              ),
              const SizedBox(
                height: 25,
              ),
              //Button
              InkWell(
                onTap: () async {
                  String res = await AuthMethods().signUpUser(
                      email: _emailcontroller.text,
                      password: _passwordcontroller.text,
                      username: _usernamecontroller.text,
                      bio: _biocontroller.text);
                },
                child: Container(
                  child: const Text("Sign Up"),
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
                    onTap: () {},
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
                  const SizedBox(
                    height: 25,
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
