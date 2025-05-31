import 'package:flutter/material.dart';
import 'package:spoonfeed_customer/custom_text.dart';
import 'package:spoonfeed_customer/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? validateEmail(String? email) {
    if (email == null || email != "") {
      return "Email incorrect";
    }
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password != "") {
      return "Password incorrect";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: "Welcome back!",
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
                CustomText(
                  text: "Enter your credentials to access your account",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                CustomTextField(
                  validateEmail,
                  "Enter your email address",
                  _emailController,
                ),
                CustomTextField(
                  validatePassword,
                  "Enter your password",
                  _passwordController,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox.expand(
            child: Image.asset("images/loginSignUp.png", fit: BoxFit.fitHeight),
          ),
        ),
      ],
    );
  }
}
