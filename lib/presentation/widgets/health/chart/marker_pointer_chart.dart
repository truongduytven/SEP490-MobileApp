import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:sep490/theme/color.dart';

class MarkerPointerChart extends StatelessWidget {
  final double value; // Current value to display
  final String result;

  const MarkerPointerChart({
    Key? key,
    required this.value,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedRadialGauge(
        /// The animation duration.
        duration: const Duration(seconds: 1),
        curve: Curves.linear,

        /// Define the radius.
        radius: 150,

        /// Gauge value.
        value: value,

        /// Optionally, you can configure your gauge, providing additional
        /// styles and transformers.
        axis: GaugeAxis(
          /// Provide the [min] and [max] value for the [value] argument.
          min: 0,
          max: 50,

          /// Render the gauge as a 180-degree arc.
          degrees: 180,

          /// Set the background color and axis thickness.
          style: const GaugeAxisStyle(
            thickness: 50,
            background: Color(0xFFE0E0E0), // Neutral background color
            segmentSpacing: 0, // Ensure no gaps for smooth gradient
          ),

          /// Define the pointer that will indicate the progress (optional).
          pointer: GaugePointer.needle(
            position: GaugePointerPosition.surface(offset: Offset(0, 20)),
            width: 20,
            height: 70,
            color: AppColors.primaryColor,
          ),

          /// Define the progress bar (with a smooth gradient transition).
          progressBar: GaugeProgressBar.rounded(
            color: Colors.transparent,
            gradient: GaugeAxisGradient(
              colors: const [
                Colors.blue, // Blue (low range)
                Colors.green, // Green (low to mid range)
                Colors.yellow, // Yellow (middle range)
                Colors.orange, // Orange (high range)
                Colors.red, // Red (high range)
              ],
              colorStops: const [
                0.0,
                0.2,
                0.4,
                0.6,
                1.0
              ], // Define transition stops
            ),
          ),

          /// Define axis segments (optional, used for visual distinction if needed).
          segments: const [
            GaugeSegment(from: 0, to: 10, color: Colors.blue),
            GaugeSegment(from: 10, to: 20, color: Colors.transparent),
            GaugeSegment(from: 20, to: 30, color: Colors.transparent),
            GaugeSegment(from: 30, to: 40, color: Colors.transparent),
            GaugeSegment(from: 40, to: 50, color: Colors.transparent),
          ],
        ),

        /// Define the child builder to display value label or other widgets (optional).
        builder: (context, child, gaugeValue) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                gaugeValue.toStringAsFixed(1),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                result,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
