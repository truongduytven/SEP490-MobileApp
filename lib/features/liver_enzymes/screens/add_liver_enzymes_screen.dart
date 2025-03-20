import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sep490/features/liver_enzymes/widgets/liver_enzymes_display_widget.dart';
import 'package:sep490/features/liver_enzymes/widgets/liver_enzymes_input_widget.dart';
import 'package:sep490/theme/color.dart';

class AddLiverEnzymesScreen extends StatefulWidget {
  final String? date;
  final num currentALTValue;
  final num currentALPValue;
  final num currentASTValue;
  final num currentGGTValue;
  final bool showLiverEnzymesWidget;
  final bool isDraft;
  const AddLiverEnzymesScreen({
    super.key,
    this.date,
    required this.currentALTValue,
    required this.currentALPValue,
    required this.currentASTValue,
    required this.currentGGTValue,
    required this.showLiverEnzymesWidget,
    required this.isDraft,
  });

  @override
  State<AddLiverEnzymesScreen> createState() => _AddLiverEnzymesScreenState();
}

class _AddLiverEnzymesScreenState extends State<AddLiverEnzymesScreen> {
  late String formattedDateTime;
  late num currentALTValue;
  late num currentALPValue;
  late num currentASTValue;
  late num currentGGTValue;
  late bool showLiverEnzymesWidget;
  late bool isDraft;
  @override
  void initState() {
    super.initState();
    // formattedDateTime = DateFormat('dd-MM-yyyy').format(DateTime.now());
    formattedDateTime = widget.date != null
        ? widget.date!
        : DateFormat('dd-MM-yyyy').format(DateTime.now());
    currentALTValue = widget.currentALTValue;
    currentALPValue = widget.currentALPValue;
    currentASTValue = widget.currentASTValue;
    currentGGTValue = widget.currentGGTValue;
    showLiverEnzymesWidget = widget.showLiverEnzymesWidget;
    isDraft = widget.isDraft;
  }

  void onEdit() {
    setState(() {
      showLiverEnzymesWidget = false;
    });
  }

  void onSubmit(
    num updateALTValue,
    num updateALPValue,
    num updateASTValue,
    num updateGGTValue,
  ) {
    print(
        "chỉ số men gan  $updateALTValue $updateALPValue $updateASTValue $updateGGTValue ");
    setState(() {
      currentALTValue = updateALTValue;
      currentALPValue = updateALPValue;
      currentASTValue = updateASTValue;
      currentGGTValue = updateGGTValue;
      showLiverEnzymesWidget = true;
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
                "assets/img3D/treatment_medical/gan.png",
                width: 10,
                height: 10,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Text(
          "Men gan",
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
      body: showLiverEnzymesWidget
          ? LiverEnzymesDisplayWidget(
              altValue: currentALTValue,
              alpValue: currentALPValue,
              astValue: currentASTValue,
              ggtValue: currentGGTValue,
              typeData: "Thủ công",
              isDraft: isDraft,
              dateTime: formattedDateTime,
              onEdit: onEdit,
            )
          : LiverEnzymesInputWidget(
              dateTime: formattedDateTime,
              initialALTValue: currentALTValue,
              initialALPValue: currentALPValue,
              initialASTValue: currentASTValue,
              initialGGTValue: currentGGTValue,
              onSubmit: onSubmit,
            ),
    );
  }
}
