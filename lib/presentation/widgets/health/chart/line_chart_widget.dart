import 'package:flutter/material.dart';
import 'package:mrx_charts/mrx_charts.dart';
import 'package:sep490/theme/color.dart';

class LineChartWidget extends StatelessWidget {
  final List<String> xValues; // Days of the week
  final List<double> yValues; // Heart rate data

  const LineChartWidget({
    Key? key,
    required this.xValues,
    required this.yValues,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure that xValues and yValues are of the same length
    if (xValues.length != yValues.length) {
      return Center(
          child: Text("Error: Data arrays must have the same length"));
    }

    return Chart(
      layers: [
        ChartAxisLayer(
          settings: ChartAxisSettings(
            x: ChartAxisSettingsAxis(
              frequency: 1.0,
              max: (xValues.length - 1).toDouble(),
              min: 0.0,
              textStyle: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: 10.0,
              ),
            ),
            y: ChartAxisSettingsAxis(
              frequency: 20.0,
              max: 160.0, // Maximum heart rate value
              min: 40.0, // Minimum heart rate value
              textStyle: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: 10.0,
              ),
            ),
          ),
          labelX: (value) => xValues[value.toInt()], // Use xValues for days
          labelY: (value) => '${value.toInt()} BPM',
        ),
        ChartLineLayer(
          items: List.generate(
            xValues.length, // Generate based on xValues length
            (index) => ChartLineDataItem(
              x: index.toDouble(),
              value: yValues[index],
            ),
          ),
          settings: const ChartLineSettings(
            color: AppColors.primaryColor,
            thickness: 2.0,
          ),
        ),
      ],
    );
  }
}
