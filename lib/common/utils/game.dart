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
      "Rock": "Hòa nhau",
      "Paper": "Bạn thua",
      "Scissors": "Bạn thắng"
    },
    "Paper":{
      "Paper": "Hòa nhau",
      "Scissors": "Bạn thua",
      "Rock": "Bạn thắng"
    },
    "Scissors":{
      "Scissors": "Hòa nhau",
      "Rock": "Bạn thua",
      "Paper": "Bạn thắng"
    }
  };
  Choice(this.type);
}