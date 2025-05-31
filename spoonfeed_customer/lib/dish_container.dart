import 'package:flutter/material.dart';
import 'package:spoonfeed_customer/custom_text.dart';
import 'package:spoonfeed_customer/models/dish.dart';

class DishContainer extends StatelessWidget {
  const DishContainer({super.key, required this.dish});
  final Dish dish;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(30),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
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
                SizedBox(height: 10),
                CustomText(
                  text: dish.description,
                  alignment: Alignment.centerLeft,
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    CustomText(
                      text: "${dish.priceWithDiscount}\$  ",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomText(
                      text: "-${dish.discount}%  ",
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
          Image.asset("images/dish_images/${dish.dishId}.png"),
        ],
      ),
    );
  }
}
