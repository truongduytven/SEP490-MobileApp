import 'package:flutter/material.dart';

class PlayGameScreen extends StatelessWidget {
  final String gameTitle;

  const PlayGameScreen({super.key, required this.gameTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(gameTitle)),
      body: Center(
        child: Text(
          "Playing $gameTitle...",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
