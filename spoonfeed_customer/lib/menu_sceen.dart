import 'package:flutter/material.dart';
import 'package:spoonfeed_customer/api/dish_api.dart';
import 'package:spoonfeed_customer/api/facility_api.dart';
import 'package:spoonfeed_customer/api/restaurant_api.dart';
import 'package:spoonfeed_customer/current_state_widget.dart';
import 'package:spoonfeed_customer/custom_text.dart';
import 'package:spoonfeed_customer/dish_container.dart';
import 'package:spoonfeed_customer/models/dish.dart';
import 'package:spoonfeed_customer/models/dish_category.dart';
import 'package:spoonfeed_customer/models/facility.dart';
import 'package:spoonfeed_customer/models/restaurant.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({
    super.key,
    required this.facilityId,
    required this.restaurantId,
    required this.currentCity,
  });
  final int restaurantId;
  final int facilityId;
  final String currentCity;

  List<List<Dish>> chunkDishes(List<Dish> dishes, int chunk) {
    List<List<Dish>> chunks = [];
    for (int i = 0; i < (dishes.length / chunk).ceil(); i++) {
      chunks.add([]);
      for (var j = 0; j < chunk; j++) {
        chunks[i].add(dishes[i * chunk + j]);
      }
    }
    return chunks;
  }

  @override
  State<StatefulWidget> createState() {
    return _MenuScreenState();
  }
}

class _MenuScreenState extends State<MenuScreen> {
  late Future<Restaurant> restaurant;
  late Future<Facility> facility;
  late Future<List<DishCategory>> dishCategories;

  @override
  void initState() {
    super.initState();
    facility = FacilityApi().getFacility();
    restaurant = RestaurantApi().getRestaurant(widget.restaurantId);
    dishCategories = DishApi().getDishCategories(widget.facilityId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([restaurant, facility, dishCategories]),
      builder: (context, snaphot) {
        if (!snaphot.hasData) {
          return SizedBox();
        }
        List data = snaphot.data!;
        Restaurant restaurant = data[0];
        Facility facility = data[1];
        List<DishCategory> dishCategories = data[2];
        return Column(
          children: [
            CurrentStateWidget(
              restaurant: restaurant,
              address: "${facility.address}, ${widget.currentCity}",
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children:
                      dishCategories.map((DishCategory dishCategory) {
                        return Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 100,
                              ),
                              child: CustomText(
                                text: dishCategory.categoryName,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                            ...widget.chunkDishes(dishCategory.dishes, 3).map((
                              List<Dish> dishes,
                            ) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children:
                                    dishes.map((Dish dish) {
                                      return DishContainer(dish: dish);
                                    }).toList(),
                              );
                            }),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
