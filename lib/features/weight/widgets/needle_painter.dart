import 'package:flutter/material.dart';

class NeedlePainter extends CustomPainter {
  final double triangleHeight = 30;
  final double triangleBase = 20;
  final double lineHeightInCm = 2.5;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.pink
      ..style = PaintingStyle.fill;

    double lineHeightInPixels = lineHeightInCm * 37.795;

    canvas.save();

    canvas.translate(size.width / 2, size.height / 2);

    final Path path = Path()
      ..moveTo(0, -triangleHeight / 2)
      ..lineTo(-triangleBase / 2, triangleHeight / 2)
      ..lineTo(triangleBase / 2, triangleHeight / 2)
      ..close();

    canvas.drawPath(path, paint);

    final Paint linePaint = Paint()
      ..color = Colors.pink
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(0, triangleHeight / 2),
      Offset(0, triangleHeight / 2 + lineHeightInPixels),
      linePaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
