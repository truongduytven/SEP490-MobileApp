import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sep490/theme/color.dart';

class BloodPressureDisplayWidget extends StatelessWidget {
  final num systolic;
  final num diastolic;
  final String dateTime;
  final VoidCallback onEdit;
  final bool isDraft;
  final String typeData;
  const BloodPressureDisplayWidget({
    required this.systolic,
    required this.diastolic,
    required this.dateTime,
    required this.onEdit,
    required this.isDraft,
    required this.typeData,
    super.key,
  });
  bool isToday(String dateTime) {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    final DateTime dateFromString = dateFormat.parse(dateTime);
    final DateTime today = DateTime.now();
    return dateFromString.year == today.year &&
        dateFromString.month == today.month &&
        dateFromString.day == today.day;
  }

  String get bloodPressureClassification {
    print("value $systolic $diastolic");
    if (systolic < 120 && diastolic < 80) {
      return 'Bình Thường';
    } else if (systolic >= 120 && systolic < 130 && diastolic < 80) {
      return 'Cao hơn mức bình thường';
    } else if (systolic >= 130 && systolic <= 139 ||
        diastolic >= 80 && diastolic <= 89) {
      return 'Tăng huyết áp cấp độ 1';
    } else if (systolic >= 140 || diastolic >= 90) {
      return 'Tăng huyết áp cấp độ 2';
    } else if (systolic > 180 || diastolic > 120) {
      return 'Huyết áp cao nghiêm trọng';
    }
    return 'Unknown';
  }

  Color get classificationColor {
    if (systolic < 120 && diastolic < 80) {
      return Colors.green;
    } else if (systolic >= 120 && systolic < 130 && diastolic < 80) {
      return Colors.yellow;
    } else if (systolic >= 130 && systolic <= 139 ||
        diastolic >= 80 && diastolic <= 89) {
      return Colors.orange;
    } else if (systolic >= 140 || diastolic >= 90) {
      return Colors.red;
    } else if (systolic > 180 || diastolic > 120) {
      return Colors.red.shade900;
    }
    return Colors.grey;
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  systolic.toString(),
                                  style: TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.w700),
                                ),
                                Transform.translate(
                                  offset: Offset(0,
                                      -20), // Adjust the vertical position of "kg"
                                  child: Text(
                                    "Tâm thu",
                                    style: TextStyle(
                                        fontSize: 28,
                                        color: AppColors.grayColor5),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  diastolic.toString(),
                                  style: TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.w700),
                                ),
                                Transform.translate(
                                  offset: Offset(0,
                                      -20), // Adjust the vertical position of "kg"
                                  child: Text(
                                    "Tâm trương",
                                    style: TextStyle(
                                        fontSize: 28,
                                        color: AppColors.grayColor5),
                                  ),
                                ),
                              ],
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.bloodtype_rounded,
                                size: 30,
                                color: classificationColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                bloodPressureClassification,
                                style: TextStyle(
                                  fontSize: 22,
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
                                onTap: () => _showAccountDialog(context),
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
                      print('hehe $systolic $diastolic $dateTime');
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

void _showAccountDialog(BuildContext context) {
  showDialog(
    barrierColor: AppColors.secondaryColor.withOpacity(0.95),
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.all(20),
        backgroundColor: AppColors.bgColor,
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Bảng phân loại tham khảo",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange,
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      // Adjust text to fit within the available space
                      child: Text(
                        "Bảng này chỉ mang tính chất tham khảo, chỉ số huyết áp còn phụ thuộc vào nhiều yếu tố như: độ tuổi, cân nặng, chế độ ăn uống, tình trạng thể chất, tiền sử gia đình,..",
                        style: TextStyle(
                            fontSize: 16, color: AppColors.grayColor5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: InteractiveViewer(
                    panEnabled: true,
                    boundaryMargin: EdgeInsets.all(20),
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: Image.asset(
                      'assets/img/phanloaitanghuyep.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "Đóng",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      );
    },
  );
}
