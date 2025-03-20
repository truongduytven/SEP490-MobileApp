import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sep490/features/kidney_function/widgets/bun_information_dialog.dart';
import 'package:sep490/features/kidney_function/widgets/egfr_information_dialog.dart';
import 'package:sep490/features/kidney_function/widgets/gfr_information_dialog.dart';
import 'package:sep490/presentation/widgets/health/health_input.dart';
import 'package:sep490/features/lipid_profile/widgets/hdl_information_dialog.dart';
import 'package:sep490/features/lipid_profile/widgets/ldl_information_dialog.dart';
import 'package:sep490/features/lipid_profile/widgets/total_cholesterol_information_dialog.dart';
import 'package:sep490/features/lipid_profile/widgets/triglycerides_information_dialog.dart';
import 'package:sep490/presentation/widgets/health/liverEnzymes/liver_enzymes_information_dialog.dart';
import 'package:sep490/theme/color.dart';

class LiverEnzymesInputWidget extends StatefulWidget {
  final num initialALTValue;
  final num initialALPValue;
  final num initialASTValue;
  final num initialGGTValue;
  final String dateTime;
  final void Function(num, num, num, num) onSubmit;

  const LiverEnzymesInputWidget({
    super.key,
    required this.initialALTValue,
    required this.initialALPValue,
    required this.initialASTValue,
    required this.initialGGTValue,
    required this.dateTime,
    required this.onSubmit,
  });

  @override
  State<LiverEnzymesInputWidget> createState() =>
      _LiverEnzymesInputWidgetState();
}

class _LiverEnzymesInputWidgetState extends State<LiverEnzymesInputWidget> {
  late TextEditingController _altController;
  late TextEditingController _alpController;
  late TextEditingController _astController;
  late TextEditingController _ggtController;
  final FocusNode altFocusNode = FocusNode();
  final FocusNode alpFocusNode = FocusNode();
  final FocusNode astFocusNode = FocusNode();
  final FocusNode ggtFocusNode = FocusNode();
  late num currentALTValue;
  late num currentALPValue;
  late num currentASTValue;
  late num currentGGTValue;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    currentALTValue = widget.initialALTValue;
    currentALPValue = widget.initialALPValue;
    currentASTValue = widget.initialASTValue;
    currentGGTValue = widget.initialGGTValue;

    _altController = TextEditingController(
        text: widget.initialALTValue > 0
            ? widget.initialALTValue.toString()
            : "");
    _alpController = TextEditingController(
        text: widget.initialALPValue > 0
            ? widget.initialALPValue.toString()
            : "");
    _astController = TextEditingController(
        text: widget.initialASTValue > 0
            ? widget.initialASTValue.toString()
            : "");
    _ggtController = TextEditingController(
        text: widget.initialGGTValue > 0
            ? widget.initialGGTValue.toString()
            : "");

    altFocusNode.addListener(() {
      setState(() {});
    });
    alpFocusNode.addListener(() {
      setState(() {});
    });
    astFocusNode.addListener(() {
      setState(() {});
    });
    ggtFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _altController.dispose();
    _alpController.dispose();
    _astController.dispose();
    _ggtController.dispose();
    altFocusNode.dispose();
    alpFocusNode.dispose();
    astFocusNode.dispose();
    ggtFocusNode.dispose();
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
                          "ALT",
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
                                  controller: _altController,
                                  focusNode: altFocusNode,
                                  onChanged: (value) {
                                    setState(() {
                                      final parsedValue =
                                          num.tryParse(value) ?? 0;

                                      currentALTValue =
                                          parsedValue.clamp(0, double.infinity);

                                      if (currentALTValue == 0) {
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
                                            child:
                                                LiverEnzymesInformationDialog(),
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
                          "ALP",
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
                                  controller: _alpController,
                                  focusNode: alpFocusNode,
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        final parsedValue =
                                            num.tryParse(value) ?? 0;

                                        currentALPValue = parsedValue.clamp(
                                            0, double.infinity);

                                        if (currentALPValue == 0) {
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
                                            child:
                                                LiverEnzymesInformationDialog(),
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
                          "AST",
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
                                    controller: _astController,
                                    focusNode: astFocusNode,
                                    onChanged: (value) {
                                      setState(() {
                                        final parsedValue =
                                            num.tryParse(value) ?? 0;

                                        currentASTValue = parsedValue.clamp(
                                            0, double.infinity);

                                        if (currentASTValue == 0) {
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
                                                    LiverEnzymesInformationDialog(),
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
                          "GGT",
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
                                  controller: _ggtController,
                                  focusNode: ggtFocusNode,
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        final parsedValue =
                                            num.tryParse(value) ?? 0;

                                        currentGGTValue = parsedValue.clamp(
                                            0, double.infinity);

                                        if (currentGGTValue == 0) {
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
                                                LiverEnzymesInformationDialog(),
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
                          "UI/L",
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
                  onPressed: (_altController.text.isEmpty ||
                          _alpController.text.isEmpty ||
                          _astController.text.isEmpty ||
                          _ggtController.text.isEmpty ||
                          double.tryParse(_altController.text) == 0.0 ||
                          double.tryParse(_alpController.text) == 0.0 ||
                          double.tryParse(_astController.text) == 0.0 ||
                          double.tryParse(_ggtController.text) == 0.0)
                      ? null // Disable button
                      : () {
                          // Format values to two decimal places
                          final formattedALTValue =
                              double.parse(currentALTValue.toStringAsFixed(2));
                          final formattedALPValue =
                              double.parse(currentALPValue.toStringAsFixed(2));
                          final formattedASTValue =
                              double.parse(currentASTValue.toStringAsFixed(2));
                          final formattedGGTValue =
                              double.parse(currentGGTValue.toStringAsFixed(2));

                          // Pass formatted values to onSubmit
                          widget.onSubmit(
                            formattedALTValue,
                            formattedALPValue,
                            formattedASTValue,
                            formattedGGTValue,
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
