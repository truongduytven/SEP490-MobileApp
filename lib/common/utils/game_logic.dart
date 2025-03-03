import 'dart:math';

import 'player.dart';

class Game {
  static final boardlenth = 9;
  static final blocSize = 100.0;

  List<String>? board;

  static List<String>? initGameBoard() =>
      List.generate(boardlenth, (index) => Player.empty);

  bool winnerCheck(String player, int index, List<int> scoreboard, int gridSize) {
    int row = index ~/ 3;
    int col = index % 3;
    int score = player == "X" ? 1 : -1;

    scoreboard[row] += score;
    scoreboard[gridSize + col] += score;

    if (row == col) scoreboard[2 * gridSize] += score;
    if (gridSize - 1 - col == row) scoreboard[2 * gridSize + 1] += score;

    if (scoreboard.contains(3) || scoreboard.contains(-3)) {
      return true;
    }

    return false;
  }

  int evaluateBoard(List<String> board) {
    // Kiểm tra xem AI ("O") có thắng không
    if (winnerCheck("O", 0, List.filled(8, 0), 3)) {
      return 10;
    }
    // Kiểm tra xem người chơi ("X") có thắng không
    if (winnerCheck("X", 0, List.filled(8, 0), 3)) {
      return -10;
    }
    // Nếu không ai thắng, trả về 0 (hòa)
    return 0;
  }

  int minimax(List<String> board, int depth, bool isMaximizing, int alpha, int beta) {
    int score = evaluateBoard(board);

    // Nếu AI thắng, trả về điểm số
    if (score == 10) return score - depth;
    // Nếu người chơi thắng, trả về điểm số
    if (score == -10) return score + depth;
    // Nếu bảng đầy, trả về 0 (hòa)
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
          if (beta <= alpha) {
            break; // Alpha-Beta Pruning
          }
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
          if (beta <= alpha) {
            break; // Alpha-Beta Pruning
          }
        }
      }
      return bestScore;
    }
  }

  int checkImmediateWinOrBlock(List<String> board, String player) {
    for (int i = 0; i < board.length; i++) {
      if (board[i] == Player.empty) {
        board[i] = player;
        if (winnerCheck(player, i, List.filled(8, 0), 3)) {
          board[i] = Player.empty;
          return i;
        }
        board[i] = Player.empty;
      }
    }
    return -1;
  }

  int findBestMove(List<String> board) {
    // Kiểm tra xem AI có thể chiến thắng ngay không
    int winningMove = checkImmediateWinOrBlock(board, "O");
    if (winningMove != -1) return winningMove;

    // Kiểm tra xem người chơi có thể chiến thắng ngay không và chặn lại
    int blockingMove = checkImmediateWinOrBlock(board, "X");
    if (blockingMove != -1) return blockingMove;

    // Nếu không, sử dụng Minimax để chọn nước đi tốt nhất
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
}