import 'package:flutter/material.dart';
import 'package:spoonfeed_customer/custom_table_cell.dart';
import 'package:spoonfeed_customer/custom_text.dart';
import 'package:spoonfeed_customer/models/order.dart';

class DishesPopUp extends StatelessWidget {
  const DishesPopUp({super.key, required this.dishes});

  final List<DishInOrder> dishes;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.all(6),
      title: CustomText(text: "Dishes", fontSize: 20),
      content: SizedBox(
        width: 900,
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Table(
              children:
                  dishes.map((dish) {
                    return TableRow(
                      children: [
                        CustomTableCell(
                          child: Image.asset(
                            "images/dish_images/${dish.id}.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                        CustomTableCell(
                          child: CustomText(
                            text: dish.name,
                            textAlign: TextAlign.center,
                            fontSize: 30,
                          ),
                        ),
                        CustomTableCell(
                          child: CustomText(
                            text: dish.count.toString(),
                            fontSize: 30,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: CustomText(text: "Ok"),
        ),
      ],
    );
  }
}
