import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spoonfeed_customer/api/customer_api.dart';
import 'package:spoonfeed_customer/custom_button.dart';
import 'package:spoonfeed_customer/custom_text.dart';
import 'package:spoonfeed_customer/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.updateUser});
  final Function(int) updateUser;
  @override
  State<StatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool login = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return; // користувач скасував

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final user = userCredential.user;
      if (user == null) return;

      int? userId;
      if (login) {
        userId = await CustomerApi().login(user.email!);
      } else {
        userId = await CustomerApi().register(
          user.email!,
          user.displayName ?? "No Name",
        );
      }

      if (userId == null) return;
      print(userId.toString());
      widget.updateUser(userId);
      context.go("/");
    } catch (e) {
      print("Google sign-in error: $e");
    }
  }

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
              margin: EdgeInsets.symmetric(horizontal: 400),
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
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: signInWithGoogle,
                        icon: Icon(Icons.login),
                        label: Text("Continue with Google"),
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Text.rich(
                    TextSpan(
                      text:
                          login
                              ? "Don't have an account? "
                              : "Have an account? ",
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
        Flexible(
          flex: 1,
          child: SizedBox.expand(
            child: Image.asset("images/loginSignUp.png", fit: BoxFit.fitHeight),
          ),
        ),
      ],
    );
  }
}
