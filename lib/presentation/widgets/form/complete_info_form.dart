import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sep490/data/services/api_services.dart';
import 'package:sep490/presentation/pages/auth/signin_screen.dart';
import 'package:sep490/presentation/pages/navigation_menu.dart';
import 'package:sep490/presentation/widgets/auth_field.dart';
import 'package:sep490/theme/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) {
            return Center(
                child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ));
          });
      // Lấy data
      final WeightIndex = weightController.text.trim();
      final HeightIndex = heightController.text.trim();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final accountId = prefs.getInt('accountId');
      final fullName = prefs.getString('fullName');
      final type = prefs.getString('typeSignUp');
      final email = type == 'Email'
          ? prefs.getString('emailOrPhoneSignUp')
          : prefs.getString('emailOrPhoneSignUpLater');
      final numberPhone = type == 'Phone'
          ? prefs.getString('emailOrPhoneSignUp')
          : prefs.getString('emailOrPhoneSignUpLater');
      final RoleId = prefs.getString('role') == 'Elderly' ? 2 : 3;
      final gender = prefs.getString('gender');
      final dob = prefs.getString('dateOfBirth') ?? '';
      String formatDOB = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
          .format(DateFormat("d/M/yyyy").parse(dob));
      final MedicalRecord = prefs.getStringList('medicalRecord') ?? [];
      String MedicalApi =
          MedicalRecord.map((e) => "MedicalRecord=$e").join("&");

      final Image =
          prefs.getString('avatar') ?? "assets/img/default_avatar.png";
      File avatarFile = File(Image);

      // Gửi data
      print(WeightIndex);
      print(HeightIndex);
      print(accountId);
      print(fullName);
      print(type);
      print(email);
      print(numberPhone);
      print(RoleId);
      print(gender);
      print(formatDOB);
      print(MedicalApi);

      var response = await ApiService.postRequestSignUp(
          "auth-management/managed-auths/sign-ups?AccountId=$accountId&FullName=$fullName&Email=$email&Gender=$gender&DateOfBirth=$formatDOB&PhoneNumber=$numberPhone&RoleId=$RoleId&$MedicalApi&Height=$HeightIndex&Weight=$WeightIndex",
          avatarFile);

      Navigator.of(context).pop();

      if (response['success'] && response['data']['isSuccess']) {
        Fluttertoast.showToast(
          msg: "Xác nhận thông tin thành công!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignInScreen(),
          ),
        );
      } else {
        Fluttertoast.showToast(
          msg: "Cõ lỗi trong quá trình xử lí",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
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
