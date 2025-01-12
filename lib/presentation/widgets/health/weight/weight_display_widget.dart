import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sep490/theme/color.dart';

class WeightDisplayWidget extends StatelessWidget {
  final num weight; // in kilograms
  final num height; // in centimeters
  final String dateTime;
  final VoidCallback onEdit;
  final bool isDraft;

  const WeightDisplayWidget({
    required this.weight,
    required this.height,
    required this.dateTime,
    required this.onEdit,
    required this.isDraft,
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

  bool isToday(String dateTime) {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    final DateTime dateFromString = dateFormat.parse(dateTime);
    final DateTime today = DateTime.now();
    return dateFromString.year == today.year &&
        dateFromString.month == today.month &&
        dateFromString.day == today.day;
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
                // Icon(
                //   Icons.delete_outline,
                //   color: AppColors.primaryColor,
                //   size: 30,
                // ),
                isDraft
                    ? Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.errorColor,
                        size: 30,
                      )
                    : Icon(
                        Icons.delete_outline,
                        color: AppColors.primaryColor,
                        size: 30,
                      ),
                SizedBox(width: 8),
                Expanded(
                  child: Center(
                    child: Text(
                      isToday(dateTime) // Check if it's today's date
                          ? "Hôm nay"
                          : dateTime,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // IconButton(
                //   icon: Icon(Icons.edit, size: 28, color: AppColors.grayColor5),
                //   onPressed: onEdit,
                // ),
                isToday(dateTime) // Check if it's today's date
                    ? IconButton(
                        onPressed: onEdit,
                        icon: Icon(Icons.edit,
                            size: 30, color: AppColors.primaryColor),
                      )
                    : Icon(
                        Icons.lock_outline, // "Cannot edit" icon
                        size: 30,
                        color: AppColors.primaryColor,
                      )
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
