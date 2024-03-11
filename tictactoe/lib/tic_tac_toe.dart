import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TicTacToeGame(),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  late List<List<String?>> board;
  String? currentPlayer;
  String? winner;

  @override
  void initState() {
    super.initState();
    initializeBoard();
  }

  void initializeBoard() {
    board = List.generate(3, (_) => List.filled(3, null));
    currentPlayer = 'X';
    winner = null;
  }

  void makeMove(int row, int col) {
    if (board[row][col] == null && winner == null) {
      setState(() {
        board[row][col] = currentPlayer;
        if (checkWinner(row, col)) {
          showWinner();
        } else if (isBoardFull()) {
          showDraw();
        } else {
          currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
        }
      });
    }
  }

  bool checkWinner(int row, int col) {
    // Check row
    if (board[row].every((element) => element == currentPlayer)) {
      winner = currentPlayer;
      return true;
    }

    // Check column
    if (board.every((row) => row[col] == currentPlayer)) {
      winner = currentPlayer;
      return true;
    }

    // Check diagonals
    if (row == col &&
        board
            .every((row) => row[row.indexOf(currentPlayer)] == currentPlayer)) {
      winner = currentPlayer;
      return true;
    }

    if (row + col == 2 &&
        board.every(
            (row) => row[2 - row.indexOf(currentPlayer)] == currentPlayer)) {
      winner = currentPlayer;
      return true;
    }

    return false;
  }

  bool isBoardFull() {
    return board.every((row) => row.every((cell) => cell != null));
  }

  void showWinner() {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('$winner Wins!'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  resetGame();
                },
                child: Text('New Game'),
              ),
            ],
          );
        },
      );
    });
  }

  void showDraw() {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('It\'s a Draw!'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  resetGame();
                },
                child: Text('New Game'),
              ),
            ],
          );
        },
      );
    });
  }

  void resetGame() {
    setState(() {
      initializeBoard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.green], // Adjust gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                (winner != null)
                    ? '$winner Wins!'
                    : (isBoardFull()
                        ? 'It\'s a Draw!'
                        : 'Current Player: $currentPlayer'),
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (row) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (col) => GestureDetector(
                        onTap: () => makeMove(row, col),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: Center(
                            child: Text(
                              board[row][col] ?? '',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: resetGame,
                child: Text('New Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
