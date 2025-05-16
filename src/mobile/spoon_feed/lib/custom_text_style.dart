import 'package:flutter/material.dart';

class CustomTextStyle extends StatelessWidget {
  const CustomTextStyle({
    super.key,
    required this.text,
    this.textAlign = TextAlign.left,
  });
  final String text;
  final TextAlign textAlign;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    );
  }
}
