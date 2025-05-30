import 'package:flutter/material.dart';
import 'package:spoonfeed_customer/custom_text.dart';
import 'package:spoonfeed_customer/models/restaurant.dart';

class RestaurantButton extends StatelessWidget {
  const RestaurantButton({
    super.key,
    required this.restaurant,
    required this.onClick,
  });
  final Restaurant restaurant;
  final Function() onClick;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onClick();
      },
      child: SizedBox(
        width: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              "images/restaurants_logo/${restaurant.restaurantId}.png",
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              color: const Color(0xFFF24822),
              child: CustomText(text: restaurant.restaurant),
            ),
          ],
        ),
      ),
    );
  }
}
