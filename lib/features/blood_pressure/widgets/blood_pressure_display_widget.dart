import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gif_view/gif_view.dart';
import 'package:intl/intl.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/features/blood_pressure/controller/blood_pressure_controller.dart';
import 'package:sep490/theme/color.dart';

class BloodPressureDisplayWidget extends ConsumerStatefulWidget {
  final num systolic;
  final num diastolic;
  final String dateTime;
  final VoidCallback onEdit;
  final bool isDraft;
  final String typeData;
  final String? id;

  const BloodPressureDisplayWidget({
    required this.systolic,
    required this.diastolic,
    required this.dateTime,
    required this.onEdit,
    required this.isDraft,
    required this.typeData,
    super.key,
    this.id,
  });

  @override
  ConsumerState<BloodPressureDisplayWidget> createState() =>
      _BloodPressureDisplayWidgetState();
}

class _BloodPressureDisplayWidgetState
    extends ConsumerState<BloodPressureDisplayWidget> {
  String bloodPressureEvaluation = "Đang đánh giá...";
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    fetchBloodPressureEvaluation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(AssetImage('assets/gif/notes.gif'), context);
    });
  }

  Future<void> fetchBloodPressureEvaluation() async {
    final bloodPressureController = ref.read(bloodPressureControllerProvider);
    final result = await bloodPressureController.getBloodPressureEvaluation(
      context,
      widget.systolic.toInt(),
      widget.diastolic.toInt(),
    );
    setState(() {
      bloodPressureEvaluation = result;
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

  Color getColorBasedOnEvaluation(String evaluation) {
    if (evaluation.toLowerCase().contains("cao")) {
      return Colors.red;
    } else if (evaluation.toLowerCase().contains("thấp")) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  // String get bloodPressureClassification {
  //   print("value ${widget.systolic} ${widget.diastolic}");
  //   if (widget.systolic < 120 && widget.diastolic < 80) {
  //     return 'Bình Thường';
  //   } else if (widget.systolic >= 120 &&
  //       widget.systolic < 130 &&
  //       widget.diastolic < 80) {
  //     return 'Cao hơn mức bình thường';
  //   } else if (widget.systolic >= 130 && widget.systolic <= 139 ||
  //       widget.diastolic >= 80 && widget.diastolic <= 89) {
  //     return 'Tăng huyết áp cấp độ 1';
  //   } else if (widget.systolic >= 140 || widget.diastolic >= 90) {
  //     return 'Tăng huyết áp cấp độ 2';
  //   } else if (widget.systolic > 180 || widget.diastolic > 120) {
  //     return 'Huyết áp cao nghiêm trọng';
  //   }
  //   return 'Unknown';
  // }

  // Color get classificationColor {
  //   if (widget.systolic < 120 && widget.diastolic < 80) {
  //     return Colors.green;
  //   } else if (widget.systolic >= 120 &&
  //       widget.systolic < 130 &&
  //       widget.diastolic < 80) {
  //     return Colors.yellow;
  //   } else if (widget.systolic >= 130 && widget.systolic <= 139 ||
  //       widget.diastolic >= 80 && widget.diastolic <= 89) {
  //     return Colors.orange;
  //   } else if (widget.systolic >= 140 || widget.diastolic >= 90) {
  //     return Colors.red;
  //   } else if (widget.systolic > 180 || widget.diastolic > 120) {
  //     return Colors.red.shade900;
  //   }
  //   return Colors.grey;
  // }
  void _handleDelete() async {
    setState(() => isLoading = true);

    try {
      final success =
          await ref.read(bloodPressureControllerProvider).deleteBloodPressure(
                context: context,
                bloodPressureId: int.parse(widget.id!),
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
                          ? "Đang cập nhật huyết áp..."
                          : "Đang thêm huyết áp...",
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
                                            onPressed: () => Navigator.pop(
                                                context), // Đóng hộp thoại
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.systolic.toString(),
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
                                  widget.diastolic.toString(),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.bloodtype_rounded,
                                size: 30,
                                color: getColorBasedOnEvaluation(
                                    bloodPressureEvaluation),
                              ),
                              SizedBox(width: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Text(
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  bloodPressureEvaluation,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: getColorBasedOnEvaluation(
                                        bloodPressureEvaluation),
                                  ),
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
                    // onPressed: () {
                    //   print(
                    //       'hehe ${widget.systolic} ${widget.diastolic} ${widget.dateTime}');
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
                              final bloodPressureController =
                                  ref.read(bloodPressureControllerProvider);

                              // final success =
                              //     await heartRateController.addBloodPressure(
                              //   context: context,
                              //   accountId: currentUserAccountID ?? 0,
                              //   elderlyId: currentUserAccountID ?? 0,
                              //   systolic: widget.systolic.toInt(),
                              //   diastolic: widget.diastolic.toInt(),
                              //   systolicSource: "Thủ công",
                              //   diastolicSource: "Thủ công",
                              // );

                              bool success;
                              if (widget.id != null) {
                                // Gọi hàm update nếu có id
                                success = await bloodPressureController
                                    .updateBloodPressure(
                                  context: context,
                                  bloodPressureId: int.parse(widget.id!),
                                  createdBy: currentUserFullName ?? "Unknown",
                                  systolic: widget.systolic.toInt(),
                                  diastolic: widget.diastolic.toInt(),
                                );
                              } else {
                                // Gọi hàm add nếu không có id
                                success = await bloodPressureController
                                    .addBloodPressure(
                                  context: context,
                                  accountId: currentUserAccountID ?? 0,
                                  elderlyId: currentUserAccountID ?? 0,
                                  systolic: widget.systolic.toInt(),
                                  diastolic: widget.diastolic.toInt(),
                                  systolicSource: "Thủ công",
                                  diastolicSource: "Thủ công",
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
