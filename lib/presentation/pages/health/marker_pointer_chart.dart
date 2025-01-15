import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:sep490/theme/color.dart';

class MarkerPointerChart extends StatelessWidget {
  final double value; // Current value to display

  const MarkerPointerChart({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marker Pointer Chart'),
      ),
      body: Center(
        child: AnimatedRadialGauge(
          /// The animation duration.
          duration: const Duration(seconds: 1),
          curve: Curves.linear,

          /// Define the radius.
          /// If you omit this value, the parent size will be used, if possible.
          radius: 100,

          /// Gauge value.
          value: value,

          /// Optionally, you can configure your gauge, providing additional
          /// styles and transformers.
          axis: GaugeAxis(
            /// Provide the [min] and [max] value for the [value] argument.
            min: 0,
            max: 100,

            /// Render the gauge as a 180-degree arc.
            degrees: 180,

            /// Set the background color and axis thickness.
            style: const GaugeAxisStyle(
              thickness: 20,
              background: Color(0xFFE0E0E0), // Neutral background color
              segmentSpacing: 0, // Ensure no gaps for smooth gradient
            ),

            /// Define the pointer that will indicate the progress (optional).
            pointer: GaugePointer.needle(
              width: 10,
              height: 50,
              color: AppColors.primaryColor,
            ),

            /// Define the progress bar (with a smooth gradient transition).
            progressBar: GaugeProgressBar.rounded(
              color: Colors.transparent,
              gradient: GaugeAxisGradient(
                colors: [
                  AppColors.errorColor, // Red (low range)
                  Colors.orange, // Orange (middle range)
                  Colors.green, // Green (high range)
                ],
                colorStops: [0.0, 0.5, 1.0], // Define transition stops
              ),
            ),

            /// Define axis segments (optional, used for visual distinction if needed).
            segments: const [
              GaugeSegment(
                from: 0,
                to: 33.3,
                color: Colors.transparent, // Gradient handles the color
              ),
              GaugeSegment(
                from: 33.3,
                to: 66.6,
                color: Colors.transparent,
              ),
              GaugeSegment(
                from: 66.6,
                to: 100,
                color: Colors.transparent,
              ),
            ],
          ),

          /// Define the child builder to display value label or other widgets (optional).
          builder: (context, child, gaugeValue) => Center(
            child: Text(
              '${gaugeValue.toStringAsFixed(1)}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
