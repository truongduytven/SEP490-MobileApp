import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class SocalCard extends StatelessWidget {
  const  SocalCard({
    Key? key,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final Widget icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 56,
        width: 56,
        decoration: const BoxDecoration(
          color: AppColors.bgColor,
          shape: BoxShape.circle,
        ),
        child: icon,
      ),
    );
  }
}
