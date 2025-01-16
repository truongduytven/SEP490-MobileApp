import 'package:flutter/material.dart';
import 'package:mrx_charts/mrx_charts.dart';
import 'package:sep490/theme/color.dart';

class GroupBarChartWidget extends StatelessWidget {
  final Map<String, List<double>> data; // Data for grouped bars

  const GroupBarChartWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final xValues = data.keys
        .toList(); // X-axis categories (e.g., 'Monday', 'Tuesday', ...)
    final barData =
        data.values.toList(); // Grouped bar values for each category

    if (xValues.isEmpty || barData.isEmpty) {
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
                color: AppColors.secondaryColor,
                fontSize: 14.0,
              ),
            ),
            y: ChartAxisSettingsAxis(
              frequency: 10.0,
              max: barData.expand((e) => e).reduce((a, b) => a > b ? a : b) +
                  10.0, // Set max slightly higher
              min: barData.expand((e) => e).reduce((a, b) => a < b ? a : b) -
                  10.0,
              textStyle: const TextStyle(
                color: AppColors.grayColor5,
                fontSize: 12.0,
              ),
            ),
          ),
          labelX: (value) => xValues[value.toInt()], // Labels for categories
          labelY: (value) => '${value.toInt()} units', // Labels for the values
        ),
        // Grouped Bar Layer
        ChartBarLayer(
          items: List.generate(
            xValues.length,
            (index) {
              final group =
                  barData[index]; // Group data (multiple bars per category)
              return [
                for (int i = 0; i < group.length; i++)
                  ChartBarDataItem(
                    x: index.toDouble() +
                        0.2 * i, // Slightly offset bars within the group
                    value: group[i],
                    color: i.isEven
                        ? AppColors.primaryColor
                        : AppColors.secondaryColor, // Alternate bar colors
                  ),
              ];
            },
          )
              .expand((element) => element)
              .toList(), // Flatten list of bars per category
          settings: const ChartBarSettings(
            thickness: 8.0,
            radius: BorderRadius.all(Radius.circular(4.0)),
          ),
        ),
      ],
    );
  }
}
