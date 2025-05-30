import 'package:flutter/material.dart';
import 'package:spoonfeed_customer/footer.dart';
import 'package:spoonfeed_customer/main_screen.dart';
import 'package:spoonfeed_customer/navigation_menu.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});
  @override
  State<StatefulWidget> createState() {
    return _MainLayoutState();
  }

  List<String> getCities() {
    return ["Kuiv", "Harkiv"];
  }
}

class _MainLayoutState extends State<MainLayout> {
  Widget? _currentScreen;

  void changeScreen(Widget screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  String? currentCity;

  void changeCity(String? city) {
    if (city != null) {
      setState(() {
        currentCity = city;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _currentScreen ??= MainScreen(
      changeScreen: changeScreen,
      currentCity: widget.getCities()[0],
    );
    currentCity ??= widget.getCities()[0];
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: Color(0xFFEAB045)),
          child: Column(
            children: [
              NavigationMenu(
                cities: widget.getCities(),
                changeCity: changeCity,
                changeScreen: changeScreen,
                city: currentCity!,
              ),
              Expanded(child: _currentScreen!),
              Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
