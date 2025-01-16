import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mrx_charts/mrx_charts.dart';
import 'package:sep490/theme/color.dart';

class ColumnChartMedicine extends StatelessWidget {
  const ColumnChartMedicine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chart(
      layers: [
        ChartAxisLayer(
          settings: ChartAxisSettings(
            x: ChartAxisSettingsAxis(
              frequency: 1.0,
              max: 13.0,
              min: 7.0,
              textStyle: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: 10.0,
              ),
            ),
            y: ChartAxisSettingsAxis(
              frequency: 100.0,
              max: 300.0,
              min: 0.0,
              textStyle: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: 10.0,
              ),
            ),
          ),
          labelX: (value) => value.toInt().toString(),
          labelY: (value) => value.toInt().toString(),
        ),
        ChartBarLayer(
          items: List.generate(
            13 - 7 + 1,
            (index) => ChartBarDataItem(
              color: AppColors.primaryColor,
              value:
                  Random().nextInt(280) + 20, // Random value between 20 and 300
              x: index.toDouble() + 7, // X position for each bar
            ),
          ),
          settings: const ChartBarSettings(
            thickness: 8.0,
            radius: BorderRadius.all(Radius.circular(4.0)),
          ),
        ),
      ],
    );
  }
}
