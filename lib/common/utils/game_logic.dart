import 'dart:math';

import 'player.dart';

class Game {
  static final boardLength = 9;
  static final blocSize = 100.0;

  List<String>? board;
  int difficulty = 1; // Mặc định là cấp độ dễ

  static List<String>? initGameBoard() =>
      List.generate(boardLength, (index) => Player.empty);

  void setDifficulty(int level) {
    difficulty = level;
  }

  bool winnerCheck(
      String player, int index, List<int> scoreboard, int gridSize) {
    int row = index ~/ 3;
    int col = index % 3;
    int score = player == "X" ? 1 : -1;

    scoreboard[row] += score;
    scoreboard[gridSize + col] += score;

    if (row == col) scoreboard[2 * gridSize] += score;
    if (gridSize - 1 - col == row) scoreboard[2 * gridSize + 1] += score;

    return scoreboard.contains(3) || scoreboard.contains(-3);
  }

  int evaluateBoard(List<String> board) {
    if (winnerCheck("O", 0, List.filled(8, 0), 3)) return 10;
    if (winnerCheck("X", 0, List.filled(8, 0), 3)) return -10;
    return 0;
  }

  int minimax(
      List<String> board, int depth, bool isMaximizing, int alpha, int beta) {
    int score = evaluateBoard(board);
    if (score == 10) return score - depth;
    if (score == -10) return score + depth;
    if (board.every((cell) => cell != Player.empty)) return 0;

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < board.length; i++) {
        if (board[i] == Player.empty) {
          board[i] = "O";
          int currentScore = minimax(board, depth + 1, false, alpha, beta);
          board[i] = Player.empty;
          bestScore = max(bestScore, currentScore);
          alpha = max(alpha, bestScore);
          if (beta <= alpha) break;
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < board.length; i++) {
        if (board[i] == Player.empty) {
          board[i] = "X";
          int currentScore = minimax(board, depth + 1, true, alpha, beta);
          board[i] = Player.empty;
          bestScore = min(bestScore, currentScore);
          beta = min(beta, bestScore);
          if (beta <= alpha) break;
        }
      }
      return bestScore;
    }
  }

  int checkImmediateWinOrBlock(
      List<String> board, String player, List<int> scoreboard) {
    for (int i = 0; i < board.length; i++) {
      if (board[i] == Player.empty) {
        List<int> boardData = List.from(scoreboard);
        board[i] = player;
        if (winnerCheck(player, i, boardData, 3)) {
          board[i] = Player.empty;
          return i;
        }
        board[i] = Player.empty;
      }
    }
    return -1;
  }

  int findBestMove(List<String> board, List<int> scoreboard) {
    return difficulty == 1
        ? getEasyMove(board, scoreboard)
        : getHardMove(board, scoreboard);
  }

  int getEasyMove(List<String> board, List<int> scoreboard) {
    var emptyIndexes = List.generate(board.length, (i) => i)
        .where((i) => board[i] == Player.empty)
        .toList();
    return emptyIndexes.isNotEmpty
        ? emptyIndexes[Random().nextInt(emptyIndexes.length)]
        : -1;
  }

  int getHardMove(List<String> board, List<int> scoreboard) {
    print('Khó nè');
    int winningMove = checkImmediateWinOrBlock(board, "O", scoreboard);
    if (winningMove != -1) return winningMove;

    int blockingMove = checkImmediateWinOrBlock(board, "X", scoreboard);
    if (blockingMove != -1) return blockingMove;

    int forcedMove = checkDoubleThreat(board, "X");
    if (forcedMove != -1) return forcedMove;

    int bestScore = -1000;
    int bestMove = -1;

    for (int i = 0; i < board.length; i++) {
      if (board[i] == Player.empty) {
        board[i] = "O";
        int score = minimax(board, 0, false, -1000, 1000);
        board[i] = Player.empty;
        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
      }
    }

    return bestMove;
  }

  int checkDoubleThreat(List<String> board, String player) {
    List<int> threatMoves = [];

    for (int i = 0; i < board.length; i++) {
      if (board[i] == Player.empty) {
        board[i] = player;
        int threatCount = 0;

        for (int j = 0; j < board.length; j++) {
          if (board[j] == Player.empty) {
            board[j] = player;
            if (winnerCheck(player, j, List.filled(8, 0), 3)) {
              threatCount++;
            }
            board[j] = Player.empty;
          }
        }

        if (threatCount >= 2) {
          threatMoves.add(i);
        }
        board[i] = Player.empty;
      }
    }

    return threatMoves.isNotEmpty ? threatMoves.first : -1;
  }
}
