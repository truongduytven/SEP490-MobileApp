import 'package:flutter/material.dart';
import 'package:sep490/presentation/pages/health/add_weight_screen.dart';
import 'package:sep490/presentation/pages/opening/splash_screen.dart';
import 'package:sep490/theme/color.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'LeagueSpartan'),
      color: AppColors.bgColor,
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
