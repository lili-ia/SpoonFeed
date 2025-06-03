import 'package:latlong2/latlong.dart';
import 'package:spoonfeed_customer/models/order.dart';

class ActiveOrderApi {
  Future<Order> getActiveOrder() async {
    return Order(
      orderId: 1111,
      restaurants: [
        Restaurant(
          name: "KFC",
          address:
              "проспект Соборний, 76, Запоріжжя, Запорізька область, 69061",
          position: LatLng(47.823476574726456, 35.16094047747023),
          codeVerification: 4150,
          dishes: [
            DishInOrder(id: 1, name: "Боксмайстер Ланчбокс", count: 2),
            DishInOrder(id: 8, name: "Тауер Бургер Оригінальний", count: 3),
          ],
          phone: "+380954960491",
          status: Status.cooking,
        ),
        Restaurant(
          name: "ЯПІКО",
          address:
              "Сіті Мол, Запорізька вул., 1Б, Запоріжжя, Запорізька область, 69000",
          position: LatLng(47.81850078811102, 35.15624257716185),
          codeVerification: 9485,
          dishes: [
            DishInOrder(
              id: 13,
              name: "Роял-рол з вугрем, тунцем та крабовим міксом",
              count: 2,
            ),
          ],
          phone: "+380953941565",
          status: Status.expected,
        ),
      ],
      customer: MapLocation(
        name: "Григорій",
        address:
            "Вулиця Українська, 2ж, Запоріжжя, Запорізька область, будинок 3, квартира 8",
        position: LatLng(47.81972264857566, 35.15913558940047),
        phone: "+380951049411",
      ),
      courier: MapLocation(
        name: "Григорій",
        address:
            "Вулиця Українська, 2ж, Запоріжжя, Запорізька область, будинок 3, квартира 8",
        position: LatLng(47.81968909979783, 35.15715650175769),
        phone: "+380951049411",
      ),
      timeToEnd: "15:35",
      codeVerification: "3961",
      totalPrice: 436.99,
    );
  }

  Future<Order> getActiveOrder2() async {
    return Order(
      orderId: 1111,
      restaurants: [
        Restaurant(
          name: "KFC",
          address:
              "проспект Соборний, 76, Запоріжжя, Запорізька область, 69061",
          position: LatLng(47.823476574726456, 35.16094047747023),
          codeVerification: 4150,
          dishes: [
            DishInOrder(id: 1, name: "Боксмайстер Ланчбокс", count: 2),
            DishInOrder(id: 8, name: "Тауер Бургер Оригінальний", count: 3),
          ],
          phone: "+380954960491",
          status: Status.pickedUp,
        ),
        Restaurant(
          name: "ЯПІКО",
          address:
              "Сіті Мол, Запорізька вул., 1Б, Запоріжжя, Запорізька область, 69000",
          position: LatLng(47.81850078811102, 35.15624257716185),
          codeVerification: 9485,
          dishes: [
            DishInOrder(
              id: 13,
              name: "Роял-рол з вугрем, тунцем та крабовим міксом",
              count: 2,
            ),
          ],
          phone: "+380953941565",
          status: Status.canPickUp,
        ),
      ],
      customer: MapLocation(
        name: "Григорій",
        address:
            "Вулиця Українська, 2ж, Запоріжжя, Запорізька область, будинок 3, квартира 8",
        position: LatLng(47.81972264857566, 35.15913558940047),
        phone: "+380951049411",
      ),
      courier: MapLocation(
        name: "Григорій",
        address:
            "Вулиця Українська, 2ж, Запоріжжя, Запорізька область, будинок 3, квартира 8",
        position: LatLng(47.82241228536726, 35.16079153110774),
        phone: "+380951049411",
      ),
      timeToEnd: "15:35",
      codeVerification: "3961",
      totalPrice: 436.99,
    );
  }

  Future<Order> getActiveOrder3() async {
    return Order(
      orderId: 1111,
      restaurants: [
        Restaurant(
          name: "KFC",
          address:
              "проспект Соборний, 76, Запоріжжя, Запорізька область, 69061",
          position: LatLng(47.823476574726456, 35.16094047747023),
          codeVerification: 4150,
          dishes: [
            DishInOrder(id: 1, name: "Боксмайстер Ланчбокс", count: 2),
            DishInOrder(id: 8, name: "Тауер Бургер Оригінальний", count: 3),
          ],
          phone: "+380954960491",
          status: Status.pickedUp,
        ),
        Restaurant(
          name: "ЯПІКО",
          address:
              "Сіті Мол, Запорізька вул., 1Б, Запоріжжя, Запорізька область, 69000",
          position: LatLng(47.81850078811102, 35.15624257716185),
          codeVerification: 9485,
          dishes: [
            DishInOrder(
              id: 13,
              name: "Роял-рол з вугрем, тунцем та крабовим міксом",
              count: 2,
            ),
          ],
          phone: "+380953941565",
          status: Status.pickedUp,
        ),
      ],
      customer: MapLocation(
        name: "Григорій",
        address:
            "Вулиця Українська, 2ж, Запоріжжя, Запорізька область, будинок 3, квартира 8",
        position: LatLng(47.81972264857566, 35.15913558940047),
        phone: "+380951049411",
      ),
      courier: MapLocation(
        name: "Григорій",
        address:
            "Вулиця Українська, 2ж, Запоріжжя, Запорізька область, будинок 3, квартира 8",
        position: LatLng(47.81983845223438, 35.15808281356526),
        phone: "+380951049411",
      ),
      timeToEnd: "15:35",
      codeVerification: "3961",
      totalPrice: 436.99,
    );
  }
}
