import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sep490/presentation/widgets/form/otp_form.dart';
import 'package:sep490/theme/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late String method = '';
  Intl intl = Intl();
  String timeEnd = DateFormat('HH:mm').format(DateTime.now().add(Duration(minutes: 5)));

  @override
  void initState() {
    super.initState();
    getMethod();
  }

  void getMethod() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      method = prefs.getString('emailOrPhoneSignUp')!;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        title: const Text(
          "Xác thực mã OTP",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: AppColors.secondaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    "Chúng tôi đã gửi mã code tới $method",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textColor),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  const OtpForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


