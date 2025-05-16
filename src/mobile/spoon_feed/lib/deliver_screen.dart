import 'package:courier_app/auth_screen.dart';
import 'package:courier_app/balance_screen.dart';
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
  bool _isMenuOpen = false;
  
  static List<Color> restaurantColors = const [
    Colors.orange,
    Colors.blue,
    Colors.green,
    Colors.red,
  ];
  ActiveOrder _activeOrder = ActiveOrder(restaurants: null, customer: null);
  
  @override
  void dispose() {
    futureAPI?.cancel();
    super.dispose();
  }
  
  void changeState() {
    setState(() {
      if (currentState == "Inactive") {
        currentState = "Search";
        submitText = "Cancel";
        searchingCustomer();
      } else if (currentState == "Search") {
        currentState = "Inactive";
        submitText = "Start";
        cancelSearching();
      }
    });
  }

  void updateState(
    LatLng courierPosition,
    List<String> restaurantDistance,
    String customerDistance,
  ) {
    if (!mounted || activeOrder.restaurants == null) return;
    
    futureAPI = Timer(const Duration(microseconds: 1), () {});
    
    setState(() {
      try {
        for (var i = 0; i < activeOrder.restaurants!.length; i++) {
          if (i < restaurantDistance.length) {
            activeOrder.restaurants![i].distance = restaurantDistance[i];
          }
        }
        
        if (activeOrder.customer != null) {
          activeOrder.customer!.distance = customerDistance;
        }
      } catch (e) {
        print("Error updating distances: $e");
      }
    });
  }

  void searchingCustomer() {
    futureAPI?.cancel();
    
    futureAPI = Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      
      setState(() {
        currentState = "Accepting";
        submitText = "Accept";
        
        if (activeOrder.restaurants != null) {
          _activeOrder = activeOrder;
          _activeOrder.active = true;
          
          for (var i = 0; i < activeOrder.restaurants!.length; i++) {
            if (i < restaurantColors.length) {
              _activeOrder.restaurants![i].color = restaurantColors[i];
            } else {
              _activeOrder.restaurants![i].color = Colors.purple;
            }
          }
        } else {
          print("Warning: No restaurants available in activeOrder");
          _activeOrder = ActiveOrder(restaurants: [], customer: activeOrder.customer);
          _activeOrder.active = true;
        }
      });
    });
  }

  void cancelSearching() {
    futureAPI?.cancel();
    setState(() {
      currentState = "Inactive";
      submitText = "Start";
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
  
  void _navigateToMainPage() {
    setState(() {
      _isMenuOpen = false;
    });
    
    futureAPI?.cancel();
    
    widget.changeScreen(AuthScreen(changeScreen: widget.changeScreen));
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
                      : const SizedBox.shrink(),
            ),
            Expanded(flex: 1, child: CustomButton(submitText!, changeState)),
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