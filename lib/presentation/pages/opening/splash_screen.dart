import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/data/repositories/user_pref_repository_impl.dart';
import 'package:sep490/data/services/api_services.dart';
import 'package:sep490/data/services/local_storage_service.dart';
import 'package:sep490/domain/use_cases/user_pref_repository.dart';
import 'package:sep490/presentation/pages/navigation_menu.dart';
import 'package:sep490/presentation/pages/opening/select_sign.dart';
import 'package:sep490/presentation/pages/opening/welcome_screen.dart';
import 'package:sep490/theme/color.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), _navigateNext);
  }

  Future<void> _navigateNext() async {
    final String token = SharedPrefsHelper().getString('accessToken') ?? '';
    final String email = SharedPrefsHelper().getString('email') ?? '';
    final String password = SharedPrefsHelper().getString('password') ?? '';
    if (email.isNotEmpty && password.isNotEmpty) {
      _handleGetUserDetail(email, password);
    } else {
      final localStorageService = LocalStorageService();
      final userPrefRepository = UserPrefRepositoryImpl(localStorageService);
      final CheckUserOnboardingUseCase checkUserOnboardingUseCase =
          CheckUserOnboardingUseCase(userPrefRepository);

      final isFirstTime = await checkUserOnboardingUseCase.execute();
      if (!mounted) return;
      if (isFirstTime) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => WelcomeScreen(
                      userOnboardingUseCase: checkUserOnboardingUseCase,
                    )));
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SelectSignScreen()),
        );
      }
    }
  }

  void _handleGetUserDetail(String email, String password) async {
    var response =
        await ApiService.postRequest("auth-management/managed-auths/sign-ins", {
      "email": email,
      "password": password,
      "deviceToken": "string",
    });
    if (response['success'] && response['data']['isSuccess']) {
      final String accessToken = response['data']['data'];
      var responseToken = await ApiService.getRequest("auth-management",
          headers: {
            "Content-Type": "application/json",
            "Authorization": 'Bearer $accessToken'
          });

      if (responseToken['success']) {
        await SharedPrefsHelper().setInt(
            'accountId', responseToken['data']['user']['accountId'] ?? 0);
        await SharedPrefsHelper()
            .setInt('roleId', responseToken['data']['user']['roleId'] ?? 0);
        await SharedPrefsHelper().setString('email', email);
        await SharedPrefsHelper().setString('password', password);
        await SharedPrefsHelper().setString(
            'fullName', responseToken['data']['user']['fullName'] ?? '');
        await SharedPrefsHelper()
            .setString('avatar', responseToken['data']['user']['avatar'] ?? '');
        await SharedPrefsHelper()
            .setString('gender', responseToken['data']['user']['gender'] ?? "");

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
        await SharedPrefsHelper().clear();

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return SelectSignScreen();
        }));

        Fluttertoast.showToast(
          msg: "Có lỗi trong quá trình xử lý!",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/background_app.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img/Logo.png',
                    height: 130,
                    width: 130,
                  ),
                  Text(
                    'Senior Essentials',
                    style: TextStyle(
                        color: AppColors.secondaryColor,
                        fontSize: 40,
                        fontFamily: 'TTMilks'),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Lottie.asset(
                  "assets/img/Animation.json",
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          )),
    );
  }
}
