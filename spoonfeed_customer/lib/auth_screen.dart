import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spoonfeed_customer/api/customer_api.dart';
import 'package:spoonfeed_customer/custom_button.dart';
import 'package:spoonfeed_customer/custom_text.dart';
import 'package:spoonfeed_customer/custom_text_field.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.updateUser});
  final Function(int) updateUser;
  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  bool login = true;
  final _formKey = GlobalKey<FormState>();
  // final _googleSignIn = GoogleSignIn();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  // void signInWithGoogle() async {
  //   GoogleSignInAccount? user = await _googleSignIn.signIn();
  //   if (user == null) {
  //     return;
  //   }
  //   int? userId;
  //   if (login) {
  //     userId = await CustomerApi().login(_emailController.text);
  //   } else {
  //     userId = await CustomerApi().register(user.email, user.displayName!);
  //   }
  //   if (userId == null) {
  //     return;
  //   }
  //   widget.updateUser(userId);
  //   context.go("/");
  // }

  String? validateEmail(String? email) {
    if (email == null || email == "") {
      return "Email incorrect";
    }
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password == "") {
      return "Password incorrect";
    }
    return null;
  }

  String? validateName(String? name) {
    if (name == null || name == "") {
      return "Name incorrect";
    }
    return null;
  }

  void submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    int? userId;
    if (login) {
      userId = await CustomerApi().login(_emailController.text);
    } else {
      userId = await CustomerApi().register(
        _emailController.text,
        _passwordController.text,
      );
    }

    if (userId == null) {
      return;
    }
    widget.updateUser(userId);
    context.go("/");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 200),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: login ? "Welcome back!" : "Get started now",
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                  login
                      ? CustomText(
                        text: "Enter your credentials to access your account",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )
                      : CustomTextField(
                        validateName,
                        "Enter your name",
                        _nameController,
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
                  SizedBox(height: 50),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomButton(
                        onClick: submit,
                        text: login ? "Login" : "Signup",
                      ),
                    ],
                  ),
                  // SignInButton(Buttons.Google, onPressed: signInWithGoogle),
                  Text.rich(
                    TextSpan(
                      text:
                          login ? "Don't have an account?" : "Have an account?",
                      style: TextStyle(fontSize: 14),
                      children: [
                        TextSpan(
                          text: login ? "Sign up" : "Sign in",
                          style: TextStyle(color: Colors.blue),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  setState(() {
                                    login = !login;
                                  });
                                },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
