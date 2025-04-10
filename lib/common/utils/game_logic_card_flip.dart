import 'dart:math';

class Game {
  final String hiddenCardpath = 'assets/img/faq_12319423.png';
  List<String>? gameImg;

  List<String> card_list = [
    "assets/img/latbai1.jpg",
    "assets/img/latbai1.jpg",
    "assets/img/latbai2.png",
    "assets/img/latbai2.png",
    "assets/img/latbai3.jpg",
    "assets/img/latbai3.jpg",
    "assets/img/latbai4.png",
    "assets/img/latbai4.png",
    "assets/img/latbai5.png",
    "assets/img/latbai5.png",
    "assets/img/latbai6.png",
    "assets/img/latbai6.png",
    "assets/img/latbai7.png",
    "assets/img/latbai7.png",
    "assets/img/latbai8.jpeg",
    "assets/img/latbai8.jpeg",
  ];

  List<Map<int, String>> matchCheck = [];
  final int cardCount = 16; 

  void initGame() {
    card_list.shuffle(Random());
    gameImg = List.generate(cardCount, (index) => hiddenCardpath);
  }
}