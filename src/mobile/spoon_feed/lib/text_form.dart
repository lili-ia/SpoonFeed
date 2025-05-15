import 'package:flutter/material.dart';

class TextForm extends StatelessWidget {
  const TextForm(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        text,
        style: TextStyle(
          color: const Color.fromARGB(255, 99, 92, 92),
          fontSize: 16,
        ),
      ),
    );
  }
}
