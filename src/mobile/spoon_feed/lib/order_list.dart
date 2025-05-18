import 'package:courier_app/dishes_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:courier_app/models/order.dart';
import 'package:courier_app/custom_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        return "Can pick up";
      case Status.pickedUp:
        return "Picked up";
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
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...activeOrder.restaurants!.map((restaurant) {
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.store, color: restaurant.color),
                    Expanded(
                      child: Column(
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
                              Expanded(
                                child: CustomText(
                                  text: restaurant.getConvertedDistance(),
                                  textAlign: TextAlign.right,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CustomText(
                                text: getStatusText(restaurant.status),
                                color: color,
                              ),
                              getStatusIcon(restaurant.status, color),
                            ],
                          ),
                          CustomText(
                            text: "Address: ${activeOrder.customer!.address}",
                            color: color,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomText(
                                  text:
                                      "Verification code: ${restaurant.codeVerification}",
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomText(
                                  text: "Phone: ${restaurant.phone}",
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              );
              if (restaurant.status != Status.pickedUp) {
                isFirst = false;
              }

              return widgetElement;
            }),
            Opacity(
              opacity:
                  activeOrder.restaurants!.last.status == Status.pickedUp
                      ? 1
                      : 0.5,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.person, color: Colors.red),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CustomText(text: activeOrder.customer!.name),
                            Expanded(
                              child: CustomText(
                                text:
                                    activeOrder.customer!
                                        .getConvertedDistance(),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        CustomText(
                          text: "Address: ${activeOrder.customer!.address}",
                        ),
                        activeOrder.customer!.phone != null
                            ? Row(
                              children: [
                                Expanded(
                                  child: CustomText(
                                    text:
                                        "Phone: ${activeOrder.customer!.phone}",
                                  ),
                                ),
                              ],
                            )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
