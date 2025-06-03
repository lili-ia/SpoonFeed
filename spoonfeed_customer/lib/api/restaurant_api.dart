import 'package:spoonfeed_customer/models/restaurant.dart';

class RestaurantApi {
  Future<Restaurant> getRestaurant(int restaurantId) async {
    await Future.delayed(Duration(seconds: 1));
    return Restaurant(3, "KFC");
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
        Restaurant(7, "OKKO"),
        Restaurant(8, "Donet Market"),
        Restaurant(9, "Buffet Myaso bylka"),
        Restaurant(10, "Maranello"),
        Restaurant(11, "Napo"),
        Restaurant(12, "Salateria"),
        Restaurant(13, "Aroma Kava"),
        Restaurant(14, "FreshLine"),
        Restaurant(15, "Coffee Lab"),
        Restaurant(16, "Пузата Хата"),
        Restaurant(17, "Celentano Pizza"),
        Restaurant(18, "IL Molino"),
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
