import 'package:courier_app/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:courier_app/custom_text_field.dart';
import 'package:courier_app/custom_button.dart';
import 'package:courier_app/heading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/gestures.dart';

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

  String? validate(String? input) {
    if (input == null || input.isEmpty) {
      return "This is a required field";
    }
    return null;
  }

  void submit() {
    setState(() {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      if (isSignIn) {
      } else {
        widget.changeScreen(RegisterScreen(changeScreen: widget.changeScreen));
      }
    });
  }

  void signInWithGoogle() async {
    GoogleSignInAccount? user = await _googleSignIn.signIn();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
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
            CustomButton(submitText, submit),
            SizedBox(height: 30),
            SignInButton(Buttons.Google, onPressed: signInWithGoogle),
            SizedBox(height: 6),
            Text.rich(
              TextSpan(
                text: "$suggestionText ",
                style: TextStyle(fontSize: 11),
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
    );
  }
}
