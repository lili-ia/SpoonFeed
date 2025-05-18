import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:courier_app/custom_text_for_button.dart';
import 'package:courier_app/text_form.dart';

class UploadFileField extends StatefulWidget {
  const UploadFileField({super.key, required this.title});
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _UploadFileFieldState();
  }
}

class _UploadFileFieldState extends State<UploadFileField> {
  PlatformFile? platformFile;

  void pickFile() async {
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles();
    if (filePickerResult != null) {
      setState(() {
        platformFile = filePickerResult.files.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextForm(widget.title),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.centerLeft,
          child: Column(
            children: [
              Visibility(
                visible: platformFile != null,
                child: Text(
                  platformFile == null ? "" : platformFile!.name,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 99, 92, 92),
                    fontSize: 12,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: pickFile,
                label: CustomTextForButton("Choose file"),
                icon: Icon(Icons.upload_file),
                iconAlignment: IconAlignment.end,
                style: TextButton.styleFrom(backgroundColor: Colors.blueAccent),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
