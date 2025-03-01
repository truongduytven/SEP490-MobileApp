import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sep490/common/utils/game_logic.dart';
import 'package:sep490/theme/color.dart';

class CoCaroScreen extends StatefulWidget {
  @override
  State<CoCaroScreen> createState() => _CoCaroScreenState();
}

class _CoCaroScreenState extends State<CoCaroScreen> {

    String lastValue = "X";
  bool gameOver = false;
  int turn = 0;
  String result = "";
  List<int> scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
  Game game = Game();

  @override
  void initState() {
    super.initState();
    game.board = Game.initGameBoard();
  }

  void aiMove() {
    List<int> emptyCells = [];
    for (int i = 0; i < Game.boardlenth; i++) {
      if (game.board![i] == Player.empty) {
        emptyCells.add(i);
      }
    }

    if (emptyCells.isNotEmpty) {
      int randomIndex = emptyCells[Random().nextInt(emptyCells.length)];
      setState(() {
        game.board![randomIndex] = lastValue;
        turn++;
        gameOver = game.winnerCheck(lastValue, randomIndex, scoreboard, 3);
        if (gameOver) {
          result = "$lastValue is the Winner";
        } else if (!gameOver && turn == 9) {
          result = "It's a Draw";
          gameOver = true;
        }
        if (lastValue == "X") lastValue = "O";
        else lastValue = "X";
      });
    }
  }

  void makeMove(int index) {
    if (game.board![index] == "") {
      setState(() {
        game.board![index] = lastValue;
        turn++;
        gameOver = game.winnerCheck(lastValue, index, scoreboard, 3);
        if (gameOver) {
          result = "$lastValue is the Winner";
        } else if (!gameOver && turn == 9) {
          result = "It's a Draw";
          gameOver = true;
        }
        if (lastValue == "X") lastValue = "O";
        else lastValue = "X";

        // Call AI move after a delay if it's the machine's turn
        if (!gameOver && lastValue == "O") {
          Future.delayed(Duration(seconds: 1), () {
            aiMove();
          });
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;

    return Scaffold(
       appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0.0,
        centerTitle: true,
         leading: IconButton(
    icon: Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () {
       setState(() {
                game.board = Game.initGameBoard();
                lastValue = "X";
                gameOver = false;
                turn = 0;
                result = "";
                scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
              });
      Navigator.pop(context);
    },
  ),
        title: Text(
          "Cờ caro",
          style: TextStyle(color: Colors.white),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
      ),
      backgroundColor: AppColors.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "It's ${lastValue} turn".toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 58,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            width: boardWidth,
            height: boardWidth,
            child: GridView.count(
              crossAxisCount: Game.boardlenth ~/ 3,
              padding: EdgeInsets.all(16.0),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              children: List.generate(Game.boardlenth, (index) {
                return InkWell(
                  onTap: gameOver
                      ? null
                      : () {
                          makeMove(index); // Use the makeMove function
                        },
                  child: Container(
                    width: Game.blocSize,
                    height: Game.blocSize,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Center(
                      child: Text(
                        game.board![index],
                        style: TextStyle(
                          color: game.board![index] == "X" ? Colors.blue : Colors.pink,
                          fontSize: 64.0,
                        ),
                      ),
                    ),
                  ),
                );
                }),
            ),
          ),
          SizedBox(height: 25.0),
          Text(
            result,
            style: TextStyle(color: Colors.white, fontSize: 54.0),
          ),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                game.board = Game.initGameBoard();
                lastValue = "X";
                gameOver = false;
                turn = 0;
                result = "";
                scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
              });
            },
            icon: Icon(Icons.replay),
            label: Text("Play Again"),
          ),
        ],
      ),
    );
  }
}
