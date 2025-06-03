import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spoonfeed_customer/active_order_screen.dart';
import 'package:spoonfeed_customer/api/customer_api.dart';
import 'package:spoonfeed_customer/auth_layout.dart';
import 'package:spoonfeed_customer/city_service.dart';
import 'package:spoonfeed_customer/food_facilities_screen.dart';
import 'package:spoonfeed_customer/auth_screen.dart';
import 'package:spoonfeed_customer/main_layout.dart';
import 'package:spoonfeed_customer/providers/cart_provider.dart';
import 'package:spoonfeed_customer/cart_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:spoonfeed_customer/main_screen.dart';
import 'package:spoonfeed_customer/menu_sceen.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDllxB5rPSshYFAYpBpqHNSyuNBzr1dVic",
      authDomain: "spoonfeed-4203b.firebaseapp.com",
      projectId: "spoonfeed-4203b",
      storageBucket: "spoonfeed-4203b.firebasestorage.app",
      messagingSenderId: "341221018921",
      appId: "1:341221018921:web:0a3bb9068bc207b31cfb38",
      measurementId: "G-9LWG03G1V4",
    ),
  );

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
  String? userName;
  int? userId;

  @override
  void initState() {
    super.initState();
    loadUser();
    loadCity();
  }

  void loadCity() async {
    city = await CityService().getCity();
    setState(() {});
  }

  void loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString("user_id");
    if (user == null) {
      return;
    }
    setState(() {
      userId = int.parse(user);
    });

    userName = await CustomerApi().getName(userId!);
    setState(() {});
  }

  void updateCity(String newCity) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('city', newCity);
    setState(() {
      city = newCity;
    });
  }

  void updateUser(int? userId) async {
    final prefs = await SharedPreferences.getInstance();
    if (userId == null) {
      prefs.remove("user_id");
      setState(() {
        userName = null;
      });
      return;
    }
    prefs.setString("user_id", userId.toString());
    String name = await CustomerApi().getName(userId);
    setState(() {
      userName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp.router(routerConfig: _createRouter()),
    );
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
              userName: userName,
              logout: updateUser,
            );
          },
        ),
        GoRoute(
          path: '/restaurants',
          builder: (context, state) {
            if (city == null) {
              return Scaffold();
            }
            return MainLayout(
              currentCity: city!,
              onChangeCity: updateCity,
              widget: MainScreen(currentCity: city!),
              userName: userName,
              logout: updateUser,
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
              userName: userName,
              logout: updateUser,
            );
          },
        ),
        GoRoute(
          path: '/menu/:restaurant_id/:facilities_id',
          builder: (context, state) {
            if (city == null) {
              return Scaffold();
            }
            final int restaurantId = int.parse(
              state.pathParameters['restaurant_id']!,
            );
            final int facilitiesId = int.parse(
              state.pathParameters['facilities_id']!,
            );
            return MainLayout(
              currentCity: city!,
              onChangeCity: updateCity,
              widget: MenuScreen(
                restaurantId: restaurantId,
                facilityId: facilitiesId,
                currentCity: city!,
              ),
              userName: userName,
              logout: updateUser,
            );
          },
        ),
        GoRoute(
          path: '/activeOrder',
          builder: (context, state) {
            if (city == null || userId == null) {
              return Scaffold();
            }
            return MainLayout(
              currentCity: city!,
              onChangeCity: updateCity,
              widget: ActiveOrderScreen(userId: userId!),
              userName: userName,
              logout: updateUser,
            );
          },
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) {
            if (city == null) {
              return Scaffold();
            }
            return MainLayout(
              currentCity: city!,
              onChangeCity: updateCity,
              widget: CartScreen(userName: userName), // Pass userName here
              userName: userName,
              logout: updateUser,
            );
          },
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) {
            if (city == null) {
              return Scaffold();
            }
            return AuthLayout(widget: AuthScreen(updateUser: updateUser));
          },
        ),
      ],
    );
  }
}
