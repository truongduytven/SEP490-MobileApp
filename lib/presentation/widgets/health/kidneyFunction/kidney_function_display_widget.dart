import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sep490/presentation/widgets/health/kidneyFunction/kidney_function_dialog.dart';
import 'package:sep490/theme/color.dart';

class KidneyFunctionDisplayWidget extends StatelessWidget {
  final num bunValue;
  final num gfrValue;
  final num egfrValue;
  final String dateTime;
  final VoidCallback onEdit;
  final bool isDraft;
  final String typeData;
  KidneyFunctionDisplayWidget({
    super.key,
    required this.dateTime,
    required this.onEdit,
    required this.isDraft,
    required this.bunValue,
    required this.egfrValue,
    required this.gfrValue,
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
    if (bunValue < 60) {
      return Colors.orange; // Yellow for Bradycardia
    } else if (bunValue >= 60 && bunValue <= 100) {
      return Colors.green; // Green for Normal
    } else {
      return Colors.red; // Red for Tachycardia
    }
  }

  String get heartBeatClassification {
    if (bunValue < 60) {
      return "Thận chậm";
    } else if (bunValue >= 60 && bunValue <= 100) {
      return "Thận bình thường";
    } else {
      return "Thận nhanh";
    }
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "BUN",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              Text(
                                bunValue.toString(),
                                style: TextStyle(
                                    fontSize: 50, fontWeight: FontWeight.w700),
                              ),
                              Transform.translate(
                                offset: Offset(0,
                                    -25), // Adjust the vertical position of "kg"
                                child: Text(
                                  "mmol/L",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.grayColor5),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "GFR",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              Text(
                                gfrValue.toString(),
                                style: TextStyle(
                                    fontSize: 50, fontWeight: FontWeight.w700),
                              ),
                              Transform.translate(
                                offset: Offset(0,
                                    -25), // Adjust the vertical position of "kg"
                                child: Text(
                                  "mmol/L",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.grayColor5),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "eGFR",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          Text(
                            egfrValue.toString(),
                            style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.w700),
                          ),
                          Transform.translate(
                            offset: Offset(
                                0, -25), // Adjust the vertical position of "kg"
                            child: Text(
                              " mL/min/1.73m",
                              style: TextStyle(
                                  fontSize: 20, color: AppColors.grayColor5),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.grain,
                                size: 30,
                                color: classificationColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                overflow: TextOverflow.ellipsis,
                                heartBeatClassification,
                                style: TextStyle(
                                  fontSize: 26,
                                  color: classificationColor,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.textPrimary,
                                width: 1.5,
                              ),
                              color: AppColors.bgColor,
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.8, // 80% of screen height
                                        padding: EdgeInsets.all(16),
                                        child: KidneyFunctionInfoDialog(),
                                      );
                                    },
                                  );
                                },
                                child: Icon(
                                  Icons.question_mark_sharp,
                                  color: AppColors.textPrimary,
                                  size: 20,
                                ),
                              ),
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
                      print('hehe $bunValue $dateTime');
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
