import 'package:flutter/material.dart';

class CustomDropdownMenu extends StatefulWidget {
  const CustomDropdownMenu({
    super.key,
    required this.elements,
    required this.onChanged,
  });
  final List<String> elements;
  final void Function(String?) onChanged;
  @override
  State<StatefulWidget> createState() {
    return _CustomDropdownMenuState();
  }
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  String? currentElement;
  @override
  Widget build(BuildContext context) {
    currentElement ??= widget.elements[0];
    return SizedBox(
      width: 100,
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
        onChanged: (String? value) {
          widget.onChanged(value);
          currentElement = value;
        },
      ),
    );
  }
}
