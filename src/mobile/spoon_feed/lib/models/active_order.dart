import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ActiveOrder {
  final List<Restaurant>? restaurants;

  final MapLocation? customer;

  bool active = false;

  ActiveOrder({required this.restaurants, required this.customer});
}

class MapLocation {
  final String name;
  final String address;
  final LatLng position;
  final int codeVerification;
  String? distance;
  bool isDone = false;

  MapLocation({
    required this.name,
    required this.address,
    required this.position,
    required this.codeVerification,
    this.distance,
  });
}

class Restaurant extends MapLocation {
  final List<DishInOrder> dishes;
  Color? color;
  Restaurant({
    required super.name,
    required super.address,
    required super.position,
    required super.codeVerification,
    super.distance,
    required this.dishes,
    this.color,
  });
}

class DishInOrder {
  final int id;
  final String name;
  final int count;

  DishInOrder({required this.id, required this.name, required this.count});
}
