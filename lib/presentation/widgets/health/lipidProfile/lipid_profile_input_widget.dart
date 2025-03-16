import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sep490/presentation/widgets/health/kidneyFunction/bun_information_dialog.dart';
import 'package:sep490/presentation/widgets/health/kidneyFunction/egfr_information_dialog.dart';
import 'package:sep490/presentation/widgets/health/kidneyFunction/gfr_information_dialog.dart';
import 'package:sep490/presentation/widgets/health/health_input.dart';
import 'package:sep490/presentation/widgets/health/lipidProfile/hdl_information_dialog.dart';
import 'package:sep490/presentation/widgets/health/lipidProfile/ldl_information_dialog.dart';
import 'package:sep490/presentation/widgets/health/lipidProfile/total_cholesterol_information_dialog.dart';
import 'package:sep490/presentation/widgets/health/lipidProfile/triglycerides_information_dialog.dart';
import 'package:sep490/theme/color.dart';

class LipidProfileInputWidget extends StatefulWidget {
  final num initialTCValue;
  final num initialTGValue;
  final num initialLDLValue;
  final num initialHDLValue;
  final String dateTime;
  final void Function(num, num, num, num) onSubmit;

  const LipidProfileInputWidget({
    super.key,
    required this.initialTCValue,
    required this.initialTGValue,
    required this.initialLDLValue,
    required this.initialHDLValue,
    required this.dateTime,
    required this.onSubmit,
  });

  @override
  State<LipidProfileInputWidget> createState() =>
      _LipidProfileInputWidgetState();
}

class _LipidProfileInputWidgetState extends State<LipidProfileInputWidget> {
  late TextEditingController _tcController;
  late TextEditingController _tgController;
  late TextEditingController _ldlController;
  late TextEditingController _hdlController;
  final FocusNode tcFocusNode = FocusNode();
  final FocusNode tgFocusNode = FocusNode();
  final FocusNode ldlFocusNode = FocusNode();
  final FocusNode hdlFocusNode = FocusNode();
  late num currentTCValue;
  late num currentTGValue;
  late num currentLDLValue;
  late num currentHDLValue;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    currentTCValue = widget.initialTCValue;
    currentTGValue = widget.initialTGValue;
    currentLDLValue = widget.initialLDLValue;
    currentHDLValue = widget.initialHDLValue;

    _tcController = TextEditingController(
        text:
            widget.initialTCValue > 0 ? widget.initialTCValue.toString() : "");
    _tgController = TextEditingController(
        text:
            widget.initialTGValue > 0 ? widget.initialTGValue.toString() : "");
    _ldlController = TextEditingController(
        text: widget.initialLDLValue > 0
            ? widget.initialLDLValue.toString()
            : "");
    _hdlController = TextEditingController(
        text: widget.initialHDLValue > 0
            ? widget.initialHDLValue.toString()
            : "");

