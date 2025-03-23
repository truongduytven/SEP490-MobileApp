import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gif_view/gif_view.dart';
import 'package:intl/intl.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/features/lipid_profile/controller/lipid_profile_controller.dart';
import 'package:sep490/theme/color.dart';

class LipidProfileDisplayWidget extends ConsumerStatefulWidget {
  final num tcValue;
  final num tgValue;
  final num ldlValue;
  final num hdlValue;
  final String dateTime;
  final VoidCallback onEdit;
  final bool isDraft;
  final String typeData;
  LipidProfileDisplayWidget({
    super.key,
    required this.dateTime,
    required this.onEdit,
    required this.isDraft,
    required this.tcValue,
    required this.tgValue,
    required this.ldlValue,
    required this.hdlValue,
    required this.typeData,
  });

  @override
  ConsumerState<LipidProfileDisplayWidget> createState() =>
      _LipidProfileDisplayWidgetState();
}

class _LipidProfileDisplayWidgetState
    extends ConsumerState<LipidProfileDisplayWidget> {
  String lipidProfileEvaluation = "Đang đánh giá...";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchLipidProfileEvaluation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(AssetImage('assets/gif/notes.gif'), context);
    });
  }

  Future<void> fetchLipidProfileEvaluation() async {
    final lipidProfileController = ref.read(lipidProfileControllerProvider);
    final result = await lipidProfileController.getLipidProfileEvaluation(
      context,
      widget.tcValue.toDouble(),
      widget.ldlValue.toDouble(),
      widget.hdlValue.toDouble(),
      widget.tgValue.toDouble(),
    );
    setState(() {
      lipidProfileEvaluation = result;
    });
  }

  bool isToday(String dateTime) {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    final DateTime dateFromString = dateFormat.parse(dateTime);
    final DateTime today = DateTime.now();
    return dateFromString.year == today.year &&
        dateFromString.month == today.month &&
        dateFromString.day == today.day;
  }

  Color get classificationColor {
    if (widget.tcValue < 60) {
      return Colors.orange; // Yellow for Bradycardia
    } else if (widget.tcValue >= 60 && widget.tcValue <= 100) {
      return Colors.green; // Green for Normal
    } else {
      return Colors.red; // Red for Tachycardia
    }
  }

  // String get heartBeatClassification {
  //   if (widget.tcValue < 60) {
  //     return "Mỡ máu chậm";
  //   } else if (widget.tcValue >= 60 && widget.tcValue <= 100) {
  //     return "Mỡ máu bình thường";
  //   } else {
  //     return "Mỡ máu nhanh";
  //   }
  // }
  Color getColorBasedOnEvaluation(String evaluation) {
    print("get cllor ${evaluation.toLowerCase().contains("cao")}");
    if (evaluation.toLowerCase().contains("cao")) {
      return Colors.red;
    } else if (evaluation.toLowerCase().contains("thấp")) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isButtonDisabled = !isToday(widget.dateTime) && !widget.isDraft;
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
                      "Đang thêm mỡ máu...",
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
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.tcValue.toDouble().toStringAsFixed(1),
                            style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Transform.translate(
                            offset: Offset(
                                0, -25), // Adjust the vertical position of "kg"
                            child: Text(
                              "mmol/L",
                              style: TextStyle(
                                  fontSize: 20, color: AppColors.grayColor5),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.hdlValue.toDouble().toStringAsFixed(1),
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  "HDL",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.grayColor5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Transform.rotate(
                            angle: 0.2,
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              width: 1,
                              height: 40,
                              color: AppColors.grayColor5,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.ldlValue.toDouble().toStringAsFixed(1),
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  "LDL",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.grayColor5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Transform.rotate(
                            angle: 0.2,
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              width: 1,
                              height: 40,
                              color: AppColors.grayColor5,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.tgValue.toDouble().toStringAsFixed(1),
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  "TRIG",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.grayColor5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 20,
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
                                Icons.blur_on,
                                size: 30,
                                color: classificationColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ...lipidProfileEvaluation
                                      .split("-")
                                      .map((text) => Text(
                                            text.trim(),
                                            style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 16,
                                              color: getColorBasedOnEvaluation(
                                                  text),
                                            ),
                                          )),
                                ],
                              )
                            ],
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
                    //   print('hehe ${widget.tcValue} ${widget.dateTime}');
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
                              final kidneyFunctionController =
                                  ref.read(lipidProfileControllerProvider);

                              final success = await kidneyFunctionController
                                  .addLipidProfile(
                                context: context,
                                accountId: currentUserAccountID ?? 0,
                                elderlyId: currentUserAccountID ?? 0,
                                totalCholesterol: widget.tcValue.toDouble(),
                                ldlCholesterol: widget.ldlValue.toDouble(),
                                hdlCholesterol: widget.hdlValue.toDouble(),
                                triglycerides: widget.tgValue.toDouble(),
                                lipidProfileSource: "Thủ công",
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
