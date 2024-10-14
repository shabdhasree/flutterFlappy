import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static double birdY = 0; // Initial bird Y position
  double initialPosition = birdY;
  double height = 0;
  double time = 0;
  double gravity = -4.9; // Gravity effect
  double velocity = 3.5;  // Initial upward velocity
  bool gameHasStarted = false;
  static double barrierXOne = 1; // Position of first barrier
  double barrierXTwo = barrierXOne + 1.5; // Position of second barrier
  double birdWidth = 0.1; // Bird size
  double birdHeight = 0.1;

  // Start the game and update the position of the bird and barriers
  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      time += 0.05;
      height = gravity * time * time + velocity * time;

      setState(() {
        birdY = initialPosition - height;

        // Move barriers
        if (barrierXOne < -1.5) {
          barrierXOne += 3;
        } else {
          barrierXOne -= 0.05;
        }

        if (barrierXTwo < -1.5) {
          barrierXTwo += 3;
        } else {
          barrierXTwo -= 0.05;
        }

        // Check for collision with ground or barriers
        if (birdY > 1 || birdY < -1) {
          timer.cancel();
          gameHasStarted = false;
        }
      });

      if (!gameHasStarted) {
        timer.cancel();
      }
    });
  }

  // Bird jumps when the screen is tapped
  void jump() {
    setState(() {
      time = 0;
      initialPosition = birdY;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.blue,
                child: Stack(
                  children: [
                    AnimatedContainer(
                      alignment: Alignment(0, birdY),
                      duration: Duration(milliseconds: 0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * birdHeight / 2,
                        width: MediaQuery.of(context).size.width * birdWidth / 2,
                        child: Image.asset('assets/bird.png'), // Use a bird image here
                      ),
                    ),
                    Container(
                      alignment: Alignment(0, -0.3),
                      child: gameHasStarted
                          ? const  Text("")
                          : const Text(
                              "T A P  T O  P L A Y",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXOne, 1.1),
                      duration: Duration(milliseconds: 0),
                      child: Barrier(
                        size: 200.0,
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXOne, -1.1),
                      duration: Duration(milliseconds: 0),
                      child: Barrier(
                        size: 150.0,
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXTwo, 1.1),
                      duration: Duration(milliseconds: 0),
                      child: Barrier(
                        size: 100.0,
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXTwo, -1.1),
                      duration: Duration(milliseconds: 0),
                      child: Barrier(
                        size: 250.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: const Center(
                  child: Text(
                    "SCORE: 0",
                    style: TextStyle(color: Colors.white, fontSize: 35),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Barrier widget to represent the pipes
class Barrier extends StatelessWidget {
  final double size;
  Barrier({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: size,
      decoration: BoxDecoration(
        color: Colors.green,
        border: Border.all(width: 10,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
