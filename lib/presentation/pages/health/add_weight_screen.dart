import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sep490/presentation/widgets/health/weight/weight_display_widget.dart';
import 'package:sep490/presentation/widgets/health/weight/weight_picker_widget_state.dart';
import 'package:sep490/theme/color.dart';

class AddWeight extends StatefulWidget {
  final num currentValue;
  final bool showWeightWidget;
  final bool isDraft;
  const AddWeight(
      {super.key,
      required this.currentValue,
      required this.showWeightWidget,
      required this.isDraft});

  @override
  State<AddWeight> createState() => _AddWeightState();
}

class _AddWeightState extends State<AddWeight> {
  late String formattedDateTime;
  late num currentValue;
  late bool showWeightWidget;
  late bool isDraft;
  @override
  void initState() {
    super.initState();
    formattedDateTime = DateFormat('dd-MM-yyyy').format(DateTime.now());
    currentValue = widget.currentValue;
    showWeightWidget = widget.showWeightWidget;
    isDraft = widget.isDraft;
  }

  void onEdit() {
    setState(() {
      showWeightWidget = false;
    });
  }

  void onSubmit(num updatedValue) {
    setState(() {
      currentValue = updatedValue;
      showWeightWidget = true;
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
              "assets/img3D/cannang.png",
              width: 45,
              height: 45,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          "Cân nặng",
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
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      body: showWeightWidget
          ? WeightDisplayWidget(
            
              isDraft: isDraft,
              typeData: "Thủ công",
              height: 170,
              dateTime: formattedDateTime,
              weight: currentValue,
              onEdit: onEdit,
            )
          : WeightPickerWidget(
              dateTime: formattedDateTime,
              initialValue: currentValue,
              onSubmit: onSubmit,
            ),
    );
  }
}
