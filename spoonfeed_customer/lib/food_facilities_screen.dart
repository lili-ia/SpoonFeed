import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spoonfeed_customer/api/facility_api.dart';
import 'package:spoonfeed_customer/api/restaurant_api.dart';
import 'package:spoonfeed_customer/current_state_widget.dart';
import 'package:spoonfeed_customer/custom_text.dart';
import 'package:spoonfeed_customer/models/facility.dart';
import 'package:spoonfeed_customer/models/restaurant.dart';
import 'package:spoonfeed_customer/smooth_scroll_behavior.dart';

class FoodFacilitiesScreen extends StatefulWidget {
  const FoodFacilitiesScreen({super.key, required this.restaurantId});
  final int restaurantId;

  @override
  State<StatefulWidget> createState() {
    return _FoodFacilitiesScreenState();
  }
}

class _FoodFacilitiesScreenState extends State<FoodFacilitiesScreen> {
  @override
  void initState() {
    super.initState();
    restaurant = RestaurantApi().getRestaurant(widget.restaurantId);
    facilities = FacilityApi().getFacilities(widget.restaurantId);
  }

  late Future<Restaurant> restaurant;
  late Future<List<Facility>> facilities;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([restaurant, facilities]),
      builder: (context, snaphot) {
        if (!snaphot.hasData) {
          return SizedBox();
        }
        List data = snaphot.data!;
        Restaurant restaurant = data[0];
        List<Facility> facilities = data[1];
        return Column(
          children: [
            CurrentStateWidget(restaurant: restaurant, address: "Kharkiv"),
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
                                        facilities.map((Facility facility) {
                                          return Container(
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    context.go(
                                                      "/menu/${widget.restaurantId}/${facility.facilityId}",
                                                    );
                                                  },
                                                  child: Column(
                                                    children: [
                                                      CustomText(
                                                        text:
                                                            restaurant
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
      },
    );
  }
}
