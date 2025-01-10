import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final bool isObscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;

  const AuthField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.controller,
    this.isObscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
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
            borderSide: const BorderSide(color: AppColors.primaryColor),
          ),
        ),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          suffix: suffixIcon,
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
