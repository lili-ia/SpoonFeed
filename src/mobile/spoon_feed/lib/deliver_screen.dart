import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:courier_app/custom_button.dart';
import 'courier_map.dart';

class DeliverScreen extends StatefulWidget {
  const DeliverScreen({super.key, required this.changeScreen});
  final void Function(Widget) changeScreen;
  @override
  State<StatefulWidget> createState() {
    return _DeliverScreenState();
  }
}

class _DeliverScreenState extends State<DeliverScreen> {
  String? submitText = "Start";
  void changeState() {}
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(flex: 3, child: CourierMap()),
        Expanded(flex: 1, child: SizedBox()),
        Expanded(flex: 1, child: CustomButton(submitText!, changeState)),
      ],
    );
  }
}
