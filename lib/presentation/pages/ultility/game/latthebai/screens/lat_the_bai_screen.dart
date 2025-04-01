import 'package:flutter/material.dart';
import 'package:sep490/common/utils/game_logic_card_flip.dart';
import 'package:sep490/presentation/pages/ultility/game/latthebai/widgets/score_board.dart';
import 'package:sep490/theme/colors_game.dart';

class LatTheBaiScreen extends StatefulWidget {
  @override
  State<LatTheBaiScreen> createState() => _LatTheBaiScreenState();
}

class _LatTheBaiScreenState extends State<LatTheBaiScreen> {
  Game _game = Game();
  int tries = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    _game.initGame();
  }

  void _resetGame() {
    setState(() {
      _game = Game();
      tries = 0;
      score = 0;
      _game.initGame();
    });
  }

  void _showGameGuide(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Hướng dẫn chơi", style: TextStyle(fontSize: 30.0)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "🌟 Cách chơi: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 8),
                Text("1️⃣ Chọn một thẻ bất kỳ để lật.", style: TextStyle(fontSize: 22.0)),
                Text("2️⃣ Chọn thêm một thẻ khác.", style: TextStyle(fontSize: 22.0)),
                Text("3️⃣ Nếu hai thẻ giống nhau, bạn sẽ ghi điểm.", style: TextStyle(fontSize: 22.0)),
                Text("4️⃣ Nếu không giống, hai thẻ sẽ bị úp lại.", style: TextStyle(fontSize: 22.0)),
                Text("5️⃣ Tiếp tục chơi cho đến khi lật hết tất cả các thẻ.", style: TextStyle(fontSize: 22.0)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK", style: TextStyle(fontSize: 22.0, color: AppColor.primaryColor)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Lật thẻ bài",
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _showGameGuide(context);
              },
              icon: Icon(
                Icons.help_outline,
                color: Colors.white,
                size: 30.0,
              ))
        ],
      ),
      backgroundColor: AppColor.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Trò chơi trí nhớ",
              style: TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              scoreBoard("Số lần lật", "$tries"),
              scoreBoard("Điểm", "$score"),
            ],
          ),
          SizedBox(
            height: screenWidth,
            width: screenWidth,
            child: GridView.builder(
              itemCount: _game.gameImg!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 4x4 grid
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (_game.matchCheck
                        .any((element) => element.containsKey(index))) {
                      return; // Prevent clicking the same card twice
                    }
                    setState(() {
                      tries++;
                      _game.gameImg![index] = _game.card_list[index];
                      _game.matchCheck.add({index: _game.card_list[index]});
                    });
                    if (_game.matchCheck.length == 2) {
                      if (_game.matchCheck[0].values.first ==
                          _game.matchCheck[1].values.first) {
                        score += 100;
                        _game.matchCheck.clear();
                      } else {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          setState(() {
                            _game.gameImg![_game.matchCheck[0].keys.first] =
                                _game.hiddenCardpath;
                            _game.gameImg![_game.matchCheck[1].keys.first] =
                                _game.hiddenCardpath;
                            _game.matchCheck.clear();
                          });
                        });
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB46A),
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: AssetImage(_game.gameImg![index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: _resetGame,
            child: const Text(
              "Chơi lại",
              style: TextStyle(fontSize: 24.0),
            ),
          ),
        ],
      ),
    );
  }
}
