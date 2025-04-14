import 'dart:math' as math;
import 'package:flutter/material.dart';

class WaterDrinking extends StatefulWidget {
  const WaterDrinking({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _WaterDrinkingState createState() => _WaterDrinkingState();
}

class _WaterDrinkingState extends State<WaterDrinking>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: AutomatedAnimator(
          animateToggle: true,
          doRepeatAnimation: true,
          duration: Duration(seconds: 10),
          buildWidget: (double animationPosition) {
            return WaveLoadingBubble(
              foregroundWaveColor: Color(0xFF6AA0E1),
              backgroundWaveColor: Color(0xFF4D90DF),
              loadingWheelColor: Color(0xFF77AAEE),
              period: animationPosition,
              backgroundWaveVerticalOffset: 90 - animationPosition * 200,
              foregroundWaveVerticalOffset: 90 +
                  reversingSplitParameters(
                    position: animationPosition,
                    numberBreaks: 6,
                    parameterBase: 8.0,
                    parameterVariation: 8.0,
                    reversalPoint: 0.75,
                  ) -
                  animationPosition * 200,
              waveHeight: reversingSplitParameters(
                position: animationPosition,
                numberBreaks: 5,
                parameterBase: 12,
                parameterVariation: 8,
                reversalPoint: 0.75,
              ),
            );
          },
        ),
      ),
    );
  }
}

class AutomatedAnimator extends StatefulWidget {
  const AutomatedAnimator({
    required this.buildWidget,
    required this.animateToggle,
    this.duration = const Duration(milliseconds: 300),
    this.doRepeatAnimation = false,
    Key? key,
  }) : super(key: key);

  final Widget Function(double animationValue) buildWidget;
  final Duration duration;
  final bool animateToggle;
  final bool doRepeatAnimation;

  @override
  _AutomatedAnimatorState createState() => _AutomatedAnimatorState();
}

class _AutomatedAnimatorState extends State<AutomatedAnimator>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() => setState(() {}));

    if (widget.animateToggle) controller.forward();
    if (widget.doRepeatAnimation) controller.repeat();
  }

  @override
  void didUpdateWidget(covariant AutomatedAnimator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animateToggle) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.buildWidget(controller.value);
  }
}

// Custom animation logic
double reversingSplitParameters({
  required double position,
  required double numberBreaks,
  required double parameterBase,
  required double parameterVariation,
  required double reversalPoint,
}) {
  assert(reversalPoint <= 1.0 && reversalPoint >= 0.0,
      "reversalPoint must be between 0.0 and 1.0");
  final double finalAnimationPosition =
      breakAnimationPosition(position, numberBreaks);

  if (finalAnimationPosition <= reversalPoint) {
    return parameterBase -
        (finalAnimationPosition / reversalPoint) * parameterVariation;
  } else {
    return parameterBase -
        ((1 - finalAnimationPosition) / (1 - reversalPoint)) *
            parameterVariation;
  }
}

double breakAnimationPosition(double position, double numberBreaks) {
  double finalAnimationPosition = 0;
  final double breakPoint = 1.0 / numberBreaks;

  for (var i = 0; i < numberBreaks; i++) {
    if (position <= breakPoint * (i + 1)) {
      finalAnimationPosition = (position - i * breakPoint) * numberBreaks;
      break;
    }
  }

  return finalAnimationPosition;
}

class WaveLoadingBubble extends StatelessWidget {
  const WaveLoadingBubble({
    this.bubbleDiameter = 200.0,
    this.loadingCircleWidth = 10.0,
    this.waveInsetWidth = 5.0,
    this.waveHeight = 10.0,
    this.foregroundWaveColor = Colors.lightBlue,
    this.backgroundWaveColor = Colors.blue,
    this.loadingWheelColor = Colors.white,
    this.foregroundWaveVerticalOffset = 10.0,
    this.backgroundWaveVerticalOffset = 0.0,
    this.period = 0.0,
    Key? key,
  }) : super(key: key);

  final double bubbleDiameter;
  final double loadingCircleWidth;
  final double waveInsetWidth;
  final double waveHeight;
  final Color foregroundWaveColor;
  final Color backgroundWaveColor;
  final Color loadingWheelColor;
  final double foregroundWaveVerticalOffset;
  final double backgroundWaveVerticalOffset;
  final double period;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WaveLoadingBubblePainter(
        bubbleDiameter: bubbleDiameter,
        loadingCircleWidth: loadingCircleWidth,
        waveInsetWidth: waveInsetWidth,
        waveHeight: waveHeight,
        foregroundWaveColor: foregroundWaveColor,
        backgroundWaveColor: backgroundWaveColor,
        loadingWheelColor: loadingWheelColor,
        foregroundWaveVerticalOffset: foregroundWaveVerticalOffset,
        backgroundWaveVerticalOffset: backgroundWaveVerticalOffset,
        period: period,
      ),
    );
  }
}