    tcFocusNode.addListener(() {
      setState(() {});
    });
    tgFocusNode.addListener(() {
      setState(() {});
    });
    ldlFocusNode.addListener(() {
      setState(() {});
    });
    hdlFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tcController.dispose();
    _tgController.dispose();
    _ldlController.dispose();
    _hdlController.dispose();
    tcFocusNode.dispose();
    tgFocusNode.dispose();
    ldlFocusNode.dispose();
    hdlFocusNode.dispose();
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
                          "HDL-C",
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
                                child: HealthInput(
                                  controller: _hdlController,
                                  focusNode: hdlFocusNode,
                                  onChanged: (value) {
                                    setState(() {
                                      final parsedValue =
                                          num.tryParse(value) ?? 0;

                                      currentHDLValue =
                                          parsedValue.clamp(0, double.infinity);

                                      if (currentHDLValue == 0) {
                                        errorMessage =
                                            "Giá trị không được để trống hoặc bằng 0.";
                                      } else {
                                        errorMessage = null;
                                      }
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.textPrimary,
                                    width: 1.5,
                                  ),
                                  color: AppColors.bgColor,
                                ),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        backgroundColor: AppColors.bgColor,
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          return Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.8, // 80% of screen height
                                            padding: EdgeInsets.all(16),
                                            child: HDLInformationDialog(),
                                          );
                                        },
                                      );
                                    },
                                    child: Icon(
                                      Icons.question_mark_sharp,
                                      color: AppColors.textPrimary,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
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
                          "LDL-C",
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
                                child: HealthInput(
                                  controller: _ldlController,
                                  focusNode: ldlFocusNode,
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        final parsedValue =
                                            num.tryParse(value) ?? 0;

                                        currentLDLValue = parsedValue.clamp(
                                            0, double.infinity);

                                        if (currentLDLValue == 0) {
                                          errorMessage =
                                              "Giá trị không được để trống hoặc bằng 0.";
                                        } else {
                                          errorMessage = null;
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.textPrimary,
                                    width: 1.5,
                                  ),
                                  color: AppColors.bgColor,
                                ),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        backgroundColor: AppColors.bgColor,
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          return Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.8, // 80% of screen height
                                            padding: EdgeInsets.all(16),
                                            child: LDLInformationDialog(),
                                          );
                                        },
                                      );
                                    },
                                    child: Icon(
                                      Icons.question_mark_sharp,
                                      color: AppColors.textPrimary,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
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
                          "Triglycerides",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondaryColor),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width *
                                  0.5, // Half of screen width
                              child: Row(
                                children: [
                                  Expanded(
                                      child: HealthInput(
                                    controller: _tgController,
                                    focusNode: tgFocusNode,
                                    onChanged: (value) {
                                      setState(() {
                                        final parsedValue =
                                            num.tryParse(value) ?? 0;

                                        currentTGValue = parsedValue.clamp(
                                            0, double.infinity);

                                        if (currentTGValue == 0) {
                                          errorMessage =
                                              "Giá trị không được để trống hoặc bằng 0.";
                                        } else {
                                          errorMessage = null;
                                        }
                                      });
                                    },
                                  )),
                                  SizedBox(width: 10),
                                  Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.textPrimary,
                                        width: 1.5,
                                      ),
                                      color: AppColors.bgColor,
                                    ),
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            backgroundColor: AppColors.bgColor,
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (BuildContext context) {
                                              return Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.8, // 80% of screen height
                                                padding: EdgeInsets.all(16),
                                                child:
                                                    TriglyceridesInformationDialog(),
                                              );
                                            },
                                          );
                                        },
                                        child: Icon(
                                          Icons.question_mark_sharp,
                                          color: AppColors.textPrimary,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Toàn phần",
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
                                child: HealthInput(
                                  controller: _tcController,
                                  focusNode: tcFocusNode,
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        final parsedValue =
                                            num.tryParse(value) ?? 0;

                                        currentTCValue = parsedValue.clamp(
                                            0, double.infinity);

                                        if (currentTCValue == 0) {
                                          errorMessage =
                                              "Giá trị không được để trống hoặc bằng 0.";
                                        } else {
                                          errorMessage = null;
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.textPrimary,
                                    width: 1.5,
                                  ),
                                  color: AppColors.bgColor,
                                ),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          return Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.8, // 80% of screen height
                                            padding: EdgeInsets.all(16),
                                            child:
                                                TotalCholesterolInformationDialog(),
                                          );
                                        },
                                      );
                                    },
                                    child: Icon(
                                      Icons.question_mark_sharp,
                                      color: AppColors.textPrimary,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "*Các chỉ số được tính theo đơn vị",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        Text(
                          "mmol/L",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
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
                  onPressed: (_tcController.text.isEmpty ||
                          _tgController.text.isEmpty ||
                          _ldlController.text.isEmpty ||
                          _hdlController.text.isEmpty ||
                          double.tryParse(_tcController.text) == 0.0 ||
                          double.tryParse(_tgController.text) == 0.0 ||
                          double.tryParse(_ldlController.text) == 0.0 ||
                          double.tryParse(_hdlController.text) == 0.0)
                      ? null // Disable button
                      : () {
                          // Format values to two decimal places
                          final formattedTCValue =
                              double.parse(currentTCValue.toStringAsFixed(2));
                          final formattedTGValue =
                              double.parse(currentTGValue.toStringAsFixed(2));
                          final formattedLDLValue =
                              double.parse(currentLDLValue.toStringAsFixed(2));
                          final formattedHDLValue =
                              double.parse(currentHDLValue.toStringAsFixed(2));

                          // Pass formatted values to onSubmit
                          widget.onSubmit(
                            formattedTCValue,
                            formattedTGValue,
                            formattedLDLValue,
                            formattedHDLValue,
                          );
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
