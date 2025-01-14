import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sep490/presentation/widgets/health/height/height_slider.dart';
import 'package:sep490/presentation/widgets/health/height/height_styles.dart';
import 'dart:math' as math;
import 'package:sep490/presentation/widgets/health/height/widget_utils.dart';

class HeightPicker extends StatefulWidget {
  final double maxHeight; // Change to double
  final double minHeight; // Change to double
  final double height; // Change to double
  final double widgetHeight;
  final ValueChanged<double> onChange; // Change to double

  const HeightPicker({
    Key? key,
    required this.height,
    required this.widgetHeight,
    required this.onChange,
    this.maxHeight = 190.0,
    this.minHeight = 145.0,
  }) : super(key: key);

  double get totalUnits => maxHeight - minHeight;

  @override
  _HeightPickerState createState() => _HeightPickerState();
}

class _HeightPickerState extends State<HeightPicker> {
  late double startDragYOffset;
  late double startDragHeight;

  double get _pixelsPerUnit => _drawingHeight / widget.totalUnits;

  double get _sliderPosition {
    double halfOfBottomLabel = labelsFontSize / 2;
    double unitsFromBottom = widget.height - widget.minHeight;
    return halfOfBottomLabel + unitsFromBottom * _pixelsPerUnit;
  }

  double get _drawingHeight {
    double totalHeight = widget.widgetHeight;
    double marginBottom = marginBottomAdapted(context);
    double marginTop = marginTopAdapted(context);
    return totalHeight - (marginBottom + marginTop + labelsFontSize);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: _onTapDown,
      onVerticalDragStart: _onDragStart,
      onVerticalDragUpdate: _onDragUpdate,
      child: Stack(
        children: <Widget>[
          _drawPersonImage(),
          _drawSlider(),
          _drawLabels(),
        ],
      ),
    );
  }

  void _onTapDown(TapDownDetails tapDownDetails) {
    double height = _globalOffsetToHeight(tapDownDetails.globalPosition);
    widget.onChange(_normalizeHeight(height));
  }

  double _normalizeHeight(double height) {
    return math.max(widget.minHeight, math.min(widget.maxHeight, height));
  }

  double _globalOffsetToHeight(Offset globalOffset) {
    RenderBox getBox = context.findRenderObject() as RenderBox;
    Offset localPosition = getBox.globalToLocal(globalOffset);
    double dy = localPosition.dy;
    dy = dy - marginTopAdapted(context) - labelsFontSize / 2;
    double height = widget.maxHeight - (dy / _pixelsPerUnit);
    return height;
  }

  void _onDragStart(DragStartDetails dragStartDetails) {
    double newHeight = _globalOffsetToHeight(dragStartDetails.globalPosition);
    widget.onChange(newHeight);
    setState(() {
      startDragYOffset = dragStartDetails.globalPosition.dy;
      startDragHeight = newHeight;
    });
  }

  void _onDragUpdate(DragUpdateDetails dragUpdateDetails) {
    double currentYOffset = dragUpdateDetails.globalPosition.dy;
    double verticalDifference = startDragYOffset - currentYOffset;
    double diffHeight = verticalDifference / _pixelsPerUnit;
    double height = _normalizeHeight(startDragHeight + diffHeight);
    setState(() => widget.onChange(height));
  }

  Widget _drawSlider() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: _sliderPosition,
      child: HeightSlider(
        height: widget.height,
      ),
    );
  }

  Widget _drawLabels() {
    int labelsToDisplay = (widget.totalUnits ~/ 5) + 1;
    List<Widget> labels = List.generate(
      labelsToDisplay,
      (idx) {
        return Text(
          "${(widget.maxHeight - 5 * idx).toStringAsFixed(1)}", // Show decimals
          style: labelsTextStyle,
        );
      },
    );

    return Align(
      alignment: Alignment.centerRight,
      child: IgnorePointer(
        child: Padding(
          padding: EdgeInsets.only(
            right: screenAwareSize(12.0, context),
            bottom: marginBottomAdapted(context),
            top: marginTopAdapted(context),
          ),
          child: Column(
            children: labels,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
      ),
    );
  }

  // Widget _drawPersonImage() {
  //   double personImageHeight = _sliderPosition + marginBottomAdapted(context);
  //   return Align(
  //     alignment: Alignment.bottomCenter,
  //     child: SvgPicture.asset(
  //       "assets/icons/person.svg",
  //       height: personImageHeight,
  //       width: personImageHeight / 3,
  //     ),
  //   );
  // }
  Widget _drawPersonImage() {
    double personImageHeight = _sliderPosition + marginBottomAdapted(context);
    // Ensure the height is always positive and meets a minimum threshold
    personImageHeight = personImageHeight > 0
        ? personImageHeight
        : 100.0; // Set a minimum height

    return Align(
      alignment: Alignment.bottomCenter,
      child: SvgPicture.asset(
        "assets/icons/person.svg",
        height: personImageHeight,
        width: personImageHeight / 3,
      ),
    );
  }
}
