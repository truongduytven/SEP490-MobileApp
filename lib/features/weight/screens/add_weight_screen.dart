import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sep490/features/weight/widgets/weight_display_widget.dart';
import 'package:sep490/features/weight/widgets/weight_picker_widget_state.dart';
import 'package:sep490/theme/color.dart';

class AddWeight extends StatefulWidget {
  final num currentValue;
  final bool showWeightWidget;
  final bool isDraft;
  final String? date;
  final String? id;
  final String? dataType;

  const AddWeight({
    super.key,
    required this.currentValue,
    required this.showWeightWidget,
    required this.isDraft,
    this.date,
    this.id,
    this.dataType,
  });

  @override
  State<AddWeight> createState() => _AddWeightState();
}

class _AddWeightState extends State<AddWeight> {
  late String formattedDateTime;
  late String date;
  late num currentValue;
  late bool showWeightWidget;
  late bool isDraft;
  @override
  void initState() {
    super.initState();
    // formattedDateTime =  DateFormat('dd-MM-yyyy').format(DateTime.now());
    formattedDateTime = widget.date != null
        ? widget.date!
        : DateFormat('dd-MM-yyyy').format(DateTime.now());
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
      isDraft = updatedValue != widget.currentValue;
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
      // body: showWeightWidget
      //     ? WeightDisplayWidget(
      //         isDraft: isDraft,
      //         typeData: widget.dataType ?? "Thủ công",
      //         dateTime: formattedDateTime,
      //         weight: currentValue,
      //         onEdit: onEdit,
      //         id: widget.id,
      //       )
      //     : WeightPickerWidget(
      //         dateTime: formattedDateTime,
      //         initialValue: currentValue,
      //         onSubmit: onSubmit,
      //       ),

      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          );

          return FadeTransition(
            opacity: curvedAnimation,
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 0.85,
                end: 1.0,
              ).animate(curvedAnimation),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0, 0.1),
                  end: Offset(0, 0),
                ).animate(curvedAnimation),
                child: child,
              ),
            ),
          );
        },
        child: showWeightWidget
            ? WeightDisplayWidget(
                key: ValueKey<bool>(showWeightWidget),
                isDraft: isDraft,
                typeData: widget.dataType ?? "Thủ công",
                dateTime: formattedDateTime,
                weight: currentValue,
                onEdit: onEdit,
                id: widget.id,
              )
            : WeightPickerWidget(
                key: ValueKey<bool>(showWeightWidget),
                dateTime: formattedDateTime,
                initialValue: currentValue,
                onSubmit: onSubmit,
              ),
      ),
    );
  }
}
