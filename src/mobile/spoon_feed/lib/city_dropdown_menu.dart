import 'package:flutter/material.dart';

class CityDropdownMenu extends StatefulWidget {
  const CityDropdownMenu({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CityDropdownMenuState();
  }
}

class _CityDropdownMenuState extends State<CityDropdownMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: DropdownButtonFormField(
        iconEnabledColor: const Color.fromARGB(255, 141, 135, 135),
        iconDisabledColor: const Color.fromARGB(255, 141, 135, 135),
        items:
            ['Kharkiv'].map((String element) {
              return DropdownMenuItem(child: Text(element));
            }).toList(),
        onChanged: null,
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
      ),
    );
  }
}
