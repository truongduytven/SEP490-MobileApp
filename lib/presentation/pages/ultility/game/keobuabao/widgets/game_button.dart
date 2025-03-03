import 'package:flutter/material.dart';

Widget gameButton(void Function()? onTap, String imagePath, double width){
  return GestureDetector(
    onTap: onTap,
    child: Image.asset(
      imagePath,
      width: width,
    )
  );
}