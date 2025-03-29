import 'package:flutter/material.dart';
import 'package:sep490/presentation/pages/ultility/game/widgets/full_width_game_card.dart';
import 'package:sep490/presentation/pages/ultility/game/widgets/game_card.dart';
import 'package:sep490/theme/color.dart';

class GameCardScreen extends StatelessWidget {
  const GameCardScreen({super.key});

  final List<Map<String, dynamic>> games = const [
    {
      "title": "Cờ caro",
      "color1": Colors.orange,
      "color2": Colors.deepOrange,
      "image": "assets/img/xo_game.webp"
    },
    {
      "title": "Dò bom",
      "color1": Colors.purple,
      "color2": Colors.deepPurple,
      "image": "assets/img/boom.webp"
    },
    {
      "title": "Kéo búa bao",
      "color1": Colors.blue,
      "color2": Colors.lightBlueAccent,
      "image": "assets/img/keobuabao_game.png"
    },
    {
      "title": "Lật thẻ bài",
      "color1": Colors.yellow,
      "color2": Colors.amber,
      "image": "assets/img/card_game_2.png"
    },
    {
      "title": "2048",
      "color1": Colors.yellow,
      "color2": Colors.amber,
      "image": "assets/img/2048.png"
    },
    // {
    //   "title": "Chú chim bay",
    //   "color1": Colors.yellow,
    //   "color2": Colors.amber,
    //   "image": "assets/img/card_game_2.png"
    // },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text("Trò chơi"),
        centerTitle: true,
        backgroundColor: AppColors.bgColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            // Full-width special card at the top
            const FullWidthGameCard(
              title: "Chơi trò chơi",
              subtitle: "Thử thách bản thân với những trò chơi hấp dẫn! ",
              color1: Colors.red,
              color2: Colors.deepOrange,
              imagePath: "assets/img/game_3.webp",
            ),
            const SizedBox(height: 40), // Spacing between full-width and grid

            // Grid of smaller cards
            Expanded(
              child: GridView.builder(
                clipBehavior: Clip.none,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two cards per row
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 36,
                  childAspectRatio: 1.4, // Adjust aspect ratio
                ),
                itemCount: games.length,
                itemBuilder: (context, index) {
                  return GameCard(
                    title: games[index]["title"],
                    color1: games[index]["color1"],
                    color2: games[index]["color2"],
                    imagePath: games[index]["image"],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


