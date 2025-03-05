import 'package:flutter/material.dart';

class LottieLoadingWidget extends StatelessWidget {
  final String assetPath;
  final double width;
  final double height;

  const LottieLoadingWidget({
    Key? key,
    required this.assetPath,
    this.width = 100,
    this.height = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}
