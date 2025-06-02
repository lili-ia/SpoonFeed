import 'package:spoonfeed_customer/models/dish.dart';

class CartItem {
  final Dish dish;
  final int quantity;

  CartItem({
    required this.dish,
    required this.quantity,
  });

  double get totalPrice => dish.priceWithDiscount * quantity;

  CartItem copyWith({
    Dish? dish,
    int? quantity,
  }) {
    return CartItem(
      dish: dish ?? this.dish,
      quantity: quantity ?? this.quantity,
    );
  }
}