import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
    this.validate,
    this.text,
    this._controller, {
    super.key,
    this.obscureText = false,
  });
  final TextEditingController _controller;
  final String? Function(String?) validate;
  final String text;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: TextFormField(
        obscureText: obscureText,
        validator: validate,
        controller: _controller,
        decoration: InputDecoration(
          labelText: text,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 2,
              color: const Color.fromARGB(255, 141, 135, 135),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
