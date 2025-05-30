import 'package:flutter/material.dart';
import 'package:spoonfeed_customer/custom_text.dart';
import 'package:spoonfeed_customer/footer_list.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Color(0xFFD9D9D9),
          child: SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("images/spoonfeed_logo.png"),
                FooterList(
                  header: "Legal pages",
                  links: [
                    "Terms and conditions",
                    "Privacy",
                    "Cookies",
                    "Modern Slavery Statement",
                  ],
                ),
                FooterList(
                  header: "Important Links",
                  links: [
                    "Get help",
                    "Add your restaurant",
                    "Sign up to deliver",
                    "Create a business account",
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          color: Colors.black,
          child: SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomText(
                  text: "SpoonFeed Copyright 2025, All Rights Reserved.",
                  color: Colors.white,
                ),
                Row(
                  children:
                      [
                        "Privacy policy",
                        "Terms",
                        "Pricing",
                        "Do not sell or share my personal information",
                      ].map((String element) {
                        return TextButton(
                          onPressed: () {},
                          child: CustomText(text: element, color: Colors.white),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
