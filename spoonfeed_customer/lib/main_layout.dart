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
  bool autorization = false;
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

  void changeHeaderFooterVisible(bool autorization) {
    setState(() {
      this.autorization = autorization;
    });
  }

  @override
  Widget build(BuildContext context) {
    currentCity ??= widget.getCities()[0];
    _currentScreen ??= MainScreen(
      changeScreen: changeScreen,
      currentCity: currentCity!,
    );

    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: Color(0xFFEAB045)),
          child: Column(
            children: [
              autorization
                  ? SizedBox()
                  : NavigationMenu(
                    cities: widget.getCities(),
                    changeCity: changeCity,
                    changeScreen: changeScreen,
                    city: currentCity!,
                    changeHeaderFooterVisible: changeHeaderFooterVisible,
                  ),
              Expanded(child: _currentScreen!),
              autorization ? SizedBox() : Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
