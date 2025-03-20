import 'package:flutter/material.dart';
import 'package:sep490/features/height/widgets/height_picker.dart';
import 'package:sep490/features/height/widgets/widget_utils.dart';
import 'package:sep490/theme/color.dart';

class HeightCard extends StatefulWidget {
  final double? height;
  final void Function(double)
      onSubmit; // Callback function for submitting the height

  const HeightCard({Key? key, this.height, required this.onSubmit})
      : super(key: key);

  @override
  HeightCardState createState() => HeightCardState();
}

class HeightCardState extends State<HeightCard> {
  late double height;

  @override
  void initState() {
    super.initState();
    // Initialize height as a double with the value passed from the widget
    height = widget.height ?? 170.0;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 300.0,
        maxHeight: 800.0,
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: screenAwareSize(16.0, context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Kéo thanh trượt lên xuống để xác định chiều cao chính xác",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(screenAwareSize(8.0, context)),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final double maxHeight = constraints.maxHeight > 0
                              ? constraints.maxHeight
                              : 300.0;

                          return HeightPicker(
                            widgetHeight: maxHeight,
                            height: height,
                            onChange: (val) => setState(() => height = val),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                widget.onSubmit(height);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryColor,
                padding: EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                'Tiếp tục',
                style: TextStyle(
                  fontSize: 28,
                  color: AppColors.bgColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
