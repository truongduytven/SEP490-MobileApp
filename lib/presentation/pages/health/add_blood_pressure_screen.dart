import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sep490/presentation/widgets/health/bloodPressure/blood_pressure_display_widget.dart';
import 'package:sep490/presentation/widgets/health/bloodPressure/blood_pressure_input_widget.dart';
import 'package:sep490/theme/color.dart';

class AddBloodPressureScreen extends StatefulWidget {
  final num currentValueSystolic;
  final num currentValueDiastolic;
  final bool showBloodPressuretWidget;
  final bool isDraft;

  const AddBloodPressureScreen({
    super.key,
    required this.currentValueSystolic,
    required this.currentValueDiastolic,
    required this.showBloodPressuretWidget,
    required this.isDraft,
  });

  @override
  State<AddBloodPressureScreen> createState() => _AddBloodPressureScreenState();
}

class _AddBloodPressureScreenState extends State<AddBloodPressureScreen> {
  late String formattedDateTime;
  late num currentValueSystolic;
  late num currentValueDiastolic;
  late bool showBloodPressuretWidget;
  late bool isDraft;

  @override
  void initState() {
    super.initState();
    formattedDateTime = DateFormat('dd-MM-yyyy').format(DateTime.now());
    currentValueSystolic = widget.currentValueSystolic;
    currentValueDiastolic = widget.currentValueDiastolic;
    showBloodPressuretWidget = widget.showBloodPressuretWidget;
    isDraft = widget.isDraft;
  }

  /// Switch to edit mode (hide display widget, show input widget).
  void onEdit() {
    setState(() {
      showBloodPressuretWidget = false;
    });
  }

  /// Update values and switch back to display mode.
  void onSubmit(Map<String, num> updatedValues) {
    setState(() {
      currentValueSystolic = updatedValues['systolic'] ?? currentValueSystolic;
      currentValueDiastolic =
          updatedValues['diastolic'] ?? currentValueDiastolic;
      showBloodPressuretWidget = true;
      print('gia tri huyet ap $currentValueSystolic $currentValueDiastolic');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              "assets/img3D/huyetap.png",
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          "Huyết áp",
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
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      body: showBloodPressuretWidget
          ? BloodPressureDisplayWidget(
              isDraft: isDraft,
              typeData: "Thủ công",
              systolic: currentValueSystolic,
              diastolic: currentValueDiastolic,
              dateTime: formattedDateTime,
              onEdit: onEdit,
            )
          : BloodPressureInputWidget(
              initialValueSystolic: currentValueSystolic,
              initialValueDiastolic: currentValueDiastolic,
              dateTime: formattedDateTime,
              onSubmit: onSubmit,
            ),
    );
  }
}
