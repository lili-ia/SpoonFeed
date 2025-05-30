import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.color = Colors.black,
    this.textDecoration = TextDecoration.none,
    this.fontWeight = FontWeight.normal,
    this.backgroundColor,
  });
  final String text;
  final Color color;
  final TextDecoration textDecoration;
  final FontWeight fontWeight;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        decoration: textDecoration,
        fontWeight: fontWeight,
        backgroundColor: backgroundColor,
      ),
      textAlign: TextAlign.center,
    );
  }
}
