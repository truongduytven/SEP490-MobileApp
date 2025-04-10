import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gif_view/gif_view.dart';
import 'package:intl/intl.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/features/weight/controller/weight_controller.dart';
import 'package:sep490/theme/color.dart';

class WeightDisplayWidget extends ConsumerStatefulWidget {
  final num weight;
  final String dateTime;
  final VoidCallback onEdit;
  final bool isDraft;
  final String typeData;
  final String? id;

  const WeightDisplayWidget({
    super.key,
    required this.weight,
    required this.dateTime,
    required this.onEdit,
    required this.isDraft,
    required this.typeData,
    this.id,
  });

  @override
  ConsumerState<WeightDisplayWidget> createState() =>
      _WeightDisplayWidgetState();
}

class _WeightDisplayWidgetState extends ConsumerState<WeightDisplayWidget> {
  String weightEvaluation = "Đang đánh giá...";
  String bmiEvaluation = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchWeightEvaluation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(AssetImage('assets/gif/notes.gif'), context);
    });
  }

  Future<void> fetchWeightEvaluation() async {
    SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
    final currentUserAccountID = sharedPrefsHelper.getInt("accountId") ?? 0;
    final currentSelectedElderlyUserId =
        sharedPrefsHelper.getInt("selectedElderlyUserId") ?? 0;
    final weightController = ref.read(weightControllerProvider);
    final result = await weightController.getWeightEvaluation(
      context,
      currentSelectedElderlyUserId != 0
          ? currentSelectedElderlyUserId
          : currentUserAccountID,
      widget.weight.toDouble(),
    );
    setState(() {
      weightEvaluation = result["evaluation"] ?? "Không có đánh giá";
      bmiEvaluation = result["bmi"] ?? "Không có đánh giá";
    });
  }

  /// Calculate BMI
  // double calculateBMI() {
  //   double heightInMeters = widget.height / 100; // Convert height to meters
  //   return widget.weight / (heightInMeters * heightInMeters);
  // }

  // /// Determine BMI classification
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

  void _handleDelete() async {
    setState(() => isLoading = true);

    try {
      final success = await ref.read(weightControllerProvider).deleteWeight(
            context: context,
            weightId: int.parse(
              widget.id!,
            ),
          );
      await Future.delayed(Duration(seconds: 2));

      if (mounted && success) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      print(e);
    } finally {
      await Future.delayed(Duration(seconds: 2));
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("weight_display ${widget.id}");
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
                      widget.id != null
                          ? "Đang cập nhật cân nặng..."
                          : "Đang thêm cân nặng...",
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
                              : IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("Xác nhận xóa"),
                                        content: Text(
                                            "Bạn có chắc chắn muốn xóa không?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text("Hủy"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              _handleDelete();
                                            },
                                            child: Text("Xóa",
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: AppColors.primaryColor,
                                    size: 30,
                                  ),
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
                          widget.typeData == 'Tự động'
                              ? Icon(
                                  Icons.lock_outline,
                                  size: 30,
                                  color: AppColors.primaryColor,
                                )
                              : isToday(widget.dateTime)
                                  ? IconButton(
                                      onPressed: widget.onEdit,
                                      icon: Icon(Icons.edit,
                                          size: 30,
                                          color: AppColors.primaryColor),
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
                              widget.weight.toStringAsFixed(1),
                              style: TextStyle(
                                  fontSize: 80, fontWeight: FontWeight.w700),
                            ),
                            Transform.translate(
                              offset: Offset(0,
                                  -25), // Adjust the vertical position of "kg"
                              child: Text(
                                "kg",
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
                            color: getBMIClassificationColor(weightEvaluation),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            weightEvaluation,
                            style: TextStyle(
                              fontSize: 26,
                              color:
                                  getBMIClassificationColor(weightEvaluation),
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
                            final currentUserElderlyID = sharedPrefsHelper
                                      .getInt("selectedElderlyUserId") ??
                                  0;
                              final weightController =
                                  ref.read(weightControllerProvider);

                              // final success = await weightController.addWeight(
                              //   context: context,
                              //   accountId: currentUserAccountID ?? 0,
                              //   elderlyId: currentUserAccountID ?? 0,
                              //   weight: widget.weight.toDouble(),
                              //   weightSource: "Thủ công",
                              // );

                              bool success;
                              if (widget.id != null) {
                                // Gọi hàm update nếu có id
                                success = await weightController.updateWeight(
                                  context: context,
                                  weightId: int.parse(widget.id!),
                                  createdBy: currentUserFullName ?? "Unknown",
                                  weight: widget.weight.toDouble(),
                                );
                              } else {
                                // Gọi hàm add nếu không có id
                                success = await weightController.addWeight(
                                  context: context,
                                  accountId: currentUserAccountID ?? 0,
                                  elderlyId: currentUserElderlyID != 0 ? currentUserElderlyID : currentUserAccountID ?? 0,
                                  weight: widget.weight.toDouble(),
                                  weightSource: widget.typeData,
                                );
                              }
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
          )
        ],
      ),
    );
  }
}
