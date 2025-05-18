import 'package:courier_app/auth_screen.dart';
import 'package:courier_app/custom_text_for_button.dart';
import 'package:courier_app/deliver_screen.dart';
import 'package:courier_app/text_form.dart';
import 'package:flutter/material.dart';
import 'package:courier_app/custom_text_field.dart';
import 'package:courier_app/custom_button.dart';
import 'package:courier_app/heading.dart';
import 'package:courier_app/custom_dropdown_menu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:courier_app/upload_file_field.dart';
import 'package:courier_app/vehicle_type_radio_list_tile.dart';
import 'package:courier_app/data/vehicle_types.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.changeScreen});

  final void Function(Widget) changeScreen;

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  List<String> cities = ['Kharkiv', 'Kyev'];
  String? selectedCity = "Kharkiv";
  String? selectedVehicleType = "bike";
  PlatformFile? platformFile;

  String? validate(String? input) {
    if (input == null || input.isEmpty) {
      return "";
    }
    return null;
  }

  void signUp() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        widget.changeScreen(DeliverScreen(changeScreen: widget.changeScreen));
      });
    }
  }

  void onCitySelected(String? city) {
    selectedCity = city;
  }

  void onVehicleTypeSelected(String? vehicleType) {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      child: Image.asset('images/spoonfeed_logo.png'),
                    ),
                    Heading("Registration (next step)"),
                    SizedBox(
                      height: 300,
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(
                                validate,
                                "Name",
                                _nameController,
                              ),
                              CustomTextField(
                                validate,
                                "Phone number",
                                _phoneController,
                              ),
                              UploadFileField(title: "Identity document:"),
                              TextForm("City:"),
                              SizedBox(height: 10),
                              CustomDropdownMenu(
                                values: cities,
                                onSelected: onCitySelected,
                              ),
                              SizedBox(height: 10),
                              VehicleTypeRadioListTile(
                                values: vehicleTypes,
                                onSelected: onVehicleTypeSelected,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
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
                        child: CustomTextForButton("Back"),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
