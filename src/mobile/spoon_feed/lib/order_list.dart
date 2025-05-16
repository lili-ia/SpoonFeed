import 'package:courier_app/temp_API_replacement/active_order.dart';
import 'package:flutter/material.dart';
import 'package:courier_app/models/active_order.dart';
import 'package:courier_app/custom_text_style.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key, required this.activeOrder});
  final ActiveOrder activeOrder;
  @override
  State<StatefulWidget> createState() {
    return _OrderListState();
  }
}

class _OrderListState extends State<OrderList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...activeOrder.restaurants!.map((restaurant) {
              return Row(
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
                                text:
                                    restaurant.distance == null
                                        ? ""
                                        : restaurant.distance!,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        CustomTextStyle(text: restaurant.address),
                      ],
                    ),
                  ),
                ],
              );
            }),
            Row(
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
                                  activeOrder.customer!.distance == null
                                      ? ""
                                      : activeOrder.customer!.distance!,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      CustomTextStyle(text: activeOrder.customer!.address),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
