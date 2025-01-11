import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:sep490/theme/color.dart';

class Rules extends StatefulWidget {
  Rules({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _RulesState createState() => _RulesState();
}

class _RulesState extends State<Rules> {
  RulerPickerController? _rulerPickerController;

  num currentValue = 40;

  List<RulerRange> ranges = const [
    RulerRange(begin: 0, end: 10, scale: 0.1),
    RulerRange(begin: 10, end: 100, scale: 1),
    RulerRange(begin: 100, end: 1000, scale: 10),
    RulerRange(begin: 1000, end: 10000, scale: 100),
    RulerRange(begin: 10000, end: 100000, scale: 1000)
  ];

  @override
  void initState() {
    super.initState();
    _rulerPickerController = RulerPickerController(value: currentValue);
  }

  Widget _buildPositionBtn(num value) {
    return InkWell(
      onTap: () {
        _rulerPickerController?.value = value;
      },
      child: Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          color: Colors.blue,
          child: Text(
            value.toString(),
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  Widget _buildChangeRangerBtn(String tip, List<RulerRange> rangeList) {
    return InkWell(
      onTap: () {
        setState(() {
          ranges = rangeList;
        });
      },
      child: Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          color: AppColors.primaryColor,
          child: Text(
            tip,
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              currentValue.toStringAsFixed(1),
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 80),
            ),
            const SizedBox(height: 50),
            RulerPicker(
              controller: _rulerPickerController!,
              onBuildRulerScaleText: (index, value) {
                return value.toInt().toString();
              },
              ranges: ranges,
              scaleLineStyleList: const [
                ScaleLineStyle(
                    color: Colors.grey, width: 1.5, height: 30, scale: 0),
                ScaleLineStyle(
                    color: Colors.grey, width: 1, height: 25, scale: 5),
                ScaleLineStyle(
                    color: Colors.grey, width: 1, height: 15, scale: -1)
              ],
              onValueChanged: (value) {
                setState(() {
                  currentValue = value;
                });
              },
              width: MediaQuery.of(context).size.width,
              height: 80,
              rulerMarginTop: 8,
              rulerBackgroundColor: Colors.transparent,
              // marker: Container(
              //     width: 8,
              //     height: 50,
              //     decoration: BoxDecoration(
              //         color: Colors.red.withAlpha(100),
              //         borderRadius: BorderRadius.circular(5))),

              marker: CustomPaint(
                size: Size(10, 20),
                painter: NeedlePainter(),
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPositionBtn(8.4),
                SizedBox(width: 10),
                _buildPositionBtn(30),
                SizedBox(width: 10),
                _buildPositionBtn(50.5),
                SizedBox(width: 10),
                _buildPositionBtn(1000),
                SizedBox(width: 10),
                _buildPositionBtn(40000),
                SizedBox(width: 10),
                _buildPositionBtn(50000),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildChangeRangerBtn("[20,100,1],[100,200,0.1]", [
                  RulerRange(begin: 20, end: 100, scale: 1),
                  RulerRange(begin: 100, end: 200, scale: 0.1)
                ]),
                SizedBox(width: 10),
                _buildChangeRangerBtn(
                    "[100,500]", [RulerRange(begin: 100, end: 500)]),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class NeedlePainter extends CustomPainter {
  final double lineHeightInCm = 0.6; // Line height in cm

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.pink // Pink color for the needle
      ..style = PaintingStyle.fill;

    // Convert line height from cm to pixels (1 cm = 37.795px approx)
    double lineHeightInPixels = lineHeightInCm * 37.795;

    // Save the canvas state to restore later after rotation
    canvas.save();

    // Translate the canvas to the center of the canvas (for rotation)
    canvas.translate(size.width / 2, size.height / 2);

    // Rotate the canvas 180 degrees (in radians)
    canvas.rotate(3.14159); // 3.14159 radians = 180 degrees

    // Now the path will be drawn with the rotation applied
    final Path path = Path()
      ..moveTo(0,
          -size.height / 2) // Start at the center top (adjusted for rotation)
      ..lineTo(-10, size.height / 2) // Left side of the needle
      ..lineTo(10, size.height / 2) // Right side of the needle
      ..close();

    // Draw the rotated needle
    canvas.drawPath(path, paint);

    // Draw a line 2 cm below the top of the triangle
    final Paint linePaint = Paint()
      ..color = Colors.pink // Color for the line
      ..strokeWidth = 2; // Line thickness

    // Draw the line
    canvas.drawLine(
      Offset(
          0,
          -size.height / 2 -
              lineHeightInPixels), // Start just below the triangle tip
      Offset(0,
          -size.height / 6 - lineHeightInPixels + 20), // Extend the line down
      linePaint,
    );

    // Restore the canvas state to undo the rotation
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
