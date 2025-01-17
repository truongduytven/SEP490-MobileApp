import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class HeartBeatInputWidget extends StatefulWidget {
  final num initialValue;
  final String dateTime;
  final ValueChanged<num> onSubmit;

  const HeartBeatInputWidget({
    super.key,
    required this.initialValue,
    required this.dateTime,
    required this.onSubmit,
  });

  @override
  State<HeartBeatInputWidget> createState() => _HeartBeatInputWidgetState();
}

class _HeartBeatInputWidgetState extends State<HeartBeatInputWidget> {
  late TextEditingController _controller;
  final FocusNode heartBeatFocusNode = FocusNode();
  late num currentValue;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: widget.initialValue > 0 ? widget.initialValue.toString() : "");
    currentValue = widget.initialValue;
    heartBeatFocusNode.addListener(() {
      setState(() {});
    });
  }

  void _incrementValue() {
    setState(() {
      currentValue = (currentValue + 1).clamp(1, double.infinity);
      _controller.text = currentValue.toString();
      _validateInput();
    });
  }

  void _decrementValue() {
    setState(() {
      currentValue = (currentValue - 1).clamp(1, double.infinity);
      _controller.text = currentValue.toString();
      _validateInput();
    });
  }

  void _validateInput() {
    if (currentValue < 40 || currentValue > 300) {
      errorMessage = "Nhịp tim phải trong khoảng từ 40 đến 300.";
    } else {
      errorMessage = null;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    heartBeatFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.borderColor,
                  width: 1.5,
                ),
                color: AppColors.bgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    color: AppColors.secondaryColor,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Hôm nay, ${widget.dateTime}",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _decrementValue,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.remove, size: 40, color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                // Number Input
                SizedBox(
                  width: 100,
                  height: 100,
                  child: TextField(
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      color: heartBeatFocusNode.hasFocus
                          ? AppColors.primaryColor
                          : AppColors.textColor,
                    ),
                    showCursor: false,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    controller: _controller,
                    focusNode: heartBeatFocusNode,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 25,
                        horizontal: 0,
                      ),
                      hintText: "---",
                      hintStyle: TextStyle(
                        fontSize: 40,
                        color: heartBeatFocusNode.hasFocus
                            ? AppColors.primaryColor
                            : AppColors.grayColor4,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide:
                            const BorderSide(color: AppColors.grayColor1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                            width: 1.5, color: AppColors.primaryColor),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        final parsedValue = num.tryParse(value) ?? 0;
                        currentValue = parsedValue.clamp(0, double.infinity);
                        _controller.text = currentValue.toString();
                        _validateInput();
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: _incrementValue,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.add, size: 40, color: Colors.white),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 10),
              child: Text(
                "Nhịp tim tính bằng nhịp/phút(40~300)",
                style:
                    const TextStyle(fontSize: 20, color: AppColors.grayColor5),
              ),
            ),
            // Error Message
            if (errorMessage != null)
              Text(
                textAlign: TextAlign.center,
                errorMessage!,
                style: TextStyle(
                    color: AppColors.errorColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
            SizedBox(
              height: 30,
            ),
            // Submit Button
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: (currentValue >= 40 && currentValue <= 300)
                    ? () => widget.onSubmit(currentValue)
                    : null,
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
      ),
    );
  }
}
