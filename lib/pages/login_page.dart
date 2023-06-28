import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../widgets/text_field_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              //Button
              InkWell(
                child: Container(
                  child: const Text("Log In"),
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
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: const Text(
                        "Sign In ",
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
