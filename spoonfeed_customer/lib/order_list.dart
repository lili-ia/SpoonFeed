import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spoonfeed_customer/custom_text.dart';
import 'package:spoonfeed_customer/dishes_pop_up.dart';
import 'package:spoonfeed_customer/models/order.dart';

class OrderList extends StatelessWidget {
  const OrderList({super.key, required this.activeOrder});
  final Order activeOrder;

  String getStatusText(Status state) {
    switch (state) {
      case Status.expected:
        return "Expected";
      case Status.cooking:
        return "Cooking";
      case Status.canPickUp:
        return "Can pick up courier";
      case Status.pickedUp:
        return "Picked up courier";
    }
  }

  Icon getStatusIcon(Status state, Color color) {
    switch (state) {
      case Status.expected:
        return Icon(Icons.schedule, color: color);
      case Status.cooking:
        return Icon(Icons.soup_kitchen, color: color);
      case Status.canPickUp:
        return Icon(Icons.inventory_2, color: color);
      case Status.pickedUp:
        return Icon(Icons.check, color: color);
    }
  }

  @override
  Widget build(BuildContext context) {
    var isFirst = true;
    Color color;
    return Container(
      margin: EdgeInsets.all(25),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...activeOrder.restaurants.map((restaurant) {
              if (restaurant.status == Status.pickedUp) {
                color = Colors.green;
              } else {
                color = Colors.black;
              }
              Widget widgetElement = Opacity(
                opacity:
                    restaurant.status == Status.pickedUp
                        ? 1
                        : isFirst
                        ? 1
                        : 0.5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.store, color: restaurant.color, size: 44),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomText(text: restaurant.name, color: color),
                            SizedBox(width: 15),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(6),
                                minimumSize: Size(0, 0),
                                backgroundColor: const Color(0xFFF24822),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (builder) {
                                    return DishesPopUp(
                                      dishes: restaurant.dishes,
                                    );
                                  },
                                );
                              },
                              child: Row(
                                children: [
                                  CustomText(text: "Dishes "),
                                  Icon(
                                    FontAwesomeIcons.hamburger,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            CustomText(
                              text: getStatusText(restaurant.status),
                              fontSize: 24,
                              color: color,
                            ),
                            getStatusIcon(restaurant.status, color),
                          ],
                        ),
                        CustomText(
                          text: "Address: ${restaurant.address}",
                          fontSize: 24,
                          color: color,
                        ),
                        CustomText(
                          text: "Phone: ${restaurant.phone}",
                          fontSize: 24,
                          color: color,
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ],
                ),
              );
              if (restaurant.status != Status.pickedUp) {
                isFirst = false;
              }
              return widgetElement;
            }),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.person, color: Colors.red, size: 44),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomText(
                          text: "Courier (${activeOrder.courier.name})",
                          fontSize: 24,
                        ),
                      ],
                    ),
                    CustomText(
                      text: "Phone: ${activeOrder.courier.phone}",
                      fontSize: 24,
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, color: Colors.black, size: 44),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [CustomText(text: "You", fontSize: 24)]),
                    SizedBox(height: 30),
                  ],
                ),
              ],
            ),
            CustomText(
              text:
                  "The courier will deliver the order at ${activeOrder.timeToEnd}",
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            CustomText(
              text:
                  "Verification code for courier: ${activeOrder.codeVerification}",
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            CustomText(
              text: "Amount due: ${activeOrder.totalPrice} UAH",
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}
