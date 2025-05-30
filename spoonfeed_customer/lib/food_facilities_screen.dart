import 'package:flutter/material.dart';
import 'package:spoonfeed_customer/custom_text.dart';
import 'package:spoonfeed_customer/models/facility.dart';
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

  List<Facility> getFacilities() {
    return [
      Facility(
        1,
        "2a Hryhorii Skovoroda St.",
        "+3809415968585",
        "https://www.kfc-ukraine.com/",
      ),
      Facility(
        2,
        "3a Hryhorii Skovoroda St.",
        "+3809415968585",
        "https://www.kfc-ukraine.com/",
      ),
      Facility(
        3,
        "4a Hryhorii Skovoroda St.",
        "+3809415968585",
        "https://www.kfc-ukraine.com/",
      ),
    ];
  }

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
        Container(
          margin: EdgeInsets.symmetric(horizontal: 60),
          color: const Color(0xFFFFB900),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Address: ${widget.city}",
                    fontSize: 40,
                    alignment: Alignment.centerLeft,
                  ),
                  CustomText(
                    text:
                        "Selected food chain: ${widget.restaurant.restaurant}",
                    alignment: Alignment.centerLeft,
                    fontSize: 40,
                  ),
                ],
              ),

              Image.asset(
                "images/restaurants_logo/${widget.restaurant.restaurantId}.png",
              ),
            ],
          ),
        ),
        Container(
          color: Colors.black,
          child: Column(children: [CustomText(text: "Select a food spot:")]),
        ),
      ],
    );
  }
}
