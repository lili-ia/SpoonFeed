import 'package:courier_app/models/order.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

var activeOrder = Order(
  orderId: 1111,
  restaurants: [
    Restaurant(
      name: "MacDonalds",
      address: "проспект Соборний, 76, Запоріжжя, Запорізька область, 69061",
      position: LatLng(47.825817124660006, 35.166360163086985),
      codeVerification: 4150,
      dishes: [
        DishInOrder(id: 2, name: "Тейсті джуніор", count: 1),
        DishInOrder(id: 3, name: "Кока кола", count: 1),
        DishInOrder(id: 3, name: "Кока кола", count: 1),
        DishInOrder(id: 3, name: "Кока кола", count: 1),
        DishInOrder(id: 3, name: "Кока кола", count: 1),
        DishInOrder(id: 3, name: "Кока кола", count: 1),
        DishInOrder(id: 3, name: "Кока кола", count: 1),
        DishInOrder(id: 3, name: "Кока кола", count: 1),
      ],
      phone: "+380954960491",
    ),
    Restaurant(
      name: "Lavazza Coffee",
      address:
          "Сіті Мол, Запорізька вул., 1Б, Запоріжжя, Запорізька область, 69000",
      position: LatLng(47.8187694, 35.1570175),
      codeVerification: 9485,
      dishes: [DishInOrder(id: 1, name: "Кава Американо", count: 2)],
      phone: "+380953941565",
    ),
  ],
  customer: MapLocation(
    name: "Григорій",
    address:
        "Вулиця Українська, 2ж, Запоріжжя, Запорізька область, будинок 3, квартира 8",
    position: LatLng(47.82191135238006, 35.15517485771208),
    phone: "+380951049411",
  ),
);
