import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sep490/theme/color.dart';

class LineChartBloodPressureWidget extends StatelessWidget {
  final Map<String, List<double>> data;
  final Color lineColor1;
  final Color lineColor2;
  final String unit;

  const LineChartBloodPressureWidget({
    Key? key,
    required this.data,
    required this.unit,
    this.lineColor1 = Colors.blue,
    this.lineColor2 = Colors.red,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> spots1 = [];
    final List<FlSpot> spots2 = [];
    int index = 0;
    double maxY = double.negativeInfinity;
    double minY = double.infinity;

    data.forEach((key, values) {
      if (values.isNotEmpty) {
        spots1.add(FlSpot(index.toDouble(), values[0]));
        spots2.add(FlSpot(
            index.toDouble(), values.length > 1 ? values[1] : values[0]));

        maxY = values.reduce((a, b) => a > b ? a : b) > maxY
            ? values.reduce((a, b) => a > b ? a : b)
            : maxY;
        minY = values.reduce((a, b) => a < b ? a : b) < minY
            ? values.reduce((a, b) => a < b ? a : b)
            : minY;
      }
      index++;
    });

    if (minY == double.infinity) minY = 0;
    if (maxY == double.negativeInfinity) maxY = 0;

    double buffer = (maxY - minY) * 0.3;
    minY = (minY - buffer).clamp(0, double.infinity);
    maxY = maxY + buffer;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: LineChart(
            LineChartData(
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
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: (maxY - minY) / 5,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      );
                    },
                  ),
                ),
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
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: data.length.toDouble() - 1,
              minY: minY,
              maxY: maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: spots1,
                  isCurved: true,
                  color: lineColor1,
                  barWidth: 2.5,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        lineColor1.withOpacity(0.3),
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
                        color: lineColor1,
                        strokeWidth: 3,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                ),
                LineChartBarData(
                  spots: spots2,
                  isCurved: true,
                  color: lineColor2,
                  barWidth: 2.5,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        lineColor2.withOpacity(0.3),
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
                        color: lineColor2,
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
                        '${touchedSpot.y}',
                        const TextStyle(
                          color: AppColors.bgColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend(lineColor1, "Tâm thu"),
              const SizedBox(width: 15),
              _buildLegend(lineColor2, "Tâm trương"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
