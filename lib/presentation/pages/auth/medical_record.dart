import 'dart:io';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sep490/data/services/api_services.dart';
import 'package:sep490/presentation/pages/auth/signin_screen.dart';
import 'package:sep490/presentation/widgets/form/medical_record_form.dart';
import 'package:sep490/theme/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicalRecordScreen extends StatefulWidget {
  const MedicalRecordScreen({super.key});

  @override
  State<MedicalRecordScreen> createState() => _MedicalRecordScreenState();
}

class _MedicalRecordScreenState extends State<MedicalRecordScreen> {
  List<Map<String, String>> selectedTreatments = [];

  Future<void> submitForm() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ));
        });
    // Lấy data
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final weightIndex = prefs.getString('weight') ?? '0';
    final heightIndex = prefs.getString('height') ?? '0';
    final accountId = prefs.getInt('accountId');
    final fullName = prefs.getString('fullName');
    final type = prefs.getString('typeSignUp');
    final email = type == 'Email'
        ? prefs.getString('emailOrPhoneSignUp')
        : prefs.getString('emailOrPhoneSignUpLater');
    final numberPhone = type == 'Phone number'
        ? prefs.getString('emailOrPhoneSignUp')
        : prefs.getString('emailOrPhoneSignUpLater');
    final roleId = prefs.getString('role') == 'Elderly' ? 2 : 3;
    final gender = prefs.getString('gender');
    final dob = prefs.getString('dateOfBirth') ?? '';
    String formatDOB = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
        .format(DateFormat("d/M/yyyy").parse(dob));
    String medicalApi = '';
    if (selectedTreatments.isNotEmpty) {
      medicalApi = selectedTreatments.map((e) => "MedicalRecord=${e['name']}").join("&");
    } else {
      medicalApi = "MedicalRecord=Không có";
    }
    String? storedAvatar = prefs.getString('avatar');
    String image = (storedAvatar != null && storedAvatar.isNotEmpty)
        ? storedAvatar
        : await getDefaultAvatarPath();

    try {
      var response = await ApiService.postRequestSignUp(
          "auth-management/managed-auths/sign-ups?AccountId=$accountId&FullName=$fullName&Email=$email&Gender=$gender&DateOfBirth=$formatDOB&PhoneNumber=$numberPhone&RoleId=$roleId&$medicalApi&Height=$heightIndex&Weight=$weightIndex",
          image);

      Navigator.of(context).pop();

      if (response['success'] && response['data']['isSuccess']) {
        CherryToast.success(
          toastDuration: Duration(seconds: 2),
          title: Text(
            "Cập nhật thông tin thành công!",
            style: TextStyle(color: Colors.black),
          ),
        ).show(context);
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
    } catch (e) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: "Có lỗi trong quá trình xử lí",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<String> getDefaultAvatarPath() async {
    final byteData = await rootBundle.load('assets/img/default_avatar.png');
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/default_avatar.png');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file.path;
  }

  // void handleSkip() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setStringList('medicalRecord', ['Không có']);
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => CompleteInfoScreen()));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          "Bệnh án",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: AppColors.secondaryColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              submitForm();
            },
            child: Text(
              "Bỏ qua",
              style: TextStyle(color: AppColors.secondaryColor, fontSize: 18),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.80,
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Bạn có đang gặp phải vấn đề về sức khỏe nào không?",
                        textAlign: TextAlign.start,
                        style:
                            TextStyle(color: AppColors.textColor, fontSize: 20),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    MedicalRecordForm(
                      onSelectionChanged: (List<Map<String, String>> selected) {
                        setState(() {
                          selectedTreatments = selected;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: selectedTreatments.isNotEmpty ? submitForm : null,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: selectedTreatments.isNotEmpty
                      ? AppColors.secondaryColor
                      : AppColors.grayColor3,
                  foregroundColor: AppColors.bgColor,
                  minimumSize: const Size(double.infinity, 55),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                child: Text(
                  "Tiếp tục",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: AppColors.bgColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
