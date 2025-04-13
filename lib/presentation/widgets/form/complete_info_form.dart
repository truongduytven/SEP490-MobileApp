import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/presentation/pages/auth/medical_record.dart';
import 'package:sep490/presentation/widgets/auth_field.dart';
import 'package:sep490/theme/color.dart';

class CompleteInfoForm extends StatefulWidget {
  const CompleteInfoForm({super.key});

  @override
  State<CompleteInfoForm> createState() => _CompleteInfoFormState();
}

class _CompleteInfoFormState extends State<CompleteInfoForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    weightController.addListener(_valuechanged);
    heightController.addListener(_valuechanged);
  }

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  void _valuechanged() {
    if (weightController.text.isNotEmpty && heightController.text.isNotEmpty) {
      setState(() {
        isButtonEnabled = true;
      });
    } else {
      setState(() {
        isButtonEnabled = false;
      });
    }
  }

  Future<String> getDefaultAvatarPath() async {
    final byteData = await rootBundle.load('assets/img/default_avatar.png');
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/default_avatar.png');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file.path;
  }

  void handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      SharedPrefsHelper prefsHelper = SharedPrefsHelper();
      prefsHelper.setString('height', heightController.text.trim());
      prefsHelper.setString('weight', weightController.text.trim());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MedicalRecordScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            AuthField(
              labelText: "Cân nặng",
              hintText: "Nhập cân nặng",
              controller: weightController,
              keyboardType: TextInputType.number,
              isRequired: true,
              suffixText: "(kg)",
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            AuthField(
              labelText: "Chiều cao",
              hintText: "Nhập chiều cao",
              controller: heightController,
              keyboardType: TextInputType.number,
              isRequired: true,
              suffixText: "(cm)",
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            ElevatedButton(
              onPressed: isButtonEnabled
                  ? () {
                      handleSubmit();
                    }
                  : null,         
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.secondaryColor,
                foregroundColor: AppColors.bgColor,
                minimumSize: const Size(double.infinity, 55),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              child: const Text(
                "Tiếp tục",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ));
  }
}
