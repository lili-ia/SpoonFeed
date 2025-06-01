import 'package:spoonfeed_customer/models/restaurant.dart';

class RestaurantApi {
  Future<Restaurant> getRestaurant(int restaurantId) async {
    await Future.delayed(Duration(seconds: 1));
    return Restaurant(1, "KFC");
  }

  Future<List<Restaurant>> getRestaurants(String city) async {
    List<Restaurant> restaurants;
    if (city == "Kyiv") {
      restaurants = [
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
    } else {
      restaurants = [
        Restaurant(18, "McDonald’s"),
        Restaurant(17, "BURGER KING"),
        Restaurant(16, "PIZZA DAY"),
        Restaurant(15, "KFC"),
        Restaurant(14, "ЯПІКО"),
        Restaurant(13, "BUFET"),
        Restaurant(12, "McDonald’s"),
        Restaurant(11, "BURGER KING"),
        Restaurant(10, "PIZZA DAY"),
        Restaurant(9, "KFC"),
        Restaurant(8, "ЯПІКО"),
        Restaurant(7, "BUFET"),
        Restaurant(6, "McDonald’s"),
        Restaurant(5, "BURGER KING"),
        Restaurant(4, "PIZZA DAY"),
        Restaurant(3, "KFC"),
        Restaurant(2, "ЯПІКО"),
        Restaurant(1, "BUFET"),
      ];
    }
    await Future.delayed(Duration(seconds: 1));
    return restaurants;
  }
}
