import 'package:courier_app/models/active_order.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

var activeOrder = ActiveOrder(
  restaurants: [
    Restaurant(
      name: "Lavazza Coffee",
      address:
          "Сіті Мол, Запорізька вул., 1Б, Запоріжжя, Запорізька область, 69000",
      position: LatLng(47.8187694, 35.1570175),
      codeVerification: 9485,
      dishes: [DishInOrder(id: 1, name: "Кава Американо", count: 2)],
    ),
    Restaurant(
      name: "MacDonalds",
      address: "проспект Соборний, 76, Запоріжжя, Запорізька область, 69061",
      position: LatLng(47.81863892619486, 35.16352282611364),
      codeVerification: 4150,
      dishes: [
        DishInOrder(id: 2, name: "Тейсті джуніор", count: 1),
        DishInOrder(id: 3, name: "Кока кола", count: 1),
      ],
    ),
  ],
  customer: MapLocation(
    name: "Григорій",
    address:
        "Вулиця Українська, 2ж, Запоріжжя, Запорізька область, будинок 3, квартира 8",
    position: LatLng(47.82191135238006, 35.15517485771208),
    codeVerification: 2341,
  ),
);
