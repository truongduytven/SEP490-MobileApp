import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sep490/presentation/widgets/health/heartBeat/heart_beat_display_widget.dart';
import 'package:sep490/presentation/widgets/health/heartBeat/heart_beat_input_widget.dart';
import 'package:sep490/theme/color.dart';

class AddHeartBeatScreen extends StatefulWidget {
  final String? date;

  final num currentValue;
  final bool showHeartBeatWidget;
  final bool isDraft;
  const AddHeartBeatScreen({
    super.key,
    required this.currentValue,
    required this.showHeartBeatWidget,
    required this.isDraft,
    this.date,
  });

  @override
  State<AddHeartBeatScreen> createState() => _AddHeartBeatScreenState();
}

class _AddHeartBeatScreenState extends State<AddHeartBeatScreen> {
  late String formattedDateTime;
  late num currentValue;
  late bool showHeartBeatWidget;
  late bool isDraft;
  @override
  void initState() {
    super.initState();
    // formattedDateTime = DateFormat('dd-MM-yyyy').format(DateTime.now());
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
    print("chi so nhip tim $updatedValue");
    setState(() {
      currentValue = updatedValue;
      showHeartBeatWidget = true;
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
                "assets/img3D/nhiptim.png",
                width: 10,
                height: 10,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Text(
          "Nhịp tim",
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
      body: showHeartBeatWidget
          ? HeartBeatDisplayWidget(
              isDraft: isDraft,
              typeData: "Thủ công",
              dateTime: formattedDateTime,
              heartBeat: currentValue,
              onEdit: onEdit,
            )
          : HeartBeatInputWidget(
              dateTime: formattedDateTime,
              initialValue: currentValue,
              onSubmit: onSubmit,
            ),
    );
  }
}
