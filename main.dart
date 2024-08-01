import 'package:flutter/material.dart';
import 'level_five.dart';
import 'level_two.dart';
import 'level_four.dart';
import 'level_one.dart';
import 'level_three.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key,});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Tic Tac Toe',
                style: TextStyle(
                  fontSize: 54,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: <Color>[Colors.blue, Colors.purple],
                    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                ),
              ),
            ),
            // Background image
            Positioned.fill(
              child: Image.asset(
                'images/tic.png', // Replace with your image asset path
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Choose Level To Play',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueGrey
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 300,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LevelOnePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                label: const Text('Level One', style: TextStyle(fontSize: 16,color: Colors.white70),),
                icon: const Icon(Icons.arrow_forward),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 300,
              height: 40,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LevelTwoPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.arrow_forward), // Replace with your desired icon
                label: const Text(
                  'Level Two',
                  style: TextStyle(fontSize: 16,color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LevelThreePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.arrow_forward), // Replace with your desired icon
                label: const Text(
                  'Level Three',
                  style: TextStyle(fontSize: 17,color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 300,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LevelFourPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.arrow_forward), // Replace with your desired icon
                label: const Text(
                  'Level Four',
                  style: TextStyle(fontSize: 20,color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 8),

            SizedBox(
              width: 300,
              height: 70,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LevelFivePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.arrow_forward), // Replace with your desired icon
                label: const Text(
                  'Level Five',
                  style: TextStyle(fontSize: 22,color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
