import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class KidneyFunctionChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  KidneyFunctionChart({required this.data});

  List<FlSpot> getSpots(String key) {
    return data
        .asMap()
        .entries
        .map(
          (e) => FlSpot(e.key.toDouble(), e.value[key].toDouble()),
        )
        .toList();
  }

  // double getMinY() {
  //   double minValue = data
  //       .expand((element) => [element["BUN"], element["GFR"], element["eGFR"]])
  //       .reduce((a, b) => a < b ? a : b)
  //       .toDouble();
  //   return minValue - 15; // Cộng thêm 20 vào giới hạn dưới
  // }

  // double getMaxY() {
  //   double maxValue = data
  //       .expand((element) => [element["BUN"], element["GFR"], element["eGFR"]])
  //       .reduce((a, b) => a > b ? a : b)
  //       .toDouble();
  //   return maxValue + 15; // Cộng thêm 20 vào giới hạn trên
  // }
  double getMinY() {
    if (data.isEmpty) return 0; // Default value when no data

    final values = data
        .expand((element) => [element["BUN"], element["GFR"], element["eGFR"]]
            .where((v) => v != null)) // Filter out null values
        .toList();

    if (values.isEmpty) return 0; // Default value when all values are null

    final minValue = values.reduce((a, b) => a < b ? a : b);
    return (minValue as num).toDouble() - 15; // Ensure numeric conversion
  }

  double getMaxY() {
    if (data.isEmpty) return 100; // Default value when no data

    final values = data
        .expand((element) => [element["BUN"], element["GFR"], element["eGFR"]]
            .where((v) => v != null)) // Filter out null values
        .toList();

    if (values.isEmpty) return 100; // Default value when all values are null

    final maxValue = values.reduce((a, b) => a > b ? a : b);
    return (maxValue as num).toDouble() + 15; // Ensure numeric conversion
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10),
        // 📊 Biểu đồ chính
        Container(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LineChart(
              LineChartData(
                minY: getMinY(), // ✅ Giới hạn dưới
                maxY: getMaxY(), // ✅ Giới hạn trên
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false, // 📌 Ẩn đường lưới dọc
                  horizontalInterval: 5, // 📌 Khoảng cách đường lưới ngang
                  getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.5),
                      strokeWidth: 1,
                      dashArray: [5, 5]),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        "${value.toInt()}",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.grayColor5,
                        ),
                      ),
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < data.length) {
                          return Text(
                            data[index]["date"],
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.primaryColor,
                            ),
                          );
                        }
                        return Text("");
                      },
                      interval: 1,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: AppColors.primaryColor,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    spots: getSpots("BUN"),
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 2,
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.lightBlue,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    spots: getSpots("GFR"),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 2,
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.lightGreen,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    spots: getSpots("eGFR"),
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 2,
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 📌 Hiển thị chú thích (Legend)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LegendItem(color: Colors.red, text: "BUN (mmol/L)"),
              SizedBox(width: 10),
              LegendItem(color: Colors.blue, text: "GFR (mmol/L)"),
              SizedBox(width: 10),
              LegendItem(color: Colors.green, text: "eGFR (mL/phút/1.72m2)"),
            ],
          ),
        ),
      ],
    );
  }
}

// 📌 Widget nhỏ để hiển thị chú thích (Legend)
class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 5),
        Text(text, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
