import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sep490/theme/color.dart';

class BloodGlucoseDisplayWidget extends StatelessWidget {
  final num bloodGlucose;
  final String dateTime;
  final VoidCallback onEdit;
  final bool isDraft;
  final String typeData;
  final String period;
  BloodGlucoseDisplayWidget({
    super.key,
    required this.bloodGlucose,
    required this.dateTime,
    required this.onEdit,
    required this.isDraft,
    required this.period,
    required this.typeData,
  });
  bool isToday(String dateTime) {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    final DateTime dateFromString = dateFormat.parse(dateTime);
    final DateTime today = DateTime.now();
    return dateFromString.year == today.year &&
        dateFromString.month == today.month &&
        dateFromString.day == today.day;
  }

  Color get classificationColor {
    if (bloodGlucose < 60) {
      return Colors.orange; // Yellow for Bradycardia
    } else if (bloodGlucose >= 60 && bloodGlucose <= 100) {
      return Colors.green; // Green for Normal
    } else {
      return Colors.red; // Red for Tachycardia
    }
  }

  String get heartBeatClassification {
    if (bloodGlucose < 60) {
      return "Đường huyết chậm";
    } else if (bloodGlucose >= 60 && bloodGlucose <= 100) {
      return "Đường huyết bình thường";
    } else {
      return "Đường huyết nhanh";
    }
  }

  Map<String, IconData> periodIcons = {
    "Thức dậy": Icons.wb_sunny_outlined,
    "Trước bữa ăn": Icons.local_cafe_outlined,
    "Sau bữa ăn": Icons.fastfood_sharp,
    "Trước khi ngủ": Icons.night_shelter_outlined,
  };

  IconData getPeriodIcon(String period) {
    return periodIcons[period] ??
        Icons.help_outline; // Default icon if not found
  }

  @override
  Widget build(BuildContext context) {
    bool isButtonDisabled = !isToday(dateTime) && !isDraft;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Card(
                color: AppColors.bgColor,
                margin: const EdgeInsets.all(20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(
                      color: AppColors.borderColor, width: 1.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Row with date-time and edit button
                      Row(
                        children: [
                          isDraft
                              ? Icon(
                                  Icons.calendar_month_outlined,
                                  color: AppColors.textColor,
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
                                style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          isToday(dateTime)
                              ? IconButton(
                                  onPressed: onEdit,
                                  icon: Icon(Icons.edit,
                                      size: 30, color: AppColors.primaryColor),
                                )
                              : Icon(
                                  Icons.lock_outline,
                                  size: 30,
                                  color: AppColors.primaryColor,
                                )
                        ],
                      ),
                      // Weight display
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              bloodGlucose.toString(),
                              style: TextStyle(
                                  fontSize: 80, fontWeight: FontWeight.w700),
                            ),
                            Transform.translate(
                              offset: Offset(0,
                                  -25), // Adjust the vertical position of "kg"
                              child: Text(
                                "mmol/L",
                                style: TextStyle(
                                    fontSize: 40, color: AppColors.grayColor5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.borderColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              getPeriodIcon(period),
                              color: AppColors.textPrimary,
                              size: 24,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              period,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: 26,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: Divider(
                            color: AppColors.grayColor4,
                            thickness: 0.3,
                            height: 24),
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.bloodtype_outlined,
                            size: 30,
                            color: classificationColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            heartBeatClassification,
                            style: TextStyle(
                              fontSize: 26,
                              color: classificationColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Lưu Button

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            child: isButtonDisabled
                ? SizedBox.shrink() // Use an empty widget when disabled
                : ElevatedButton(
                    onPressed: () {
                      print('hehe $bloodGlucose $dateTime');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryColor,
                      padding: EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      'Lưu',
                      style: TextStyle(
                        fontSize: 28,
                        color: AppColors.bgColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
