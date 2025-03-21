import 'package:flutter/material.dart';
import 'package:sep490/presentation/pages/health/carouse_with_save.dart';
import 'package:sep490/features/health/widgets/skeleton_card.dart';
import 'package:sep490/theme/color.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Thông báo",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: AppColors.secondaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          // Prevents layout overflow issues
          child: Column(
            mainAxisSize: MainAxisSize.min, // Prevents infinite height
            children: [
              Text("Notification Screen here"),
              CarouselWithSave(),
            ],
          ),
        ),
      ),
    );
  }
}
