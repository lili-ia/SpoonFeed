import 'package:courier_app/deliver_screen.dart';
import 'package:courier_app/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:courier_app/custom_text_field.dart';
import 'package:courier_app/custom_button.dart';
import 'package:courier_app/heading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.changeScreen});

  final void Function(Widget) changeScreen;

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _googleSignIn = GoogleSignIn();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String titleText = "Register";
  String submitText = "Continue";
  String suggestionText = "Already have an account?";
  String switchText = "Sign in";
  bool isSignIn = false;
  void switchState() {
    setState(() {
      isSignIn = !isSignIn;
      if (isSignIn) {
        titleText = "Sign In";
        submitText = "Welcome back!";
        suggestionText = "Not a member?";
        switchText = "Sign up";
      } else {
        titleText = "Register";
        submitText = "Continue";
        suggestionText = "Already have an account?";
        switchText = "Sign in";
      }
    });
  }

  void checkAuth() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    if (!sharedPreferences.containsKey("user_id")) {
      return;
    }
    sharedPreferences.getInt("user_id");
    widget.changeScreen(DeliverScreen(changeScreen: widget.changeScreen));
  }

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  String? validate(String? input) {
    // if (input == null || input.isEmpty) {
    //   return "This is a required field";
    // }
    return null;
  }

  void submit() async {
    setState(() {
      if (!_formKey.currentState!.validate()) {
        return;
      }
    });
    if (isSignIn) {
      int user_id = 1;
      final preferences = await SharedPreferences.getInstance();
      preferences.setInt("user_id", user_id);
      setState(() {
        widget.changeScreen(DeliverScreen(changeScreen: widget.changeScreen));
      });
    } else {
      setState(() {
        widget.changeScreen(RegisterScreen(changeScreen: widget.changeScreen));
      });
    }
  }

  void signInWithGoogle() async {
    GoogleSignInAccount? user = await _googleSignIn.signIn();
    if (user != null) {
      print(
        "Login successful: Email: ${user.email}, Username: ${user.displayName}",
      );
    } else {
      print("Unsuccessful login.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(30),
                        child: Image.asset('images/spoonfeed_logo.png'),
                      ),
                      Heading(titleText),
                      CustomTextField(validate, "Email", _emailController),
                      CustomTextField(
                        validate,
                        "Password",
                        _passwordController,
                        obscureText: true,
                      ),
                      SizedBox(height: 30),
                      CustomButton(submitText, submit),
                      SizedBox(height: 30),
                      SignInButton(Buttons.Google, onPressed: signInWithGoogle),
                      SizedBox(height: 6),
                      Text.rich(
                        TextSpan(
                          text: "$suggestionText ",
                          style: TextStyle(fontSize: 14),
                          children: [
                            TextSpan(
                              text: switchText,
                              style: TextStyle(color: Colors.blue),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      switchState();
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
          ),
        ),
      ],
    );
  }
}
