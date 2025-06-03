import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spoonfeed_customer/providers/cart_provider.dart';
import 'widgets/cart_item_widget.dart';
import 'widgets/address_picker_dialog.dart';

class CartScreen extends StatefulWidget {
  final String? userName;
  
  const CartScreen({super.key, this.userName});

  @override
  State<StatefulWidget> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends State<CartScreen> {
  String selectedLocation = "Choose your location...";
  String selectedPaymentMethod = "Visa •••• •••• •••• 4563";
  List<String> recentAddresses = [];
  
  bool get isLoggedIn => widget.userName != null;

  @override
  void initState() {
    super.initState();
    _loadRecentAddresses();
  }

  Future<void> _loadRecentAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      recentAddresses = prefs.getStringList('recent_addresses') ?? [];
      selectedLocation =
          prefs.getString('selected_address') ?? "Choose your location...";
    });
  }

  Future<void> _saveRecentAddress(String address) async {
    final prefs = await SharedPreferences.getInstance();

    recentAddresses.remove(address);
    recentAddresses.insert(0, address);
    if (recentAddresses.length > 5) {
      recentAddresses = recentAddresses.take(5).toList();
    }

    await prefs.setStringList('recent_addresses', recentAddresses);
    await prefs.setString('selected_address', address);
    setState(() {});
  }

  Future<List<String>> _searchAddresses(String query) async {
    final List<String> predefinedAddresses = [
      'вул. Хрещатик, 22, Київ',
      'просп. Свободи, 16, Львів',
      'вул. Дерибасівська, 5, Одеса',
      'вул. Сумська, 25, Харків',
      'вул. Катерининська, 12, Дніпро',
    ];

    return predefinedAddresses
        .where((address) => address.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void _showLocationPicker() {
    showDialog(
      context: context,
      builder: (context) => AddressPickerDialog(
        onAddressSelected: (address) {
          setState(() {
            selectedLocation = address;
          });
          _saveRecentAddress(address);
        },
        recentAddresses: recentAddresses,
        onSearchAddresses: _searchAddresses,
      ),
    );
  }

  void _addPaymentMethod() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Payment Method"),
        content: const Text("Payment method selection would go here"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _payInCash() {
    setState(() {
      selectedPaymentMethod = "Pay in Cash";
    });
  }

  void _addPromoCode() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Promo Code"),
        content: const TextField(
          decoration: InputDecoration(hintText: "Enter promo code"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Apply"),
          ),
        ],
      ),
    );
  }

  void _placeOrder() {
    final cart = Provider.of<CartProvider>(context, listen: false);
    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Your cart is empty!")),
      );
      return;
    }

    if (selectedLocation == "Choose your location...") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a delivery address!")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Order Placed!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your order total is ${cart.total.toStringAsFixed(2)}₴"),
            const SizedBox(height: 10),
            Text("Delivery to: $selectedLocation"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              cart.clearCart();
              Navigator.pop(context);
              context.go('/');
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _goToLogin() {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE4934C),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          return Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF5E6B8),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.go('/'),
                      child: const Icon(Icons.arrow_back, size: 24),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => context.go('/'),
                      child: const Text(
                        "Back to Menu",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                const Text(
                  "Your basket",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Main Content - Two Column Layout
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left side - Cart Items (60% width)
                      Expanded(
                        flex: 3,
                        child: cart.items.isEmpty
                            ? const Center(
                                child: Text(
                                  "Your cart is empty",
                                  style: TextStyle(fontSize: 18, color: Colors.grey),
                                ),
                              )
                            : ListView.builder(
                                itemCount: cart.items.length,
                                itemBuilder: (context, index) {
                                  final cartItem = cart.items[index];
                                  return CartItemWidget(
                                    cartItem: cartItem,
                                    onQuantityChanged: (quantity) {
                                      cart.updateQuantity(cartItem.dish.dishId, quantity);
                                    },
                                    onRemove: () {
                                      cart.removeItem(cartItem.dish.dishId);
                                    },
                                  );
                                },
                              ),
                      ),
                      
                      const SizedBox(width: 20),
                      
                      // Right side - Order Summary (40% width)
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Location Section (only show when logged in)
                                if (isLoggedIn) ...[
                                  const Text(
                                    "Delivery Address",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: _showLocationPicker,
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey[300]!),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.location_on, color: Colors.blue),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              selectedLocation,
                                              style: TextStyle(
                                                color: selectedLocation == "Choose your location..."
                                                    ? Colors.grey[600]
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                          const Icon(Icons.arrow_drop_down, color: Colors.grey),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  
                                  // Payment Method Section (only when logged in)
                                  const Text(
                                    "Payment method",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const SizedBox(height: 10),
                                  
                                  // Payment method options
                                  Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey[300]!),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            Radio<String>(
                                              value: "Visa •••• •••• •••• 4563",
                                              groupValue: selectedPaymentMethod,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedPaymentMethod = value!;
                                                });
                                              },
                                            ),
                                            const Text("💳"),
                                            const SizedBox(width: 8),
                                            const Expanded(
                                              child: Text("Visa •••• •••• •••• 4563"),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey[300]!),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            Radio<String>(
                                              value: "•••• •••• •••• 4456",
                                              groupValue: selectedPaymentMethod,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedPaymentMethod = value!;
                                                });
                                              },
                                            ),
                                            const Text("💳"),
                                            const SizedBox(width: 8),
                                            const Expanded(
                                              child: Text("•••• •••• •••• 4456"),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey[300]!),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            Radio<String>(
                                              value: "Visa •••• •••• •••• 6643",
                                              groupValue: selectedPaymentMethod,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedPaymentMethod = value!;
                                                });
                                              },
                                            ),
                                            const Text("💳"),
                                            const SizedBox(width: 8),
                                            const Expanded(
                                              child: Text("Visa •••• •••• •••• 6643"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  const SizedBox(height: 10),
                                  
                                  // Add New Card Button
                                  GestureDetector(
                                    onTap: _addPaymentMethod,
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.blue),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add, color: Colors.blue),
                                          SizedBox(width: 8),
                                          Text(
                                            "Add New Card",
                                            style: TextStyle(color: Colors.blue),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 10),
                                  
                                  // Pay in Cash Button
                                  GestureDetector(
                                    onTap: _payInCash,
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.blue),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.money, color: Colors.blue),
                                          SizedBox(width: 8),
                                          Text(
                                            "Pay in Cash",
                                            style: TextStyle(color: Colors.blue),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 20),
                                ],
                                
                                // Order Summary
                                const Text(
                                  "Order Summary",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 15),
                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Subtotal"),
                                    Text("${cart.subtotal.toStringAsFixed(0)}₴"),
                                  ],
                                ),
                                
                                const SizedBox(height: 8),
                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Delivery Fee"),
                                    Text("${cart.deliveryFee.toStringAsFixed(0)}₴"),
                                  ],
                                ),
                                
                                const Divider(height: 20),
                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Total",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                    Text(
                                      "${cart.total.toStringAsFixed(0)}₴",
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // Add Coupon Button
                                GestureDetector(
                                  onTap: _addPromoCode,
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blue),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.local_offer, color: Colors.blue),
                                        SizedBox(width: 8),
                                        Text(
                                          "Add your coupon",
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 15),
                                
                                // Action Button (changes based on login status)
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: isLoggedIn ? _placeOrder : _goToLogin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isLoggedIn ? Colors.green : Colors.black,
                                      padding: const EdgeInsets.all(15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      isLoggedIn ? "Purchase" : "Login/Signup to continue",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}