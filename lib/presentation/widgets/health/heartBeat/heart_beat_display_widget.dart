import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sep490/theme/color.dart';

class HeartBeatDisplayWidget extends StatelessWidget {
  final num heartBeat;
  final String dateTime;
  final VoidCallback onEdit;
  final bool isDraft;
  final String typeData;
  const HeartBeatDisplayWidget({
    super.key,
    required this.heartBeat,
    required this.dateTime,
    required this.onEdit,
    required this.isDraft,
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
    if (heartBeat < 60) {
      return Colors.orange; // Yellow for Bradycardia
    } else if (heartBeat >= 60 && heartBeat <= 100) {
      return Colors.green; // Green for Normal
    } else {
      return Colors.red; // Red for Tachycardia
    }
  }

  String get heartBeatClassification {
    if (heartBeat < 60) {
      return "Nhịp tim chậm";
    } else if (heartBeat >= 60 && heartBeat <= 100) {
      return "Nhịp tim bình thường";
    } else {
      return "Nhịp tim nhanh";
    }
  }

  @override
  Widget build(BuildContext context) {
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
                              heartBeat.toString(),
                              style: TextStyle(
                                  fontSize: 80, fontWeight: FontWeight.w700),
                            ),
                            Transform.translate(
                              offset: Offset(0,
                                  -25), // Adjust the vertical position of "kg"
                              child: Text(
                                "Nhịp/phút",
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
                              Icons.draw_outlined,
                              color: AppColors.textPrimary,
                              size: 24,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              typeData,
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
                            Icons.monitor_heart_outlined,
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
            child: ElevatedButton(
              onPressed: () {
                print('hehe $heartBeat $dateTime');
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
