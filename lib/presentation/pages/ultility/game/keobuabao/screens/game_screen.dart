import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:sep490/common/utils/game.dart';
import 'package:sep490/presentation/pages/ultility/game/keobuabao/screens/keo_bua_bao_screen.dart';
import 'package:sep490/theme/color.dart';

import '../widgets/game_button.dart';

class GameScreen extends StatefulWidget {
  GameScreen(this.gameChoice, {super.key});
  Choice gameChoice;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final ConfettiController _confettiController =
      ConfettiController(duration: Duration(seconds: 3));
  final player = AudioPlayer();

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    double btnWidth = MediaQuery.of(context).size.width / 2 - 40;
    String? robotChoice = Game.randomChoice();
    String robotChoicePath = "";
    switch (robotChoice) {
      case "Rock":
        robotChoicePath = "assets/img/rock.png";
        break;
      case "Paper":
        robotChoicePath = "assets/img/paper.png";
        break;
      case "Scissors":
        robotChoicePath = "assets/img/scissors.png";
        break;
      default:
    }

    String? player_choice;
    switch (widget.gameChoice.type) {
      case "Rock":
        player_choice = "assets/img/rock.png";
        break;
      case "Paper":
        player_choice = "assets/img/paper.png";
        break;
      case "Scissors":
        player_choice = "assets/img/scissors.png";
        break;
      default:
    }

    if (Choice.gameRule[widget.gameChoice.type]![robotChoice] == "Bạn thắng") {
      setState(() {
        Game.score++;
      });
      _confettiController.play();
      player.play(AssetSource("music/win.mp3"));
    }

    void _showRulesDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Luật chơi - Kéo Búa Bao",
                style: TextStyle(fontSize: 30.0)),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    "🔹 Trò chơi gồm 3 lựa chọn:",
                    style: TextStyle(fontSize: 22.0),
                  ),
                  Text(
                    "   - Kéo ✂️ (Scissors)",
                    style: TextStyle(fontSize: 22.0),
                  ),
                  Text(
                    "   - Búa 👊 (Rock)",
                    style: TextStyle(fontSize: 22.0),
                  ),
                  Text(
                    "   - Bao ✋ (Paper)",
                    style: TextStyle(fontSize: 22.0),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "🔹 Quy tắc thắng thua:",
                    style: TextStyle(fontSize: 22.0),
                  ),
                  Text(
                    "   - Kéo thắng Bao",
                    style: TextStyle(fontSize: 22.0),
                  ),
                  Text(
                    "   - Bao thắng Búa",
                    style: TextStyle(fontSize: 22.0),
                  ),
                  Text(
                    "   - Búa thắng Kéo",
                    style: TextStyle(fontSize: 22.0),
                  ),
                  Text(
                    "🔹 Nếu bạn chọn giống máy, kết quả là Hòa.",
                    style: TextStyle(fontSize: 22.0),
                  ),
                  Text(
                    "🔹 Mỗi lần thắng, bạn sẽ được cộng điểm.",
                    style: TextStyle(fontSize: 22.0),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text("Đã hiểu"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 34.0, horizontal: 8.0),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 5.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Điểm số",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${Game.score}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 2,
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Hero(
                        tag: "${widget.gameChoice.type}",
                        child: gameButton(null, player_choice!, btnWidth),
                      ),
                      Text(
                        "VS",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26.0,
                        ),
                      ),
                      gameButton(null, robotChoicePath, btnWidth)
                    ],
                  )),
                ),
                //  SizedBox(height: 20.0,),
                Text(
                  "${Choice.gameRule[widget.gameChoice.type]![robotChoice]}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0),
                ),
                Container(
                  width: double.infinity,
                  child: RawMaterialButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context)=> KeoBuaBaoScreen())
                      // );
                      Navigator.pop(context, Game.score);
                    },
                    padding: EdgeInsets.all(16.0),
                    shape: StadiumBorder(
                        side: BorderSide(color: Colors.white, width: 5.0)),
                    child: Text(
                      "Chơi lại",
                      style: TextStyle(color: Colors.white, fontSize: 24.0),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: RawMaterialButton(
                    onPressed: () {
                      _showRulesDialog();
                    },
                    padding: EdgeInsets.all(16.0),
                    shape: StadiumBorder(
                        side: BorderSide(color: Colors.white, width: 5.0)),
                    child: Text(
                      "Luật chơi",
                      style: TextStyle(color: Colors.white, fontSize: 24.0),
                    ),
                  ),
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
      ),
    );
  }
}
