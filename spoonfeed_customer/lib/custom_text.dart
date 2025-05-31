import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.color = Colors.black,
    this.textDecoration = TextDecoration.none,
    this.fontWeight = FontWeight.bold,
    this.backgroundColor,
    this.fontSize = 14,
    this.alignment = Alignment.center,
    this.textAlign = TextAlign.center,
    this.padding = 0,
    this.margin = 0,
  });
  final String text;
  final Color color;
  final TextDecoration textDecoration;
  final FontWeight fontWeight;
  final Color? backgroundColor;
  final double fontSize;
  final Alignment alignment;
  final TextAlign textAlign;
  final double padding;
  final double margin;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: EdgeInsets.all(padding),
      margin: EdgeInsets.all(margin),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          decoration: textDecoration,
          fontWeight: fontWeight,
          backgroundColor: backgroundColor,
          fontSize: fontSize,
        ),
        textAlign: textAlign,
      ),
    );
  }
}
