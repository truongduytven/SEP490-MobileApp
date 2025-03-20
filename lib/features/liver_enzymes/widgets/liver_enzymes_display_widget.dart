import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gif_view/gif_view.dart';
import 'package:intl/intl.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/features/liver_enzymes/controller/liver_enzymes_controller.dart';
import 'package:sep490/theme/color.dart';

class LiverEnzymesDisplayWidget extends ConsumerStatefulWidget {
  final num altValue;
  final num alpValue;
  final num astValue;
  final num ggtValue;
  final String dateTime;
  final VoidCallback onEdit;
  final bool isDraft;
  final String typeData;
  LiverEnzymesDisplayWidget({
    super.key,
    required this.dateTime,
    required this.onEdit,
    required this.isDraft,
    required this.altValue,
    required this.alpValue,
    required this.astValue,
    required this.ggtValue,
    required this.typeData,
  });

  @override
  ConsumerState<LiverEnzymesDisplayWidget> createState() =>
      _LiverEnzymesDisplayWidgetState();
}

class _LiverEnzymesDisplayWidgetState
    extends ConsumerState<LiverEnzymesDisplayWidget> {
  String liverEnzymesEvaluation = "Đang đánh giá...";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchLiverEnzymesEvaluation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(AssetImage('assets/gif/notes.gif'), context);
    });
  }

  Future<void> fetchLiverEnzymesEvaluation() async {
    final liverEnzymesController = ref.read(liverEnzymesControllerProvider);
    final result = await liverEnzymesController.getLiverEnzymesEvaluation(
      context,
      widget.altValue.toDouble(),
      widget.astValue.toDouble(),
      widget.alpValue.toDouble(),
      widget.ggtValue.toDouble(),
    );
    setState(() {
      liverEnzymesEvaluation = result;
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
    if (widget.altValue < 60) {
      return Colors.orange; // Yellow for Bradycardia
    } else if (widget.altValue >= 60 && widget.altValue <= 100) {
      return Colors.green; // Green for Normal
    } else {
      return Colors.red; // Red for Tachycardia
    }
  }

  // String get heartBeatClassification {
  //   if (widget.altValue < 60) {
  //     return "Gan chậm";
  //   } else if (widget.altValue >= 60 && widget.altValue <= 100) {
  //     return "Gan bình thường";
  //   } else {
  //     return "Gan nhanh";
  //   }
  // }
  Color getColorBasedOnEvaluation(String evaluation) {
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
                      "Đang thêm men gan...",
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "ALT",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              Text(
                                widget.altValue.toDouble().toStringAsFixed(1),
                                style: TextStyle(
                                    fontSize: 50, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Transform.translate(
                                offset: Offset(0,
                                    -25), // Adjust the vertical position of "kg"
                                child: Text(
                                  "UI/L",
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
                                "ALP",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              Text(
                                widget.alpValue.toDouble().toStringAsFixed(1),
                                style: TextStyle(
                                    fontSize: 50, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Transform.translate(
                                offset: Offset(0,
                                    -25), // Adjust the vertical position of "kg"
                                child: Text(
                                  "UI/L",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.grayColor5),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "AST",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              Text(
                                widget.astValue.toDouble().toStringAsFixed(1),
                                style: TextStyle(
                                    fontSize: 50, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Transform.translate(
                                offset: Offset(0,
                                    -25), // Adjust the vertical position of "kg"
                                child: Text(
                                  " UI/L",
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
                                "GGT",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              Text(
                                widget.ggtValue.toDouble().toStringAsFixed(1),
                                style: TextStyle(
                                    fontSize: 50, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Transform.translate(
                                offset: Offset(0,
                                    -25), // Adjust the vertical position of "kg"
                                child: Text(
                                  " UI/L",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.grayColor5),
                                ),
                              ),
                            ],
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
                                Icons.tune,
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
                                  ...liverEnzymesEvaluation
                                      .split("-")
                                      .map((text) => Text(
                                            text.trim(),
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: getColorBasedOnEvaluation(
                                                  liverEnzymesEvaluation),
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
                    //   print('hehe ${widget.altValue} ${widget.dateTime}');
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
                              final liverEnzymesController =
                                  ref.read(liverEnzymesControllerProvider);

                              final success =
                                  await liverEnzymesController.addLiverEnzymes(
                                context: context,
                                accountId: currentUserAccountID ?? 0,
                                elderlyId: currentUserAccountID ?? 0,
                                alt: widget.altValue.toDouble(),
                                ast: widget.astValue.toDouble(),
                                alp: widget.alpValue.toDouble(),
                                ggt: widget.ggtValue.toDouble(),
                                liverEnzymesSource: "Thủ công",
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
