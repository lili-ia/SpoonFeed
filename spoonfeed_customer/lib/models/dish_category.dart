import 'package:spoonfeed_customer/models/dish.dart';

class DishCategory {
  final int categoryId;
  final String categoryName;
  final List<Dish> dishes;
  DishCategory(this.categoryId, this.categoryName, this.dishes);
}
