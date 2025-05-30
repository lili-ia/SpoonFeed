import 'package:flutter/material.dart';
import 'package:spoonfeed_customer/cart_screen.dart';
import 'package:spoonfeed_customer/custom_button.dart';
import 'package:spoonfeed_customer/custom_dropdown_menu.dart';
import 'package:spoonfeed_customer/login_screen.dart';
import 'package:spoonfeed_customer/main_screen.dart';
import 'package:spoonfeed_customer/restaurants_screen.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({
    super.key,
    required this.changeScreen,
    required this.changeCity,
    required this.cities,
    required this.city,
  });
  final void Function(Widget) changeScreen;
  final void Function(String?) changeCity;
  final List<String> cities;
  final String city;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset("images/spoonfeed_logo.png"),
        Spacer(),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomButton(
                onClick: () {
                  changeScreen(
                    MainScreen(changeScreen: changeScreen, currentCity: city),
                  );
                },
                text: "Home",
              ),
              CustomButton(
                onClick: () {
                  changeScreen(RestaurantsScreen());
                },
                text: "Restaurants",
              ),
              CustomDropdownMenu(elements: cities, onChanged: changeCity),
              IconButton(
                onPressed: () {
                  return changeScreen(CartScreen());
                },
                icon: Icon(Icons.shopping_cart, color: const Color(0xFFF24822)),
              ),
              CustomButton(
                onClick: () {
                  changeScreen(LoginScreen());
                },
                text: "Login/Register",
                backgroundColor: Colors.black,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
