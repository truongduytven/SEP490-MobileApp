import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sep490/data/services/api_services.dart';
import 'package:sep490/presentation/pages/auth/forgot_password_screen.dart';
import 'package:sep490/presentation/pages/navigation_menu.dart';
import 'package:sep490/presentation/widgets/auth_field.dart';
import 'package:sep490/theme/color.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_onTextChanged);
    passwordController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      isButtonEnabled =
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });
  }

  void handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) {
            return Center(child: CircularProgressIndicator());
          });
      var response = await ApiService.postRequest(
          "auth-management/managed-auths/sign-ins", {
        "email": emailController.text,
        "password": passwordController.text,
        "deviceToken": "string",
      });
      if (response['success'] && response['data']['isSuccess']) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
          msg: "Đăng nhập thành công!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return NavigationMenu(
            keyIndex: 0,
          );
        }));
      } else {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
          msg: response['data']['data'] ?? "Có lỗi trong quá trình xử lý!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
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
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              //   return NavigationMenu(keyIndex: 0,);
              // }));
              handleSignIn();
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
