import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sep490/features/blood_oxygen/widgets/blood_oxygen_display.dart';
import 'package:sep490/features/heart_beat/widgets/heart_beat_input_widget.dart';
import 'package:sep490/theme/color.dart';

class AddBloodOxygen extends StatefulWidget {
  final String? date;

  final num currentValue;
  final bool showHeartBeatWidget;
  final bool isDraft;
  final String? id;
  final String? dataType;
  final bool? canEdit;

  const AddBloodOxygen({
    super.key,
    required this.currentValue,
    required this.showHeartBeatWidget,
    required this.isDraft,
    this.date,
    this.id,
    this.dataType,
    this.canEdit,
  });

  @override
  State<AddBloodOxygen> createState() => _AddBloodOxygenState();
}

class _AddBloodOxygenState extends State<AddBloodOxygen> {
  late String formattedDateTime;
  late num currentValue;
  late bool showHeartBeatWidget;
  late bool isDraft;
  @override
  void initState() {
    super.initState();
    formattedDateTime = widget.date != null
        ? widget.date!
        : DateFormat('dd-MM-yyyy').format(DateTime.now());
    currentValue = widget.currentValue;
    showHeartBeatWidget = widget.showHeartBeatWidget;
    isDraft = widget.isDraft;
  }

  void onEdit() {
    setState(() {
      showHeartBeatWidget = false;
    });
  }

  void onSubmit(num updatedValue) {
    setState(() {
      currentValue = updatedValue;
      showHeartBeatWidget = true;
      isDraft = updatedValue != widget.currentValue;
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
                "assets/img3D/oxy_mau.png",
                width: 10,
                height: 10,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Text(
          "Oxy trong máu",
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
        child: showHeartBeatWidget
            ? BloodOxygenDisplay(
                key: ValueKey<bool>(showHeartBeatWidget),
                isDraft: isDraft,
                typeData: widget.dataType ?? "Thủ công",
                dateTime: formattedDateTime,
                bloodOxygen: currentValue,
                onEdit: onEdit,
                id: widget.id,
                canEdit: widget.canEdit ?? true,
              )
            : HeartBeatInputWidget(
                key: ValueKey<bool>(showHeartBeatWidget),
                dateTime: formattedDateTime,
                initialValue: currentValue,
                onSubmit: onSubmit,
              ),
      ),
    );
  }
}