class WaveLoadingBubblePainter extends CustomPainter {
  WaveLoadingBubblePainter({
    required this.bubbleDiameter,
    required this.loadingCircleWidth,
    required this.waveInsetWidth,
    required this.waveHeight,
    required this.foregroundWaveColor,
    required this.backgroundWaveColor,
    required this.loadingWheelColor,
    required this.foregroundWaveVerticalOffset,
    required this.backgroundWaveVerticalOffset,
    required this.period,
  })  : foregroundWavePaint = Paint()..color = foregroundWaveColor,
        backgroundWavePaint = Paint()..color = backgroundWaveColor,
        loadingCirclePaint = Paint()
          ..shader = SweepGradient(
            colors: [
              Colors.transparent,
              loadingWheelColor,
              Colors.transparent,
            ],
            stops: [0.0, 0.9, 1.0],
            startAngle: 0,
            endAngle: math.pi,
            transform: GradientRotation(period * math.pi * 2 * 5),
          ).createShader(Rect.fromCircle(
            center: Offset.zero,
            radius: bubbleDiameter / 2,
          ));

  final double bubbleDiameter;
  final double loadingCircleWidth;
  final double waveInsetWidth;
  final double waveHeight;
  final Paint foregroundWavePaint;
  final Paint backgroundWavePaint;
  final Paint loadingCirclePaint;
  final Color foregroundWaveColor;
  final Color backgroundWaveColor;
  final Color loadingWheelColor;
  final double foregroundWaveVerticalOffset;
  final double backgroundWaveVerticalOffset;
  final double period;

  @override
  void paint(Canvas canvas, Size size) {
    final double loadingBubbleRadius = (bubbleDiameter / 2);
    final double insetBubbleRadius = loadingBubbleRadius - waveInsetWidth;
    final double waveBubbleRadius = insetBubbleRadius - loadingCircleWidth;

    final Path backgroundWavePath = WavePathHorizontal(
      amplitude: waveHeight,
      period: 1.0,
      startPoint: Offset(-waveBubbleRadius, backgroundWaveVerticalOffset),
      width: bubbleDiameter,
      crossAxisEndPoint: waveBubbleRadius,
      doClosePath: true,
      phaseShift: period * 2 * 5,
    ).build();

    final Path foregroundWavePath = WavePathHorizontal(
      amplitude: waveHeight,
      period: 1.0,
      startPoint: Offset(-waveBubbleRadius, foregroundWaveVerticalOffset),
      width: bubbleDiameter,
      crossAxisEndPoint: waveBubbleRadius,
      doClosePath: true,
      phaseShift: -period * 2 * 5,
    ).build();

    final Path circleClip = Path()
      ..addRRect(RRect.fromLTRBXY(
        -waveBubbleRadius,
        -waveBubbleRadius,
        waveBubbleRadius,
        waveBubbleRadius,
        waveBubbleRadius,
        waveBubbleRadius,
      ));

    canvas.translate(size.width / 2, size.height / 2);
    canvas.clipPath(circleClip, doAntiAlias: true);
    canvas.drawPath(backgroundWavePath, backgroundWavePaint);
    canvas.drawPath(foregroundWavePath, foregroundWavePaint);
  }

  @override
  bool shouldRepaint(WaveLoadingBubblePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(WaveLoadingBubblePainter oldDelegate) => false;
}

class WavePathHorizontal {
  WavePathHorizontal({
    required this.width,
    required this.amplitude,
    required this.period,
    required this.startPoint,
    this.phaseShift = 0.0,
    this.doClosePath = false,
    this.crossAxisEndPoint = 0,
  }) : assert(crossAxisEndPoint != null || doClosePath == false,
            "if doClosePath is true you must provide an end point");

  final double width;
  final double amplitude;
  final double period;
  final Offset startPoint;
  final double crossAxisEndPoint;
  final double phaseShift;
  final bool doClosePath;

  Path build() {
    double startX = startPoint.dx;
    double startY = startPoint.dy;
    Path path = Path();
    path.moveTo(startX, startY);

    for (double i = 0; i <= width; i++) {
      double x = i + startX;
      double y =
          startY + amplitude * math.sin((i * 2 * math.pi / width) + phaseShift);
      path.lineTo(x, y);
    }

    if (doClosePath) {
      path.lineTo(startX + width, crossAxisEndPoint);
      path.lineTo(startX, crossAxisEndPoint);
      path.close();
    }

    return path;
  }
}
