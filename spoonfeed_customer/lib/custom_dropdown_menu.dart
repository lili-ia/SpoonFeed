import 'package:flutter/material.dart';

class CustomDropdownMenu extends StatefulWidget {
  const CustomDropdownMenu({
    super.key,
    required this.elements,
    required this.onChange,
    required this.currentElement,
  });
  final List<String> elements;
  final Function(String) onChange;
  final String currentElement;
  @override
  State<StatefulWidget> createState() {
    return _CustomDropdownMenuState();
  }
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  String? currentElement;
  @override
  Widget build(BuildContext context) {
    currentElement ??= widget.currentElement;
    return SizedBox(
      width: 150,
      child: DropdownButtonFormField<String>(
        value: currentElement,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF24822),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),

          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        items:
            widget.elements.map((element) {
              return DropdownMenuItem<String>(
                value: element,
                child: Text(element),
              );
            }).toList(),
        onChanged: (String? value) async {
          currentElement = value;
          widget.onChange(value!);
        },
      ),
    );
  }
}
