import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:tic/level_three.dart';
import 'package:tic/main.dart';
import 'package:video_player/video_player.dart';

class LevelTwoPage extends StatefulWidget {
  const LevelTwoPage({Key? key}) : super(key: key);

  @override
  _LevelTwoPageState createState() => _LevelTwoPageState();
}

class _LevelTwoPageState extends State<LevelTwoPage> {
  late List<String> board;
  late List<Color> backgroundColors;
  late String currentPlayer;
  String? winner;
  int boardSize = 3;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Duration _animationDuration = const Duration(milliseconds: 300);
  late VideoPlayerController _winnerController;
  late VideoPlayerController _drawController;

  bool _isDarkTheme = true; // Track the theme mode

  final ThemeData _darkTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF34495E), // Dark blue color
    ),
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF34495E),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF34495E),
      primary: const Color(0xFF34495E),
      secondary: Colors.purpleAccent,
      background: const Color(0xFF34495E),
      brightness: Brightness.dark, // Ensure this matches brightness
    ),
    dialogBackgroundColor: const Color(0xFF450758),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.pink,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  ThemeData get _lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: Colors.pink,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.purple), // Change icon color here
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.pink,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.pink,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _winnerController = VideoPlayerController.asset('assets/winner.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
    _drawController = VideoPlayerController.asset('assets/draw.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
    resetGame();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _winnerController.dispose();
    _drawController.dispose();
    super.dispose();
  }

  void resetGame() {
    setState(() {
      board = List<String>.filled(9, '');
      backgroundColors = List<Color>.filled(9, const Color(0xFFD6EAF8));
      currentPlayer = 'X';
      winner = null;
    });
  }

  void handleTap(int index) {
    if (board[index] != '' || winner != null) return;
    setState(() {
      board[index] = currentPlayer;
      backgroundColors[index] = currentPlayer == 'X' ? Colors.blue.withOpacity(0.5) : Colors.red.withOpacity(0.5);
      _playSound('draw.mp3');
      winner = calculateWinner();
      if (winner != null) {
        if (winner == 'X') {
          showWinnerDialog();
        } else if (winner == 'O') {
          showOWinsDialog();
        }
      } else if (isBoardFull()) {
        showDrawDialog();
      } else {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        if (currentPlayer == 'O') {
          Future.delayed(_animationDuration, aiMoveLevelTwo);
        }
      }
    });
  }


  // Add this method to your _LevelOnePageState class
  Widget buildDialog({
    required String title,
    required String message,
    required String buttonText,
    required VoidCallback onPressed,
    required Color backgroundColor,
    String? secondButtonText,
    VoidCallback? secondButtonPressed,
  })

  {
    return AlertDialog(
      backgroundColor: backgroundColor,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: _isDarkTheme ? Colors.pink : Colors.pink[800],
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('images/win.png'), // Adjust this path as needed
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: _isDarkTheme ? Colors.white70 : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        SizedBox(
          width: 300,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purpleAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
        if (secondButtonText != null && secondButtonPressed != null)
          SizedBox(
            width: 300,
            child: ElevatedButton(
              onPressed: secondButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                secondButtonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
      ],
    );
  }

  bool isBoardFull() {
    return board.every((element) => element.isNotEmpty);
  }

  void aiMoveLevelTwo() {
    List<int> availableMoves = [];
    for (int i = 0; i < board.length; i++) {
      if (board[i] == '') {
        availableMoves.add(i);
      }
    }
    if (availableMoves.isNotEmpty) {
      int move = availableMoves[Random().nextInt(availableMoves.length)];
      setState(() {
        board[move] = currentPlayer;
        backgroundColors[move] =
        currentPlayer == 'X' ? Colors.blue.withOpacity(0.5) : Colors.red.withOpacity(0.5);
        _playSound('draw.mp3');
        winner = calculateWinner();
        if (winner != null) {
          showWinnerDialog();
        } else if (isBoardFull()) {
          showDrawDialog();
        }
        if (winner == null) {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  String? calculateWinner() {
    List<List<int>> lines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var line in lines) {
      if (line.every((index) => board[index] == board[line[0]] && board[line[0]] != '')) {
        _playSound('vanessa.mp3');
        return board[line[0]];
      }
    }
    return null;
  }

  Widget buildSquare(int index) {
    Gradient gradient;
    Color textColor;

    if (board[index] == 'X') {
      gradient = LinearGradient(
        colors: [Colors.purple.shade100, Colors.purple.shade400],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      textColor = Colors.blue.shade900;
    } else if (board[index] == 'O') {
      gradient = LinearGradient(
        colors: [Colors.red.shade100, Colors.red.shade400],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      textColor = Colors.red.shade900;
    } else {
      gradient = LinearGradient(
        colors: [_isDarkTheme ? const Color(0xFF34495E) : Colors.white, _isDarkTheme ? const Color(0xFF34495E) : Colors.white],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      textColor = _isDarkTheme ? Colors.grey.shade900 : Colors.grey.shade600;
    }

    return GestureDetector(
      onTap: () => handleTap(index),
      child: AnimatedContainer(
        duration: _animationDuration,
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(3, 3),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.6),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(-3, -3),
            ),
          ],
          border: Border.all(
            color: Colors.purpleAccent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Text(
            board[index],
            style: TextStyle(
              fontSize: 46,
              color: textColor,
              fontWeight: FontWeight.bold,
              shadows: const [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black,
                  offset: Offset(5.0, 5.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkTheme ? _darkTheme : _lightTheme,
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const WelcomePage()), // Replace with your main page
                      (route) => false,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: resetGame,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Tic Tac Toe - Level 2',
                style: TextStyle(
                  fontSize: 54,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: <Color>[Colors.blue, Colors.purple],
                    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                ),
              ),
              Text(
                winner == null ? 'Current Player: $currentPlayer' : 'Winner: $winner',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: boardSize,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: board.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => buildSquare(index),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _isDarkTheme = !_isDarkTheme;
            });
          },
          backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,

          child: Icon(
            _isDarkTheme ? Icons.wb_sunny : Icons.nightlight_round,
            color: Theme.of(context).floatingActionButtonTheme.foregroundColor,),
        ),
      ),
    );
  }


  void _playSound(String soundFile) async {
    try {
      await _audioPlayer.play(AssetSource(soundFile));
    } catch (e) {
      if (kDebugMode) {
        print("Error playing sound: $e");
      }
    }
  }



  void showWinnerDialog() {
    _playSound('vanessa.mp3');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _isDarkTheme ? _darkTheme.dialogBackgroundColor : _lightTheme.dialogBackgroundColor,
        title: Text(
          winner == 'X' ? 'Winner!' : 'O Wins!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _isDarkTheme ? Colors.pink : Colors.pink[800],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/win.png'),
            const SizedBox(height: 20),
            Text(
              winner == 'X' ? 'Whaooooh! Congratulations, you win!' : 'Try again!',
              style: TextStyle(
                fontSize: 16,
                color: _isDarkTheme ? Colors.white70 : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          if (winner == 'X') ...[
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  resetGame();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Play Again',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LevelThreePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Next Level',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ] else ...[
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  resetGame();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Play Again',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void showOWinsDialog() {
    _playSound('win.mp3');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _isDarkTheme ? _darkTheme.dialogBackgroundColor : _lightTheme.dialogBackgroundColor,
        title: Text(
          'O Wins!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _isDarkTheme ? Colors.pink : Colors.pink[800],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/win.png'),
            const SizedBox(height: 20),
            const Text(
              'Try again!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: 300,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Play Again',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showDrawDialog() {
    _playSound('game_over.mp3'); // Play a sound for a draw

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _isDarkTheme ? _darkTheme.dialogBackgroundColor : _lightTheme.dialogBackgroundColor,
        title: Text(
          'Draw!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _isDarkTheme ? Colors.pink : Colors.pink[800],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/draw.png'), // Use an image for draw
            const SizedBox(height: 20),
            const Text(
              'It\'s a draw! Try again!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: 300,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Play Again',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
