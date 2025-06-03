import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:spoonfeed_customer/footer.dart';
import 'package:spoonfeed_customer/navigation_menu.dart';
import 'package:spoonfeed_customer/providers/cart_provider.dart';

class MainLayout extends StatefulWidget {
  final Widget widget;
  final String currentCity;
  final Function(String) onChangeCity;
  final String? userName;
  final Function(int?) logout;

  const MainLayout({
    super.key,
    required this.widget,
    required this.currentCity,
    required this.onChangeCity,
    this.userName,
    required this.logout,
  });

  @override
  State<StatefulWidget> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xFFEAB045)),
        child: Column(
          children: [
            NavigationMenu(
              onChange: widget.onChangeCity,
              city: widget.currentCity,
              userName: widget.userName,
              logout: widget.logout,
            ),
            Expanded(child: widget.widget),
            Footer(),
          ],
        ),
      ),
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.isEmpty) {
            return const SizedBox.shrink();
          }

          return FloatingActionButton.extended(
            onPressed: () {
              context.go('/cart');
            },
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${cart.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: Text(
              'Cart (${cart.total.toStringAsFixed(0)}₴)',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
