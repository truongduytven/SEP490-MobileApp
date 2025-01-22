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
  final FocusNode _focusNode = FocusNode();
  bool isButtonEnabled = false;
  String? typeSignUp;
  String? errorMessage;
  @override
  void initState() {
    super.initState();
    emailOrPhoneController.addListener(_onTextChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    emailOrPhoneController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      isButtonEnabled = emailOrPhoneController.text.isNotEmpty;
      errorMessage = null;
    });
  }

  bool _validateInput(String input) {
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    final phoneRegex = RegExp(r"^0\d{9}$");

    if (emailRegex.hasMatch(input)) {
      typeSignUp = 'email';
      return true;
    } else if (phoneRegex.hasMatch(input)) {
      typeSignUp = 'phone';
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            AuthField(
              focusNode: _focusNode,
              hintText: 'Nhập số điện thoại hoặc email',
              labelText: "Số điện thoại hoặc email",
              controller: emailOrPhoneController,
              keyboardType: TextInputType.emailAddress,
              // suffixIcon: SizedBox(
              //   width: 50,
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       SvgPicture.asset('assets/icons/mailIcon.svg'),
              //       SizedBox(width: 5),
              //       SvgPicture.asset('assets/icons/phoneIcon.svg'),
              //     ],
              //   ),
              // )
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),

            // Submit Button
            ElevatedButton(
              onPressed: isButtonEnabled
                  ? () {
                      final input = emailOrPhoneController.text.trim();
                      if (_validateInput(input)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtpScreen(),
                          ),
                        );
                      } else {
                        setState(() {
                          errorMessage =
                              "Không đúng định dạng. Vui lòng thử lại";
                        });
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: isButtonEnabled
                    ? AppColors.secondaryColor
                    : AppColors.grayColor3,
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
                    color: isButtonEnabled
                        ? AppColors.bgColor
                        : AppColors.grayColor3.withOpacity(0.3)),
              ),
            ),
          ],
        ));
  }
}
