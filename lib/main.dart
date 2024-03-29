import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.russoOneTextTheme(),
      ),
      home: const GamePage(),
    );
  }
}

enum GameStatus {
  running,
  over,
  none,
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final diceList = [
    'images/d1.png',
    'images/d2.png',
    'images/d3.png',
    'images/d4.png',
    'images/d5.png',
    'images/d6.png',
  ];

  static const String win = 'You Win!!!';
  static const String lost = 'You Lost!!!';
  GameStatus gameStatus = GameStatus.none;
  String result = '';
  int index1 = 0, index2 = 0, diceSum = 0, target = 0;
  bool hasTarget = false, shouldShowBoard = false;
  final random = Random.secure();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Mega Roll"),
      ),
      body: Center(
        child: shouldShowBoard
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        diceList[index1],
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        diceList[index2],
                        width: 100,
                        height: 100,
                      ),
                    ],
                  ),
                  Text(
                    'Dice Sum:' '$diceSum',
                    style: const TextStyle(fontSize: 25),
                  ),
                  if (hasTarget)
                    Text(
                      'Your target: $target\n Keep rolling to match $target',
                      style: const TextStyle(fontSize: 27),
                    ),
                  if (gameStatus == GameStatus.over)
                    Text(
                      result,
                      style: const TextStyle(fontSize: 50),
                    ),
                  if (gameStatus == GameStatus.running)
                    DiceButton(
                      label: 'ROLL',
                      onPressed: () {
                        rollDice();
                      },
                    ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       reset();
                  //     },
                  //     child: const Text("RESET"))
                  if (gameStatus == GameStatus.over)
                    DiceButton(
                      label: 'RESET',
                      onPressed: () {
                        reset();
                      },
                    ),
                ],
              )
            : StartPage(
                onStart: startGame,
              ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void rollDice() {
    setState(() {
      index1 = random.nextInt(6);
      index2 = random.nextInt(6);
      diceSum = index1 + index2 + 2;
      if (hasTarget) {
        checkTarget();
      } else {
        checkFirstRoll();
      }
    });
  }

  void checkTarget() {
    if (target == diceSum) {
      result = win;
      gameStatus = GameStatus.over;
    } else if (diceSum == 7) {
      result = lost;
      gameStatus = GameStatus.over;
    }
  }

  void checkFirstRoll() {
    if (diceSum == 7 || diceSum == 11) {
      result = win;
      gameStatus = GameStatus.over;
    } else if (diceSum == 2 || diceSum == 3 || diceSum == 12) {
      result = lost;
      gameStatus = GameStatus.over;
    } else {
      hasTarget = true;
      target = diceSum;
    }
  }

  void reset() {
    setState(() {
      index1 = 0;
      index2 = 0;
      diceSum = 0;
      target = 0;
      result = '';
      hasTarget = false;
      shouldShowBoard = false;
      gameStatus = GameStatus.none;
    });
  }

  startGame() {
    setState(() {
      shouldShowBoard = true;
      gameStatus = GameStatus.running;
    });
  }
}

class StartPage extends StatelessWidget {
  final VoidCallback onStart;

  const StartPage({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'images/dicelogo.png',
          width: 150,
          height: 150,
        ),
        RichText(
            text: TextSpan(
                text: 'MEGA',
                style: GoogleFonts.russoOne().copyWith(
                  color: Colors.red,
                  fontSize: 40,
                ),
                children: [
              TextSpan(
                  text: 'ROLL',
                  style: GoogleFonts.russoOne().copyWith(
                    color: Colors.black,
                  ))
            ])),
        const Spacer(),
        DiceButton(label: 'START', onPressed: onStart),
        DiceButton(
            label: 'HOW TO PLAY',
            onPressed: () {
              showInstruction(context);
            })
      ],
    );
  }

  void showInstruction(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Instructions'),
              content: const Text(gameRules),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CLOSE'),
                )
              ],
            ));
  }
}

class DiceButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const DiceButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 200,
        height: 60,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: Text(
            label,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

const gameRules = '''
*At the first roll, if the dice sum is 7 or 11, you win!
*At the first roll, if the dice sum is 2, 3 or 12, you lost!
*At the first roll, if the dice sum is 4,6,6,8,9,10, then this sum will be the target!
*If dice sum matches the target point, you win!
*If the dice sum is 7, you lost!
''';
