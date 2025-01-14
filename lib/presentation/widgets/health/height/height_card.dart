import 'package:flutter/material.dart';
import 'package:sep490/presentation/widgets/health/height/card_title.dart';
import 'package:sep490/presentation/widgets/health/height/height_picker.dart';
import 'package:sep490/presentation/widgets/health/height/widget_utils.dart';

class HeightCard extends StatefulWidget {
  final int? height;

  const HeightCard({Key? key, this.height}) : super(key: key);

  @override
  HeightCardState createState() => HeightCardState();
}

class HeightCardState extends State<HeightCard> {
  late int height;

  @override
  void initState() {
    super.initState();
    height = widget.height ?? 170;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(top: screenAwareSize(16.0, context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CardTitle("HEIGHT", subtitle: "(cm)"),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: screenAwareSize(8.0, context)),
                child: LayoutBuilder(builder: (context, constraints) {
                  return HeightPicker(
                    widgetHeight: constraints.maxHeight,
                    height: height,
                    onChange: (val) => setState(() => height = val),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
