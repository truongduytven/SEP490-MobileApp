import 'package:flutter/material.dart';
import 'package:sep490/presentation/widgets/health/height/height_picker.dart';
import 'package:sep490/presentation/widgets/health/height/widget_utils.dart';
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
      constraints: BoxConstraints(
        minHeight: 300.0, // Added a minimum height constraint
        maxHeight: 700.0, // Keeping the maximum height constraint as is
      ),
      child: Card(
        elevation: 3,
        color: AppColors.bgColor,
        child: Padding(
          padding: EdgeInsets.only(top: screenAwareSize(16.0, context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                textAlign: TextAlign.center,
                "Kéo thanh trượt lên xuống để xác định chiều cao chính xác",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(screenAwareSize(8.0, context)),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Ensure we have valid constraints
                      final double maxHeight = constraints.maxHeight > 0
                          ? constraints.maxHeight
                          : 300.0; // Use fallback value
                      final double maxWidth = constraints.maxWidth > 0
                          ? constraints.maxWidth
                          : 400.0; // Fallback for width

                      return HeightPicker(
                        widgetHeight: maxHeight,
                        height: height,
                        onChange: (val) => setState(() => height = val),
                      );
                    },
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.onSubmit(height); // Notify parent of updated height
                },
                child: const Text("Xác nhận"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
