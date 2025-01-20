import 'package:flutter/material.dart';
import 'package:mrx_charts/mrx_charts.dart';
import 'package:sep490/theme/color.dart';

class LineChartWidget extends StatelessWidget {
  final Map<String, double?> data; // Accepts a map of day-value pairs

  const LineChartWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final xValues = data.keys.toList(); // Days of the week
    final yValues = data.values.toList(); // Heart rate data (nullable)
    final minY = yValues.whereType<double>().reduce((a, b) => a < b ? a : b);
    final maxY = yValues.whereType<double>().reduce((a, b) => a > b ? a : b);
    if (xValues.isEmpty || yValues.isEmpty) {
      return Center(
        child: Text(
          "No data available",
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    return Chart(
      layers: [
        // X and Y axes
        ChartAxisLayer(
          settings: ChartAxisSettings(
            x: ChartAxisSettingsAxis(
              frequency: 1.0,
              max: (xValues.length - 1).toDouble(),
              min: 0.0,
              textStyle: const TextStyle(
                color: AppColors.primaryColor,
                fontSize: 14.0,
              ),
            ),
            y: ChartAxisSettingsAxis(
              frequency: 2.0,
              max: maxY + 5.0, // Set max slightly higher than the actual max
              min: minY - 5.0,
              textStyle: const TextStyle(
                color: AppColors.grayColor5,
                fontSize: 12.0,
              ),
            ),
          ),
          labelX: (value) => xValues[value.toInt()], // Labels for days
          labelY: (value) => '${value.toInt()} kg', // Labels for heart rate
        ),
        // Line layer with skipped null values
        ChartLineLayer(
          items: List.generate(
            xValues.length,
            (index) {
              // Skip null values to avoid breaking the line
              if (yValues[index] == null) {
                return null;
              }
              return ChartLineDataItem(
                x: index.toDouble(),
                value: yValues[index]!,
              );
            },
          ).whereType<ChartLineDataItem>().toList(), // Filter out null items
          settings: const ChartLineSettings(
            color: AppColors.primaryColor,
            thickness: 2.0,
          ),
        ),
      ],
    );
  }
}
