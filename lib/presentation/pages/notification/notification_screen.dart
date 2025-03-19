import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sep490/theme/color.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Thông báo",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: AppColors.secondaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              final player = AudioPlayer();
              player.play(AssetSource('music/outgoing.mp3'));
            },
            child: Text("Đánh giá"),
          ),
          Center(
            child: Text("Notification Screen here"),
          ),
        ],
      ),
    );
  }
}
