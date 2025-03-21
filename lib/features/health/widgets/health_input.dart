import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class HealthInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;

  const HealthInput({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  }) : super(key: key);

  @override
  _HealthInputState createState() => _HealthInputState();
}

class _HealthInputState extends State<HealthInput> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5, // Half of screen width
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: widget.focusNode.hasFocus
                    ? AppColors.primaryColor
                    : AppColors.textColor,
              ),
              showCursor: true,
              textAlign: TextAlign.center,
              controller: widget.controller,
              focusNode: widget.focusNode,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                hintText: "---",
                hintStyle: TextStyle(
                  fontSize: 35,
                  color: widget.focusNode.hasFocus
                      ? AppColors.primaryColor
                      : AppColors.grayColor4,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: AppColors.grayColor2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide:
                      BorderSide(width: 1.5, color: AppColors.primaryColor),
                ),
              ),
              onChanged: widget.onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
