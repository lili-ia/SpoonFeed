import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spoonfeed_customer/city_service.dart';
import 'package:spoonfeed_customer/food_facilities_screen.dart';
import 'package:spoonfeed_customer/main_layout.dart';
import 'package:go_router/go_router.dart';
import 'package:spoonfeed_customer/main_screen.dart';
import 'package:spoonfeed_customer/menu_sceen.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() {
  setUrlStrategy(PathUrlStrategy());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? city;

  @override
  void initState() {
    super.initState();
    loadCity();
  }

  void loadCity() async {
    city = await CityService().getCity();
    setState(() {});
  }

  void updateCity(String newCity) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('city', newCity);
    setState(() {
      city = newCity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _createRouter());
  }

  GoRouter _createRouter() {
    return GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            if (city == null) {
              return Scaffold();
            }
            return MainLayout(
              currentCity: city!,
              onChangeCity: updateCity,
              widget: MainScreen(currentCity: city!),
            );
          },
        ),
        GoRoute(
          path: '/facilities/:restaurant_id',
          builder: (context, state) {
            if (city == null) {
              return Scaffold();
            }
            final int restaurantId = int.parse(
              state.pathParameters['restaurant_id']!,
            );
            return MainLayout(
              currentCity: city!,
              onChangeCity: updateCity,
              widget: FoodFacilitiesScreen(restaurantId: restaurantId),
            );
          },
        ),
        GoRoute(
          path: '/menu/:restaurant_id/:facility_id',
          builder: (context, state) {
            if (city == null) {
              return Scaffold();
            }
            final int restaurantId = int.parse(
              state.pathParameters['restaurant_id']!,
            );
            final int facilityId = int.parse(
              state.pathParameters['facility_id']!,
            );
            return MainLayout(
              currentCity: city!,
              onChangeCity: updateCity,
              widget: MenuScreen(
                facilityId: facilityId,
                restaurantId: restaurantId,
                currentCity: city!,
              ),
            );
          },
        ),
      ],
    );
  }
}
