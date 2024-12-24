import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class OnBoardingSlideData {
  final String imagePath;
  final String title;
  final String description;

  const OnBoardingSlideData({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

// A single slide layout: image + title + description
class OnBoardingSlide extends StatelessWidget {
  final OnBoardingSlideData slide;
  const OnBoardingSlide({super.key, required this.slide});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bgColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image
          Image.asset(
            slide.imagePath,
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Text(
              slide.title,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              slide.description,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
