import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gif_view/gif_view.dart';
import 'package:intl/intl.dart';
import 'package:sep490/common/utils/utils.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/features/sleep/controller/sleep_controller.dart';
import 'package:sep490/theme/color.dart';

class SleepDisplay extends ConsumerStatefulWidget {
  final num sleep;
  final String dateTime;
  final VoidCallback onEdit;
  final bool isDraft;
  final String typeData;
  final String? id;

  const SleepDisplay({
    super.key,
    required this.sleep,
    required this.dateTime,
    required this.onEdit,
    required this.isDraft,
    required this.typeData,
    this.id,
  });

  @override
  ConsumerState<SleepDisplay> createState() => _SleepDisplayState();
}

class _SleepDisplayState extends ConsumerState<SleepDisplay> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
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
      final success =
          await ref.read(sleepControllerProvider).deleteHeartRate(
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
                                  hourFormatSleep(widget.sleep.toInt()),
                                  style: TextStyle(
                                      fontSize: 80,
                                      fontWeight: FontWeight.w700),
                                ),
                                Transform.translate(
                                  offset: Offset(0,
                                      -25), // Adjust the vertical position of "kg"
                                  child: Text(
                                    "phút",
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

                          SizedBox(
                            height: 30,
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
                                  final heartRateController =
                                      ref.read(sleepControllerProvider);

                                  bool success;
                                  if (widget.id != null) {
                                    // Gọi hàm update nếu có id
                                    success = false;
                                  } else {
                                    // Gọi hàm add nếu không có id
                                    success =
                                        await heartRateController.addBloodOxygen(
                                      context: context,
                                      accountId: currentUserAccountID ?? 0,
                                      elderlyId: currentUserAccountID ?? 0,
                                      sleep: widget.sleep.toInt(),
                                      sleepSource: widget.typeData,
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
