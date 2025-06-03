import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spoonfeed_customer/city_service.dart';
import 'package:spoonfeed_customer/custom_button.dart';
import 'package:spoonfeed_customer/custom_dropdown_menu.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({
    super.key,
    required this.onChange,
    required this.city,
    this.userName,
    required this.logout,
  });
  final Function(String) onChange;
  final String city;
  final String? userName;
  final Function(int?) logout;
  @override
  Widget build(BuildContext context) {
    List<String> cities = CityService().getCities();
    return Row(
      children: [
        Image.asset("images/spoonfeed_logo.png", height: 100),
        Spacer(),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomButton(
                onClick: () {
                  context.go('/');
                },
                text: "Home",
              ),
              CustomButton(
                onClick: () {
                  context.go('/restaurants');
                  
                },
                text: "Restaurants",
              ),
              CustomDropdownMenu(
                elements: cities,
                onChange: onChange,
                currentElement: city,
              ),
              IconButton(
                onPressed: () {
                  context.go('/cart');
                },
                icon: Icon(Icons.shopping_cart, color: const Color(0xFFF24822)),
              ),
              CustomButton(
                onClick: () {
                  context.go(userName == null ? '/login' : "/activeOrder");
                },
                text: userName == null ? "Login/Register" : userName!,
                backgroundColor: Colors.black,
              ),
              userName != null
                  ? IconButton(
                    onPressed: () {
                      logout(null);
                    },
                    icon: Icon(Icons.logout, color: Colors.black),
                  )
                  : SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
