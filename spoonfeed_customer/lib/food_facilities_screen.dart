import 'package:flutter/material.dart';
import 'package:spoonfeed_customer/current_state_widget.dart';
import 'package:spoonfeed_customer/custom_text.dart';
import 'package:spoonfeed_customer/menu_sceen.dart';
import 'package:spoonfeed_customer/models/facility.dart';
import 'package:spoonfeed_customer/models/restaurant.dart';
import 'package:spoonfeed_customer/smooth_scroll_behavior.dart';

class FoodFacilitiesScreen extends StatefulWidget {
  const FoodFacilitiesScreen({
    super.key,
    required this.changeScreen,
    required this.restaurant,
    required this.city,
  });

  final void Function(Widget) changeScreen;

  final String city;

  final Restaurant restaurant;

  List<Facility> getFacilities() {
    return [
      Facility(
        1,
        "2a Hryhorii Skovoroda St.",
        "+3809415968585",
        "https://www.kfc-ukraine.com/",
        3,
      ),
      Facility(
        2,
        "3a Hryhorii Skovoroda St.",
        "+3809415968585",
        "https://www.kfc-ukraine.com/",
        3,
      ),
      Facility(
        3,
        "4a Hryhorii Skovoroda St.",
        "+3809415968585",
        "https://www.kfc-ukraine.com/",
        3,
      ),
      Facility(
        4,
        "5a Hryhorii Skovoroda St.",
        "+3809415968585",
        "https://www.kfc-ukraine.com/",
        3,
      ),
      Facility(
        5,
        "6a Hryhorii Skovoroda St.",
        "+3809415968585",
        "https://www.kfc-ukraine.com/",
        3,
      ),
      Facility(
        6,
        "7a Hryhorii Skovoroda St.",
        "+3809415968585",
        "https://www.kfc-ukraine.com/",
        3,
      ),
      Facility(
        7,
        "8a Hryhorii Skovoroda St.",
        "+3809415968585",
        "https://www.kfc-ukraine.com/",
        3,
      ),
    ];
  }

  @override
  State<StatefulWidget> createState() {
    return _FoodFacilitiesScreenState();
  }
}

class _FoodFacilitiesScreenState extends State<FoodFacilitiesScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CurrentStateWidget(restaurant: widget.restaurant, address: widget.city),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Colors.black,
                margin: EdgeInsets.all(35),
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 6),
                child: Column(
                  children: [
                    CustomText(
                      text: "Select a food spot:",
                      color: Color(0xFFF24822),
                      fontSize: 30,
                    ),
                    Expanded(
                      child: ScrollbarTheme(
                        data: ScrollbarThemeData(
                          thumbColor: WidgetStateProperty.all<Color>(
                            Colors.white,
                          ),
                        ),
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: ScrollConfiguration(
                            behavior: SmoothScrollBehavior(),
                            child: SingleChildScrollView(
                              child: Column(
                                children:
                                    widget.getFacilities().map((
                                      Facility facility,
                                    ) {
                                      return Container(
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                widget.changeScreen(
                                                  MenuScreen(
                                                    changeScreen:
                                                        widget.changeScreen,
                                                    facility: facility,
                                                    city: widget.city,
                                                    restaurant:
                                                        widget.restaurant,
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                children: [
                                                  CustomText(
                                                    text:
                                                        widget
                                                            .restaurant
                                                            .restaurant,
                                                    color: const Color(
                                                      0xffF24822,
                                                    ),
                                                  ),
                                                  CustomText(
                                                    text: facility.address,
                                                    color: const Color(
                                                      0xFFFC8A06,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
