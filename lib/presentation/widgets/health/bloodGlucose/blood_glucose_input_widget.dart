import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class BloodGlucoseInputWidget extends StatefulWidget {
  final num initialValue;
  final String period;
  final String dateTime;
  final void Function(num, String) onSubmit;

  const BloodGlucoseInputWidget({
    super.key,
    required this.initialValue,
    required this.dateTime,
    required this.period,
    required this.onSubmit,
  });

  @override
  State<BloodGlucoseInputWidget> createState() =>
      _BloodGlucoseInputWidgetState();
}

class _BloodGlucoseInputWidgetState extends State<BloodGlucoseInputWidget> {
  int _currentIndex = 0;
  late TextEditingController _controller;
  final FocusNode bloodGlucoseFocusNode = FocusNode();
  late num currentValue;
  late String period;
  String? errorMessage;
  String unit = "mmol/L"; // Default unit

  final List<Map<String, dynamic>> items = [
    {"name": "Thức dậy", "icon": Icons.home},
    {"name": "Trước bữa ăn", "icon": Icons.star},
    {"name": "Sau bữa ăn", "icon": Icons.favorite},
    {"name": "Trước khi ngủ", "icon": Icons.settings},
  ];

  @override
  void initState() {
    super.initState();
    period = widget.period;
    currentValue = widget.initialValue;

    _controller = TextEditingController(
        text: widget.initialValue > 0 ? widget.initialValue.toString() : "");

    int index = items.indexWhere((item) => item["name"] == widget.period);
    if (index != -1) {
      _currentIndex = index;
    }

    bloodGlucoseFocusNode.addListener(() {
      setState(() {});
    });
  }

  void toggleUnit() {
    setState(() {
      if (unit == "mmol/L") {
        unit = "mg/dL";
        currentValue = (currentValue * 18).toDouble(); // Convert to mg/dL
      } else {
        unit = "mmol/L";
        currentValue = (currentValue / 18).toDouble(); // Convert to mmol/L
      }
      _controller.text = currentValue.toStringAsFixed(1);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    bloodGlucoseFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderColor, width: 1.5),
                  color: AppColors.bgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_month_outlined,
                        color: AppColors.secondaryColor, size: 24),
                    SizedBox(width: 8),
                    Text("Hôm nay, ${widget.dateTime}",
                        style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Carousel Slider for Period Selection
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                      period = items[index]["name"];
                    });
                  },
                  initialPage: _currentIndex,
                ),
                items: items.map((item) {
                  return Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item["icon"], size: 50, color: Colors.white),
                        SizedBox(height: 10),
                        Text(item["name"],
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ],
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),

              // Blood Glucose Input with Toggle Buttons
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                        color: bloodGlucoseFocusNode.hasFocus
                            ? AppColors.primaryColor
                            : AppColors.textColor,
                      ),
                      showCursor: false,
                      textAlign: TextAlign.center,
                      controller: _controller,
                      focusNode: bloodGlucoseFocusNode,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                        hintText: "---",
                        hintStyle: TextStyle(
                          fontSize: 40,
                          color: bloodGlucoseFocusNode.hasFocus
                              ? AppColors.primaryColor
                              : AppColors.grayColor4,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide:
                              const BorderSide(color: AppColors.grayColor1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(
                              width: 1.5, color: AppColors.primaryColor),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          final parsedValue = num.tryParse(value) ?? 0;

                          // Always store the value in mmol/L
                          if (unit == "mg/dL") {
                            currentValue = (parsedValue / 18)
                                .toDouble(); // Convert mg/dL to mmol/L
                          } else {
                            currentValue =
                                parsedValue.clamp(0, double.infinity);
                          }

                          // Update the displayed value to always show mmol/L
                          // _controller.text = currentValue.toStringAsFixed(1);
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),

                  // Toggle Buttons for Unit Selection
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.secondaryColor,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (unit != "mmol/L") toggleUnit();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)),
                              color: unit == "mmol/L"
                                  ? AppColors.primaryColor
                                  : Colors.transparent,
                            ),
                            child: Text(
                              "mmol/L",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (unit != "mg/dL") toggleUnit();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              color: unit == "mg/dL"
                                  ? AppColors.primaryColor
                                  : Colors.transparent,
                            ),
                            child: Text(
                              "mg/dL",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  widget.onSubmit(currentValue, period);
                },
                child: Text("Tiếp tục"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
