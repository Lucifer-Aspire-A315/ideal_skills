// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController texteditingcontroller;
  final bool isPass;
  final String hintText;
  final TextInputType textinputtype;
  const TextFieldInput({
    Key? key,
    required this.texteditingcontroller,
    this.isPass = false,
    required this.hintText,
    required this.textinputtype,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextField(
      controller: texteditingcontroller,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textinputtype,
      obscureText: isPass,
    );
  }
}
