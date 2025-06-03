import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spoonfeed_customer/api/active_order_api.dart';
import 'package:spoonfeed_customer/customer_map.dart';
import 'package:spoonfeed_customer/models/order.dart';
import 'package:spoonfeed_customer/order_list.dart';

class ActiveOrderScreen extends StatefulWidget {
  const ActiveOrderScreen({super.key, required this.userId});
  final int userId;
  @override
  State<StatefulWidget> createState() {
    return _ActiveOrderScreenState();
  }
}

class _ActiveOrderScreenState extends State<ActiveOrderScreen> {
  late Future<Order> _order;
  Timer? firstUpdate;
  Timer? secondUpdate;

  @override
  void initState() {
    super.initState();
    orderUpdate();
  }

  @override
  void dispose() {
    super.dispose();
    firstUpdate!.cancel();
    secondUpdate!.cancel();
  }

  void orderUpdate() async {
    _order = ActiveOrderApi().getActiveOrder();
    firstUpdate = Timer(Duration(seconds: 5), () {
      setState(() {
        _order = ActiveOrderApi().getActiveOrder2();
      });
    });
    secondUpdate = Timer(Duration(seconds: 10), () {
      setState(() {
        _order = ActiveOrderApi().getActiveOrder3();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _order,
      builder: (context, snaphot) {
        if (!snaphot.hasData) {
          return SizedBox();
        }
        Order order = snaphot.data!;
        final List<Color> colors = [
          Colors.purple,
          Colors.blue,
          Colors.yellow,
          Colors.deepOrange,
        ];
        for (int i = 0; i < order.restaurants.length; i++) {
          order.restaurants[i].color = colors[i];
        }
        return Container(
          margin: EdgeInsets.all(30),
          child: Row(
            children: [
              OrderList(activeOrder: order),
              Expanded(child: CustomerMap(activeOrder: order)),
            ],
          ),
        );
      },
    );
  }
}
