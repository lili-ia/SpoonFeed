import 'package:flutter/material.dart';
import 'package:courier_app/custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(this.text, this.onClick, {super.key});
  final String text;
  final Function() onClick;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: onClick,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
            child: CustomText(text),
          ),
        ],
      ),
    );
  }
}
