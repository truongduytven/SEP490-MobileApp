import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class InfoChip extends StatelessWidget {
  final String text;
  const InfoChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.secondaryColor),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          color: AppColors.bgColor,
        ),
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
