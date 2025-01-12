import 'package:flutter/material.dart';

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
