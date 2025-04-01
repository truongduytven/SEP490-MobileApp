import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gif_view/gif_view.dart';
import 'package:intl/intl.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/features/heart_beat/controller/heart_rate_controller.dart';
import 'package:sep490/theme/color.dart';

class CaloriesBurnedDislay extends ConsumerStatefulWidget {
  final num caloriesBurned;
  final String dateTime;
  final VoidCallback onEdit;
  final bool isDraft;
  final String typeData;
  final String? id;

  const CaloriesBurnedDislay({
    super.key,
    required this.caloriesBurned,
    required this.dateTime,
    required this.onEdit,
    required this.isDraft,
    required this.typeData,
    this.id,
  });

  @override
  ConsumerState<CaloriesBurnedDislay> createState() =>
      _CaloriesBurnedDislayState();
}

class _CaloriesBurnedDislayState
    extends ConsumerState<CaloriesBurnedDislay> {
  String heartRateEvaluation = "Đang đánh giá...";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchBloodOxygenEvaluation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(AssetImage('assets/gif/notes.gif'), context);
    });
  }

  Future<void> fetchBloodOxygenEvaluation() async {
    final heartRateController = ref.read(heartRateControllerProvider);
    final result = await heartRateController.getHeartRateEvaluation(
        context, widget.caloriesBurned.toInt());
    setState(() {
      heartRateEvaluation = result;
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
    if (evaluation.toLowerCase().contains("nhanh")) {
      return Colors.red;
    } else if (evaluation.toLowerCase().contains("chậm")) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  void _handleDelete() async {
    setState(() => isLoading = true);

    try {
      final success =
          await ref.read(heartRateControllerProvider).deleteHeartRate(
                context: context,
                heartRateId: int.parse(widget.id!),
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
    bool isButtonDisabled = !widget.isDraft;
    // bool isButtonDisabled = !isToday(widget.dateTime) && !widget.isDraft;

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
                          ? "Đang cập nhật chỉ số..."
                          : "Đang thêm chỉ số...",
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
      body: Stack(
        children: [
          Column(
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
                                  widget.caloriesBurned.toString(),
                                  style: TextStyle(
                                      fontSize: 80,
                                      fontWeight: FontWeight.w700),
                                ),
                                Transform.translate(
                                  offset: Offset(0,
                                      -25), // Adjust the vertical position of "kg"
                                  child: Text(
                                    "kcal",
                                    style: TextStyle(
                                        fontSize: 40,
                                        color: AppColors.grayColor5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18, vertical: 6),
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
                            children: [
                              Icon(
                                Icons.monitor_heart_outlined,
                                size: 30,
                                color: getColorBasedOnEvaluation(
                                    heartRateEvaluation), // Màu cố định
                              ),
                              SizedBox(width: 10),
                              Text(
                                heartRateEvaluation, // Hiển thị đánh giá từ API
                                style: TextStyle(
                                  fontSize: 26,
                                  color: getColorBasedOnEvaluation(
                                      heartRateEvaluation), // Màu cố định
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
                        onPressed: isLoading
                            ? null // Khi đang loading thì disable button
                            : () async {
                                setState(() {
                                  isLoading = true; // Bắt đầu loading
                                });

                                try {
                                  SharedPrefsHelper sharedPrefsHelper =
                                      SharedPrefsHelper();
                                  final currentUserAccountID =
                                      sharedPrefsHelper.getInt("accountId");
                                  final currentUserFullName =
                                      sharedPrefsHelper.getString("fullName");
                                  final heartRateController =
                                      ref.read(heartRateControllerProvider);

                                  // final success =
                                  //     await heartRateController.addHeartRate(
                                  //   context: context,
                                  //   accountId: currentUserAccountID ?? 0,
                                  //   elderlyId: currentUserAccountID ?? 0,
                                  //   heartRate: widget.heartBeat.toInt(),
                                  //   heartRateSource: "Thủ công",
                                  // );

                                  bool success;
                                  if (widget.id != null) {
                                    // Gọi hàm update nếu có id
                                    success = await heartRateController
                                        .updateHeartRate(
                                      context: context,
                                      heartRateId: int.parse(widget.id!),
                                      createdBy:
                                          currentUserFullName ?? "Unknown",
                                      heartRate: widget.caloriesBurned.toInt(),
                                    );
                                  } else {
                                    // Gọi hàm add nếu không có id
                                    success =
                                        await heartRateController.addHeartRate(
                                      context: context,
                                      accountId: currentUserAccountID ?? 0,
                                      elderlyId: currentUserAccountID ?? 0,
                                      heartRate: widget.caloriesBurned.toInt(),
                                      heartRateSource: "Thủ công",
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
                                    SnackBar(
                                        content: Text('Lỗi: ${e.toString()}')),
                                  );
                                } finally {
                                  await Future.delayed(Duration(
                                      seconds:
                                          2)); // Giữ màn hình loading lâu hơn
                                  if (mounted) {
                                    setState(() {
                                      isLoading = false; // Kết thúc loading
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
        ],
      ),
    );
  }
}
