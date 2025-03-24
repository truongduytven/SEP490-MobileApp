import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sep490/features/blood_glucose/widgets/blood_glucose_display_widget.dart';
import 'package:sep490/features/blood_glucose/widgets/blood_glucose_input_widget.dart';
import 'package:sep490/features/kidney_function/widgets/kidney_function_display_widget.dart';
import 'package:sep490/features/kidney_function/widgets/kidney_function_input_widget.dart';
import 'package:sep490/theme/color.dart';

class AddKidneyFunctionScreen extends StatefulWidget {
  final String? date;
  final num currentBUNValue;
  final num currenteGFRValue;
  final num currentGFRValue;
  final bool showKidneyFunctionWidget;
  final bool isDraft;
  const AddKidneyFunctionScreen({
    super.key,
    this.date,
    required this.currentBUNValue,
    required this.currenteGFRValue,
    required this.currentGFRValue,
    required this.showKidneyFunctionWidget,
    required this.isDraft,
  });

  @override
  State<AddKidneyFunctionScreen> createState() =>
      _AddKidneyFunctionScreenState();
}

class _AddKidneyFunctionScreenState extends State<AddKidneyFunctionScreen> {
  late String formattedDateTime;
  late num currentBUNValue;
  late num currenteGFRValue;
  late num currentGFRValue;
  late bool showKidneyFunctionWidget;
  late bool isDraft;
  @override
  void initState() {
    super.initState();
    // formattedDateTime = DateFormat('dd-MM-yyyy').format(DateTime.now());
    formattedDateTime = widget.date != null
        ? widget.date!
        : DateFormat('dd-MM-yyyy').format(DateTime.now());
    currentBUNValue = widget.currentBUNValue;
    currenteGFRValue = widget.currenteGFRValue;
    currentGFRValue = widget.currentGFRValue;
    showKidneyFunctionWidget = widget.showKidneyFunctionWidget;
    isDraft = widget.isDraft;
  }

  void onEdit() {
    setState(() {
      showKidneyFunctionWidget = false;
    });
  }

  void onSubmit(num updatedBUNValue, num updateeGFRValue, num updateGFRValue) {
    print("chi so thận  $updatedBUNValue $updateeGFRValue $updateGFRValue ");
    setState(() {
      currentBUNValue = updatedBUNValue;
      currenteGFRValue = updateeGFRValue;
      currentGFRValue = updateGFRValue;
      showKidneyFunctionWidget = true;
      isDraft = updatedBUNValue != widget.currentBUNValue ||
          updateeGFRValue != widget.currenteGFRValue ||
          updateGFRValue != widget.currentGFRValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5),
            child: SizedBox(
              width: 10,
              height: 10,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  "assets/img3D/treatment_medical/than.png",
                  width: 10,
                  height: 10,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          title: Text(
            "Chức năng thận",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
              color: AppColors.secondaryColor,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
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
                  FocusScope.of(context).unfocus();
                  Future.delayed(Duration(milliseconds: 500), () {
                    Navigator.pop(context);
                  });
                },
              ),
            ),
          ],
        ),
        body: showKidneyFunctionWidget
            ? KidneyFunctionDisplayWidget(
                typeData: "Thủ công",
                isDraft: isDraft,
                bunValue: currentBUNValue,
                gfrValue: currentGFRValue,
                egfrValue: currenteGFRValue,
                dateTime: formattedDateTime,
                onEdit: onEdit,
              )
            : KidneyFunctionInputWidget(
                dateTime: formattedDateTime,
                initialBUNValue: currentBUNValue,
                initialeGFRValue: currenteGFRValue,
                initialGFRValue: currentGFRValue,
                onSubmit: onSubmit,
              ));
  }
}
