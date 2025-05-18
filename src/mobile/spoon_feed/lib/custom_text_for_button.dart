import 'package:flutter/material.dart';

class CustomTextForButton extends StatelessWidget {
  const CustomTextForButton(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(color: Colors.white));
  }
}
