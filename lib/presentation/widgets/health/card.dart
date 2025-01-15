import 'package:flutter/material.dart';
import 'package:sep490/presentation/pages/health/marker_pointer_chart.dart';
import 'package:sep490/theme/color.dart';

class InfoCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MarkerPointerChart(value: 70)));
      },
      child: Card(
        color: AppColors.bgColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.secondaryColor, width: 0.1),
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
                      imageUrl,
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
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
                              color: _getBadgeBackgroundColor(result),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _getBadgeBorderColor(result),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                result,
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
                  thickness: 0.2,
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
                          dateTime,
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
                                text: data,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: "  $unit",
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
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            average,
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
                                  text: dataAverage,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: " $unit",
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
  switch (result) {
    case "Rất Cao":
      return const Color(0xFFE53935);
    case "Cao":
      return const Color(0xFFFFA726);
    case "Bình Thường":
      return const Color(0xFF0CCB0F);
    case "Thấp":
      return const Color(0xFF42A5F5);
    case "Rất Thấp":
      return const Color.fromARGB(255, 195, 110, 13);
    default:
      return const Color(0xFFE0E0E0);
  }
}

Color _getBadgeBorderColor(String result) {
  switch (result) {
    case "Rất Cao":
      return const Color(0xFFFFCDD2);
    case "Cao":
      return const Color(0xFFFFE0B2);
    case "Bình Thường":
      return const Color(0xFF95FFBA);
    case "Thấp":
      return const Color(0xFFBBDEFB);
    case "Rất Thấp":
      return const Color.fromARGB(255, 237, 149, 25);
    default:
      return const Color(0xFFF5F5F5);
  }
}
