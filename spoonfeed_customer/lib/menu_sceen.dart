import 'package:flutter/material.dart';
import 'package:spoonfeed_customer/current_state_widget.dart';
import 'package:spoonfeed_customer/custom_text.dart';
import 'package:spoonfeed_customer/dish_container.dart';
import 'package:spoonfeed_customer/models/dish.dart';
import 'package:spoonfeed_customer/models/dish_category.dart';
import 'package:spoonfeed_customer/models/facility.dart';
import 'package:spoonfeed_customer/models/restaurant.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({
    super.key,
    required this.facility,
    required this.changeScreen,
    required this.restaurant,
    required this.city,
  });

  final Facility facility;

  final Restaurant restaurant;

  final void Function(Widget) changeScreen;

  final String city;

  List<DishCategory> getDishCategories(int facilityId) {
    return [
      DishCategory(1, "Lunch boxes", getDish(1)),
      DishCategory(1, "Burgers", getDish(2)),
    ];
  }

  List<Dish> getDish(int categoryId) {
    return [
      Dish(
        1,
        "Crispy Combo with Nuggets",
        98.99,
        20,
        78.99,
        "6 nuggets+3 Camembert cheese+Pepsi (0.5/refill/bottle)/Pepsi Max (0.5/refill/bottle) (of...",
      ),
      Dish(
        1,
        "Crispy Combo with Nuggets",
        98.99,
        20,
        78.99,
        "6 nuggets+3 Camembert cheese+Pepsi (0.5/refill/bottle)/Pepsi Max (0.5/refill/bottle) (of...",
      ),
      Dish(
        1,
        "Crispy Combo with Nuggets",
        98.99,
        20,
        78.99,
        "6 nuggets+3 Camembert cheese+Pepsi (0.5/refill/bottle)/Pepsi Max (0.5/refill/bottle) (of...",
      ),
      Dish(1, "Crispy Combo with Nuggets", 98.99, 20, 78.99, "6 nuggets+3"),
      Dish(1, "Crispy Combo with Nuggets", 98.99, 20, 78.99, "6 nuggets+3"),
      Dish(1, "Crispy Combo with Nuggets", 98.99, 20, 78.99, "6 nuggets+3"),
    ];
  }

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
  Widget build(BuildContext context) {
    return Column(
      children: [
        CurrentStateWidget(
          restaurant: restaurant,
          address: "${facility.address}, $city",
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children:
                  getDishCategories(facility.facilityId).map((
                    DishCategory dishCategory,
                  ) {
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
                        ...chunkDishes(dishCategory.dishes, 3).map((
                          List<Dish> dishes,
                        ) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
  }
}
