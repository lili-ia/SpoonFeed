import 'package:flutter/material.dart';

class AuthLayout extends StatefulWidget {
  final Widget widget;

  const AuthLayout({super.key, required this.widget});

  @override
  State<StatefulWidget> createState() => _AuthLayoutState();
}

class _AuthLayoutState extends State<AuthLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: widget.widget,
      ),
    );
  }
}
