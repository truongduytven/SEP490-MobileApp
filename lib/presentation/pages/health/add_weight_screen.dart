import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:intl/intl.dart';
import 'package:sep490/presentation/widgets/health/needle_painter.dart';
import 'package:sep490/theme/color.dart';

class AddWeight extends StatefulWidget {
  const AddWeight({super.key});

  @override
  State<AddWeight> createState() => _AddWeightState();
}

class _AddWeightState extends State<AddWeight> {
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
                shape: BoxShape.circle, // Circular shape
                color: AppColors.secondaryColor, // Pink background
              ),
              padding:
                  EdgeInsets.all(8), // Padding to create space around the icon
              child: Icon(
                Icons.close,
                color: Colors.white, // White icon color
              ),
            ),
            onPressed: () {
              // Handle close action (e.g., pop the screen)
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display current date
                
                  Center(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.borderColor, // Gray border color
                          width: 1.5, // Border width
                        ),
                        color: AppColors.bgColor, // Badge color
                        borderRadius:
                            BorderRadius.circular(20), // Rounded corners
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
                  SizedBox(
                    height: 50,
                  ),
                  // Weight increment/decrement row
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
                          child:
                              Icon(Icons.remove, size: 40, color: Colors.white),
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
                    style: const TextStyle(
                        color: AppColors.grayColor5, fontSize: 40),
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
                ],
              ),
            ),
          ),
          // "Lưu" button at the bottom
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                // Save action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryColor,
                padding: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                'Lưu',
                style: TextStyle(
                  fontSize: 28,
                  color: AppColors.bgColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
