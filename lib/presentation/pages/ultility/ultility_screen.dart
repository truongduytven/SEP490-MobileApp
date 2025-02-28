import 'package:flutter/material.dart';
import 'package:sep490/presentation/pages/ultility/game_card_screen.dart';

class UltilityScreen extends StatefulWidget {
  const UltilityScreen({super.key});

  @override
  State<UltilityScreen> createState() => _UltilityScreenState();
}

class _UltilityScreenState extends State<UltilityScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GameCardScreen(),
    );
  }
}
