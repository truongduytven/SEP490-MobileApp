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
    {"name": "Thức dậy", "icon": Icons.sunny},
    {"name": "Trước bữa ăn", "icon": Icons.local_cafe_outlined},
    {"name": "Sau bữa ăn", "icon": Icons.fastfood_sharp},
    {"name": "Trước khi ngủ", "icon": Icons.night_shelter_outlined},
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.borderColor, width: 1.5),
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
                    const SizedBox(height: 50),

                    // Carousel Slider for Period Selection
                    CarouselSlider(
                      options: CarouselOptions(
                        viewportFraction: 0.6,
                        height: 150,
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
                            color: AppColors.bgColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.textPrimary, // Set border color
                              width: 0.5, // Border width
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(item["icon"],
                                  size: 50, color: AppColors.secondaryColor),
                              SizedBox(height: 10),
                              Text(item["name"],
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.secondaryColor)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 50),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w600,
                              color: bloodGlucoseFocusNode.hasFocus
                                  ? AppColors.primaryColor
                                  : AppColors.textColor,
                            ),
                            showCursor: true,
                            textAlign: TextAlign.center,
                            controller: _controller,
                            focusNode: bloodGlucoseFocusNode,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              hintText: "---",
                              hintStyle: TextStyle(
                                fontSize: 35,
                                color: bloodGlucoseFocusNode.hasFocus
                                    ? AppColors.primaryColor
                                    : AppColors.grayColor4,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: const BorderSide(
                                    color: AppColors.grayColor2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: const BorderSide(
                                    width: 1.5, color: AppColors.primaryColor),
                              ),
                              suffixIcon: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      const Color.fromARGB(255, 255, 225, 232),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 5.0,
                                        bottom: 5,
                                        left: 5,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (unit != "mmol/L") toggleUnit();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 12),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: unit == "mmol/L"
                                                ? AppColors.bgColor
                                                : Colors.transparent,
                                          ),
                                          child: Text(
                                            "mmol/L",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: AppColors.secondaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 5.0,
                                        bottom: 5,
                                        right: 5,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (unit != "mg/dL") toggleUnit();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 12),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: unit == "mg/dL"
                                                ? AppColors.bgColor
                                                : Colors.transparent,
                                          ),
                                          child: Text(
                                            "mg/dL",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: AppColors.secondaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                final parsedValue = num.tryParse(value) ?? 0;

                                if (unit == "mg/dL") {
                                  currentValue = (parsedValue / 18).toDouble();
                                } else {
                                  currentValue =
                                      parsedValue.clamp(0, double.infinity);
                                }

                                if (currentValue == 0) {
                                  errorMessage =
                                      "Giá trị không được để trống hoặc bằng 0.";
                                } else {
                                  errorMessage = null;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          errorMessage!,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Button positioned at the bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (currentValue == null || currentValue == 0)
                      ? null // Disable button
                      : () {
                          num valueToSubmit = unit == "mg/dL"
                              ? (currentValue / 18).toDouble()
                              : currentValue;
                          widget.onSubmit(valueToSubmit, period);
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
            ),
          ],
        ),
      ),
    );
  }
}
