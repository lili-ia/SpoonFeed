import 'package:courier_app/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:courier_app/models/order.dart';
import 'package:courier_app/table_cell.dart';

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
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Table(
              children:
                  dishes.map((dish) {
                    return TableRow(
                      children: [
                        CustomTableCell(
                          child: Image.asset("images/${dish.id}.avif"),
                        ),
                        CustomTableCell(
                          child: CustomText(
                            text: dish.name,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        CustomTableCell(
                          child: CustomText(text: dish.count.toString()),
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
