import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sep490/data/repositories/user_pref_repository_impl.dart';
import 'package:sep490/data/services/local_storage_service.dart';
import 'package:sep490/domain/use_cases/user_pref_repository.dart';
import 'package:sep490/presentation/pages/opening_screen/select_sign.dart';
import 'package:sep490/presentation/pages/opening_screen/welcome_screen.dart';
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
    // _navigateNext();
  }

  Future<void> _navigateNext() async {
    final localStorageService = LocalStorageService();
    final userPrefRepository = UserPrefRepositoryImpl(localStorageService);
    final CheckUserOnboardingUseCase checkUserOnboardingUseCase =
        CheckUserOnboardingUseCase(userPrefRepository);

    final isFirstTime = await checkUserOnboardingUseCase.execute();
    if (!mounted) return;
    if (isFirstTime) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => WelcomeScreen(
        userOnboardingUseCase: checkUserOnboardingUseCase,
      )));
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SelectSignScreen()),
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
