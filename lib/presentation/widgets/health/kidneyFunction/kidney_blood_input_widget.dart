import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sep490/presentation/widgets/health/kidneyFunction/kidney_function_input.dart';
import 'package:sep490/theme/color.dart';

class KidneyBloodInputWidget extends StatefulWidget {
  final num initialBUNValue;
  final num initialeGFRValue;
  final num initialGFRValue;
  final String dateTime;
  final void Function(num, num, num) onSubmit;

  const KidneyBloodInputWidget({
    super.key,
    required this.initialBUNValue,
    required this.initialeGFRValue,
    required this.initialGFRValue,
    required this.dateTime,
    required this.onSubmit,
  });

  @override
  State<KidneyBloodInputWidget> createState() => _KidneyBloodInputWidgetState();
}

class _KidneyBloodInputWidgetState extends State<KidneyBloodInputWidget> {
  late TextEditingController _buncontroller;
  late TextEditingController _eGFRcontroller;
  late TextEditingController _gfrcontroller;
  final FocusNode bunFocusNode = FocusNode();
  final FocusNode eGFRFocusNode = FocusNode();
  final FocusNode gfrFocusNode = FocusNode();
  late num currentBUNValue;
  late num currenteGFRValue;
  late num currentGFRValue;
  String? errorMessage;
  String unit = "mmol/L"; // Default unit

  @override
  void initState() {
    super.initState();
    currentBUNValue = widget.initialBUNValue;
    currenteGFRValue = widget.initialeGFRValue;
    currentGFRValue = widget.initialGFRValue;

    _buncontroller = TextEditingController(
        text: widget.initialBUNValue > 0
            ? widget.initialBUNValue.toString()
            : "");
    _eGFRcontroller = TextEditingController(
        text: widget.initialeGFRValue > 0
            ? widget.initialeGFRValue.toString()
            : "");
    _gfrcontroller = TextEditingController(
        text: widget.initialGFRValue > 0
            ? widget.initialGFRValue.toString()
            : "");

    bunFocusNode.addListener(() {
      setState(() {});
    });
    eGFRFocusNode.addListener(() {
      setState(() {});
    });
    gfrFocusNode.addListener(() {
      setState(() {});
    });
  }

  void toggleUnit() {
    setState(() {
      // Read the latest values from the controllers
      final bunValue = num.tryParse(_buncontroller.text) ?? 0;
      final gfrValue = num.tryParse(_gfrcontroller.text) ?? 0;

      if (unit == "mmol/L") {
        // Switching to mg/dL
        unit = "mg/dL";
        currentBUNValue = bunValue * 2.8; // Convert BUN to mg/dL
        currentGFRValue = gfrValue / 88.42; // Convert GFR to µmol/L
      } else {
        // Switching to mmol/L
        unit = "mmol/L";
        currentBUNValue = bunValue / 2.8; // Convert BUN to mmol/L
        currentGFRValue = gfrValue * 88.42; // Convert GFR to mL/min/1.73m²
      }

      // Update the controller text with formatted values
      _buncontroller.text = currentBUNValue.toStringAsFixed(1);
      _gfrcontroller.text = currentGFRValue.toStringAsFixed(1);
    });
  }

  @override
  void dispose() {
    _buncontroller.dispose();
    _eGFRcontroller.dispose();
    _gfrcontroller.dispose();
    bunFocusNode.dispose();
    eGFRFocusNode.dispose();
    gfrFocusNode.dispose();
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "BUN",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondaryColor),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.5, // Half of screen width
                          child: Row(
                            children: [
                              Expanded(
                                child: KidneyBloodInput(
                                  controller: _buncontroller,
                                  focusNode: bunFocusNode,
                                  onChanged: (value) {
                                    setState(() {
                                      final parsedValue =
                                          num.tryParse(value) ?? 0;
                                      if (unit == "mg/dL") {
                                        currentBUNValue =
                                            (currentBUNValue / 2.8);
                                      } else {
                                        currentBUNValue = parsedValue.clamp(
                                            0, double.infinity);
                                      }
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                  width:
                                      10), // Space between TextField and Icon
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "eGFR",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondaryColor),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.5, // Half of screen width
                          child: Row(
                            children: [
                              Expanded(
                                child: KidneyBloodInput(
                                  controller: _eGFRcontroller,
                                  focusNode: eGFRFocusNode,
                                  onChanged: (value) {
                                    setState(() {
                                      final parsedValue =
                                          num.tryParse(value) ?? 0;
                                      currenteGFRValue =
                                          parsedValue.clamp(0, double.infinity);
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                  width:
                                      10), // Space between TextField and Icon
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "GFR",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondaryColor),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.5, // Half of screen width
                          child: Row(
                            children: [
                              Expanded(
                                  child: KidneyBloodInput(
                                controller: _gfrcontroller,
                                focusNode: gfrFocusNode,
                                onChanged: (value) {
                                  setState(() {
                                    final parsedValue =
                                        num.tryParse(value) ?? 0;
                                    if (unit == "mg/dL") {
                                      currentGFRValue =
                                          (currentGFRValue * 88.42);
                                    } else {
                                      currentGFRValue =
                                          parsedValue.clamp(0, double.infinity);
                                    }
                                  });
                                },
                              )),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "eGFR được tính theo đơn vị",
                  style: TextStyle(
                    color: AppColors.grayColor5,
                  ),
                ),
                Text(
                  "mL/phút/ 1,73 m2",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryColor,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "BUN và GFR được tính theo đơn vị",
                  style: TextStyle(
                    color: AppColors.grayColor5,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 255, 225, 232),
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
                                borderRadius: BorderRadius.circular(20),
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
                                borderRadius: BorderRadius.circular(20),
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
              ],
            ),

            SizedBox(height: 20),

            // Button positioned at the bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_buncontroller.text.isEmpty ||
                          _eGFRcontroller.text.isEmpty ||
                          _gfrcontroller.text.isEmpty)
                      ? null // Disable button
                      : () {
                          if (unit == "mg/dL") {
                            currentBUNValue = (currentBUNValue /
                                2.8); // Convert BUN to mmol/L
                            currentGFRValue = (currentGFRValue *
                                88.42); // Convert GFR to mL/min/1.73m²
                          }

                          // Format values to two decimal places
                          final formattedBUNValue =
                              double.parse(currentBUNValue.toStringAsFixed(2));
                          final formattedGFRValue =
                              double.parse(currentGFRValue.toStringAsFixed(2));
                          final formattedeGFRValue =
                              double.parse(currenteGFRValue.toStringAsFixed(2));

                          // Pass formatted values to onSubmit
                          widget.onSubmit(formattedBUNValue, formattedGFRValue,
                              formattedeGFRValue);
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
