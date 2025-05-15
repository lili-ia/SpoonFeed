import 'package:flutter/material.dart';
import 'package:courier_app/models/vehicle_type.dart';
import 'package:courier_app/text_form.dart';

class VehicleTypeRadioListTile extends StatefulWidget {
  const VehicleTypeRadioListTile({
    super.key,
    required this.values,
    required this.onSelected,
  });
  final List<VehicleType> values;

  final Function(String?) onSelected;
  @override
  State<StatefulWidget> createState() {
    return _VehicleTypeRadioListTileState();
  }
}

class _VehicleTypeRadioListTileState extends State<VehicleTypeRadioListTile> {
  VehicleType? selectedValue;
  @override
  void initState() {
    super.initState();
    selectedValue = widget.values[0];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextForm("Vehicle type:"),
        ...widget.values.map((value) {
          return RadioListTile<VehicleType>(
            selectedTileColor: Colors.black,
            activeColor: Colors.black,
            title: Row(
              children: [
                Icon(value.icon),
                SizedBox(width: 20),
                Text(
                  value.value,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
            value: value,
            groupValue: selectedValue,
            onChanged: (value) {
              widget.onSelected(value?.value);
              setState(() {
                selectedValue = value;
              });
            },
          );
        }),
      ],
    );
  }
}
