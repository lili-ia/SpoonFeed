import 'package:flutter/material.dart';

class CustomDropdownMenu extends StatefulWidget {
  const CustomDropdownMenu({
    super.key,
    required this.values,
    required this.onSelected,
  });
  final List<String> values;
  final Function(String?) onSelected;
  @override
  State<StatefulWidget> createState() {
    return _CustomDropdownMenuState();
  }
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  String? selectedValue = 'Kharkiv';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      iconEnabledColor: const Color.fromARGB(255, 141, 135, 135),
      iconDisabledColor: const Color.fromARGB(255, 141, 135, 135),
      value: selectedValue,
      items:
          widget.values.map((String element) {
            return DropdownMenuItem(value: element, child: Text(element));
          }).toList(),
      onChanged: (value) {
        widget.onSelected(value);
        setState(() {
          selectedValue = value;
        });
      },
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 2,
            color: const Color.fromARGB(255, 141, 135, 135),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 2, color: Colors.black),
        ),
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }
}
