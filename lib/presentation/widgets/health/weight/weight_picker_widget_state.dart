import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:sep490/presentation/widgets/health/weight/needle_painter.dart';
import 'package:sep490/theme/color.dart';

class WeightPickerWidget extends StatefulWidget {
  final num initialValue;
  final String dateTime;
  final ValueChanged<num> onSubmit;

  const WeightPickerWidget({
    required this.initialValue,
    required this.dateTime,
    required this.onSubmit,
    super.key,
  });

  @override
  State<WeightPickerWidget> createState() => _WeightPickerWidgetState();
}

class _WeightPickerWidgetState extends State<WeightPickerWidget> {
  late RulerPickerController _rulerPickerController;
  late num currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
    _rulerPickerController = RulerPickerController(value: currentValue);
  }

  void _incrementValue() {
    setState(() {
      currentValue = currentValue + 1;
      _rulerPickerController.value = currentValue;
    });
  }

  void _decrementValue() {
    setState(() {
      currentValue = currentValue - 1;
      _rulerPickerController.value = currentValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.borderColor,
                          width: 1.5,
                        ),
                        color: AppColors.bgColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            color: AppColors.secondaryColor,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Hôm nay, ${widget.dateTime}",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: _decrementValue,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.pink,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.remove,
                                size: 40, color: Colors.white),
                          ),
                        ),
                        Text(
                          currentValue.toStringAsFixed(1),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 80,
                          ),
                        ),
                        GestureDetector(
                          onTap: _incrementValue,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.pink,
                              shape: BoxShape.circle,
                            ),
                            child:
                                Icon(Icons.add, size: 40, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "kg",
                      style:
                          TextStyle(color: AppColors.grayColor5, fontSize: 40),
                    ),
                    SizedBox(height: 50),
                    RulerPicker(
                      controller: _rulerPickerController,
                      onBuildRulerScaleText: (index, value) {
                        return value.toInt().toString();
                      },
                      ranges: const [
                        RulerRange(begin: 1, end: 50, scale: 0.1),
                        RulerRange(begin: 50, end: 100, scale: 0.1),
                        RulerRange(begin: 100, end: 200, scale: 0.1),
                      ],
                      scaleLineStyleList: const [
                        ScaleLineStyle(
                          color: AppColors.secondaryColor,
                          width: 1.5,
                          height: 80,
                          scale: 0,
                        ),
                        ScaleLineStyle(
                          color: AppColors.secondaryColor,
                          width: 1,
                          height: 60,
                          scale: 5,
                        ),
                        ScaleLineStyle(
                          color: AppColors.secondaryColor,
                          width: 1,
                          height: 45,
                          scale: -1,
                        ),
                      ],
                      onValueChanged: (value) {
                        setState(() {
                          currentValue = value;
                        });
                      },
                      width: MediaQuery.of(context).size.width - 20,
                      height: 150,
                      rulerMarginTop: 8,
                      rulerBackgroundColor: Colors.transparent,
                      marker: CustomPaint(
                        size: Size(10, 20),
                        painter: NeedlePainter(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              widget.onSubmit(currentValue);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryColor,
              padding: EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: Text(
              'Tiếp tục',
              style: TextStyle(
                fontSize: 28,
                color: AppColors.bgColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
