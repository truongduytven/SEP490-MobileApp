import 'package:flutter/material.dart';
import 'package:sep490/presentation/pages/opening/select_role.dart';
import 'package:sep490/theme/color.dart';

class SelectSignScreen extends StatelessWidget {
  const SelectSignScreen({super.key});

  void _goToSelectRole(BuildContext context, String sign) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SelectRoleScreen(sign: sign),
      ),
    );
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 50,
            ),
            Column(
              children: [
                Image.asset('assets/img/Logo.png', height: 200, width: 200),
                Text(
                  'Senior Essentials',
                  style: TextStyle(
                      color: AppColors.secondaryColor,
                      fontSize: 40,
                      fontFamily: 'TTMilks'),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: ElevatedButton(
                            onPressed: () => _goToSelectRole(context, 'signin'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondaryColor,
                                padding: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                )),
                            child: const Text('Đăng nhập',
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
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: ElevatedButton(
                            onPressed: () => _goToSelectRole(context, 'signup'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.bgColor,
                                padding: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                )),
                            child: const Text('Đăng ký',
                                style: TextStyle(
                                  fontSize: 28,
                                  color: AppColors.secondaryColor,
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
          ],
        ),
      ),
    );
  }
}
