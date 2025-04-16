import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:sep490/models/drinking_schedule.dart';

class WaterDrinking extends StatefulWidget {
  const WaterDrinking({super.key});

  @override
  State<WaterDrinking> createState() => _WaterDrinkingState();
}

class _WaterDrinkingState extends State<WaterDrinking>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _waterLevel = 0; // Initial water level (40%)
  int _waterAmount = 0; // Water consumed in ml
  final int _dailyGoal = 1700; // Daily goal in ml
  List<Bubble> _bubbles = [];
  final int _maxBubbles = 12;
  final Random _random = Random();
  final List<DrinkingSchedule> _schedule = [
    DrinkingSchedule(
        time: TimeOfDay(hour: 6, minute: 30),
        amount: 250,
        description: "Sau khi thức dậy, làm sạch cơ thể"),
    DrinkingSchedule(
        time: TimeOfDay(hour: 8, minute: 0),
        amount: 200,
        description: "Trước ăn sáng, hỗ trợ tiêu hóa"),
    DrinkingSchedule(
        time: TimeOfDay(hour: 10, minute: 0),
        amount: 200,
        description: "Giữa buổi sáng, giữ tính táo"),
    DrinkingSchedule(
        time: TimeOfDay(hour: 11, minute: 30),
        amount: 200,
        description: "Trước ăn trưa khoảng 30 phút"),
    DrinkingSchedule(
        time: TimeOfDay(hour: 14, minute: 0),
        amount: 200,
        description: "Sau ăn trưa, bổ sung nước nhẹ"),
    DrinkingSchedule(
        time: TimeOfDay(hour: 16, minute: 0),
        amount: 200,
        description: "Giữ nước cho cơ thể, chống mệt mỏi"),
    DrinkingSchedule(
        time: TimeOfDay(hour: 18, minute: 0),
        amount: 200,
        description: "Trước ăn tối 30 phút"),
    DrinkingSchedule(
        time: TimeOfDay(hour: 20, minute: 0),
        amount: 150,
        description: "Sau ăn tối nhẹ"),
    DrinkingSchedule(
        time: TimeOfDay(hour: 21, minute: 30),
        amount: 100,
        description: "Trước khi ngủ, tránh tiểu đêm"),
  ];

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )
      ..addListener(() {
        _updateBubbles();
        setState(() {});
      })
      ..repeat();

    // Initialize bubbles
    _generateBubbles();
    _calculateInitialWaterIntake();
    super.initState();
  }

  String getCurrentScheduleDescription() {
    final now = TimeOfDay.now();

    for (int i = 0; i < _schedule.length; i++) {
      final current = _schedule[i];
      final next = i < _schedule.length - 1 ? _schedule[i + 1] : null;

      if (next != null) {
        if (_isAfterOrEqual(now, current.time) && _isBefore(now, next.time)) {
          return current.description;
        }
      } else {
        // Nếu là khung giờ cuối cùng
        if (_isAfterOrEqual(now, current.time)) {
          return current.description;
        }
      }
    }
    return "Bổ sung nước cho ngày dài năng động";
  }

  bool _isAfterOrEqual(TimeOfDay a, TimeOfDay b) {
    return a.hour > b.hour || (a.hour == b.hour && a.minute >= b.minute);
  }

  bool _isBefore(TimeOfDay a, TimeOfDay b) {
    return a.hour < b.hour || (a.hour == b.hour && a.minute < b.minute);
  }

  void _generateBubbles() {
    _bubbles = List.generate(_maxBubbles, (_) => _createBubble());
  }

  void _calculateInitialWaterIntake() {
    final now = TimeOfDay.now();

    int totalAmount = 0;

    for (final schedule in _schedule) {
      if (_isBeforeOrEqual(schedule.time, now)) {
        totalAmount += schedule.amount;
      } else {
        break;
      }
    }

    setState(() {
      _waterAmount = totalAmount;

      _waterLevel =
          1 - (totalAmount / _dailyGoal); // ví dụ: 1000ml / 2000ml = 0.5
    });
  }

  bool _isBeforeOrEqual(TimeOfDay a, TimeOfDay b) {
    return a.hour < b.hour || (a.hour == b.hour && a.minute <= b.minute);
  }

  Bubble _createBubble() {
    final size = _random.nextDouble() * 8 + 2;
    return Bubble(
      x: _random.nextDouble() * 0.7 + 0.15,
      y: _random.nextDouble() * 0.5 + 0.4,
      size: size,
      speed: (10 - size) / 20, // Smaller bubbles rise faster
      opacity: _random.nextDouble() * 0.4 + 0.2,
    );
  }

  void _updateBubbles() {
    for (int i = 0; i < _bubbles.length; i++) {
      _bubbles[i].y -= _bubbles[i].speed * 0.01;

      // Reset bubbles that reach the water surface
      if (_bubbles[i].y < _waterLevel) {
        _bubbles[i] = _createBubble();
      }
    }
  }

  // void _addWater(int amount) {
  //   setState(() {
  //     _waterAmount += amount;
  //     // Cap at daily goal
  //     if (_waterAmount > _dailyGoal) _waterAmount = _dailyGoal;

  //     // Update water level animation (40% to 85% of bottle)
  //     _waterLevel = 0.85 - (0.45 * (1 - (_waterAmount / _dailyGoal)));
  //   });
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Nhắc nhở uống nước",
        ),
        backgroundColor: Color.fromARGB(255, 247, 249, 251),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const ui.Color.fromARGB(255, 247, 249, 251),
              Colors.blue[50]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Inspiring message at top
              Positioned(
                top: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Uống đủ nước và khỏe mạnh",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800],
                          shadows: [
                            Shadow(
                              offset: const Offset(0.5, 0.5),
                              blurRadius: 2.0,
                              color: Colors.blueAccent.withOpacity(0.3),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.water_drop,
                            color: Colors.blue[400],
                            size: 24,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "Nên uống: $_waterAmount ml / Mục tiêu: $_dailyGoal ml",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 3D Water bottle
              Center(
                child: CustomPaint(
                  painter: Enhanced3DBottlePainter(
                    animationValue: _controller,
                    waterLevel: _waterLevel,
                    bubbles: _bubbles,
                  ),
                  child: const SizedBox(width: 300, height: 500),
                ),
              ),

              // Water intake buttons
              // Positioned(
              //   bottom: 120,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       _buildWaterButton(100, Icons.local_drink),
              //       _buildWaterButton(250, Icons.water_drop),
              //       _buildWaterButton(500, Icons.water),
              //     ],
              //   ),
              // ),

              // Motivational text at bottom
              Positioned(
                bottom: 40,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue[500]!,
                        Colors.blue[700]!,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue[300]!.withOpacity(0.6),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: 250,
                    child: Text(
                      "💧  ${getCurrentScheduleDescription()} 💧",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWaterButton(int amount, IconData icon) {
    return GestureDetector(
      // onTap: () => _addWater(amount),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.blue[600],
              size: 30,
            ),
            const SizedBox(height: 5),
            Text(
              "$amount ml",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Bubble {
  double x; // Horizontal position (percentage of bottle width)
  double y; // Vertical position (percentage of bottle height)
  double size; // Bubble size
  double speed; // How fast bubble rises
  double opacity; // Bubble opacity

  Bubble({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class Enhanced3DBottlePainter extends CustomPainter {
  final Animation<double> animationValue;
  final double waterLevel;
  final List<Bubble> bubbles;

  Enhanced3DBottlePainter({
    required this.animationValue,
    required this.waterLevel,
    required this.bubbles,
  }) : super(repaint: animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Draw deeper bottle shadow for 3D effect
    final Paint deepShadowPaint = Paint()
      ..color = Colors.blueGrey.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w / 2, h * 0.97),
          width: w * 0.7,
          height: h * 0.05,
        ),
        const Radius.circular(10),
      ),
      deepShadowPaint,
    );

    // Create bottle path
    final Path bottlePath = _createBottlePath(w, h);

    // Draw glass effect (first layer)
    final Paint glassEffectPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    canvas.drawPath(bottlePath, glassEffectPaint);

    // Draw water content
    _drawWaterContent(canvas, size, bottlePath);

    // Draw bubbles
    _drawBubbles(canvas, size, bottlePath);

    // Draw bottle body (translucent layer)
    final Paint bottlePaint = Paint()
      ..color = Colors.white70.withOpacity(0.15)
      ..style = PaintingStyle.fill;
    canvas.drawPath(bottlePath, bottlePaint);

    // Draw bottle edge with gradient for 3D effect
    final Paint bottleEdgePaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(w * 0.15, h * 0.5),
        Offset(w * 0.85, h * 0.5),
        [
          Colors.cyanAccent.withOpacity(0.9),
          Colors.blue.withOpacity(0.7),
          Colors.cyanAccent.withOpacity(0.9),
        ],
        [0.0, 0.5, 1.0],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;
    canvas.drawPath(bottlePath, bottleEdgePaint);

    // Draw cap
    _drawBottleCap(canvas, w, h);

    // Draw light reflections for 3D effect
    _drawBottleHighlights(canvas, size, bottlePath);

    // Draw measurement marks on the bottle
    _drawMeasurementMarks(canvas, w, h, bottlePath);
  }

  Path _createBottlePath(double w, double h) {
    final Path bottlePath = Path();

    // Bottle shape with more defined curves for 3D effect
    bottlePath.moveTo(w * 0.3, h * 0.1);
    bottlePath.lineTo(w * 0.3, h * 0.05); // cap bottom
    bottlePath.lineTo(w * 0.7, h * 0.05); // cap bottom
    bottlePath.lineTo(w * 0.7, h * 0.1); // cap bottom to neck

    // Right side of bottle with more pronounced curve
    bottlePath.quadraticBezierTo(w * 0.7, h * 0.15, w * 0.85, h * 0.25);
    bottlePath.lineTo(w * 0.85, h * 0.9);
    bottlePath.quadraticBezierTo(w * 0.75, h * 0.97, w * 0.5, h * 0.97);

    // Left side of bottle
    bottlePath.quadraticBezierTo(w * 0.25, h * 0.97, w * 0.15, h * 0.9);
    bottlePath.lineTo(w * 0.15, h * 0.25);
    bottlePath.quadraticBezierTo(w * 0.3, h * 0.15, w * 0.3, h * 0.1);

    bottlePath.close();
    return bottlePath;
  }

  void _drawBottleCap(Canvas canvas, double w, double h) {
    // Create a more 3D looking cap
    final capPath = Path();
    capPath.moveTo(w * 0.3, h * 0.05);
    capPath.lineTo(w * 0.3, h * 0.01);
    capPath.lineTo(w * 0.7, h * 0.01);
    capPath.lineTo(w * 0.7, h * 0.05);
    capPath.close();

    // Cap gradient for 3D effect
    final capPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(w * 0.3, h * 0.03),
        Offset(w * 0.7, h * 0.03),
        [
          Colors.blue[700]!,
          Colors.blue[500]!,
          Colors.blue[700]!,
        ],
        [0.0, 0.5, 1.0],
      );
    canvas.drawPath(capPath, capPaint);

    // Cap highlight
    final capHighlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final capHighlightPath = Path();
    capHighlightPath.moveTo(w * 0.35, h * 0.02);
    capHighlightPath.lineTo(w * 0.65, h * 0.02);
    canvas.drawPath(capHighlightPath, capHighlightPaint);

    // Cap edge for definition
    final capEdgePaint = Paint()
      ..color = Colors.blue[900]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(capPath, capEdgePaint);
  }

  void _drawWaterContent(Canvas canvas, Size size, Path bottlePath) {
    final double w = size.width;
    final double h = size.height;

    // Water height based on water level
    final waterHeight = h * waterLevel;

    // Create water path
    final waterPath = Path();
    waterPath.moveTo(w * 0.15, waterHeight);

    // Calculate the wave's starting point at the water level
    final double waveLeft = w * 0.15;
    final double waveRight = w * 0.85;
    final double waveWidth = waveRight - waveLeft;

    // Draw multiple wave layers
    for (int i = 0; i < 3; i++) {
      final layer = i;
      _drawWaveLayer(
        canvas,
        size,
        bottlePath: bottlePath,
        waveLeft: waveLeft,
        waveWidth: waveWidth,
        waterHeight: waterHeight,
        layer: layer,
        animationValue: animationValue.value,
      );
    }
  }

  void _drawWaveLayer(
    Canvas canvas,
    Size size, {
    required Path bottlePath,
    required double waveLeft,
    required double waveWidth,
    required double waterHeight,
    required int layer,
    required double animationValue,
  }) {
    final double h = size.height;
    final double waveAmplitude = 8.0 - layer * 1.5; // Wave height
    final double layerOffset = layer * 5.0; // Layer spacing

    // Define wave colors with gradient effect
    final List<List<Color>> layerColors = [
      [Colors.blue[400]!, Colors.cyan[300]!],
      [Colors.blue[300]!, Colors.lightBlue[200]!],
      [Colors.lightBlue[200]!, Colors.cyan[100]!],
    ];

    final Paint wavePaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(waveLeft, waterHeight),
        Offset(waveLeft + waveWidth, waterHeight + h * 0.2),
        layerColors[layer % layerColors.length],
        [0.0, 1.0],
      )
      ..style = PaintingStyle.fill;

    // Create more complex wave path for realistic water
    final Path wavePath = Path();
    wavePath.moveTo(waveLeft, waterHeight + layerOffset);

    // Generate smooth wave with multiple sine components
    for (double x = 0; x <= waveWidth; x += 2) {
      final double xPos = waveLeft + x;
      final double progress = x / waveWidth;

      // Create complex wave with multiple frequencies
      final double primaryWave =
          sin((progress * 3 * pi) + (animationValue * 2 * pi));
      final double secondaryWave =
          sin((progress * 7 * pi) + (animationValue * 4 * pi)) * 0.3;

      final double y = waterHeight +
          layerOffset +
          (waveAmplitude * primaryWave) +
          (waveAmplitude * secondaryWave);

      wavePath.lineTo(xPos, y);
    }

    // Complete the wave path
    wavePath.lineTo(waveLeft + waveWidth, h);
    wavePath.lineTo(waveLeft, h);
    wavePath.close();

    // Clip the wave to the bottle shape
    final Path clippedWavePath = Path.combine(
      PathOperation.intersect,
      bottlePath,
      wavePath,
    );

    // Draw the wave
    canvas.drawPath(clippedWavePath, wavePaint);

    // Add subtle highlights on wave crests for top layer
    if (layer == 0) {
      final Paint highlightPaint = Paint()
        ..color = Colors.white.withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      final Path highlightPath = Path();
      double lastY = 0;

      for (double x = 0; x <= waveWidth; x += 8) {
        final double xPos = waveLeft + x;
        final double progress = x / waveWidth;

        final double primaryWave =
            sin((progress * 3 * pi) + (animationValue * 2 * pi));
        final double y = waterHeight + (waveAmplitude * primaryWave) - 1;

        if (x == 0) {
          highlightPath.moveTo(xPos, y);
          lastY = y;
        } else {
          // Only add highlight points at wave crests
          if ((lastY - y) > 0) {
            highlightPath.lineTo(xPos, y);
          }
          lastY = y;
        }
      }

      // Clip highlights to bottle
      final Path clippedHighlightPath = Path.combine(
        PathOperation.intersect,
        bottlePath,
        highlightPath,
      );

      canvas.drawPath(clippedHighlightPath, highlightPaint);
    }
  }

  void _drawBubbles(Canvas canvas, Size size, Path bottlePath) {
    final double w = size.width;
    final double h = size.height;

    // Calculate water height based on waterLevel
    final waterHeight = h * waterLevel;

    // Draw bubbles
    for (final bubble in bubbles) {
      // Only draw bubbles below the water level
      if (bubble.y >= waterLevel) {
        final bubbleX = w * bubble.x;
        final bubbleY = h * bubble.y;

        // Create bubble gradient for 3D effect
        final bubblePaint = Paint()
          ..shader = ui.Gradient.radial(
            Offset(bubbleX - bubble.size * 0.3, bubbleY - bubble.size * 0.3),
            bubble.size,
            [
              Colors.white.withOpacity(bubble.opacity * 1.5),
              Colors.cyan.withOpacity(bubble.opacity * 0.7),
            ],
          );

        // Draw bubble path
        final bubblePath = Path()
          ..addOval(Rect.fromCircle(
            center: Offset(bubbleX, bubbleY),
            radius: bubble.size,
          ));

        // Clip bubbles to bottle and below water surface
        final waterClipPath = Path()
          ..moveTo(0, waterHeight)
          ..lineTo(w, waterHeight)
          ..lineTo(w, h)
          ..lineTo(0, h)
          ..close();

        final Path clippedBubblePath = Path.combine(
          PathOperation.intersect,
          Path.combine(
            PathOperation.intersect,
            bottlePath,
            waterClipPath,
          ),
          bubblePath,
        );

        canvas.drawPath(clippedBubblePath, bubblePaint);

        // Add small highlight to bubble for 3D effect
        final highlightPaint = Paint()
          ..color = Colors.white.withOpacity(bubble.opacity)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
          Offset(bubbleX - bubble.size * 0.3, bubbleY - bubble.size * 0.3),
          bubble.size * 0.3,
          highlightPaint,
        );
      }
    }
  }

  void _drawBottleHighlights(Canvas canvas, Size size, Path bottlePath) {
    final double w = size.width;
    final double h = size.height;

    // Main reflection highlight along the right edge
    final Paint mainHighlightPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(w * 0.7, h * 0.2),
        Offset(w * 0.85, h * 0.4),
        [
          Colors.white.withOpacity(0.7),
          Colors.white.withOpacity(0.1),
        ],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final Path mainHighlightPath = Path()
      ..moveTo(w * 0.82, h * 0.2)
      ..lineTo(w * 0.82, h * 0.7);

    // Clip highlight to bottle
    final Path clippedMainHighlight = Path.combine(
      PathOperation.intersect,
      bottlePath,
      mainHighlightPath,
    );

    canvas.drawPath(clippedMainHighlight, mainHighlightPaint);

    // Add a curved highlight across the middle
    final Paint curvedHighlightPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(w * 0.3, h * 0.3),
        Offset(w * 0.7, h * 0.5),
        [
          Colors.white.withOpacity(0.05),
          Colors.white.withOpacity(0.25),
          Colors.white.withOpacity(0.05),
        ],
        [0.0, 0.5, 1.0],
      )
      ..style = PaintingStyle.fill;

    final Path curvedHighlightPath = Path()
      ..moveTo(w * 0.3, h * 0.3)
      ..quadraticBezierTo(
        w * 0.5,
        h * 0.4,
        w * 0.7,
        h * 0.3,
      )
      ..lineTo(w * 0.7, h * 0.5)
      ..quadraticBezierTo(
        w * 0.5,
        h * 0.6,
        w * 0.3,
        h * 0.5,
      )
      ..close();

    // Clip curved highlight to bottle
    final Path clippedCurvedHighlight = Path.combine(
      PathOperation.intersect,
      bottlePath,
      curvedHighlightPath,
    );

    canvas.drawPath(clippedCurvedHighlight, curvedHighlightPaint);

    // Add a small bright highlight at the top right
    final Paint topHighlightPaint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawCircle(
      Offset(w * 0.7, h * 0.15),
      w * 0.03,
      topHighlightPaint,
    );
  }

  void _drawMeasurementMarks(
      Canvas canvas, double w, double h, Path bottlePath) {
    final markPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final textStyle = TextStyle(
      color: Colors.cyan.withOpacity(0.8),
      fontSize: 10,
    );

    const int maxMl = 1700;
    final List<int> marks = [250, 500, 750, 1000, 1250, 1500];

    final double topY = h * 0.03;
    final double bottomY = h * 0.92;

    for (final ml in marks) {
      double percentage = ml / maxMl;
      double y = bottomY - (bottomY - topY) * percentage;

      // Left mark
      final leftMarkPath = Path()
        ..moveTo(w * 0.15, y)
        ..lineTo(w * 0.2, y);

      // Right mark
      final rightMarkPath = Path()
        ..moveTo(w * 0.8, y)
        ..lineTo(w * 0.85, y);

      // Clip marks to bottle shape
      final clippedLeftMark = Path.combine(
        PathOperation.intersect,
        bottlePath,
        leftMarkPath,
      );

      final clippedRightMark = Path.combine(
        PathOperation.intersect,
        bottlePath,
        rightMarkPath,
      );

      canvas.drawPath(clippedLeftMark, markPaint);
      canvas.drawPath(clippedRightMark, markPaint);

      // Text
      final textSpan = TextSpan(
        text: "$ml ml",
        style: textStyle,
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(w * 0, y - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant Enhanced3DBottlePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue ||
      oldDelegate.waterLevel != waterLevel;
}
