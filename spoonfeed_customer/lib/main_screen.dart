import 'package:flutter/material.dart';
import 'package:spoonfeed_customer/custom_text.dart';
import 'package:spoonfeed_customer/food_facilities_screen.dart';
import 'package:spoonfeed_customer/footer.dart';
import 'package:spoonfeed_customer/models/restaurant.dart';
import 'package:spoonfeed_customer/navigation_menu.dart';
import 'package:spoonfeed_customer/restaurant_button.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.changeScreen});
  final void Function(Widget) changeScreen;

  List<String> getCities() {
    return ["Kuiv", "Harkiv"];
  }

  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }

  final int restaurantCountInRow = 6;

  List<List<Restaurant>> getRestaurants() {
    List<Restaurant> r = [
      Restaurant(1, "BUFET"),
      Restaurant(2, "ЯПІКО"),
      Restaurant(3, "KFC"),
      Restaurant(4, "PIZZA DAY"),
      Restaurant(5, "BURGER KING"),
      Restaurant(6, "McDonald’s"),
      Restaurant(7, "BUFET"),
      Restaurant(8, "ЯПІКО"),
      Restaurant(9, "KFC"),
      Restaurant(10, "PIZZA DAY"),
      Restaurant(11, "BURGER KING"),
      Restaurant(12, "McDonald’s"),
      Restaurant(13, "BUFET"),
      Restaurant(14, "ЯПІКО"),
      Restaurant(15, "KFC"),
      Restaurant(16, "PIZZA DAY"),
      Restaurant(17, "BURGER KING"),
      Restaurant(18, "McDonald’s"),
    ];
    List<List<Restaurant>> restaurants = [];
    for (var i = 0; i < r.length / restaurantCountInRow; i++) {
      restaurants.add([]);
      for (var j = 0; j < restaurantCountInRow; j++) {
        restaurants[i].add(r[i * restaurantCountInRow + j]);
      }
    }
    return restaurants;
  }
}

class _MainScreenState extends State<MainScreen> {
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
    return Column(
      children: [
        NavigatioMenu(
          changeScreen: widget.changeScreen,
          cities: widget.getCities(),
          changeCity: changeCity,
        ),
        CustomText(
          text: "Food delivery right to your door!\nThe best food chains!",
        ),
        ElevatedButton(
          onPressed: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on),
              CustomText(text: "What’s your address?"),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children:
                  widget.getRestaurants().map((List<Restaurant> restaurant) {
                    return Container(
                      padding: EdgeInsets.all(15),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children:
                              restaurant.map((Restaurant element) {
                                return RestaurantButton(
                                  restaurant: element,
                                  onClick: () {
                                    widget.changeScreen(
                                      FoodFacilitiesScreen(
                                        changeScreen: widget.changeScreen,
                                        restaurant: element,
                                        city: currentCity!,
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),
        Footer(),
      ],
    );
  }
}
