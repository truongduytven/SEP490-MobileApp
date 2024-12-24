import 'package:flutter/material.dart';
import 'package:sep490/domain/use_cases/user_pref_repository.dart';
import 'package:sep490/presentation/pages/opening_screen/onboaring_screen.dart';
import 'package:sep490/theme/color.dart';

class WelcomeScreen extends StatelessWidget {
  final CheckUserOnboardingUseCase userOnboardingUseCase;
  const WelcomeScreen({super.key, required this.userOnboardingUseCase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.bgColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 60, bottom: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Image.asset('assets/img/welcome.png'),
                  SizedBox(height: 30),
                  Text(
                    'Chào mừng bạn đã đến với',
                    style: TextStyle(
                      fontSize: 32,
                      color: AppColors.secondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Senior Essential',
                    style: TextStyle(
                      fontSize: 30,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Text(
                        'Nền tảng tiện ích dành cho người cao tuổi để duy trì kết nối, an toàn và năng động.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          color: AppColors.secondaryColor,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => OnBoaringScreen(
                              userOnboardingUseCase: userOnboardingUseCase,
                            )),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondaryColor,
                            padding: EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            )),
                        child: const Text('Bắt đầu ngay',
                            style: TextStyle(
                              fontSize: 28,
                              color: AppColors.bgColor,
                              fontWeight: FontWeight.w400,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
