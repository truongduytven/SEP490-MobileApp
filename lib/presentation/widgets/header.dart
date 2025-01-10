import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ClipOval(
              child: Image.asset(
                "assets/img/onBoard1.png",
                width: 40,
                height: 40,
                fit: BoxFit.cover, // Ensures the image covers the circular area
              ),
            ),
            SizedBox(
              width: 20,
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome Back,",
                  style: TextStyle(color: AppColors.textColor, fontSize: 12),
                ),
                Text(
                  "Trần Trung Quân",
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Scaffold(
                  body: Text("noti"),
                ),
              ),
            );
          },
          icon: Image.asset(
            "assets/img/notification_active.png",
            width: 25,
            height: 25,
            fit: BoxFit.fitHeight,
          ),
        ),
      ],
    );
  }
}
