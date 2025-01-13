import 'package:flutter/material.dart';

class BloodPressureInputWidget extends StatefulWidget {
  final num initialValueSystolic;
  final num initialValueDiastolic;
  final String dateTime;
  final ValueChanged<Map<String, num>> onSubmit;

  const BloodPressureInputWidget({
    required this.initialValueDiastolic,
    required this.initialValueSystolic,
    required this.dateTime,
    required this.onSubmit,
    super.key,
  });

  @override
  State<BloodPressureInputWidget> createState() =>
      _BloodPressureInputWidgetState();
}

class _BloodPressureInputWidgetState extends State<BloodPressureInputWidget> {
  late TextEditingController systolicController;
  late TextEditingController diastolicController;
  final FocusNode systolicFocusNode = FocusNode();
  final FocusNode diastolicFocusNode = FocusNode();

  String systolicLabel = "Tâm thu";
  String diastolicLabel = "Tâm trương";
  String systolicDescription = "Huyết áp tâm thu tính bằng mmHg(30~300)";
  String diastolicDescription = "Huyết áp tâm trương tính bằng mmHg(20~250)";

  @override
  void initState() {
    super.initState();
    systolicController = TextEditingController(
        text: widget.initialValueSystolic == 0
            ? ""
            : widget.initialValueSystolic.toString());
    diastolicController = TextEditingController(
        text: widget.initialValueDiastolic == 0
            ? ""
            : widget.initialValueDiastolic.toString());

    systolicFocusNode.addListener(() {
      setState(() {
        // Update description when systolic input is focused
      });
    });

    diastolicFocusNode.addListener(() {
      setState(() {
        // Update description when diastolic input is focused
      });
    });
  }

  @override
  void dispose() {
    systolicController.dispose();
    diastolicController.dispose();
    systolicFocusNode.dispose();
    diastolicFocusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final systolic = num.tryParse(systolicController.text) ?? 0;
    final diastolic = num.tryParse(diastolicController.text) ?? 0;

    widget.onSubmit({'systolic': systolic, 'diastolic': diastolic});
  }

  void _onValueChanged(
      String value, FocusNode currentFocus, FocusNode nextFocus) {
    if (num.tryParse(value) != null && num.tryParse(value)! > 30) {
      currentFocus.unfocus();
      FocusScope.of(context).requestFocus(nextFocus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Hôm nay, ${widget.dateTime}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            // Row for Systolic and Diastolic input fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Systolic input
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        systolicLabel,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: TextField(
                          style: TextStyle(
                            fontSize: 40,
                          ),
                          showCursor: false,
                          controller: systolicController,
                          focusNode: systolicFocusNode,
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical
                              .center, // Center text vertically
                          decoration: InputDecoration(
                            hintText: "---",
                            hintStyle: TextStyle(fontSize: 40),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 25,
                              horizontal: 0,
                            ),
                          ),
                          onChanged: (value) => _onValueChanged(
                              value, systolicFocusNode, diastolicFocusNode),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                // Diastolic input
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        diastolicLabel,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      TextField(
                        showCursor: false,
                        controller: diastolicController,
                        focusNode: diastolicFocusNode,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "---",
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (systolicFocusNode.hasFocus)
              Text(
                systolicDescription,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            if (diastolicFocusNode.hasFocus)
              Text(
                diastolicDescription,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _handleSubmit,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
