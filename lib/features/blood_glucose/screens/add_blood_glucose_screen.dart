import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sep490/features/blood_glucose/widgets/blood_glucose_display_widget.dart';
import 'package:sep490/features/blood_glucose/widgets/blood_glucose_input_widget.dart';
import 'package:sep490/theme/color.dart';

class AddBloodGlucoseScreen extends StatefulWidget {
  final String? date;
  final String period;
  final num currentBloodGlucoseValue;
  final bool showBloodGlucoseWidget;
  final bool isDraft;
  const AddBloodGlucoseScreen({
    super.key,
    required this.currentBloodGlucoseValue,
    required this.showBloodGlucoseWidget,
    required this.isDraft,
    required this.period,
    this.date,
  });

  @override
  State<AddBloodGlucoseScreen> createState() => _AddBloodGlucoseScreenState();
}

class _AddBloodGlucoseScreenState extends State<AddBloodGlucoseScreen> {
  late String formattedDateTime;
  late String currentperiod;
  late num currentBloodGlucoseValue;
  late bool showBloodGlucoseWidget;
  late bool isDraft;
  @override
  void initState() {
    super.initState();
    // formattedDateTime = DateFormat('dd-MM-yyyy').format(DateTime.now());
    formattedDateTime = widget.date != null
        ? widget.date!
        : DateFormat('dd-MM-yyyy').format(DateTime.now());
    currentBloodGlucoseValue = widget.currentBloodGlucoseValue;
    showBloodGlucoseWidget = widget.showBloodGlucoseWidget;
    isDraft = widget.isDraft;
    currentperiod = widget.period;
  }

  void onEdit() {
    setState(() {
      showBloodGlucoseWidget = false;
    });
  }

  void onSubmit(num updatedValue, String period) {
    print("period $period");
    print("chi so đường huyết $updatedValue");
    setState(() {
      currentBloodGlucoseValue = updatedValue;
      currentperiod = period;
      showBloodGlucoseWidget = true;
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
                  "assets/img3D/treatment_medical/tieuduong.png",
                  width: 10,
                  height: 10,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          title: Text(
            "Đường huyết",
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
        body: showBloodGlucoseWidget
            ? BloodGlucoseDisplayWidget(
                typeData: "Thủ công",
                isDraft: isDraft,
                period: currentperiod,
                dateTime: formattedDateTime,
                bloodGlucose: currentBloodGlucoseValue,
                onEdit: onEdit,
              )
            : BloodGlucoseInputWidget(
                dateTime: formattedDateTime,
                initialValue: currentBloodGlucoseValue,
                period: currentperiod,
                onSubmit: onSubmit,
              ));
    // Text("Input blood glucose"));
  }
}
