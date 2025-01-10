import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:sep490/theme/color.dart';

class OtpForm extends StatefulWidget {
  const OtpForm({super.key});

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  String _otpCode = "";
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          OtpTextField(
            focusedBorderColor: AppColors.primaryColor,
            fieldWidth: 48,
            numberOfFields: 6,
            borderColor: AppColors.grayColor1,
            showFieldAsBox: true,
            borderRadius: BorderRadius.circular(10),
            cursorColor: AppColors.primaryColor,
            onCodeChanged: (String code) {
              setState(() {
                _otpCode = code;
                _errorMessage = null; // Clear error message when user types
              });
            },
            onSubmit: (String code) {
              // Handle OTP submission
              print("Submitted OTP: $code");
              setState(() {
                _otpCode = code;
                _errorMessage = null; // Clear error message on submit
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
            onPressed: () {
              if (_otpCode.length == 6) {
                print("OTP Code entered: $_otpCode");
                // Proceed with OTP submission logic
              } else {
                setState(() {
                  _errorMessage = "Vui lòng nhập OTP hợp lệ gồm 6 chữ số.";
                });
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
      ),
    );
  }
}
