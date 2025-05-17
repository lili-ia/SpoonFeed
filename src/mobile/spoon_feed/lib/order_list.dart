import 'package:courier_app/temp_API_replacement/active_order.dart';
import 'package:flutter/material.dart';
import 'package:courier_app/models/order.dart';
import 'package:courier_app/custom_text_style.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key, required this.activeOrder});
  final Order activeOrder;
  @override
  State<StatefulWidget> createState() {
    return _OrderListState();
  }
}

class _OrderListState extends State<OrderList> {
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

  Icon getStatusIcon(Status state) {
    switch (state) {
      case Status.expected:
        return Icon(Icons.schedule);
      case Status.cooking:
        return Icon(Icons.soup_kitchen);
      case Status.canPickUp:
        return Icon(Icons.inventory_2);
      case Status.pickedUp:
        return Icon(Icons.check);
    }
  }

  @override
  Widget build(BuildContext context) {
    var isFirst = true;
    return Container(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...activeOrder.restaurants!.map((restaurant) {
              Widget widgetElement = Opacity(
                opacity: isFirst ? 1 : 0.5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.store, color: restaurant.color),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CustomTextStyle(text: restaurant.name),
                              Expanded(
                                child: CustomTextStyle(
                                  text: restaurant.getConvertedDistance(),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CustomTextStyle(
                                text: getStatusText(restaurant.status),
                              ),
                              getStatusIcon(restaurant.status),
                            ],
                          ),
                          CustomTextStyle(text: restaurant.address),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextStyle(
                                  text:
                                      "Verification code: ${restaurant.codeVerification}",
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
              isFirst = false;
              return widgetElement;
            }),
            Opacity(
              opacity:
                  activeOrder
                              .restaurants![activeOrder.restaurants!.length - 1]
                              .status ==
                          Status.pickedUp
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
                            CustomTextStyle(text: activeOrder.customer!.name),
                            Expanded(
                              child: CustomTextStyle(
                                text:
                                    activeOrder.customer!
                                        .getConvertedDistance(),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        CustomTextStyle(text: activeOrder.customer!.address),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextStyle(
                                text:
                                    "Verification code: ${activeOrder.customer!.codeVerification}",
                              ),
                            ),
                          ],
                        ),
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
