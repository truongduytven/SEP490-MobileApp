

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:sep490/presentation/pages/ultility/game/flappy_bird/game/flappy_bird_game.dart';
import 'package:sep490/presentation/pages/ultility/game/flappy_bird/screens/game_over_screen.dart';
import 'package:sep490/presentation/pages/ultility/game/flappy_bird/screens/main_menu_screen.dart';

class ChuChimBayScreen extends StatelessWidget {
  const ChuChimBayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final game = FlappyBirdGame();

    return Scaffold(
      body: GameWidget(
        game: game,
        initialActiveOverlays: const [MainMenuScreen.id],
        overlayBuilderMap: {
          'mainMenu': (context, _) => MainMenuScreen(game: game),
          'gameOver': (context, _) => GameOverScreen(game: game),
        },
      ),
    );
  }
}
