import 'package:flutter/material.dart';
import 'package:spoonfeed_customer/footer.dart';
import 'package:spoonfeed_customer/navigation_menu.dart';

class MainLayout extends StatefulWidget {
  final Widget widget;
  final String currentCity;
  final Function(String) onChangeCity;
  final String? userName;
  final Function(int?) logout;

  const MainLayout({
    super.key,
    required this.widget,
    required this.currentCity,
    required this.onChangeCity,
    this.userName,
    required this.logout,
  });

  @override
  State<StatefulWidget> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xFFEAB045)),
        child: Column(
          children: [
            NavigationMenu(
              onChange: widget.onChangeCity,
              city: widget.currentCity,
              userName: widget.userName,
              logout: widget.logout,
            ),
            Expanded(child: widget.widget),
            Footer(),
          ],
        ),
      ),
    );
  }
}
