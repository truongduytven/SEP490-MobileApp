import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sep490/presentation/widgets/health/height/height_card.dart';
import 'package:sep490/presentation/widgets/health/height/height_slider.dart';
import 'package:sep490/theme/color.dart';

class AddHeightScreen extends StatefulWidget {
  final num currentValue;
  final bool showHeightWidget;
  final bool isDraft;
  const AddHeightScreen({
    super.key,
    required this.currentValue,
    required this.showHeightWidget,
    required this.isDraft,
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
    formattedDateTime = DateFormat('dd-MM-yyyy').format(DateTime.now());
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
    setState(() {
      currentValue = updatedValue;
      showHeightWidget = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    int height = 170;
    return Scaffold(
        appBar: AppBar(
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
        body: showHeightWidget ? Text("Đay nè, chieu cao") : HeightCard());
    // HeightSlider(
    //     height: height,
    //     onChange: (val) => setState(() => height = val),
    //   ));
  }
}
