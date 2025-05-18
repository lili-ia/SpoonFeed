import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Order {
  final List<Restaurant>? restaurants;

  final int? orderId;

  final MapLocation? customer;

  bool active = false;

  Order({this.orderId, required this.restaurants, required this.customer});

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

  MapLocation? needToDeliver() {
    if (restaurants == null || customer == null) {
      return null;
    }
    for (Restaurant restaurant in restaurants!) {
      if (restaurant.status != Status.pickedUp) {
        return restaurant;
      }
    }

    return customer;
  }
}

enum CourierStatus {
  inactive,
  searching,
  accepting,
  delivering,
  arrivedAtCustomerLocation,
}

class MapLocation {
  final String name;
  final String address;
  final LatLng position;
  double? distance;
  final String? phone;

  MapLocation({
    required this.name,
    required this.address,
    required this.position,
    this.distance,
    this.phone,
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
  final int codeVerification;
  Color? color;
  Status status = Status.expected;

  Restaurant({
    required super.name,
    required super.address,
    required super.position,
    required this.codeVerification,
    super.distance,
    required this.dishes,
    this.color,
    super.phone,
  });
}

class DishInOrder {
  final int id;
  final String name;
  final int count;

  DishInOrder({required this.id, required this.name, required this.count});
}
