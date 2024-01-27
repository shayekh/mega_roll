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

  String result = '';
  int index1 = 0, index2 = 0, diceSum = 0, target = 0;
  bool hasTarget = false;
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
        child: Column(
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
            Text(
              result,
              style: const TextStyle(fontSize: 50),
            ),
            ElevatedButton(
                onPressed: () {
                  rollDice();
                },
                child: const Text("ROLL")),
            ElevatedButton(
                onPressed: () {
                  reset();
                },
                child: const Text("RESET"))
          ],
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
      result = "You Win!!!";
    } else if (diceSum == 7) {
      result = "You Lost!!!";
    }
  }

  void checkFirstRoll() {
    if (diceSum == 7 || diceSum == 11) {
      result = "You Win!!!";
    } else if (diceSum == 2 || diceSum == 3 || diceSum == 12) {
      result = "You Lost!!!";
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
    });
  }
}

const gameRules = '''
*At the first roll, if the dice sum is 7 or 11, you win!
*At the first roll, if the dice sum is 2, 3 or 12, you lost!
*At the first roll, if the dice sum is 4,6,6,8,9,10, then this sum will be the target!
*If dice sum matches the target point, you win!
*If the dice sum is 7, you lost!
''';
