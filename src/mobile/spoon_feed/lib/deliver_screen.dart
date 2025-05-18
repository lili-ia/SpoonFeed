import 'package:courier_app/auth_screen.dart';
import 'package:courier_app/balance_screen.dart';
import 'package:courier_app/custom_text.dart';
import 'package:courier_app/models/geolocation_status.dart';
import 'package:courier_app/models/order.dart';
import 'package:courier_app/order_list.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:courier_app/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  CourierStatus courierStatus = CourierStatus.inactive;
  bool _isMenuOpen = false;
  GeolocationStatus geolocationStatus = GeolocationStatus();
  bool orderFinished = false;

  static List<Color> restaurantColors = const [
    Colors.orange,
    Colors.blue,
    Colors.green,
    Colors.red,
  ];
  Order _activeOrder = Order(restaurants: null, customer: null);
  bool isStateCanChange = true;
  @override
  void dispose() {
    futureAPI?.cancel();
    super.dispose();
  }

  void changeState() {
    setState(() {
      if (!geolocationStatus.isLocationServiceEnable) {
        showAlertDialog("To start working, geodata must be enabled");
        return;
      } else if (!geolocationStatus.locationPermission) {
        showAlertDialog("To start working, geodata permission must be enabled");
        return;
      }
      switch (courierStatus) {
        case CourierStatus.inactive:
          courierStatus = CourierStatus.searching;
          isStateCanChange = false;
          orderFinished = false;
          searchingCustomer();
          break;
        case CourierStatus.searching:
          break;
        case CourierStatus.accepting:
          courierStatus = CourierStatus.delivering;
          isStateCanChange = false;
          submitText = "Arrived at the customer";
          break;
        case CourierStatus.delivering:
          if (activeOrder.restaurants!.last.status == Status.pickedUp) {
            courierStatus = CourierStatus.arrivedAtCustomerLocation;
            submitText = "Input verification code";
            isStateCanChange = true;
          }
          break;
        case CourierStatus.arrivedAtCustomerLocation:
          showVerificationCodeForm();
          break;
      }
    });
  }

  void updateState(
    LatLng courierPosition,
    List<double> restaurantDistance,
    double customerDistance,
  ) {
    if (!mounted || _activeOrder.restaurants == null) return;

    futureAPI = Timer(const Duration(microseconds: 1), () {});

    setState(() {
      try {
        for (var i = 0; i < _activeOrder.restaurants!.length; i++) {
          if (i < restaurantDistance.length) {
            _activeOrder.restaurants![i].distance = restaurantDistance[i];
          }

          if (_activeOrder.restaurants![i].status != Status.pickedUp) {
            // Change restaurant status from API
            // activeOrder.restaurants![i].status = Status.expected;
            if (activeOrder.restaurants![i].name == "Lavazza Coffee") {
              activeOrder.restaurants![i].status = Status.cooking;
            } else if (activeOrder.restaurants![i].name == "MacDonalds") {
              activeOrder.restaurants![i].status = Status.cooking;
            }
          }
        }
        _activeOrder.sort();
        if (activeOrder.restaurants!.last.status == Status.pickedUp) {
          isStateCanChange = true;
        }
        if (_activeOrder.customer != null) {
          _activeOrder.customer!.distance = customerDistance;
        }
      } catch (e) {
        print("Error updating distances: $e");
      }
    });
  }

  void searchingCustomer() {
    futureAPI?.cancel();

    futureAPI = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        courierStatus = CourierStatus.accepting;
        submitText = "Accept";
        isStateCanChange = true;
        _activeOrder = activeOrder;
        if (_activeOrder.restaurants != null) {
          _activeOrder.active = true;
          for (var i = 0; i < _activeOrder.restaurants!.length; i++) {
            if (i < restaurantColors.length) {
              _activeOrder.restaurants![i].color = restaurantColors[i];
            } else {
              _activeOrder.restaurants![i].color = Colors.purple;
            }
          }
        } else {
          print("Warning: No restaurants available in activeOrder");
          _activeOrder = Order(
            restaurants: [],
            customer: _activeOrder.customer,
          );
          _activeOrder.active = false;
        }
      });
    });
  }

  void cancelOrder() async {
    if (courierStatus == CourierStatus.inactive) {
      return;
    } else if (courierStatus == CourierStatus.delivering ||
        courierStatus == CourierStatus.arrivedAtCustomerLocation) {
      bool? cancle = await showYesOrCancleDialog(
        "Are you sure you want to cancel an order you have already accepted? You will be charged the appropriate penalties for doing so",
      );
      if (cancle == null || !cancle) {
        return;
      }
    }
    futureAPI?.cancel();
    setState(() {
      courierStatus = CourierStatus.inactive;
      submitText = "Start";
      isStateCanChange = true;
      _activeOrder = Order(restaurants: null, customer: null);
    });
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _navigateToBalance() {
    setState(() {
      _isMenuOpen = false;
    });

    futureAPI?.cancel();

    widget.changeScreen(BalanceScreen(changeScreen: widget.changeScreen));
  }

  void _navigateToMainPage() async {
    setState(() {
      _isMenuOpen = false;
    });
    bool? confirm = await showYesOrCancleDialog(
      "Are you sure you want to log out?",
    );
    if (confirm == null || !confirm) {
      return;
    }
    futureAPI?.cancel();
    final preferences = await SharedPreferences.getInstance();
    preferences.remove("user_id");
    widget.changeScreen(AuthScreen(changeScreen: widget.changeScreen));
  }

  void showAlertDialog(String text) {
    showDialog(
      context: context,
      builder: (buildContext) {
        return AlertDialog(
          title: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Ok"),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> showYesOrCancleDialog(String text) {
    return showDialog(
      context: context,
      builder: (buildContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(text),
          actions: [
            CustomButton("Yes", () {
              Navigator.of(context).pop(true);
            }),
            CustomButton("Cancle", () {
              Navigator.of(context).pop(false);
            }, color: const Color.fromARGB(255, 218, 43, 31)),
          ],
        );
      },
    );
  }

  TextEditingController? _textEditingController;

  String? checkVerificationCode(String? code) {
    if (code != "1234") {
      return "Verification code is incorrect";
    }
    return null;
  }

  void showVerificationCodeForm() {
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (buildContext) {
        return AlertDialog(
          title: Text("Enter the verification code received from the customer"),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: _textEditingController,
              decoration: InputDecoration(hintText: "Verification code"),
              validator: checkVerificationCode,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancle"),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop();
                  orderFinished = true;
                  courierStatus = CourierStatus.inactive;
                  submitText = "Start";
                }
              },
              child: Text("Ok"),
            ),
          ],
        );
      },
    );
  }

  Widget orderResult() {
    // Getting from API using order_id
    int amountOfMoneyReceived = 60;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text:
              "The order has been successfully completed. Your personal account has been credited with",
          textAlign: TextAlign.center,
          fontSize: 18,
        ),
        CustomText(
          text: "$amountOfMoneyReceived\$",
          color: Colors.green,
          fontSize: 40,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              flex: 8,
              child: CourierMap(
                order: _activeOrder,
                updateState: updateState,
                showAlertDialog: showAlertDialog,
                geolocationStatus: geolocationStatus,
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child:
                    orderFinished
                        ? orderResult()
                        : courierStatus == CourierStatus.searching
                        ? TextForm("Searching for a customer...")
                        : courierStatus != CourierStatus.inactive
                        ? OrderList(activeOrder: _activeOrder)
                        : const SizedBox.shrink(),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      submitText!,
                      changeState,
                      margin: 10,
                      opacity: isStateCanChange ? 1 : 0.5,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: CustomButton(
                      "Cancle",
                      cancelOrder,
                      margin: 10,
                      opacity:
                          courierStatus == CourierStatus.inactive ? 0.5 : 1,
                      color: const Color.fromARGB(255, 218, 43, 31),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Menu Button (top left)
        Positioned(
          top: 40,
          left: 16,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(255, 0, 0, 0),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(_isMenuOpen ? Icons.close : Icons.menu),
              onPressed: _toggleMenu,
              color: const Color.fromARGB(221, 255, 255, 255),
            ),
          ),
        ),

        // Menu Items (when menu is open)
        if (_isMenuOpen)
          Positioned(
            top: 100,
            left: 16,
            child: Container(
              width: 150,
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 0, 0, 0),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet),
                    title: const Text('Balance'),
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    onTap: _navigateToBalance,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    title: const Text('Exit'),
                    onTap: _navigateToMainPage,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
