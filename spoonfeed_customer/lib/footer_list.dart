import 'package:flutter/material.dart';
import 'package:spoonfeed_customer/custom_text.dart';

class FooterList extends StatelessWidget {
  const FooterList({super.key, required this.header, required this.links});
  final String header;
  final List<String> links;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(text: header, fontWeight: FontWeight.bold),
        ...links.map((String element) {
          return Padding(
            padding: EdgeInsets.all(5),
            child: CustomText(
              text: element,
              textDecoration: TextDecoration.underline,
            ),
          );
        }),
      ],
    );
  }
}
