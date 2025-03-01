import 'dart:math';

class Game {
  final String hiddenCardpath = 'assets/img/faq_12319423.png';
  List<String>? gameImg;

  List<String> card_list = [
    "assets/img/social_15707749.png",
    "assets/img/youtube_3938026.png",
    "assets/img/check_14025690.png",
    "assets/img/social_15707749.png",
    "assets/img/youtube_3938026.png",
    "assets/img/linkedin_3536505.png",
    "assets/img/linkedin_3536505.png",
    "assets/img/check_14025690.png",
    "assets/img/classical.png",
    "assets/img/classical.png",
    "assets/img/cave.png",
    "assets/img/cave.png",
    "assets/img/geological.png",
    "assets/img/geological.png",
    "assets/img/potrait.png",
    "assets/img/potrait.png",
  ];

  List<Map<int, String>> matchCheck = [];
  final int cardCount = 16; // 4x4 grid

  void initGame() {
    card_list.shuffle(Random()); // Shuffle the card list
    gameImg = List.generate(cardCount, (index) => hiddenCardpath);
  }
}