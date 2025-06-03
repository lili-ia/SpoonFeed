import 'package:flutter/material.dart';
import 'package:spoonfeed_customer/custom_text.dart';
import 'package:spoonfeed_customer/models/dish.dart';
import 'package:spoonfeed_customer/widgets/dish_popup.dart';

class DishContainer extends StatelessWidget {
  const DishContainer({super.key, required this.dish});
  final Dish dish;

  void _showDishPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return DishPopup(dish: dish);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDishPopup(context),
      child: Container(
        margin: const EdgeInsets.all(30),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 240,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: dish.dishName,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    alignment: Alignment.centerLeft,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 10),
                  CustomText(
                    text: dish.description,
                    alignment: Alignment.centerLeft,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CustomText(
                        text: "${dish.priceWithDiscount}\$ ",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      CustomText(
                        text: "-${dish.discount}% ",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      CustomText(
                        text: "${dish.price}\$",
                        textDecoration: TextDecoration.lineThrough,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Image.asset(
              "images/dish_images/${dish.dishId}.jpg",
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.restaurant,
                    size: 30,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
