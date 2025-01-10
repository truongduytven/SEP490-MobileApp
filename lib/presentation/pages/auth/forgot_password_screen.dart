import 'package:flutter/material.dart';
import 'package:sep490/presentation/pages/opening/select_role.dart';
import 'package:sep490/presentation/widgets/form/forgor_password_form.dart';
import 'package:sep490/theme/color.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Quên mật khẩu",
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
                  const SizedBox(height: 8),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Vui lòng nhập email hoặc số điện thoại đã đăng kí để tiếp tục",
                        textAlign:
                            TextAlign.start, // Align text content to the left
                        style: TextStyle(color: AppColors.textColor),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  const ForgotPasswordForm(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Không có tài khoản? ",
                        style: TextStyle(color: Color(0xFF757575)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectRoleScreen(sign: 'signup'),
                            ),
                          );
                        },
                        child: const Text(
                          "Đăng kí",
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xFF757575)),
  borderRadius: BorderRadius.all(Radius.circular(20)),
);
