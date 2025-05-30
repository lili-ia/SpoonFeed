import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onClick,
    required this.text,
    this.backgroundColor = const Color(0xFFF24822),
  });
  final void Function() onClick;
  final String text;
  final Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (onClick),
      style: ElevatedButton.styleFrom(backgroundColor: backgroundColor),
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }
}
