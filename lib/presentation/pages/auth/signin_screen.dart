import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sep490/presentation/pages/auth/forgot_password_screen.dart';
import 'package:sep490/theme/color.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Text(
          "Đăng nhập",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: AppColors.secondaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
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
                  const Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Chào mừng",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "đã đến với Senior Essentials, nơi kết nối các thành viên trong gia đình cũng như dễ quản lí sức khỏe của người cao tuổi",
                          textAlign:
                              TextAlign.start, // Align text content to the left
                          style: TextStyle(color: AppColors.textColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  SignInForm(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "hoặc tiếp tục với",
                        style: TextStyle(color: Color(0xFF757575)),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocalCard(
                        icon: SvgPicture.asset('assets/icons/googleIcon.svg',
                            width: 50, height: 50),
                        press: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const NoAccountText(),
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
                  suffix: SvgPicture.string(
                    mailIcon,
                  ),
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

class SocalCard extends StatelessWidget {
  const SocalCard({
    Key? key,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final Widget icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 56,
        width: 56,
        decoration: const BoxDecoration(
          color: AppColors.bgColor,
          shape: BoxShape.circle,
        ),
        child: icon,
      ),
    );
  }
}

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Không có tài khoản? ",
          style: TextStyle(color: Color(0xFF757575)),
        ),
        GestureDetector(
          onTap: () {
            // Handle navigation to Sign Up
          },
          child: const Text(
            "Đăng kí",
            style: TextStyle(
                color: AppColors.primaryColor, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
