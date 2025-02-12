import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sep490/data/services/api_services.dart';
import 'package:sep490/presentation/pages/auth/otp_screen.dart';
import 'package:sep490/presentation/widgets/auth_field.dart';
import 'package:sep490/theme/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpFirst extends StatefulWidget {
  const SignUpFirst({super.key});

  @override
  State<SignUpFirst> createState() => _SignUpFirstState();
}

class _SignUpFirstState extends State<SignUpFirst> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailOrPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late int role = 0;
  bool isButtonEnabled = false;
  String? typeSignUp;
  String? errorMessage;
  @override
  void initState() {
    super.initState();
    emailOrPhoneController.addListener(_onTextChanged);
    passwordController.addListener(_onTextChanged);
    getRole();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    role = prefs.getString('role')! == 'Elderly' ? 2 : 3;
  }

  @override
  void dispose() {
    emailOrPhoneController.dispose();
    passwordController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      isButtonEnabled = emailOrPhoneController.text.isNotEmpty &&
          passwordController.text.isNotEmpty;
      errorMessage = null;
    });
  }

  void handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      final input = emailOrPhoneController.text.trim();
      final password = passwordController.text.trim();
      if (_validateInput(input)) {
        showDialog(
            context: context,
            builder: (context) {
              return Center(child: CircularProgressIndicator());
            });
        var response = await ApiService.postRequest(
            'auth-management/managed-auths/otp/send?account=$input&password=$password&role=$role',
            {});
        Navigator.of(context).pop();
        if (response['success'] && response['data']['isSuccess']) {
          Fluttertoast.showToast(
            msg: "Mã OTP đã được gửi đến $input",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('typeSignUp', response['data']['data']['method']);
          prefs.setString('emailOrPhoneSignUp', input);
          prefs.setInt('accountId', response['data']['data']['accountId']);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return OtpScreen();
          }));
        } else {
          Fluttertoast.showToast(
            msg: "Email hoặc số điện thoại không hợp lệ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } else {
        setState(() {
          errorMessage = "Không đúng định dạng. Vui lòng thử lại";
        });
      }
    }
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

            AuthField(
              labelText: "Mật khẩu",
              hintText: "Nhập mật khẩu",
              controller: passwordController,
              isObscureText: true, // Obscure the password
              suffixIcon: SvgPicture.asset('assets/icons/lockIcon.svg'),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            // Submit Button
            ElevatedButton(
              onPressed: isButtonEnabled ? handleSignUp : null,
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
