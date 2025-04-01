import 'dart:async';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:sep490/presentation/pages/ultility/game/2048/grid-properties.dart';
import 'package:sep490/presentation/pages/ultility/game/2048/tile.dart';

enum SwipeDirection { up, down, left, right }

class GameState {
  // this is the grid before the swipe has taken place
  final List<List<Tile>> _previousGrid;
  final SwipeDirection swipe;

  GameState(List<List<Tile>> previousGrid, this.swipe)
      : _previousGrid = previousGrid;

  // always make a copy so mutations don't screw things up.
  List<List<Tile>> get previousGrid => _previousGrid
      .map((row) => row.map((tile) => tile.copy()).toList())
      .toList();
}

class TwentyFortyEight extends StatefulWidget {
  const TwentyFortyEight({super.key});

  @override
  TwentyFortyEightState createState() => TwentyFortyEightState();
}

class TwentyFortyEightState extends State<TwentyFortyEight>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Timer aiTimer;

  List<List<Tile>> grid =
      List.generate(4, (y) => List.generate(4, (x) => Tile(x, y, 0)));
  List<GameState> gameStates = [];
  List<Tile> toAdd = [];

  Iterable<Tile> get gridTiles => grid.expand((e) => e);
  Iterable<Tile> get allTiles => [gridTiles, toAdd].expand((e) => e);
  List<List<Tile>> get gridCols =>
      List.generate(4, (x) => List.generate(4, (y) => grid[y][x]));

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          for (var e in toAdd) {
            grid[e.y][e.x].value = e.value;
          }
          for (var t in gridTiles) {
            t.resetAnimations();
          }
          toAdd.clear();
        });
      }
    });

    setupNewGame();
  }

  void _showGameGuide(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Hướng dẫn chơi 2048", style: TextStyle(fontSize: 30.0)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "🎮 Cách chơi:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                SizedBox(height: 8),
                Text(
                    "• Vuốt lên, xuống, trái hoặc phải để di chuyển các ô số.", style: TextStyle(fontSize: 22.0)),
                Text("• Khi hai ô có cùng số va chạm, chúng sẽ cộng lại.", style: TextStyle(fontSize: 22.0)),
                Text("• Mục tiêu là tạo ra ô có giá trị 2048.", style: TextStyle(fontSize: 22.0)),
                SizedBox(height: 10),
                Text(
                  "🎯 Mẹo chơi:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                SizedBox(height: 8),
                Text("✅ Luôn giữ số lớn nhất ở góc.", style: TextStyle(fontSize: 22.0)),
                Text("✅ Di chuyển theo một hướng cố định để sắp xếp số.", style: TextStyle(fontSize: 22.0)),
                Text("✅ Suy nghĩ trước khi vuốt để tránh làm đầy bàn.", style: TextStyle(fontSize: 22.0)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double contentPadding = 16;
    double borderSize = 4;
    double gridSize = MediaQuery.of(context).size.width - contentPadding * 2;
    double tileSize = (gridSize - borderSize * 2) / 4;
    List<Widget> stackItems = [];
    stackItems.addAll(gridTiles.map((t) => TileWidget(
        x: tileSize * t.x,
        y: tileSize * t.y,
        containerSize: tileSize,
        size: tileSize - borderSize * 2,
        color: lightBrown,
        child: Container())));
    stackItems.addAll(allTiles.map((tile) => AnimatedBuilder(
        animation: controller,
        builder: (context, child) => tile.animatedValue.value == 0
            ? const SizedBox()
            : TileWidget(
                x: tileSize * tile.animatedX.value,
                y: tileSize * tile.animatedY.value,
                containerSize: tileSize,
                size: (tileSize - borderSize * 2) * tile.size.value,
                color: numTileColor[tile.animatedValue.value] ??
                    Colors.transparent,
                child: Center(child: TileNumber(tile.animatedValue.value))))));

    return Scaffold(
        backgroundColor: tan,
        appBar: AppBar(
          backgroundColor: tan,
          title: const Text("2048", style: TextStyle(color: numColor, fontSize: 25, fontWeight: FontWeight.w600)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: numColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline, color: numColor),
              onPressed: () {
                _showGameGuide(context);
              },
            ),
          ],
        ),
        body: Padding(
            padding: EdgeInsets.all(contentPadding),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Swiper(
                      up: () => merge(SwipeDirection.up),
                      down: () => merge(SwipeDirection.down),
                      left: () => merge(SwipeDirection.left),
                      right: () => merge(SwipeDirection.right),
                      child: Container(
                          height: gridSize,
                          width: gridSize,
                          padding: EdgeInsets.all(borderSize),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(cornerRadius),
                              color: darkBrown),
                          child: Stack(
                            children: stackItems,
                          ))),
                  Column(
                    children: [
                      BigButton(
                        label: "Quay lại một bước",
                        color: numColor,
                        onPressed: gameStates.isEmpty
                            ? () {}
                            : undoMove, // Non-null function
                      ),
                      BigButton(
                        label: "Chơi lại",
                        color: orange,
                        onPressed: setupNewGame, // Non-null function
                      ),
                    ],
                  ),
                ])));
  }

  void undoMove() {
    GameState previousState = gameStates.removeLast();
    bool Function() mergeFn;
    switch (previousState.swipe) {
      case SwipeDirection.up:
        mergeFn = mergeUp;
        break;
      case SwipeDirection.down:
        mergeFn = mergeDown;
        break;
      case SwipeDirection.left:
        mergeFn = mergeLeft;
        break;
      case SwipeDirection.right:
        mergeFn = mergeRight;
        break;
    }
    setState(() {
      grid = previousState.previousGrid;
      mergeFn();
      controller.reverse(from: .99).then((_) {
        setState(() {
          grid = previousState.previousGrid;
          for (var t in gridTiles) {
            t.resetAnimations();
          }
        });
      });
    });
  }

  void merge(SwipeDirection direction) {
    bool Function() mergeFn;
    switch (direction) {
      case SwipeDirection.up:
        mergeFn = mergeUp;
        break;
      case SwipeDirection.down:
        mergeFn = mergeDown;
        break;
      case SwipeDirection.left:
        mergeFn = mergeLeft;
        break;
      case SwipeDirection.right:
        mergeFn = mergeRight;
        break;
    }
    List<List<Tile>> gridBeforeSwipe =
        grid.map((row) => row.map((tile) => tile.copy()).toList()).toList();
    setState(() {
      if (mergeFn()) {
        gameStates.add(GameState(gridBeforeSwipe, direction));
        addNewTiles([2]);
        controller.forward(from: 0);
      }
    });
  }

  bool mergeLeft() => grid.map((e) => mergeTiles(e)).toList().any((e) => e);

  bool mergeRight() =>
      grid.map((e) => mergeTiles(e.reversed.toList())).toList().any((e) => e);

  bool mergeUp() => gridCols.map((e) => mergeTiles(e)).toList().any((e) => e);

  bool mergeDown() => gridCols
      .map((e) => mergeTiles(e.reversed.toList()))
      .toList()
      .any((e) => e);

  bool mergeTiles(List<Tile> tiles) {
    bool didChange = false;
    for (int i = 0; i < tiles.length; i++) {
      for (int j = i; j < tiles.length; j++) {
        if (tiles[j].value != 0) {
          Tile? mergeTile =
              tiles.skip(j + 1).firstWhereOrNull((t) => t.value != 0);
          if (mergeTile != null && mergeTile.value != tiles[j].value) {
            mergeTile = null;
          }
          if (i != j || mergeTile != null) {
            didChange = true;
            int resultValue = tiles[j].value;
            tiles[j].moveTo(controller, tiles[i].x, tiles[i].y);
            if (mergeTile != null) {
              resultValue += mergeTile.value;
              mergeTile.moveTo(controller, tiles[i].x, tiles[i].y);
              mergeTile.bounce(controller);
              mergeTile.changeNumber(controller, resultValue);
              mergeTile.value = 0;
              tiles[j].changeNumber(controller, 0);
            }
            tiles[j].value = 0;
            tiles[i].value = resultValue;
          }
          break;
        }
      }
    }
    return didChange;
  }

  void addNewTiles(List<int> values) {
    List<Tile> empty = gridTiles.where((t) => t.value == 0).toList();
    empty.shuffle();
    for (int i = 0; i < values.length; i++) {
      toAdd.add(Tile(empty[i].x, empty[i].y, values[i])..appear(controller));
    }
  }

  void setupNewGame() {
    setState(() {
      gameStates.clear();
      for (var t in gridTiles) {
        t.value = 0;
        t.resetAnimations();
      }
      toAdd.clear();
      addNewTiles([2, 2]);
      controller.forward(from: 0);
    });
  }
}
