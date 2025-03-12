import 'package:flutter/material.dart';
import 'package:sep490/theme/colors_game.dart';
import 'package:sep490/common/utils/game_helper.dart';
import 'dart:async';

class DoBoomScreen extends StatefulWidget {
  @override
  State<DoBoomScreen> createState() => _DoBoomScreenState();
}

class _DoBoomScreenState extends State<DoBoomScreen> {
  late MineSweeperGame game;
  int _remainingTime = 600; // 10 phút = 600 giây
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    game = MineSweeperGame(onUpdate: _updateUI); // Truyền callback để cập nhật UI
    game.generateMap();
    startTimer();
  }

  void _updateUI() {
    setState(() {}); // Cập nhật UI khi có sự thay đổi trong game
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          game.gameOver = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            setState(() {
              game.resetGame();
              game.gameOver = false;
              _remainingTime = 600;
              _timer?.cancel();
              startTimer();
            });
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Dò bom",
          style: TextStyle(color: Colors.white),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    color: AppColor.lightPrimaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.flag,
                        color: AppColor.accentColor,
                        size: 34.0,
                      ),
                      Text(
                        "10",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    color: AppColor.lightPrimaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.lock_clock,
                        color: AppColor.accentColor,
                        size: 34.0,
                      ),
                      Text(
                        "${(_remainingTime ~/ 60).toString().padLeft(2, '0')}:${(_remainingTime % 60).toString().padLeft(2, '0')}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: 500.0,
            padding: EdgeInsets.all(20.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MineSweeperGame.row,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: MineSweeperGame.cells,
              itemBuilder: (BuildContext ctx, index) {
                Color cellColor = game.gameMap[index].reveal
                    ? AppColor.clickedCard
                    : AppColor.lightPrimaryColor;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      game.toggleFlag(game.gameMap[index]); // Nhấn một lần: đánh dấu lá cờ
                    });
                  },
                  onDoubleTap: () {
                    setState(() {
                      game.getClickedCell(game.gameMap[index]); // Nhấn đúp: mở ô
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: cellColor,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Center(
                      child: game.gameMap[index].isFlagged
                          ? Icon(Icons.flag, color: Colors.red) // Hiển thị lá cờ
                          : game.gameMap[index].reveal
                              ? game.gameMap[index].content is IconData
                                  ? Icon(
                                      game.gameMap[index].content,
                                      color: Colors.red,
                                      size: 24.0,
                                    )
                                  : Text(
                                      "${game.gameMap[index].content}",
                                      style: TextStyle(
                                        color: AppColor.letterColors[game.gameMap[index].content],
                                        fontSize: 20.0,
                                      ),
                                    )
                              : Container(),
                    ),
                  ),
                );
              },
            ),
          ),
          Text(
            game.gameOver ? "Bạn đã thua" : "",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 32.0),
          ),
          SizedBox(height: 20.0),
          RawMaterialButton(
            onPressed: () {
              setState(() {
                game.resetGame();
                game.gameOver = false;
                _remainingTime = 600;
                _timer?.cancel();
                startTimer();
              });
            },
            fillColor: AppColor.lightPrimaryColor,
            elevation: 0,
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(horizontal: 64.0, vertical: 18.0),
            child: Text(
              "Chơi lạilại",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}