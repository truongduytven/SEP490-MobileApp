import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final bool isObscureText;
  final bool isRequired;
  final Widget? suffixIcon;
  final String? suffixText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final FocusNode? focusNode;
  final int? maxLines;

  const AuthField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.controller,
    this.isObscureText = false,
    this.isRequired = false,
    this.suffixIcon,
    this.suffixText,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
    this.focusNode,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(color: AppColors.grayColor3, fontSize: 20),
          labelStyle: TextStyle(color: AppColors.textColor, fontSize: 19),

          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          suffixIconColor: AppColors.textColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: AppColors.grayColor1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: AppColors.grayColor1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: AppColors.secondaryColor, width: 1.4),
          ),
        ),
      ),
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        maxLines: maxLines ?? 1,
        decoration: InputDecoration(
          labelText: labelText + (isRequired ? '*' : ''),
          labelStyle: TextStyle(color: AppColors.textColor, fontSize: 22),
          hintText: hintText,
          suffix: suffixIcon,
          suffixText: suffixText,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return '$labelText không được bỏ trống';
          }
          return null;
        },
        obscureText: isObscureText,
        obscuringCharacter: "*",
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        maxLength: maxLength,
        style: TextStyle(color: AppColors.textColor, fontSize: 20),
      ),
    );
  }
}
