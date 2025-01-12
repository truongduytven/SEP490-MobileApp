import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:intl/intl.dart';
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
    RulerRange(
        begin: 1, end: 50, scale: 0.1), // From 1 to 50 with a scale of 0.1
    RulerRange(
        begin: 50, end: 100, scale: 0.1), // From 50 to 100 with a scale of 0.1
    RulerRange(
        begin: 100,
        end: 200,
        scale: 0.1), // From 100 to 200 with a scale of 0.1
  ];

  @override
  void initState() {
    super.initState();
    _rulerPickerController = RulerPickerController(value: currentValue);
  }

  // Button to change the value
  Widget _buildPositionBtn(num value) {
    return InkWell(
      onTap: () {
        _rulerPickerController?.value = value;
        setState(() {
          currentValue = value;
        });
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

  // Button to increment the value
  void _incrementValue() {
    setState(() {
      currentValue = currentValue + 1;
      _rulerPickerController?.value = currentValue;
    });
  }

  // Button to decrement the value
  void _decrementValue() {
    setState(() {
      currentValue = currentValue - 1;
      _rulerPickerController?.value = currentValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDateTime = DateFormat('MM-dd-yyyy').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              // Center the row horizontally in the screen
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.borderColor, // Gray border color
                    width: 1.5, // Border width
                  ),
                  color: AppColors.bgColor, // Badge color
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hôm nay, $formattedDateTime",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Minus Button
                GestureDetector(
                  onTap: _decrementValue,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.remove, size: 40, color: Colors.white),
                  ),
                ),

                Text(
                  currentValue.toStringAsFixed(1),
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 80),
                ),

                // Plus Button
                GestureDetector(
                  onTap: _incrementValue,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.add, size: 40, color: Colors.white),
                  ),
                ),
              ],
            ),
            Text(
              "kg",
              style: const TextStyle(color: AppColors.grayColor5, fontSize: 40),
            ),
            const SizedBox(height: 50),
            // RulerPicker widget
            RulerPicker(
              controller: _rulerPickerController!,
              onBuildRulerScaleText: (index, value) {
                return value.toInt().toString();
              },
              ranges: ranges,
              scaleLineStyleList: const [
                ScaleLineStyle(
                    color: AppColors.secondaryColor,
                    width: 1.5,
                    height: 80,
                    scale: 0), // Further increased height
                ScaleLineStyle(
                    color: AppColors.secondaryColor,
                    width: 1,
                    height: 60,
                    scale: 5), // Further increased height
                ScaleLineStyle(
                    color: AppColors.secondaryColor,
                    width: 1,
                    height: 45,
                    scale: -1)
              ],
              onValueChanged: (value) {
                setState(() {
                  currentValue = value;
                });
              },
              width: MediaQuery.of(context).size.width,
              height: 150,
              rulerMarginTop: 8,
              rulerBackgroundColor: Colors.transparent,
              marker: CustomPaint(
                size: Size(10, 20),
                painter: NeedlePainter(),
              ),
            ),
            SizedBox(height: 40),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     _buildPositionBtn(8.4),
            //     SizedBox(width: 10),
            //     _buildPositionBtn(30),
            //     SizedBox(width: 10),
            //     _buildPositionBtn(50.5),
            //     SizedBox(width: 10),
            //     _buildPositionBtn(100),
            //     SizedBox(width: 10),
            //     _buildPositionBtn(200),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

class NeedlePainter extends CustomPainter {
  final double triangleHeight = 30; // Height of the triangle
  final double triangleBase = 20; // Base of the triangle
  final double lineHeightInCm = 2.5; // Line height in cm

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.pink // Pink color for the triangle
      ..style = PaintingStyle.fill;

    // Convert line height from cm to pixels (1 cm = 37.795px approx)
    double lineHeightInPixels = lineHeightInCm * 37.795; // 0.6 cm to pixels

    // Save the canvas state to restore later after rotation
    canvas.save();

    // Translate the canvas to the center of the canvas (for rotation)
    canvas.translate(size.width / 2, size.height / 2);

    // Now the path will be drawn with the triangle pointing up
    final Path path = Path()
      ..moveTo(0, -triangleHeight / 2) // Start at the top (pointing up)
      ..lineTo(
          -triangleBase / 2, triangleHeight / 2) // Left side of the triangle
      ..lineTo(
          triangleBase / 2, triangleHeight / 2) // Right side of the triangle
      ..close();

    // Draw the triangle (no rotation is needed, just point up)
    canvas.drawPath(path, paint);

    // Draw a line starting from the bottom edge of the triangle
    final Paint linePaint = Paint()
      ..color = Colors.pink // Color for the line
      ..strokeWidth = 2; // Line thickness

    // The bottom edge of the triangle is at triangleHeight / 2
    // So the line should start from (0, triangleHeight / 2) and extend downward
    canvas.drawLine(
      Offset(
          0, triangleHeight / 2), // Start from the bottom edge of the triangle
      Offset(0,
          triangleHeight / 2 + lineHeightInPixels), // Extend the line downward
      linePaint,
    );

    // Restore the canvas state
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
