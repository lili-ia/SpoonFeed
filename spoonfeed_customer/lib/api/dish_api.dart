import 'package:spoonfeed_customer/models/dish.dart';
import 'package:spoonfeed_customer/models/dish_category.dart';

class DishApi {
  Future<List<DishCategory>> getDishCategories(int facilityId) async {
    return [
      DishCategory(1, "Lunch boxes", await _getDish(1)),
      DishCategory(2, "Burgers", await _getDish(2)),
    ];
  }

  Future<List<Dish>> _getDish(int categoryId) async {
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
}
