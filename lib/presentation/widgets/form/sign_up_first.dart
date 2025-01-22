import 'package:flutter/material.dart';
import 'package:sep490/presentation/pages/auth/otp_screen.dart';
import 'package:sep490/presentation/widgets/auth_field.dart';
import 'package:sep490/theme/color.dart';

class SignUpFirst extends StatefulWidget {
  const SignUpFirst({super.key});

  @override
  State<SignUpFirst> createState() => _SignUpFirstState();
}

class _SignUpFirstState extends State<SignUpFirst> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailOrPhoneController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailOrPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            AuthField(
                hintText: 'Số điện thoại hoặc email',
                labelText: "Số điện thoại hoặc email",
                controller: emailOrPhoneController,
                keyboardType: TextInputType.emailAddress,
                suffixIcon: Icon(Icons.email_outlined)),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  print('Email/Số điện thoại: ${emailOrPhoneController.text}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtpScreen(),
                    ),
                  );
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
            ),
          ],
        ));
  }
}
