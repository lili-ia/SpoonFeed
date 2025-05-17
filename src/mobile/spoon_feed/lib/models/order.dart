import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Order {
  final List<Restaurant>? restaurants;

  final MapLocation? customer;

  bool active = false;

  Order({required this.restaurants, required this.customer});

  void sort() {
    restaurants!.sort((Restaurant r1, Restaurant r2) {
      if (r1.status == Status.pickedUp && r2.status != Status.pickedUp) {
        return -1;
      }
      if (r1.status != Status.pickedUp && r2.status == Status.pickedUp) {
        return 1;
      }
      if (r1.distance == null || r2.distance == null) {
        return 0;
      }
      return r1.distance!.compareTo(r2.distance!);
    });
  }
}

class MapLocation {
  final String name;
  final String address;
  final LatLng position;
  final int codeVerification;
  double? distance;

  MapLocation({
    required this.name,
    required this.address,
    required this.position,
    required this.codeVerification,
    this.distance,
  });

  String getConvertedDistance() {
    String result = "";
    if (distance == null) {
      return result;
    }
    int meters = (distance! % 1000).floor();
    int kilometers = (distance! / 1000).floor();
    if (kilometers != 0) {
      result += "$kilometers km ";
    }
    result += "$meters m";
    return result;
  }
}

enum Status { expected, cooking, canPickUp, pickedUp }

class Restaurant extends MapLocation {
  final List<DishInOrder> dishes;
  Color? color;
  Status status = Status.expected;

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
