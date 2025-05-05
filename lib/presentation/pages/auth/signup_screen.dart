import 'package:flutter/material.dart';
import 'package:sep490/presentation/widgets/form/signup_form.dart';
import 'package:sep490/theme/color.dart';

class SignUpScreen extends StatelessWidget {
  final String typeIn;
  const SignUpScreen({super.key, required this.typeIn});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Đăng kí tài khoản",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: AppColors.secondaryColor,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
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
                  const Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Xác minh tài khoản thành công, vui lòng nhập thêm thông tin để hoàn thành đăng ký",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: AppColors.textColor, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  SignUpForm(typeIn: typeIn),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
