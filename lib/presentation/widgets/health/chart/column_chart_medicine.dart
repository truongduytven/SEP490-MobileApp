import 'package:flutter/material.dart';
import 'package:mrx_charts/mrx_charts.dart';
import 'package:sep490/theme/color.dart';

class ColumnChartMedicine extends StatelessWidget {
  final Map<String, double?> data; // The data map with null values allowed

  const ColumnChartMedicine({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chart(
      layers: [
        ChartAxisLayer(
          settings: ChartAxisSettings(
            x: ChartAxisSettingsAxis(
              frequency: 1.0,
              max: (data.length - 1)
                  .toDouble(), // Set max to the length of the data
              min: 0.0,
              textStyle: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500),
            ),
            y: ChartAxisSettingsAxis(
              frequency: 25,
              max: 100,
              min: 0,
              textStyle: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: 12.0,
              ),
            ),
          ),
          labelX: (value) {
            // Get the corresponding key from the data map for the x-axis label
            String key = data.keys.elementAt(value.toInt());
            return key;
          },
          labelY: (value) => '${value.toInt().toString()} %',
        ),
        ChartBarLayer(
          items: List.generate(
            data.length, // Ensure we generate items based on the data length
            (index) {
              String key = data.keys.elementAt(index);
              double? value = data[key];

              return value != null
                  ? ChartBarDataItem(
                      color: Colors.pinkAccent,
                      value: value,
                      x: index.toDouble(), // Align x with the index
                    )
                  : ChartBarDataItem(
                      color: Colors.transparent, // Hide bar for null values
                      value: 0.0, // Set value to 0 for null values
                      x: index.toDouble(),
                    );
            },
          ),
          settings: const ChartBarSettings(
            thickness: 14.0,
            radius: BorderRadius.all(Radius.circular(14.0)),
          ),
        ),
      ],
    );
  }
}
