import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class BloodPressureInputWidget extends StatefulWidget {
  final num initialValueSystolic;
  final num initialValueDiastolic;
  final String dateTime;
  final ValueChanged<Map<String, num>> onSubmit;

  const BloodPressureInputWidget({
    required this.initialValueDiastolic,
    required this.initialValueSystolic,
    required this.dateTime,
    required this.onSubmit,
    super.key,
  });

  @override
  State<BloodPressureInputWidget> createState() =>
      _BloodPressureInputWidgetState();
}

class _BloodPressureInputWidgetState extends State<BloodPressureInputWidget> {
  late TextEditingController systolicController;
  late TextEditingController diastolicController;
  final FocusNode systolicFocusNode = FocusNode();
  final FocusNode diastolicFocusNode = FocusNode();

  String systolicLabel = "Tâm thu";
  String diastolicLabel = "Tâm trương";
  String systolicDescription = "Huyết áp tâm thu tính bằng mmHg (30~300)";
  String diastolicDescription = "Huyết áp tâm trương tính bằng mmHg (20~250)";

  String? systolicErrorMessage;
  String? diastolicErrorMessage;

  @override
  void initState() {
    super.initState();
    // systolicErrorMessage = "";
    // diastolicErrorMessage = "";

    systolicController = TextEditingController(
        text: widget.initialValueSystolic == 0
            ? ""
            : widget.initialValueSystolic.toString());
    diastolicController = TextEditingController(
        text: widget.initialValueDiastolic == 0
            ? ""
            : widget.initialValueDiastolic.toString());

    systolicFocusNode.addListener(() {
      setState(() {});
    });
    diastolicFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    systolicController.dispose();
    diastolicController.dispose();
    systolicFocusNode.dispose();
    diastolicFocusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final systolic = num.tryParse(systolicController.text) ?? 0;
    final diastolic = num.tryParse(diastolicController.text) ?? 0;

    widget.onSubmit({'systolic': systolic, 'diastolic': diastolic});
  }

  void _onValueChanged(String value, FocusNode currentFocus,
      FocusNode nextFocus, bool isSystolic) {
    if (isSystolic) {
      final systolicValue = num.tryParse(value);
      if (systolicValue == null || systolicValue < 30 || systolicValue > 300) {
        setState(() {
          systolicErrorMessage = 'Giá trị tâm thu không hợp lệ';
        });
      } else {
        setState(() {
          systolicErrorMessage = null;
        });
      }
    } else {
      final diastolicValue = num.tryParse(value);
      if (diastolicValue == null ||
          diastolicValue < 20 ||
          diastolicValue > 250) {
        setState(() {
          diastolicErrorMessage = 'Giá trị tâm trương không hợp lệ';
        });
      } else {
        setState(() {
          diastolicErrorMessage = null;
        });
      }
    }

    if (num.tryParse(value) != null &&
        num.tryParse(value)! > 30 &&
        num.tryParse(value)! < 300) {
      currentFocus.unfocus();
      FocusScope.of(context).requestFocus(nextFocus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
              ),
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
              const SizedBox(height: 40),
              // Row for Systolic and Diastolic input fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Systolic input
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: TextField(
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w600,
                                color: systolicFocusNode.hasFocus
                                    ? AppColors.primaryColor
                                    : AppColors.textColor),
                            showCursor: false,
                            controller: systolicController,
                            focusNode: systolicFocusNode,
                            keyboardType: TextInputType.number,
                            autofocus: true,
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical
                                .center, // Center text vertically
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.bgColor,
                              hintText: "---",
                              hintStyle: TextStyle(
                                fontSize: 40,
                                color: systolicFocusNode.hasFocus
                                    ? AppColors.primaryColor
                                    : AppColors
                                        .grayColor4, // Change color based on focus
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: const BorderSide(
                                    color: AppColors.grayColor1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: const BorderSide(
                                    width: 1.5, color: AppColors.primaryColor),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 25,
                                horizontal: 0,
                              ),
                            ),
                            onChanged: (value) => _onValueChanged(value,
                                systolicFocusNode, diastolicFocusNode, true),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          systolicLabel,
                          style: const TextStyle(
                              color: AppColors.textColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  // Diastolic input
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: TextField(
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w600,
                                color: diastolicFocusNode.hasFocus
                                    ? AppColors.primaryColor
                                    : AppColors.textColor),
                            showCursor: false,
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical
                                .center, // Center text vertically
                            controller: diastolicController,
                            focusNode: diastolicFocusNode,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.bgColor,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 25,
                                horizontal: 0,
                              ),
                              hintText: "---",
                              hintStyle: TextStyle(
                                fontSize: 40,
                                color: diastolicFocusNode.hasFocus
                                    ? AppColors.primaryColor
                                    : AppColors
                                        .grayColor4, // Change color based on focus
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: const BorderSide(
                                    color: AppColors.grayColor1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: const BorderSide(
                                    width: 1.5, color: AppColors.primaryColor),
                              ),
                            ),
                            onChanged: (value) => _onValueChanged(value,
                                diastolicFocusNode, systolicFocusNode, false),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          diastolicLabel,
                          style: const TextStyle(
                              color: AppColors.textColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (systolicFocusNode.hasFocus)
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    systolicDescription,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              if (diastolicFocusNode.hasFocus)
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    diastolicDescription,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              if (diastolicErrorMessage != null)
                Text(
                  diastolicErrorMessage!,
                  style: TextStyle(color: AppColors.errorColor, fontSize: 16),
                ),
              if (systolicErrorMessage != null)
                Text(
                  systolicErrorMessage!,
                  style: TextStyle(color: AppColors.errorColor, fontSize: 16),
                ),
              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: (num.tryParse(systolicController.text) != null &&
                              num.tryParse(systolicController.text)! >= 30 &&
                              num.tryParse(systolicController.text)! <= 300) &&
                          (num.tryParse(diastolicController.text) != null &&
                              num.tryParse(diastolicController.text)! >= 20 &&
                              num.tryParse(diastolicController.text)! <= 250)
                      ? _handleSubmit
                      : null,
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
          ),
        ),
      ),
    );
  }
}
