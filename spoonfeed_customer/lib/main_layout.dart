import 'package:flutter/material.dart';
import 'package:spoonfeed_customer/main_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});
  @override
  State<StatefulWidget> createState() {
    return _MainLayoutState();
  }
}

class _MainLayoutState extends State<MainLayout> {
  Widget? _currentScreen;

  void changeScreen(Widget screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    _currentScreen ??= MainScreen(changeScreen: changeScreen);
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: Color(0xFFEAB045)),
          child: _currentScreen,
        ),
      ),
    );
  }
}
