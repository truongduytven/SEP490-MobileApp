import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sep490/theme/colors_game.dart';
import 'package:sep490/common/utils/game_logic.dart';
import 'package:sep490/common/utils/player.dart';
import 'package:confetti/confetti.dart';

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
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 3));
    game.board = Game.initGameBoard();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void celebrateWin() {
    _confettiController.play();
  }

  void aiMove() {
    int bestMove = game.findBestMove(game.board!, scoreboard);
    if (bestMove != -1) {
      setState(() {
        game.board![bestMove] = lastValue;
        turn++;
        gameOver = game.winnerCheck(lastValue, bestMove, scoreboard, 3);
        if (gameOver) {
          result = "$lastValue là người chiến thắng";
        } else if (!gameOver && turn == 9) {
          result = "Hòa nhau";
          gameOver = true;
        }
        if (lastValue == "X")
          lastValue = "O";
        else
          lastValue = "X";
      });
    }
  }

  void makeMove(int index) {
    if (game.board![index] == Player.empty) {
      setState(() {
        game.board![index] = lastValue;
        turn++;
        gameOver = game.winnerCheck(lastValue, index, scoreboard, 3);
        print(scoreboard);
        if (gameOver) {
          result = "$lastValue là người chiến thắng";
          celebrateWin();
        } else if (!gameOver && turn == 9) {
          result = "Hòa nhau";
          gameOver = true;
        }
        if (lastValue == "X")
          lastValue = "O";
        else
          lastValue = "X";

        if (!gameOver && lastValue == "O") {
          Future.delayed(Duration(seconds: 1), () {
            aiMove();
          });
        }
      });
    }
  }

  Path drawStar(Size size) {
    // Method to convert degrees to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  void showGameRulesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Luật chơi",
              style: TextStyle(
                  color: AppColor.primaryColor,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold)),
          content: Text(
            "Người chơi lần lượt đánh dấu X hoặc O trên bảng.\n"
            "- Người chiến thắng là người có 3 ký tự liên tiếp theo hàng, cột hoặc chéo.\n"
            "- Nếu bảng đầy mà không ai thắng, kết quả là hòa.",
            style: TextStyle(fontSize: 25.0, color: AppColor.primaryColor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Đóng"),
            ),
          ],
        );
      },
    );
  }

  void showGameSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Cài đặt độ khó"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Dễ", style: TextStyle(fontSize: 30),),
                    SizedBox(width: 10.0),
                    if(game.difficulty == 1)
                    Icon(Icons.check_circle, color: Colors.green),
                  ],
                ),
                onTap: () {
                  game.setDifficulty(1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Khó", style: TextStyle(fontSize: 30),),
                    SizedBox(width: 10.0),
                    if(game.difficulty == 2)
                    Icon(Icons.check_circle, color: Colors.green),
                  ],
                ),
                onTap: () {
                  game.setDifficulty(2);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
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
        actions: [
          IconButton(
              onPressed: () {
                showGameSettingsDialog();
              },
              icon: Icon(Icons.settings))
        ],
      ),
      backgroundColor: AppColor.primaryColor,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Đến lượt $lastValue".toUpperCase(),
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
                  crossAxisCount: Game.boardLength ~/ 3,
                  padding: EdgeInsets.all(16.0),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  children: List.generate(Game.boardLength, (index) {
                    return InkWell(
                      onTap: gameOver
                          ? null
                          : () {
                              makeMove(index);
                            },
                      child: Container(
                        width: Game.blocSize,
                        height: Game.blocSize,
                        decoration: BoxDecoration(
                          color: AppColor.lightPrimaryColor,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Center(
                          child: Text(
                            game.board![index],
                            style: TextStyle(
                              color: game.board![index] == "X"
                                  ? Colors.blue
                                  : Colors.pink,
                              fontSize: 64.0,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Text(
                  result,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 45.0),
                ),
              ),
              SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      showGameRulesDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.letterColors[0],
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    icon: Icon(Icons.help_outline,
                        color: AppColor.primaryColor, size: 24.0),
                    label: Text("Luật chơi ",
                        style: TextStyle(
                          color: AppColor.primaryColor,
                          fontSize: 24.0,
                        )),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.letterColors[0],
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    icon: Icon(Icons.replay,
                        color: AppColor.primaryColor, size: 24.0),
                    label: Text("Chơi lại ",
                        style: TextStyle(
                          color: AppColor.primaryColor,
                          fontSize: 24.0,
                        )),
                  ),
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality
                  .explosive, // don't specify a direction, blast randomly
              shouldLoop:
                  false, // start again as soon as the animation is finished
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ], // manually specify the colors to be used
              createParticlePath: drawStar, // define a custom shape/path.
            ),
          ),
        ],
      ),
    );
  }
}
