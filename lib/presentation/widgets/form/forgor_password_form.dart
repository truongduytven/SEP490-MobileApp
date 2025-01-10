import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sep490/presentation/widgets/auth_field.dart'; // Assuming you have AuthField widget
import 'package:sep490/theme/color.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
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
            suffixIcon: SvgPicture.asset(
              'assets/icons/mailIcon.svg',
              height: 13,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                print("Email: ${emailController.text}");
              } else {
                print("Form is not valid.");
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
              "Tiếp tục",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}
