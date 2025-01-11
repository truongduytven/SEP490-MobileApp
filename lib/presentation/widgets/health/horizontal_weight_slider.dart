import 'package:flutter/material.dart';

class HorizontalWeightSlider extends StatefulWidget {
  final double minWeight;
  final double maxWeight;
  final double initialWeight;
  final Function(double) onWeightChanged;

  const HorizontalWeightSlider({
    Key? key,
    required this.minWeight,
    required this.maxWeight,
    this.initialWeight = 60.0,
    required this.onWeightChanged,
  }) : super(key: key);

  @override
  State<HorizontalWeightSlider> createState() => _HorizontalWeightSliderState();
}

class _HorizontalWeightSliderState extends State<HorizontalWeightSlider> {
  late double _currentWeight;

  @override
  void initState() {
    super.initState();
    _currentWeight = widget.initialWeight;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Display the current weight
        Text(
          "${_currentWeight.toStringAsFixed(1)} kg",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        // Slider for weight
        Slider(
          value: _currentWeight,
          min: widget.minWeight,
          max: widget.maxWeight,
          divisions: (widget.maxWeight - widget.minWeight).toInt(),
          label: "${_currentWeight.toStringAsFixed(1)} kg",
          onChanged: (value) {
            setState(() {
              _currentWeight = value;
            });
            widget.onWeightChanged(value);
          },
          activeColor: Colors.blue,
          inactiveColor: Colors.blue.shade100,
        ),
        const SizedBox(height: 10),
        // Display the weight range
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${widget.minWeight.toStringAsFixed(1)} kg",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "${widget.maxWeight.toStringAsFixed(1)} kg",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
}
