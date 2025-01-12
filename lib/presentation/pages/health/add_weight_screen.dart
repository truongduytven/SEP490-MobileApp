import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:intl/intl.dart';
import 'package:sep490/presentation/widgets/health/needle_painter.dart';
import 'package:sep490/presentation/widgets/health/weight_display_widget.dart';
import 'package:sep490/theme/color.dart';

class AddWeight extends StatefulWidget {
  const AddWeight({super.key});

  @override
  State<AddWeight> createState() => _AddWeightState();
}

class _AddWeightState extends State<AddWeight> {
  String formattedDateTime = DateFormat('MM-dd-yyyy').format(DateTime.now());

  RulerPickerController? _rulerPickerController;
  num currentValue = 40;
  bool showWeightWidget = false;

  List<RulerRange> ranges = const [
    RulerRange(begin: 1, end: 50, scale: 0.1),
    RulerRange(begin: 50, end: 100, scale: 0.1),
    RulerRange(begin: 100, end: 200, scale: 0.1),
  ];

  @override
  void initState() {
    super.initState();
    _rulerPickerController = RulerPickerController(value: currentValue);
  }

  void _incrementValue() {
    setState(() {
      currentValue = currentValue + 1;
      _rulerPickerController?.value = currentValue;
    });
  }

  void _decrementValue() {
    setState(() {
      currentValue = currentValue - 1;
      _rulerPickerController?.value = currentValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset(
            "assets/img3D/cannang.png",
            width: 45,
            height: 45,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          "Thêm cân nặng",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: AppColors.secondaryColor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryColor,
              ),
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: showWeightWidget
          ? WeightDisplayWidget(
              height: 170,
              dateTime: formattedDateTime,
              weight: currentValue,
              onEdit: () {
                setState(() {
                  showWeightWidget = false;
                });
              },
            )
          : _buildWeightPicker(),
    );
  }

  Widget _buildWeightPicker() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.borderColor,
                      width: 1.5,
                    ),
                    color: AppColors.bgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize
                        .min, // Ensures the row wraps around its content
                    children: [
                      Icon(
                        Icons.calendar_month_outlined, // Calendar icon
                        color: AppColors.secondaryColor,
                        size: 24,
                      ),
                      SizedBox(width: 8), // Space between the icon and text
                      Text(
                        "Hôm nay, $formattedDateTime",
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
                        child:
                            Icon(Icons.remove, size: 40, color: Colors.white),
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
                        child: Icon(Icons.add, size: 40, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Text(
                  "kg",
                  style: TextStyle(color: AppColors.grayColor5, fontSize: 40),
                ),
                SizedBox(height: 50),
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
                        scale: 0),
                    ScaleLineStyle(
                        color: AppColors.secondaryColor,
                        width: 1,
                        height: 60,
                        scale: 5),
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
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                showWeightWidget = true;
              });
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
