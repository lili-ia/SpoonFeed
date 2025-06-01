import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spoonfeed_customer/api/restaurant_api.dart';
import 'package:spoonfeed_customer/custom_text.dart';
import 'package:spoonfeed_customer/models/restaurant.dart';
import 'package:spoonfeed_customer/restaurant_button.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.currentCity});

  final String currentCity;

  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }

  final int restaurantCountInRow = 6;

  List<List<Restaurant>> convertRestaurants(List<Restaurant> r) {
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
  late Future<List<Restaurant>> restaurants;

  @override
  void initState() {
    super.initState();

    restaurants = RestaurantApi().getRestaurants(widget.currentCity);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            child: FutureBuilder<List<Restaurant>>(
              future: restaurants,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                List<List<Restaurant>> rest = widget.convertRestaurants(
                  snapshot.data,
                );
                return Column(
                  children:
                      rest.map((List<Restaurant> restaurants) {
                        return Container(
                          padding: EdgeInsets.all(15),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children:
                                  restaurants.map((Restaurant restaurant) {
                                    return RestaurantButton(
                                      restaurant: restaurant,
                                      onClick: () {
                                        context.go(
                                          "/facilities/${restaurant.restaurantId}",
                                        );
                                      },
                                    );
                                  }).toList(),
                            ),
                          ),
                        );
                      }).toList(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
