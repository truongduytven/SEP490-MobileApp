import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sep490/presentation/pages/auth/forgot_password_screen.dart';
import 'package:sep490/theme/color.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(() {
      setState(() {});
    });
    passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Focus(
            focusNode: emailFocusNode,
            child: TextFormField(
              onSaved: (email) {},
              onChanged: (email) {},
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  hintText: "Nhập email hoặc số điện thoại",
                  labelText: "Email hoặc số điện thoại",
                  labelStyle: TextStyle(
                    color: emailFocusNode.hasFocus
                        ? AppColors.primaryColor
                        : AppColors.textColor,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintStyle: const TextStyle(color: Color(0xFF757575)),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  suffix: SvgPicture.asset('assets/icons/mailIcon.svg'),
                  border: authOutlineInputBorder,
                  enabledBorder: authOutlineInputBorder,
                  focusedBorder: authOutlineInputBorder.copyWith(
                      borderSide:
                          const BorderSide(color: AppColors.primaryColor))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Focus(
              focusNode: passwordFocusNode,
              child: TextFormField(
                onSaved: (password) {},
                onChanged: (password) {},
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Nhập mật khẩu",
                    labelText: "Mật khẩu",
                    labelStyle: TextStyle(
                      color: passwordFocusNode.hasFocus
                          ? AppColors.primaryColor
                          : AppColors.textColor,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintStyle: const TextStyle(color: Color(0xFF757575)),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    suffix: SvgPicture.asset('assets/icons/lockIcon.svg'),
                    border: authOutlineInputBorder,
                    enabledBorder: authOutlineInputBorder,
                    focusedBorder: authOutlineInputBorder.copyWith(
                        borderSide:
                            const BorderSide(color: AppColors.primaryColor))),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPasswordScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Quên mật khẩu?",
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {},
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
              "Đăng nhập",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
