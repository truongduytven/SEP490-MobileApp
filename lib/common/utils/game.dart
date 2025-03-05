import 'dart:math';

class Game {
  static int score = 0;
  static List<String> choices = ["Rock","Paper","Scissors"];


  static String? randomChoice(){
    Random random = new Random();
    int robotChoiceIndex = random.nextInt(3);

    return choices[robotChoiceIndex];
  }
}

class Choice{
  String? type = "";
  static var gameRule = {
    "Rock":{
      "Rock": "It's a draw",
      "Paper": "You lose",
      "Scissors": "You win"
    },
    "Paper":{
      "Paper": "It's a draw",
      "Scissors": "You lose",
      "Rock": "You win"
    },
    "Scissors":{
      "Scissors": "It's a draw",
      "Rock": "You lose",
      "Paper": "You win"
    }
  };
  Choice(this.type);
}