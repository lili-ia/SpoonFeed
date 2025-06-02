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
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        obscureText: obscureText,
        validator: validate,
        controller: _controller,
        decoration: InputDecoration(
          labelText: text,
          labelStyle: TextStyle(fontSize: 16, color: Colors.black54),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: const Color(0xFFB3B3B3)),
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
