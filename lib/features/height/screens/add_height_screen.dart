import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sep490/features/height/widgets/height_card.dart';
import 'package:sep490/features/height/widgets/height_display_widget.dart';
import 'package:sep490/theme/color.dart';

class AddHeightScreen extends StatefulWidget {
  final String? date;

  final num currentValue;
  final bool showHeightWidget;
  final bool isDraft;
  final String? id;
  final String? dataType;
  const AddHeightScreen({
    super.key,
    required this.currentValue,
    required this.showHeightWidget,
    required this.isDraft,
    this.date,
    this.id,
    this.dataType,
  });

  @override
  State<AddHeightScreen> createState() => _AddHeightScreenState();
}

class _AddHeightScreenState extends State<AddHeightScreen> {
  late String formattedDateTime;

  late num currentValue;
  late bool showHeightWidget;
  late bool isDraft;
  @override
  void initState() {
    super.initState();
    // formattedDateTime = DateFormat('dd-MM-yyyy').format(DateTime.now());
    formattedDateTime = widget.date != null
        ? widget.date!
        : DateFormat('dd-MM-yyyy').format(DateTime.now());
    currentValue = widget.currentValue;
    showHeightWidget = widget.showHeightWidget;
    isDraft = widget.isDraft;
  }

  void onEdit() {
    setState(() {
      showHeightWidget = false;
    });
  }

  void onSubmit(num updatedValue) {
    print("chieu cao ne $updatedValue");
    setState(() {
      currentValue = updatedValue;
      showHeightWidget = true;
      isDraft = updatedValue != widget.currentValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              "assets/img3D/chieucao.png",
              width: 45,
              height: 45,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          "Chiều cao",
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
      backgroundColor: AppColors.bgColor,
      // body: showHeightWidget
      //     ? HeightDisplayWidget(
      //         // weight: 50,
      //         height: currentValue,
      //         dateTime: formattedDateTime,
      //         onEdit: onEdit,
      //         isDraft: isDraft,
      //         typeData: "Thủ công")
      //     : HeightCard(
      //         height: currentValue.toDouble(),
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
        child: showHeightWidget
            ? HeightDisplayWidget(
                key: ValueKey<bool>(showHeightWidget),

                // weight: 50,
                height: currentValue,
                dateTime: formattedDateTime,
                onEdit: onEdit,
                isDraft: isDraft,
                typeData: widget.dataType ?? "Thủ công",
                id: widget.id,
              )
            : HeightCard(
                key: ValueKey<bool>(showHeightWidget),
                height: currentValue.toDouble(),
                onSubmit: onSubmit,
              ),
      ),
    );
  }
}
