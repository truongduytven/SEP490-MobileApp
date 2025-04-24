import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gif_view/gif_view.dart';
import 'package:intl/intl.dart';
import 'package:sep490/data/helper/shared_prefs_helper.dart';
import 'package:sep490/features/blood_glucose/controller/blood_glucose_controller.dart';
import 'package:sep490/theme/color.dart';

class BloodGlucoseDisplayWidget extends ConsumerStatefulWidget {
  final num bloodGlucose;
  final String dateTime;
  final VoidCallback onEdit;
  final bool isDraft;
  final bool canEdit;
  final String typeData;
  final String period;
  final String? id;

  BloodGlucoseDisplayWidget({
    super.key,
    required this.bloodGlucose,
    required this.dateTime,
    required this.onEdit,
    required this.isDraft,
    required this.canEdit,
    required this.period,
    required this.typeData,
    this.id,
  });

  @override
  ConsumerState<BloodGlucoseDisplayWidget> createState() =>
      _BloodGlucoseDisplayWidgetState();
}

class _BloodGlucoseDisplayWidgetState
    extends ConsumerState<BloodGlucoseDisplayWidget> {
  String bloodGlucoseEvaluation = "Đang đánh giá...";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchBloodGlucoseEvaluation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(AssetImage('assets/gif/notes.gif'), context);
    });
  }

  Future<void> fetchBloodGlucoseEvaluation() async {
    final bloodGlucoseController = ref.read(bloodGlucoseControllerProvider);
    final result = await bloodGlucoseController.getBloodGlucoseEvaluation(
      context,
      widget.bloodGlucose.toDouble(),
      widget.period,
    );
    setState(() {
      bloodGlucoseEvaluation = result;
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
    if (widget.bloodGlucose < 60) {
      return Colors.orange; // Yellow for Bradycardia
    } else if (widget.bloodGlucose >= 60 && widget.bloodGlucose <= 100) {
      return Colors.green; // Green for Normal
    } else {
      return Colors.red; // Red for Tachycardia
    }
  }

  String get heartBeatClassification {
    if (widget.bloodGlucose < 60) {
      return "Đường huyết chậm";
    } else if (widget.bloodGlucose >= 60 && widget.bloodGlucose <= 100) {
      return "Đường huyết bình thường";
    } else {
      return "Đường huyết nhanh";
    }
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

  Map<String, IconData> periodIcons = {
    "Thức dậy": Icons.wb_sunny_outlined,
    "Trước bữa ăn": Icons.local_cafe_outlined,
    "Sau bữa ăn": Icons.fastfood_sharp,
    "Trước khi ngủ": Icons.night_shelter_outlined,
  };

  IconData getPeriodIcon(String period) {
    return periodIcons[period] ??
        Icons.help_outline; // Default icon if not found
  }

  void _handleDelete() async {
    setState(() => isLoading = true);

    try {
      final success =
          await ref.read(bloodGlucoseControllerProvider).deleteBloodGlucose(
                context: context,
                bloodGlucoseId: int.parse(widget.id!),
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
                          ? "Đang cập nhật đường huyết..."
                          : "Đang thêm đường huyết...",
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
                                              // await deleteBloodGlucose();
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
                          isToday(widget.dateTime) && widget.canEdit
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
                              widget.bloodGlucose.toString(),
                              style: TextStyle(
                                  fontSize: 80, fontWeight: FontWeight.w700),
                            ),
                            Transform.translate(
                              offset: Offset(0,
                                  -25), // Adjust the vertical position of "kg"
                              child: Text(
                                "mmol/L",
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
                              getPeriodIcon(widget.period),
                              color: AppColors.textPrimary,
                              size: 24,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.period,
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
                                Icons.bloodtype_outlined,
                                size: 30,
                                color: getColorBasedOnEvaluation(
                                    bloodGlucoseEvaluation),
                              ),
                              SizedBox(width: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Text(
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  bloodGlucoseEvaluation,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: getColorBasedOnEvaluation(
                                        bloodGlucoseEvaluation),
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
                    //   print('hehe ${widget.bloodGlucose} ${widget.dateTime}');
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
                                  sharedPrefsHelper.getInt("accountId") ?? 0;
                              final currentUserFullName =
                                  sharedPrefsHelper.getString("fullName") ?? '';
                              final currentUserElderlyID = sharedPrefsHelper
                                      .getInt("selectedElderlyUserId") ??
                                  0;
                              final bloodGlucoseController =
                                  ref.read(bloodGlucoseControllerProvider);
                              bool success;
                              if (widget.id != null) {
                                // Gọi hàm update nếu có id
                                success = await bloodGlucoseController
                                    .updateBloodGlucose(
                                  context: context,
                                  bloodGlucoseId: int.parse(widget.id!),
                                  createdBy: currentUserFullName != ''
                                      ? currentUserFullName
                                      : "Unknown",
                                  bloodGlucoseUpdate:
                                      widget.bloodGlucose.toDouble(),
                                  period: widget.period,
                                );
                              } else {
                                // Gọi hàm add nếu không có id
                                success = await bloodGlucoseController
                                    .addBloodGlucose(
                                  context: context,
                                  accountId: currentUserAccountID,
                                  elderlyId: currentUserElderlyID != 0
                                      ? currentUserElderlyID
                                      : currentUserAccountID,
                                  bloodGlucose: widget.bloodGlucose.toDouble(),
                                  bloodGlucoseSource: "Thủ công",
                                  period: widget.period,
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

// void _showAccountDialog(BuildContext context) {
//   showDialog(
//     barrierColor: AppColors.secondaryColor.withOpacity(0.95),
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         insetPadding: EdgeInsets.all(20),
//         backgroundColor: AppColors.bgColor,
//         contentPadding: EdgeInsets.zero,
//         content: SizedBox(
//           height: 460, // Increased height to fit the source text
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Text(
//                     "Về đường huyết",
//                     style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     Expanded(
//                       child: Text(
//                         "Mức đường huyết là lượng glucose trong máu. Glucose là một loại đường có trong thực phẩm chúng ta ăn, và nó cũng được hình thành và lưu trữ bên trong cơ thể.",
//                         style: TextStyle(
//                             fontSize: 16, color: AppColors.grayColor5),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Expanded(
//                   child: Column(
//                     children: [
//                       // Row(
//                       //   children: [
//                       //     Expanded(
//                       //       child: Text(
//                       //         "Cao",
//                       //         style: TextStyle(
//                       //             fontSize: 24, fontWeight: FontWeight.w500),
//                       //       ),
//                       //     ),
//                       //     Expanded(
//                       //       child: ElevatedButton(
//                       //         onPressed: () {},
//                       //         style: ElevatedButton.styleFrom(
//                       //           backgroundColor: Colors.orange,
//                       //           padding: EdgeInsets.symmetric(vertical: 12),
//                       //           shape: RoundedRectangleBorder(
//                       //             borderRadius: BorderRadius.circular(12),
//                       //           ),
//                       //         ),
//                       //         child: Text(
//                       //           "> 9.94 mmol/L",
//                       //           style: TextStyle(
//                       //               color: Colors.white, fontSize: 16),
//                       //         ),
//                       //       ),
//                       //     ),
//                       //   ],
//                       // ),
//                       // const SizedBox(height: 20),
//                       // Row(
//                       //   children: [
//                       //     Expanded(
//                       //       child: Text(
//                       //         "Trong mức bình thường",
//                       //         style: TextStyle(
//                       //             fontSize: 23, fontWeight: FontWeight.w500),
//                       //       ),
//                       //     ),
//                       //     Expanded(
//                       //       child: ElevatedButton(
//                       //         onPressed: () {},
//                       //         style: ElevatedButton.styleFrom(
//                       //           backgroundColor: Colors.green,
//                       //           padding: EdgeInsets.symmetric(vertical: 12),
//                       //           shape: RoundedRectangleBorder(
//                       //             borderRadius: BorderRadius.circular(12),
//                       //           ),
//                       //         ),
//                       //         child: Text(
//                       //           "3.83 - 9.94 mmol/L",
//                       //           style: TextStyle(
//                       //               color: Colors.white, fontSize: 16),
//                       //         ),
//                       //       ),
//                       //     ),
//                       //   ],
//                       // ),
//                       // const SizedBox(height: 20),
//                       // Row(
//                       //   children: [
//                       //     Expanded(
//                       //       child: Text(
//                       //         "Thấp",
//                       //         style: TextStyle(
//                       //             fontSize: 24, fontWeight: FontWeight.w500),
//                       //       ),
//                       //     ),
//                       //     Expanded(
//                       //       child: ElevatedButton(
//                       //         onPressed: () {},
//                       //         style: ElevatedButton.styleFrom(
//                       //           backgroundColor: Colors.lightBlueAccent,
//                       //           padding: EdgeInsets.symmetric(vertical: 12),
//                       //           shape: RoundedRectangleBorder(
//                       //             borderRadius: BorderRadius.circular(12),
//                       //           ),
//                       //         ),
//                       //         child: Text(
//                       //           "< 3.83 mmol/L",
//                       //           style: TextStyle(
//                       //               color: Colors.white, fontSize: 16),
//                       //         ),
//                       //       ),
//                       //     ),
//                       //   ],
//                       // ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Center(
//                   child: Text(
//                     "Nguồn: Hiệp hội Tiểu đường Hoa Kỳ (ADA)",
//                     style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: const Text(
//               "Đóng",
//               style: TextStyle(fontSize: 20),
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }
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
          height: 650, // Tăng chiều cao để chứa thêm thông tin
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Về đường huyết",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 10),
                // Giới thiệu chung
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(
                      child: Text(
                        "Mức đường huyết là lượng glucose trong máu. Glucose là một loại đường có trong thực phẩm chúng ta ăn, và nó cũng được hình thành và lưu trữ bên trong cơ thể.",
                        style: TextStyle(
                            fontSize: 16, color: AppColors.grayColor5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Thông tin chi tiết
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Đường huyết cao
                        _buildInfoSection(
                          title: "1. Đường huyết cao",
                          causes: [
                            "Kháng insulin hoặc thiếu insulin (tiểu đường tuýp 1, tuýp 2)",
                            "Chế độ ăn nhiều đường, tinh bột",
                            "Ít vận động thể chất",
                            "Căng thẳng kéo dài",
                            "Tác dụng phụ của thuốc (ví dụ: corticosteroid)"
                          ],
                          symptoms: [
                            "Khát nước liên tục",
                            "Đi tiểu nhiều",
                            "Mờ mắt",
                            "Mệt mỏi kéo dài",
                            "Vết thương lâu lành"
                          ],
                          prevention: [
                            "Kiểm soát chế độ ăn (giảm đường, tăng chất xơ)",
                            "Tập thể dục 30 phút/ngày",
                            "Dùng thuốc theo chỉ định bác sĩ",
                            "Theo dõi đường huyết định kỳ"
                          ],
                          color: Colors.orange,
                        ),
                        const SizedBox(height: 20),
                        // Đường huyết bình thường
                        _buildInfoSection(
                          title: "2. Đường huyết bình thường ",
                          description:
                              "Mức đường huyết an toàn cho người khỏe mạnh khi đói: 3.9 - 5.5 mmol/L, sau ăn 2 giờ: < 7.8 mmol/L.",
                          color: Colors.green,
                        ),
                        const SizedBox(height: 20),
                        // Đường huyết thấp
                        _buildInfoSection(
                          title: "3. Đường huyết thấp",
                          causes: [
                            "Dùng quá liều thuốc hạ đường huyết",
                            "Bỏ bữa hoặc ăn quá ít carbohydrate",
                            "Vận động quá sức",
                            "Uống rượu khi đói"
                          ],
                          symptoms: [
                            "Run tay, vã mồ hôi",
                            "Chóng mặt, choáng váng",
                            "Đói cồn cào",
                            "Tim đập nhanh",
                            "Lú lẫn hoặc ngất xỉu (trường hợp nặng)"
                          ],
                          prevention: [
                            "Ăn đủ bữa, không bỏ bữa sáng",
                            "Mang theo đồ ăn nhẹ (bánh quy, kẹo) khi ra ngoài",
                            "Kiểm tra đường huyết nếu có triệu chứng",
                            "Ngừng ngay hoạt động thể lực khi thấy dấu hiệu hạ đường huyết"
                          ],
                          color: Colors.lightBlueAccent,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Nguồn tham khảo
                Center(
                  child: Text(
                    "Nguồn: Hiệp hội Tiểu đường Hoa Kỳ (ADA) & Hiệp hội Nội tiết Việt Nam",
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: AppColors.grayColor5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
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

// Widget phụ để tạo các section thông tin
Widget _buildInfoSection({
  required String title,
  String? description,
  List<String>? causes,
  List<String>? symptoms,
  List<String>? prevention,
  required Color color,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
      const SizedBox(height: 8),
      if (description != null)
        Text(
          description,
          style: const TextStyle(fontSize: 16),
        ),
      if (causes != null) ...[
        const SizedBox(height: 8),
        const Text(
          "Nguyên nhân:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        ...causes
            .map((e) => Text("• $e", style: const TextStyle(fontSize: 16))),
      ],
      if (symptoms != null) ...[
        const SizedBox(height: 8),
        const Text(
          "Triệu chứng:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        ...symptoms
            .map((e) => Text("• $e", style: const TextStyle(fontSize: 16))),
      ],
      if (prevention != null) ...[
        const SizedBox(height: 8),
        const Text(
          "Cách phòng tránh:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        ...prevention
            .map((e) => Text("• $e", style: const TextStyle(fontSize: 16))),
      ],
    ],
  );
}
