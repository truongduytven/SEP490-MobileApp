import 'package:flutter/material.dart';
import 'package:sep490/presentation/pages/auth/signin_screen.dart';
import 'package:sep490/presentation/widgets/form/sign_up_first.dart';
import 'package:sep490/theme/color.dart';

class SignupFirstScreen extends StatelessWidget {
  final String role;
  final bool? isSignUpFor;
  const SignupFirstScreen({super.key, required this.role, this.isSignUpFor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
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
      ),
      body: SafeArea(
          child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Vui lòng nhập số điện thoại để tiếp tục tạo tài khoản với SE",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: AppColors.textColor, fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              SignUpFirst(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              if(isSignUpFor == null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Đã có tài khoản?",
                    style: TextStyle(color: Color(0xFF757575)),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      " Đăng nhập",
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
