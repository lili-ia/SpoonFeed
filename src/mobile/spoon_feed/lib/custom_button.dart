import 'package:flutter/material.dart';
import 'package:courier_app/custom_text_for_button.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
    this.text,
    this.onClick, {
    super.key,
    this.margin = 30,
    this.opacity = 1,
    this.color = Colors.deepOrange,
  });
  final double margin;
  final String text;
  final double opacity;
  final Color color;
  final Function() onClick;
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: margin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: onClick,
              style: ElevatedButton.styleFrom(backgroundColor: color),
              child: CustomTextForButton(text),
            ),
          ],
        ),
      ),
    );
  }
}
