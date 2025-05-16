import 'package:courier_app/models/active_order.dart';
import 'package:courier_app/order_list.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:courier_app/custom_button.dart';
import 'courier_map.dart';
import 'package:courier_app/text_form.dart';
import 'dart:async';
import 'package:courier_app/temp_API_replacement/active_order.dart';

class DeliverScreen extends StatefulWidget {
  const DeliverScreen({super.key, required this.changeScreen});
  final void Function(Widget) changeScreen;
  @override
  State<StatefulWidget> createState() {
    return _DeliverScreenState();
  }
}

class _DeliverScreenState extends State<DeliverScreen> {
  Timer? futureAPI;
  String? submitText = "Start";
  String currentState = "Inactive";
  static List<Color> restaurantColors = const [
    Colors.orange,
    Colors.blue,
    Colors.green,
    Colors.red,
  ];
  ActiveOrder _activeOrder = ActiveOrder(restaurants: null, customer: null);
  void changeState() {
    setState(() {
      if (currentState == "Inactive") {
        currentState = "Search";
        submitText = "Cancle";
        searchingCustomer();
      } else if (currentState == "Search") {
        currentState = "Inactive";
        submitText = "Start";
        cancleSearching();
      }
    });
  }

  void updateState(
    LatLng courierPosition,
    List<String> restaurantDistance,
    String customerDistance,
  ) {
    //sent courier position to API
    futureAPI = Timer(Duration(microseconds: 1), () {});
    setState(() {
      for (var i = 0; i < activeOrder.restaurants!.length; i++) {
        activeOrder.restaurants![i].distance = restaurantDistance[i];
      }
      activeOrder.customer!.distance = customerDistance;
    });
  }

  void searchingCustomer() {
    futureAPI = Timer(Duration(seconds: 1), () {
      setState(() {
        currentState = "Accepting";
        submitText = "Accept";
        //getting from API in the future
        _activeOrder = activeOrder;
        _activeOrder.active = true;
        for (var i = 0; i < activeOrder.restaurants!.length; i++) {
          _activeOrder.restaurants![i].color = restaurantColors[i];
        }
      });
    });
  }

  void cancleSearching() {
    futureAPI!.cancel();
    setState(() {
      currentState = "Inactive";
      submitText = "Start";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 8,
          child: CourierMap(
            activeOrder: _activeOrder,
            updateState: updateState,
          ),
        ),
        Expanded(
          flex: 3,
          child:
              currentState == "Search"
                  ? TextForm("Searching for a customer...")
                  : currentState != "Inactive"
                  ? OrderList(activeOrder: _activeOrder)
                  : SizedBox.shrink(),
        ),

        Expanded(flex: 1, child: CustomButton(submitText!, changeState)),
      ],
    );
  }
}
