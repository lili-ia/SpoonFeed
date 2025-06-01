import 'package:flutter/material.dart';
import 'package:spoonfeed_customer/footer.dart';
import 'package:spoonfeed_customer/navigation_menu.dart';

class MainLayout extends StatefulWidget {
  final Widget widget;
  final String currentCity;
  final Function(String) onChangeCity;

  const MainLayout({
    super.key,
    required this.widget,
    required this.currentCity,
    required this.onChangeCity,
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
            ),
            Expanded(child: widget.widget),
            Footer(),
          ],
        ),
      ),
    );
  }
}
