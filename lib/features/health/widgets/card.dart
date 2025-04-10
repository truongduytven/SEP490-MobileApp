import 'package:flutter/material.dart';
import 'package:sep490/features/blood_glucose/screens/detail_blood_glucose_screen.dart';
import 'package:sep490/features/blood_oxygen/screens/detail_blood_oxygen.dart';
import 'package:sep490/features/blood_pressure/screens/detail_blood_pressure_screen.dart';
import 'package:sep490/features/calories_burned/screens/detail_calories_burned.dart';
import 'package:sep490/features/heart_beat/screens/detail_heart_beat_screen.dart';
import 'package:sep490/features/height/screens/detail_height_screen.dart';
import 'package:sep490/features/kidney_function/screens/detail_kidney_function_screen.dart';
import 'package:sep490/features/lipid_profile/screens/detail_lipid_profile_screen.dart';
import 'package:sep490/features/liver_enzymes/screens/detail_liver_enzymes_screen.dart';
import 'package:sep490/features/sleep/screens/detail_sleep.dart';
import 'package:sep490/features/steps/screens/detail_steps.dart';
import 'package:sep490/presentation/pages/health/detail_medicine_screen.dart';
import 'package:sep490/features/weight/screens/detail_weight_screen.dart';
import 'package:sep490/theme/color.dart';

class InfoCard extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String result;
  final String dateTime;
  final String data;
  final String unit;
  final String average;
  final String dataAverage;

  const InfoCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.result,
    required this.dateTime,
    required this.data,
    required this.unit,
    required this.average,
    required this.dataAverage,
  });

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  void navigateToCardDetail(String title) {
    // Switch case for different titles
    switch (title) {
      case "Nhịp tim":
        // Navigate to NhịpTimCard
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DetailHeartBeatScreen()));
        break;

      case "Huyết áp":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailBloodPressureScreen()));
        break;

      case "Cân nặng":
        // Navigate to CanNangCard
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DetailWeightScreen()));
        break;

      case "Chiều cao":
        // Navigate to ChieuCaoCard
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DetailHeightScreen()));
        break;
      case "Tuân thủ uống thuốc":
        // Navigate to ChieuCaoCard
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DetailMedicineScreen()));
        break;
      case "Đường huyết":
        // Navigate to ChieuCaoCard
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailBloodGlucoseScreen()));
        break;
      case "Chức năng thận":
        // Navigate to ChieuCaoCard
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailKidneyFunctionScreen()));
        break;
      case "Mỡ máu":
        // Navigate to ChieuCaoCard
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailLipidProfileScreen()));
        break;
      case "Men gan":
        // Navigate to ChieuCaoCard
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailLiverEnzymesScreen()));
        break;

      case "Oxy trong máu":
        // Navigate to ChieuCaoCard
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailBloodOxygen()));
        break;

      case "Số bước chân":
        // Navigate to ChieuCaoCard
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailStepScreen()));
        break;

      case "Thời gian ngủ":
        // Navigate to ChieuCaoCard
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailSleepScreen()));
        break;

      case "Lượng calo tiêu thụ":
        // Navigate to ChieuCaoCard
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailCaloriesBurnedScreen()));
        break;

      default:
        print("No card detail screen for ${title}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateToCardDetail(widget.title);
      },
      child: Card(
        color: AppColors.bgColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          // side: const BorderSide(color: AppColors.secondaryColor, width: 0.1),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      widget.imageUrl,
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      ConstrainedBox(
                        constraints:
                            const BoxConstraints(maxWidth: 130, minWidth: 90),
                        child: IntrinsicWidth(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 3),
                            decoration: BoxDecoration(
                              color: _getBadgeBackgroundColor(widget.result),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _getBadgeBorderColor(widget.result),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                widget.result,
                                maxLines: 1,
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                child: const Divider(
                  thickness: 0.1,
                  color: AppColors.secondaryColor,
                  height: 16,
                ),
              ),
              SizedBox(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.dateTime,
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.grayColor5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: widget.data,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: "  ${widget.unit}",
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 20,
                                    color: AppColors.grayColor5,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.average,
                            maxLines: 1,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 18,
                              color: AppColors.grayColor5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: widget.dataAverage,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: (widget.title != "Đường huyết" &&
                                          widget.title != "Men gan" &&
                                          widget.title != "Mỡ máu" &&
                                          widget.title != "Chức năng thận")
                                      ? " ${widget.unit}" // Hiển thị đơn vị nếu điều kiện không khớp
                                      : "",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: AppColors.grayColor5,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color _getBadgeBackgroundColor(String result) {
  switch (result.trim().toLowerCase()) {
    case "rất cao":
      return const Color(0xFFE53935);
    case "cao":
      return const Color(0xFFFFA726);
    case "bình thường":
      return const Color(0xFF0CCB0F);
    case "thấp":
      return const Color(0xFF42A5F5);
    case "rất thấp":
      return const Color.fromARGB(255, 195, 110, 13);
    default:
      return const Color(0xFFE0E0E0);
  }
}

Color _getBadgeBorderColor(String result) {
  switch (result.trim().toLowerCase()) {
    case "rất cao":
      return const Color(0xFFFFCDD2);
    case "cao":
      return const Color(0xFFFFE0B2);
    case "bình thường":
      return const Color(0xFF95FFBA);
    case "thấp":
      return const Color(0xFFBBDEFB);
    case "rất thấp":
      return const Color.fromARGB(255, 237, 149, 25);
    default:
      return const Color(0xFFF5F5F5);
  }
}
