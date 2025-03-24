import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gif_view/gif_view.dart';
import 'package:intl/intl.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/features/height/controller/height_controlelr.dart';
import 'package:sep490/theme/color.dart';

class HeightDisplayWidget extends ConsumerStatefulWidget {
  // final num weight; // in kilograms
  final num height; // in centimeters
  final String dateTime;
  final VoidCallback onEdit;
  final bool isDraft;
  final String typeData;
  const HeightDisplayWidget({
    super.key,
    // required this.weight,
    required this.height,
    required this.dateTime,
    required this.onEdit,
    required this.isDraft,
    required this.typeData,
  });

  @override
  ConsumerState<HeightDisplayWidget> createState() =>
      _HeightDisplayWidgetState();
}

class _HeightDisplayWidgetState extends ConsumerState<HeightDisplayWidget> {
  String heightEvaluation = "Đang đánh giá...";
  String bmiEvaluation = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchHeightEvaluation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(AssetImage('assets/gif/notes.gif'), context);
    });
  }

  Future<void> fetchHeightEvaluation() async {
    SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
    final currentUserAccountID = sharedPrefsHelper.getInt("accountId") ?? 0;
    final heightController = ref.read(heightControllerProvider);
    final result = await heightController.getHeightEvaluation(
      context,
      currentUserAccountID,
      widget.height.toDouble(),
    );
    setState(() {
      heightEvaluation = result["evaluation"] ?? "Không có đánh giá";
      bmiEvaluation = result["bmi"] ?? "Không có đánh giá";
    });
  }

  // /// Calculate BMI
  // double calculateBMI() {
  //   double heightInMeters = widget.height / 100; // Convert height to meters
  //   return widget.weight / (heightInMeters * heightInMeters);
  // }

  /// Determine BMI classification
  // String getBMIClassification(double bmi) {
  //   if (bmi < 18.5) {
  //     return "Thiếu cân";
  //   } else if (bmi >= 18.5 && bmi < 24.9) {
  //     return "Bình Thường";
  //   } else if (bmi >= 25 && bmi < 29.9) {
  //     return "Thừa cân";
  //   } else {
  //     return "Béo phì";
  //   }
  // }

  /// Get color based on BMI classification
  Color getBMIClassificationColor(String classification) {
    switch (classification.trim().toLowerCase()) {
      case "thiếu cân":
        return Colors.blue;
      case "bình Thường":
        return Colors.green;
      case "thừa cân":
        return Colors.orange;
      case "béo phì":
        return Colors.red;
      default:
        return AppColors.textPrimary;
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
    // final double bmi = calculateBMI();
    // final String bmiClassification = getBMIClassification(bmi);
    // final Color classificationColor =
    //     getBMIClassificationColor(bmiClassification);
    // bool isButtonDisabled = !isToday(widget.dateTime) && !widget.isDraft;
    bool isButtonDisabled = !widget.isDraft;
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white, // Màu nền trắng
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GifView.asset(
                'assets/gif/notes.gif',
                width: 200,
                height: 200,
                frameRate: 90,
              ),
              SizedBox(height: 10),
              DefaultTextStyle(
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 20,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      "Đang thêm chiều cao...",
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                      speed: Duration(milliseconds: 50), // Điều chỉnh tốc độ
                    ),
                  ],
                  isRepeatingAnimation: false, // Chạy 1 lần
                ),
              ),
            ],
          ),
        ),
      );
    }
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
                          widget.isDraft
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
                                isToday(widget
                                        .dateTime) // Check if it's today's date
                                    ? "Hôm nay"
                                    : widget.dateTime,
                                style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          isToday(widget.dateTime)
                              ? IconButton(
                                  onPressed: widget.onEdit,
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
                              widget.height.toStringAsFixed(1),
                              style: TextStyle(
                                  fontSize: 80, fontWeight: FontWeight.w700),
                            ),
                            Transform.translate(
                              offset: Offset(0,
                                  -25), // Adjust the vertical position of "kg"
                              child: Text(
                                "cm",
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
                              widget.typeData,
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
                      // BMI display
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Chỉ số khối cơ thể (BMI): ",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            bmiEvaluation,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.speed_rounded,
                            size: 30,
                            color: getBMIClassificationColor(heightEvaluation),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            heightEvaluation,
                            style: TextStyle(
                              fontSize: 26,
                              color:
                                  getBMIClassificationColor(heightEvaluation),
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
                    // onPressed: () {
                    //   print('hehe ${widget.weight} $bmi ${widget.dateTime}');
                    // },

                    onPressed: isLoading
                        ? null
                        : () async {
                            setState(() {
                              isLoading = true;
                            });

                            try {
                              SharedPrefsHelper sharedPrefsHelper =
                                  SharedPrefsHelper();
                              final currentUserAccountID =
                                  sharedPrefsHelper.getInt("accountId");
                              final currentUserFullName =
                                  sharedPrefsHelper.getString("fullName");
                              final heightController =
                                  ref.read(heightControllerProvider);

                              final success = await heightController.addHeight(
                                context: context,
                                accountId: currentUserAccountID ?? 0,
                                elderlyId: currentUserAccountID ?? 0,
                                height: widget.height.toDouble(),
                                heightSource: "Thủ công",
                              );
                              await Future.delayed(Duration(seconds: 2));

                              if (mounted) {
                                if (success) {
                                  Navigator.pop(context);
                                }
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Lỗi: ${e.toString()}')),
                              );
                            } finally {
                              await Future.delayed(Duration(seconds: 2));
                              if (mounted) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
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
