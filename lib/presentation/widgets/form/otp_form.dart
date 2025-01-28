import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:sep490/presentation/pages/auth/signup_screen.dart';
import 'package:sep490/theme/color.dart';

class OtpForm extends StatefulWidget {
  const OtpForm({super.key});

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  String _otpCode = "";
  String? _errorMessage;
  bool isButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          OtpTextField(
            autoFocus: true,
            focusedBorderColor: AppColors.primaryColor,
            fieldWidth: 48,
            numberOfFields: 6,
            borderColor: AppColors.grayColor1,
            showFieldAsBox: true,
            borderRadius: BorderRadius.circular(10),
            cursorColor: AppColors.primaryColor,
            textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            onCodeChanged: (String code) {
              setState(() {
                _otpCode = code;
                _errorMessage = null;
                isButtonEnabled = code.length == 6;
              });
            },
            onSubmit: (String code) {
              setState(() {
                _otpCode = code;
                _errorMessage = null;
                isButtonEnabled = code.length == 6;
              });
            },
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          ],
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: isButtonEnabled ?
            () {
              if (_otpCode.length == 6) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpScreen(typeIn: 'email',),
                  ),
                );
                // Proceed with OTP submission logic
              } else {
                setState(() {
                  _errorMessage = "Vui lòng nhập OTP hợp lệ gồm 6 chữ số.";
                });
              }
            }: null,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: isButtonEnabled ? AppColors.secondaryColor : AppColors.grayColor3,
              foregroundColor: AppColors.bgColor,
              minimumSize: const Size(double.infinity, 55),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
            child: Text(
              "Tiếp tục",
              style: TextStyle(
                fontSize: 20,
                color: isButtonEnabled ? AppColors.bgColor : AppColors.grayColor3.withOpacity(0.3) 
              ),
            ),
          ),
        ],
      ),
    );
  }
}
