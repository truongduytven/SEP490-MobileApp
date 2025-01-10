import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sep490/presentation/pages/auth/forgot_password_screen.dart';
import 'package:sep490/presentation/widgets/auth_field.dart';
import 'package:sep490/theme/color.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, 
      child: Column(
        children: [
          AuthField(
            labelText: "Email hoặc số điện thoại",
            hintText: "Nhập email hoặc số điện thoại",
            controller: emailController,
            suffixIcon: SvgPicture.asset('assets/icons/mailIcon.svg'),
            keyboardType: TextInputType.emailAddress, // Optional keyboard type
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: AuthField(
              labelText: "Mật khẩu",
              hintText: "Nhập mật khẩu",
              controller: passwordController,
              isObscureText: true, // Obscure the password
              suffixIcon: SvgPicture.asset('assets/icons/lockIcon.svg'),
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
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                print('Email/Số điện thoại: ${emailController.text}');
                print('Mật khẩu: ${passwordController.text}');
              }
            },
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
