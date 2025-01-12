import 'package:flutter/material.dart';
import 'package:sep490/presentation/pages/health/add_weight_screen.dart';
import 'package:sep490/presentation/pages/notification/notification_screen.dart';
import 'package:sep490/presentation/widgets/health/weight/horizontal_weight_slider.dart';
import 'package:sep490/presentation/widgets/health/weight/rules.dart';
import 'package:sep490/theme/color.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  "assets/img/onBoard1.png",
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
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
          Padding(
            padding: const EdgeInsets.only(right: 60.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.grayColor2,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationScreen()),
                  );
                },
                icon: Image.asset(
                  "assets/img/notification_active.png",
                  width: 25,
                  height: 25,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
