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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Legend

        // Chart
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          height: 300,
          child: Chart(
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
                    frequency: 10.0,
                    max: barData
                            .expand((e) => e)
                            .reduce((a, b) => a > b ? a : b) +
                        10.0,
                    min: barData
                            .expand((e) => e)
                            .reduce((a, b) => a < b ? a : b) -
                        10.0,
                    textStyle: const TextStyle(
                      color: AppColors.grayColor5,
                      fontSize: 12.0,
                    ),
                  ),
                ),
                labelX: (value) => xValues[value.toInt()],
                labelY: (value) => '${value.toInt()} BPM',
              ),
              // Grouped Bar Layer
              ChartBarLayer(
                items: List.generate(
                  xValues.length,
                  (index) {
                    final group = barData[index];
                    return [
                      for (int i = 0; i < group.length; i++)
                        ChartBarDataItem(
                          x: index.toDouble() + (i * 0.2),
                          value: group[i],
                          color: i.isEven
                              ? const Color.fromARGB(255, 80, 218, 87)
                              : const Color.fromARGB(255, 81, 86, 194),
                        ),
                    ];
                  },
                ).expand((element) => element).toList(),
                settings: const ChartBarSettings(
                  thickness: 8.0,
                  radius: BorderRadius.all(Radius.circular(4.0)),
                ),
              ),
            ],
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(Color.fromARGB(255, 80, 218, 87), "Tâm thu"),
            const SizedBox(width: 16),
            _buildLegendItem(Color.fromARGB(255, 81, 86, 194), "Tâm trương"),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  /// Helper method to create a legend item
  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
