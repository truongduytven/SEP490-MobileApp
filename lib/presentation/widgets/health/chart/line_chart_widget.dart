import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sep490/theme/color.dart';

class LineChartWidget extends StatelessWidget {
  final Map<String, double?> data;
  final Color lineColor;
  final String unit;
  const LineChartWidget({
    Key? key,
    required this.data,
    required this.unit,
    this.lineColor = AppColors.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> spots = [];
    int index = 0;
    double maxY = double.negativeInfinity;
    double minY = double.infinity;

    data.forEach((key, value) {
      if (value != null) {
        spots.add(FlSpot(index.toDouble(), value));
        if (value > maxY) maxY = value;
        if (value < minY) minY = value;
      }
      index++;
    });

    if (minY == double.infinity) minY = 0;
    if (maxY == double.negativeInfinity) maxY = 0;

    double buffer = (maxY - minY) * 0.1;
    minY = (minY - buffer).clamp(0, double.infinity);
    maxY = maxY + buffer;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: LineChart(LineChartData(
          backgroundColor: Colors.transparent,
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.shade300,
              strokeWidth: 1,
              dashArray: [5, 5],
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final keys = data.keys.toList();
                  if (value >= 0 && value < keys.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        keys[value.toInt()],
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    );
                  }
                  return Text("");
                },
              ),
            ),
            // leftTitles: AxisTitles(
            //   // axisNameWidget: Padding(
            //   //   padding: const EdgeInsets.only(
            //   //       right: 0.0), // Đẩy đơn vị ra ngoài một chút
            //   //   child: Text(
            //   //     unit,
            //   //     style: const TextStyle(
            //   //       fontSize: 16,
            //   //       fontWeight: FontWeight.bold,
            //   //       color: Colors.black87,
            //   //     ),
            //   //   ),
            //   // ),
            //   // axisNameSize: 24,
            //   sideTitles: SideTitles(
            //     showTitles: true,
            //     reservedSize: 40,
            //     interval: (maxY - minY) / 10,
            //     getTitlesWidget: (value, meta) {
            //       return Text(
            //         value.toInt().toString(),
            //         style: TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.w500,
            //           color: Colors.black54,
            //         ),
            //       );
            //     },
            //   ),
            // ),

            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 70,
                interval: (maxY - minY) / 5 > 1
                    ? (maxY - minY) / 5
                    : 1, // Tính toán khoảng cách giữa các mốc
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(
                        1), // Hiển thị số dạng thập phân nếu cần
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: data.length.toDouble() - 1,
          minY: minY,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: lineColor,
              barWidth: 2.5,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    lineColor.withOpacity(0.3),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 5,
                    color: lineColor,
                    strokeWidth: 3,
                    strokeColor: Colors.white,
                  );
                },
              ),
            ),
          ],
          lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (LineBarSpot spot) => Colors.redAccent,
            tooltipRoundedRadius: 8,
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((touchedSpot) {
                return LineTooltipItem(
                  '${touchedSpot.y} $unit',
                  const TextStyle(
                    color: AppColors.bgColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          )))),
    );
  }
}
