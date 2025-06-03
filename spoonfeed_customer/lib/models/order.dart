import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class Order {
  final List<Restaurant> restaurants;

  final int orderId;

  final MapLocation customer;

  MapLocation courier;

  String timeToEnd;

  String codeVerification;

  double totalPrice;

  Order({
    required this.orderId,
    required this.restaurants,
    required this.customer,
    required this.courier,
    required this.timeToEnd,
    required this.codeVerification,
    required this.totalPrice,
  });
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
  Status status;

  Restaurant({
    required super.name,
    required super.address,
    required super.position,
    required this.codeVerification,
    super.distance,
    required this.dishes,
    this.color,
    super.phone,
    required this.status,
  });
}

class DishInOrder {
  final int id;
  final String name;
  final int count;

  DishInOrder({required this.id, required this.name, required this.count});
}
