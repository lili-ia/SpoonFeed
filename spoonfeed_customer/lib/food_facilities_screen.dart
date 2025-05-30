import 'package:flutter/material.dart';
import 'package:spoonfeed_customer/custom_text.dart';
import 'package:spoonfeed_customer/models/restaurant.dart';

class FoodFacilitiesScreen extends StatefulWidget {
  const FoodFacilitiesScreen({
    super.key,
    required this.changeScreen,
    required this.restaurant,
    required this.city,
  });

  final void Function(Widget) changeScreen;

  final String city;

  final Restaurant restaurant;
  @override
  State<StatefulWidget> createState() {
    return _FoodFacilitiesScreenState();
  }
}

class _FoodFacilitiesScreenState extends State<FoodFacilitiesScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Column(
              children: [
                CustomText(text: "Address: ${widget.city}"),
                CustomText(
                  text: "Selected food chain: ${widget.restaurant.restaurant}",
                ),
              ],
            ),
          ],
        ),
        Row(children: []),
      ],
    );
  }
}
