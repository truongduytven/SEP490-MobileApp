import 'package:flutter/material.dart';

class DrinkingSchedule {
  final TimeOfDay time;
  final int amount;
  final String description;
  bool completed;

  DrinkingSchedule({
    required this.time,
    required this.amount,
    required this.description,
    this.completed = false,
  });
}
