import 'package:flutter/material.dart';
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text("Tiện ích"),
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
              title: "Chơi game",
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

// Full-width game card with gradient
class FullWidthGameCard extends StatelessWidget {
  final String title;
  final Color color1;
  final Color color2;
  final String imagePath;
  final String subtitle;
  const FullWidthGameCard({
    super.key,
    required this.title,
    required this.color1,
    required this.color2,
    required this.imagePath,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Full width
      height: 180, // Taller than other cards
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color1, color2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(
                          height: 8), // Space between title and subtitle
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70, // Lighter color for subtitle
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2, // Allow more space for subtitle
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: -50,
            top: -50,
            child: Image.asset(
              imagePath,
              width: 240,
              height: 240,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

// Normal game card (used in grid) with gradient
class GameCard extends StatelessWidget {
  final String title;
  final Color color1;
  final Color color2;
  final String imagePath;

  const GameCard({
    super.key,
    required this.title,
    required this.color1,
    required this.color2,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 140,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color1, color2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: -30,
            top: -25,
            child: Image.asset(
              imagePath,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
