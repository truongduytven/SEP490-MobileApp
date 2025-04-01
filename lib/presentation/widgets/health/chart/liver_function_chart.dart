import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class LiverFunctionChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  LiverFunctionChart({required this.data});

  List<FlSpot> getSpots(String key) {
    return data
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value[key].toDouble()))
        .toList();
  }

  // double getMinY() {
  //   double minValue = data
  //       .expand((element) =>
  //           [element["ALT"], element["AST"], element["ALP"], element["GGT"]])
  //       .reduce((a, b) => a < b ? a : b)
  //       .toDouble();
  //   return minValue - 10;
  // }

  // double getMaxY() {
  //   double maxValue = data
  //       .expand((element) =>
  //           [element["ALT"], element["AST"], element["ALP"], element["GGT"]])
  //       .reduce((a, b) => a > b ? a : b)
  //       .toDouble();
  //   return maxValue + 10;
  // }
  double getMinY() {
    if (data.isEmpty) return 0; // Default value when no data

    final values = data
        .expand((element) => [
              element["ALT"],
              element["AST"],
              element["ALP"],
              element["GGT"],
            ].where((v) => v != null)) // Filter out null values
        .toList();

    if (values.isEmpty) return 0; // Default value when all values are null

    final minValue = values.reduce((a, b) => a < b ? a : b);
    return (minValue as num).toDouble() - 10; // Ensure numeric conversion
  }

  double getMaxY() {
    if (data.isEmpty) return 100; // Default value when no data

    final values = data
        .expand((element) => [
              element["ALT"],
              element["AST"],
              element["ALP"],
              element["GGT"],
            ].where((v) => v != null)) // Filter out null values
        .toList();

    if (values.isEmpty) return 100; // Default value when all values are null

    final maxValue = values.reduce((a, b) => a > b ? a : b);
    return (maxValue as num).toDouble() + 10; // Ensure numeric conversion
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10),
        Container(
          height: 320,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LineChart(
              LineChartData(
                minY: getMinY(),
                maxY: getMaxY(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 5,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.2),
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        "${value.toInt()}",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.grayColor5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < data.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              data[index]["date"],
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return Text("");
                      },
                      interval: 1,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                lineBarsData: [
                  createLineChartBarData(getSpots("ALT"), Colors.red),
                  createLineChartBarData(getSpots("AST"), Colors.blue),
                  createLineChartBarData(getSpots("ALP"), Colors.green),
                  createLineChartBarData(getSpots("GGT"), Colors.orange),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Wrap(
            spacing: 12,
            children: [
              LegendItem(color: Colors.red, text: "ALT(UI/L)"),
              LegendItem(color: Colors.blue, text: "AST(UI/L)"),
              LegendItem(color: Colors.green, text: "ALP(UI/L)"),
              LegendItem(color: Colors.orange, text: "GGT(UI/L)"),
            ],
          ),
        ),
      ],
    );
  }

  LineChartBarData createLineChartBarData(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,
      belowBarData: BarAreaData(
        show: true,
        color: color.withOpacity(0.1),
      ),
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 4,
          color: color,
          strokeWidth: 2,
          strokeColor: Colors.white,
        ),
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
