import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sep490/features/lipid_profile/widgets/lipid_profile_display_widget.dart';
import 'package:sep490/features/lipid_profile/widgets/lipid_profile_input_widget.dart';
import 'package:sep490/theme/color.dart';

class AddLipidProfileScreen extends StatefulWidget {
  final String? date;
  final num currentTCValue; // TC (cholesterol toàn phần)
  final num currentTGValue; // TG (triglyceride)
  final num currentLDLValue; // LDL (low-density lipoprotein)
  final num currentHDLValue; // HDL (high-density lipoprotein)
  final bool showLipidProfileWidget;
  final bool isDraft;
  final bool? canEdit;
  final String? id;
  final String? dataType;
  const AddLipidProfileScreen({
    super.key,
    this.date,
    required this.currentTCValue,
    required this.currentTGValue,
    required this.currentLDLValue,
    required this.currentHDLValue,
    required this.showLipidProfileWidget,
    required this.isDraft,
    this.canEdit,
    this.id,
    this.dataType,
  });

  @override
  State<AddLipidProfileScreen> createState() => _AddLipidProfileScreenState();
}

class _AddLipidProfileScreenState extends State<AddLipidProfileScreen> {
  late String formattedDateTime;
  late num currentTCValue;
  late num currentTGValue;
  late num currentLDLValue;
  late num currentHDLValue;
  late bool showLipidProfileWidget;
  late bool isDraft;
  @override
  void initState() {
    super.initState();
    // formattedDateTime = DateFormat('dd-MM-yyyy').format(DateTime.now());
    formattedDateTime = widget.date != null
        ? widget.date!
        : DateFormat('dd-MM-yyyy').format(DateTime.now());
    currentTCValue = widget.currentTCValue;
    currentTGValue = widget.currentTGValue;
    currentLDLValue = widget.currentLDLValue;
    currentHDLValue = widget.currentHDLValue;
    showLipidProfileWidget = widget.showLipidProfileWidget;
    isDraft = widget.isDraft;
  }

  void onEdit() {
    setState(() {
      showLipidProfileWidget = false;
    });
  }

  void onSubmit(
    num updatedTCValue,
    num updateTGValue,
    num updateLDLValue,
    num updateHDLValue,
  ) {
    print(
        "chỉ số mỡ máu  $updatedTCValue $updateTGValue $updateLDLValue $updateHDLValue ");
    setState(() {
      currentTCValue = updatedTCValue;
      currentTGValue = updateTGValue;
      currentLDLValue = updateLDLValue;
      currentHDLValue = updateHDLValue;
      showLipidProfileWidget = true;

      isDraft = updatedTCValue != widget.currentTCValue ||
          updateTGValue != widget.currentTGValue ||
          updateHDLValue != widget.currentHDLValue ||
          updateLDLValue != widget.currentLDLValue;
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
                "assets/img3D/treatment_medical/momau.webp",
                width: 10,
                height: 10,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Text(
          "Mỡ máu",
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
      // body: showLipidProfileWidget
      //     ? LipidProfileDisplayWidget(
      //         tcValue: currentTCValue,
      //         tgValue: currentTGValue,
      //         ldlValue: currentLDLValue,
      //         hdlValue: currentHDLValue,
      //         typeData: "Thủ công",
      //         isDraft: isDraft,
      //         dateTime: formattedDateTime,
      //         onEdit: onEdit,
      //       )
      //     : LipidProfileInputWidget(
      //         dateTime: formattedDateTime,
      //         initialTCValue: currentTCValue,
      //         initialTGValue: currentTGValue,
      //         initialLDLValue: currentLDLValue,
      //         initialHDLValue: currentHDLValue,
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
        child: showLipidProfileWidget
            ? LipidProfileDisplayWidget(
                key: ValueKey<bool>(showLipidProfileWidget),
                tcValue: currentTCValue,
                tgValue: currentTGValue,
                ldlValue: currentLDLValue,
                hdlValue: currentHDLValue,
                typeData: widget.dataType ?? "Thủ công",
                id: widget.id,
                isDraft: isDraft,
                dateTime: formattedDateTime,
                onEdit: onEdit,
                canEdit: widget.canEdit ?? true,
              )
            : LipidProfileInputWidget(
                key: ValueKey<bool>(showLipidProfileWidget),
                dateTime: formattedDateTime,
                initialTCValue: currentTCValue,
                initialTGValue: currentTGValue,
                initialLDLValue: currentLDLValue,
                initialHDLValue: currentHDLValue,
                onSubmit: onSubmit,
              ),
      ),
    );
  }
}
