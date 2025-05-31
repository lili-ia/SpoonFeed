import 'package:flutter/material.dart';
import 'package:spoonfeed_customer/custom_text.dart';
import 'package:spoonfeed_customer/models/restaurant.dart';

class CurrentStateWidget extends StatelessWidget {
  const CurrentStateWidget({
    super.key,
    required this.restaurant,
    required this.address,
  });
  final Restaurant restaurant;
  final String address;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 60),
      color: const Color(0xFFFFB900),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Address: $address",
                fontSize: 40,
                alignment: Alignment.centerLeft,
              ),
              CustomText(
                text: "Selected food chain: ${restaurant.restaurant}",
                alignment: Alignment.centerLeft,
                fontSize: 40,
              ),
            ],
          ),

          Image.asset("images/restaurants_logo/${restaurant.restaurantId}.png"),
        ],
      ),
    );
  }
}
