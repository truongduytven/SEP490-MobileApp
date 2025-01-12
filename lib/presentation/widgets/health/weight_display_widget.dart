import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class WeightDisplayWidget extends StatelessWidget {
  final num weight; // in kilograms
  final num height; // in centimeters
  final String dateTime;
  final VoidCallback onEdit;

  const WeightDisplayWidget({
    required this.weight,
    required this.height,
    required this.dateTime,
    required this.onEdit,
    super.key,
  });

  /// Calculate BMI
  double calculateBMI() {
    double heightInMeters = height / 100; // Convert height to meters
    return weight / (heightInMeters * heightInMeters);
  }

  /// Determine BMI classification
  String getBMIClassification(double bmi) {
    if (bmi < 18.5) {
      return "Thiếu cân";
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return "Bình Thường";
    } else if (bmi >= 25 && bmi < 29.9) {
      return "Thừa cân";
    } else {
      return "Béo phì";
    }
  }

  @override
  Widget build(BuildContext context) {
    final double bmi = calculateBMI();
    final String bmiClassification = getBMIClassification(bmi);

    return Card(
      color: AppColors.bgColor,
      margin: const EdgeInsets.all(16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row with date-time and edit button
            Row(
              children: [
                Icon(Icons.calendar_today,
                    color: AppColors.secondaryColor, size: 24),
                SizedBox(width: 8),
                Expanded(
                  child: Center(
                    child: Text(
                      dateTime,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit,
                      size: 32, color: AppColors.secondaryColor),
                  onPressed: onEdit,
                ),
              ],
            ),
            Divider(color: AppColors.borderColor, thickness: 1, height: 24),
            // Weight display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Cân nặng:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(
                  "${weight.toStringAsFixed(1)} kg",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(color: AppColors.borderColor, thickness: 1, height: 24),
            // Height display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Chiều cao:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(
                  "${height.toStringAsFixed(1)} cm",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(color: AppColors.borderColor, thickness: 1, height: 24),
            // BMI display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "BMI:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      bmi.toStringAsFixed(1),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      bmiClassification,
                      style: TextStyle(
                        fontSize: 16,
                        color: bmiClassification == "Bình Thường"
                            ? Colors.green
                            : AppColors.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(color: AppColors.borderColor, thickness: 1, height: 24),
          ],
        ),
      ),
    );
  }
}
