import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LineChartSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Color.fromARGB(255, 243, 240, 248),
      highlightColor: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skeleton cho phần "Trung bình ngày"
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white, // Màu giả lập
                          borderRadius: BorderRadius.circular(8), // Bo tròn góc
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: 80,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white, // Màu giả lập
                          borderRadius: BorderRadius.circular(8), // Bo tròn góc
                        ),
                      ),
                    ],
                  ),
                  // Skeleton cho phần "BMI"
                  Container(
                    width: 100,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white, // Màu giả lập
                      borderRadius: BorderRadius.circular(8), // Bo tròn góc
                    ),
                  ),
                ],
              ),
            ),
            // Skeleton cho biểu đồ cột
            SizedBox(
              height: 300,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent, // Màu nền trong suốt
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.red, // Màu đường viền
                    width: 1,
                  ),
                ),
                child: CustomPaint(
                  size: Size(double.infinity, 300),
                  painter: _FakeBarChartPainter(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// CustomPainter để vẽ biểu đồ cột giả với border radius
class _FakeBarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    debugPrint("CustomPaint size: $size"); // In kích thước để kiểm tra

    final paint = Paint()
      ..color = Colors.blue // Màu cột
      ..style = PaintingStyle.fill;

    // Số lượng cột
    final int barCount = 7; // Tăng số lượng cột lên 10
    // Khoảng cách giữa các cột
    final double barSpacing = size.width / (barCount * 2);
    // Chiều rộng của mỗi cột
    final double barWidth =
        (size.width - (barSpacing * (barCount + 1))) / barCount;
    // Border radius cho cột
    final double barRadius = 8;

    // Giá trị giả lập cho chiều cao của các cột
    final List<double> barHeights = [
      size.height * 0.8,
      size.height * 0.5,
      size.height * 0.7,
      size.height * 0.4,
      size.height * 0.6,
      size.height * 0.3,
      size.height * 0.9,
    ];

    for (int i = 0; i < barCount; i++) {
      final double x = barSpacing + (barWidth + barSpacing) * i;
      final double y = size.height - barHeights[i];
      final double height = barHeights[i];

      // Tạo Path với border radius
      final path = Path()
        ..moveTo(x + barRadius, y)
        ..lineTo(x + barWidth - barRadius, y)
        ..arcToPoint(
          Offset(x + barWidth, y + barRadius),
          radius: Radius.circular(barRadius),
        )
        ..lineTo(x + barWidth, y + height - barRadius)
        ..arcToPoint(
          Offset(x + barWidth - barRadius, y + height),
          radius: Radius.circular(barRadius),
        )
        ..lineTo(x + barRadius, y + height)
        ..arcToPoint(
          Offset(x, y + height - barRadius),
          radius: Radius.circular(barRadius),
        )
        ..lineTo(x, y + barRadius)
        ..arcToPoint(
          Offset(x + barRadius, y),
          radius: Radius.circular(barRadius),
        )
        ..close();

      // Vẽ cột với border radius
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
