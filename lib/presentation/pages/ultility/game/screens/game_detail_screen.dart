import 'package:flutter/material.dart';
import 'package:sep490/presentation/pages/ultility/game/screens/chu_chim_bay_screen.dart';
import 'package:sep490/presentation/pages/ultility/game/screens/do_boom_screen.dart';
import 'play_game_screen.dart';
import 'co_caro_screen.dart';
import 'keo_bua_bao_screen.dart';
import 'lat_the_bai_screen.dart';

class GameDetailScreen extends StatefulWidget {
  final String title;
  final String imagePath;

  const GameDetailScreen(
      {super.key, required this.title, required this.imagePath});

  @override
  _GameDetailScreenState createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the corresponding game page after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => _getGameScreen(widget.title)),
      );
    });
  }

  Widget _getGameScreen(String title) {
    print("title ne $title");
    switch (title) {
      case "Cờ caro":
        return CoCaroScreen();
      case "Dò bom":
        return DoBoomScreen();
      case "Kéo búa bao":
        return KeoBuaBaoScreen();
      case "Lật thẻ bài":
        return LatTheBaiScreen();
      case "Chú chim bay":
        return ChuChimBayScreen();
      default:
        return PlayGameScreen(gameTitle: title); // Default screen if not found
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: widget.imagePath,
              child: Image.asset(
                widget.imagePath,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20), // Space between image and title
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
