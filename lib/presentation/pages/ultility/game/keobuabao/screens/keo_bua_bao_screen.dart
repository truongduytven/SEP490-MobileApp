import 'package:flutter/material.dart';
import 'package:sep490/common/utils/game.dart';
import 'package:sep490/presentation/pages/ultility/game/keobuabao/screens/game_screen.dart';
import 'package:sep490/presentation/pages/ultility/game/keobuabao/widgets/game_button.dart';
import 'package:sep490/theme/colors_game.dart';

class KeoBuaBaoScreen extends StatefulWidget {
  @override
  State<KeoBuaBaoScreen> createState() => _KeoBuaBaoScreenState();
}

class _KeoBuaBaoScreenState extends State<KeoBuaBaoScreen> {
  late int gamePoint = Game.score;

  void _showRulesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text("Luật chơi - Kéo Búa Bao", style: TextStyle(fontSize: 30.0)),
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

  @override
  Widget build(BuildContext context) {
    double btnWidth = MediaQuery.of(context).size.width / 2 - 40;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Kéo búa bao",
              style: TextStyle(
                  fontSize: 28.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          backgroundColor: AppColor.primaryColor,
        ),
        backgroundColor: AppColor.primaryColor,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 34.0, horizontal: 20.0),
          child: Column(
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
                      "ĐIỂM",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      gamePoint.toString(),
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
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: MediaQuery.of(context).size.width / 2 -
                            btnWidth / 2 -
                            20,
                        child: Hero(
                          tag: "Rock",
                          child: gameButton(() {
                            print("Tou choosed Rock!");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GameScreen(Choice("Rock")),
                                )).then((newPoint) {
                              if (newPoint != null && newPoint > gamePoint) {
                                setState(() {
                                  gamePoint = newPoint;
                                });
                              }
                            });
                          }, "assets/img/rock.png", btnWidth),
                        ),
                      ),
                      Positioned(
                        top: btnWidth,
                        left: MediaQuery.of(context).size.width / 2 -
                            btnWidth -
                            40,
                        child: Hero(
                          tag: "Paper",
                          child: gameButton(() {
                            print("Tou choosed paper!");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GameScreen(Choice("Paper")),
                                )).then((newPoint) {
                              if (newPoint != null && newPoint > gamePoint) {
                                setState(() {
                                  gamePoint = newPoint;
                                });
                              }
                            });
                          }, "assets/img/paper.png", btnWidth),
                        ),
                      ),
                      Positioned(
                        top: btnWidth,
                        right: MediaQuery.of(context).size.width / 2 -
                            btnWidth -
                            40,
                        child: Hero(
                          tag: "Scissors",
                          child: gameButton(() {
                            print("Tou choosed scissors!");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GameScreen(Choice("Scissors")),
                                )).then((newPoint) {
                              if (newPoint != null && newPoint > gamePoint) {
                                setState(() {
                                  gamePoint = newPoint;
                                });
                              }
                            });
                          }, "assets/img/scissors.png", btnWidth),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
