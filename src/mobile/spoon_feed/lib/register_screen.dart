import 'package:courier_app/auth_screen.dart';
import 'package:courier_app/custom_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:courier_app/custom_text_field.dart';
import 'package:courier_app/custom_button.dart';
import 'package:courier_app/heading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:courier_app/city_dropdown_menu.dart';
import 'package:http/http.dart';
import 'package:file_picker/file_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.changeScreen});

  final void Function(Widget) changeScreen;

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _googleSignIn = GoogleSignIn();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  PlatformFile? platformFile;

  String? validate(String? input) {
    if (input == null || input.isEmpty) {
      return "";
    }
    return null;
  }

  void signUp() {}

  void signInWithGoogle() async {
    GoogleSignInAccount? user = await _googleSignIn.signIn();
  }

  void pickFile() async {
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles();
    if (filePickerResult != null) {
      platformFile = filePickerResult.files.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              child: Image.asset('images/spoonfeed_logo.png'),
            ),
            Heading("Registration (second step)"),
            SizedBox(
              height: 300,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextField(validate, "Name", _nameController),
                    CustomTextField(validate, "Phone number", _nameController),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 30),
                      child: Text(
                        "Identity document:",
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                    CustomText(platformFile == null ? "" : platformFile!.name),
                    TextButton.icon(
                      onPressed: pickFile,
                      label: CustomText("Choose file"),
                      icon: Icon(Icons.upload_file),
                      iconAlignment: IconAlignment.end,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                    ),
                    CityDropdownMenu(),
                  ],
                ),
              ),
            ),

            CustomButton("Register!", signUp),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 6),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                ),
                onPressed: () {
                  widget.changeScreen(
                    AuthScreen(changeScreen: widget.changeScreen),
                  );
                },
                child: CustomText("Back"),
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
