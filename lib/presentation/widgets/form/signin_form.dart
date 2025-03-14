import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sep490/common/constants/common.dart';
import 'package:sep490/common/constants/secrets.example.dart';
import 'package:sep490/data/services/api_services.dart';
import 'package:sep490/presentation/pages/auth/forgot_password_screen.dart';
import 'package:sep490/presentation/pages/navigation_menu.dart';
import 'package:sep490/presentation/widgets/auth_field.dart';
import 'package:sep490/theme/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

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
  String? _token = '';

  @override
  void initState() {
    super.initState();
    emailController.addListener(_onTextChanged);
    passwordController.addListener(_onTextChanged);
    FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        _token = token;
        print('Device token: $_token');
      });
    });
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

  void onUserLogin(int userID, String userName, String avatar) {
    /// 4/5. initialized ZegoUIKitPrebuiltCallInvitationService when account is logged in or re-logged in
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: AppSecrets.appId /*input your AppID*/,
      appSign: AppSecrets.appSign /*input your AppSign*/,
      userID: userID.toString(),
      userName: userName,
      plugins: [ZegoUIKitSignalingPlugin()],
      requireConfig: (ZegoCallInvitationData data) {
        final config = (data.invitees.length > 1)
            ? ZegoCallInvitationType.videoCall == data.type
                ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
                : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
            : ZegoCallInvitationType.videoCall == data.type
                ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

        /// custom avatar
        config.avatarBuilder = (context, size, user, extraInfo) {
          return customAvatarBuilder(
            context,
            size,
            user,
            {'avatar': avatar}, // Pass the avatar URL
          );
        };

        /// support minimizing, show minimizing button
        config.topMenuBar.isVisible = true;
        config.topMenuBar.buttons
            .insert(0, ZegoCallMenuBarButtonName.minimizingButton);
        config.topMenuBar.buttons
            .insert(1, ZegoCallMenuBarButtonName.soundEffectButton);

        return config;
      },
    );
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
        "deviceToken": _token ?? "string",
      });
      if (response['success'] && response['data']['isSuccess']) {
        final String accessToken = response['data']['data'];
        var responseToken = await ApiService.getRequest("auth-management",
            headers: {
              "Content-Type": "application/json",
              "Authorization": 'Bearer $accessToken'
            });

        if (responseToken['success']) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final userData = responseToken['data']['user'];
          final int userID = userData['accountId'] ?? 0;
          final String userName = userData['fullName'] ?? '';
          final String avatar = userData['avatar'] ?? '';
          prefs.setInt(
              'accountId', responseToken['data']['user']['accountId'] ?? 0);
          prefs.setInt('roleId', responseToken['data']['user']['roleId'] ?? 0);
          prefs.setString('email', emailController.text);
          prefs.setString('password', passwordController.text);
          prefs.setString('accessToken', accessToken);
          prefs.setString(
              'fullName', responseToken['data']['user']['fullName'] ?? '');
          prefs.setString(
              'avatar', responseToken['data']['user']['avatar'] ?? '');
          prefs.setString(
              'gender', responseToken['data']['user']['gender'] ?? "");
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
          onUserLogin(userID, userName, avatar);
        } else {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: responseToken['data']['data'] ??
                "Có lỗi trong quá trình xử lý!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
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
            // keyboardType: TextInputType.emailAddress, // Optional keyboard type
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
