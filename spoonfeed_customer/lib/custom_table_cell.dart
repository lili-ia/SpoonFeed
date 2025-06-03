import 'package:flutter/material.dart';

class CustomTableCell extends StatelessWidget {
  const CustomTableCell({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 600,
      alignment: Alignment.center,
      margin: EdgeInsets.all(5),
      child: Center(child: child),
    );
  }
}
