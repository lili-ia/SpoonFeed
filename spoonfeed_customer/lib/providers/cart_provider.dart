import 'package:flutter/foundation.dart';
import 'package:spoonfeed_customer/models/dish.dart';
import 'package:spoonfeed_customer/models/cart_item.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  double _deliveryFee = 25.0; // Fixed delivery fee

  List<CartItem> get items => _items;
  
  double get deliveryFee => _deliveryFee;

  double get subtotal {
    return _items.fold(0.0, (sum, item) => sum + (item.dish.priceWithDiscount * item.quantity));
  }

  double get total {
    return subtotal + deliveryFee;
  }

  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  void addItem(Dish dish, int quantity) {
    // Check if item already exists in cart
    final existingIndex = _items.indexWhere((item) => item.dish.dishId == dish.dishId);
    
    if (existingIndex >= 0) {
      // Update quantity if item exists
      _items[existingIndex] = CartItem(
        dish: _items[existingIndex].dish,
        quantity: _items[existingIndex].quantity + quantity,
      );
    } else {
      // Add new item to cart
      _items.add(CartItem(dish: dish, quantity: quantity));
    }
    
    notifyListeners();
  }

  void removeItem(int dishId) {
    _items.removeWhere((item) => item.dish.dishId == dishId);
    notifyListeners();
  }

  void updateQuantity(int dishId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(dishId);
      return;
    }

    final index = _items.indexWhere((item) => item.dish.dishId == dishId);
    if (index >= 0) {
      _items[index] = CartItem(
        dish: _items[index].dish,
        quantity: newQuantity,
      );
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  bool get isEmpty => _items.isEmpty;
}