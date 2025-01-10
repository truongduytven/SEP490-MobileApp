import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class HealthCard extends StatelessWidget {
  const HealthCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    required this.index,
  }) : super(key: key);

  final String icon;
  final String label;
  final String value;
  final String index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.bgColor.withOpacity(0.2),
            radius: 30,
            backgroundImage: AssetImage(icon),          
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "$value $index",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
