import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Expanded(
            child: Image.asset(
              slide.imagePath,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 24),
          // Title
          Text(
            slide.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Description
          Text(
            slide.description,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}