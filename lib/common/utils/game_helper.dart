import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class Cell {
  int row;
  int col;
  dynamic content;
  bool reveal = false;
  bool isFlagged = false; // Thêm trạng thái đánh dấu lá cờ
  Cell(this.row, this.col, this.content, this.reveal);
}

class MineSweeperGame {
  static int row = 6;
  static int col = 6;
  static int cells = row * col;
  bool gameOver = false;
  List<Cell> gameMap = [];
  static List<List<dynamic>> map = List.generate(
    row,
    (x) => List.generate(col, (y) => Cell(x, y, "", false)),
  );

  // Callback để thông báo cho UI cập nhật lại
  final VoidCallback? onUpdate;

  MineSweeperGame({this.onUpdate});

  void generateMap() {
    PlaceMines(10);
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        gameMap.add(map[i][j]);
      }
    }
  }

  void resetGame() {
    map = List.generate(
      row,
      (x) => List.generate(col, (y) => Cell(x, y, "", false)),
    );
    gameMap.clear();
    generateMap();
    if (onUpdate != null) onUpdate!(); // Thông báo cập nhật UI
  }

  static void PlaceMines(int minesNumber) {
    Random random = Random();
    for (int i = 0; i < minesNumber; i++) {
      int mineRow = random.nextInt(row);
      int mineCol = random.nextInt(col);
      map[mineRow][mineCol] = Cell(mineRow, mineCol, FontAwesomeIcons.bomb, false);
    }
  }

  void showMines() {
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        if (map[i][j].content == FontAwesomeIcons.bomb) {
          map[i][j].reveal = true;
        }
      }
    }
    if (onUpdate != null) onUpdate!(); // Thông báo cập nhật UI
  }

  void toggleFlag(Cell cell) {
    if (!cell.reveal) {
      cell.isFlagged = !cell.isFlagged;
      if (onUpdate != null) onUpdate!(); // Thông báo cập nhật UI
    }
  }

  void getClickedCell(Cell cell) {
    if (cell.isFlagged || cell.reveal) return; // Không làm gì nếu ô đã được đánh dấu hoặc đã mở

    if (cell.content == FontAwesomeIcons.bomb) {
      showMines();
      gameOver = true;
    } else {
      int mineCount = 0;
      int cellRow = cell.row;
      int cellCol = cell.col;

      for (int i = max(cellRow - 1, 0); i <= min(cellRow + 1, row - 1); i++) {
        for (int j = max(cellCol - 1, 0); j <= min(cellCol + 1, col - 1); j++) {
          if (map[i][j].content ==FontAwesomeIcons.bomb) {
            mineCount++;
          }
        }
      }
      cell.content = mineCount;
      cell.reveal = true;
      if (mineCount == 0) {
        for (int i = max(cellRow - 1, 0); i <= min(cellRow + 1, row - 1); i++) {
          for (int j = max(cellCol - 1, 0); j <= min(cellCol + 1, col - 1); j++) {
            if (map[i][j].content == "") {
              getClickedCell(map[i][j]);
            }
          }
        }
      }
    }
    if (onUpdate != null) onUpdate!(); // Thông báo cập nhật UI
  }
}