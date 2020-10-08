import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class Stage extends StatefulWidget {
  @override
  _StageState createState() => _StageState();
}

class _StageState extends State<Stage> {
  static int numCell = 500;
  var snackPosition = [5, 25, 45];
  var direction = 'down';

  int cont = 0;

  static var randomNumber = Random();
  int food = randomNumber.nextInt(numCell);

  void startGame() {
    snackPosition = [5, 25, 45];
    direction = 'down';
    const duration = Duration(milliseconds: 100);

    Timer.periodic(duration, (timer) {
      cont += 50;

      if (cont > 500 - snackPosition.length * 50) {
        cont = 0;
        updateSnake();
        setState(() {
          if (snackPosition.last == food) {
            food = randomNumber.nextInt(numCell);
          } else {
            snackPosition.removeAt(0);
          }
        });

        if (gameOver()) {
          timer.cancel();
          showGameOver();
        }
      }
    });
  }

  void showGameOver() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text("Score: ${(snackPosition.length - 3).toString()}"),
          actions: [
            FlatButton(
              onPressed: () {
                startGame();
                Navigator.of(context).pop();
              },
              child: Text("Try Again"),
            )
          ],
        );
      },
    );
  }

  bool gameOver() {
    var distinct = snackPosition.toSet().toList();

    if (distinct.length == snackPosition.length)
      return false;
    else
      return true;
  }

  void updateSnake() {
    switch (direction) {
      case 'down':
        if (snackPosition.last > (numCell - 20)) {
          snackPosition.add(snackPosition.last + 20 - numCell);
        } else {
          snackPosition.add(snackPosition.last + 20);
        }
        break;

      case 'up':
        if (snackPosition.last < 20) {
          snackPosition.add(snackPosition.last - 20 + numCell);
        } else {
          snackPosition.add(snackPosition.last - 20);
        }
        break;

      case 'left':
        if ((snackPosition.last) % 20 == 0) {
          snackPosition.add(snackPosition.last + 19);
        } else {
          snackPosition.add(snackPosition.last - 1);
        }
        break;

      case 'right':
        if ((snackPosition.last + 1) % 20 == 0) {
          snackPosition.add(snackPosition.last - 19);
        } else {
          snackPosition.add(snackPosition.last + 1);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.blueGrey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Snack Game",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (direction != 'up' && details.delta.dy > 0) {
                    direction = 'down';
                  } else if (direction != 'down' && details.delta.dy < 0) {
                    direction = 'up';
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (direction != 'left' && details.delta.dx > 0) {
                    direction = 'right';
                  } else if (direction != 'right' && details.delta.dx < 0) {
                    direction = 'left';
                  }
                },
                child: Container(
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 20,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                    ),
                    itemCount: numCell,
                    itemBuilder: (context, index) {
                      if (snackPosition.contains(index)) {
                        return Container(color: Colors.red);
                      } else if (index == food) {
                        return Container(color: Colors.blue);
                      } else
                        return Container(color: Colors.white);
                    },
                  ),
                ),
              ),
            ),
            Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton(
                    onPressed: startGame,
                    child: Text(
                      "Start",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  Text(
                    "Score: ${(snackPosition.length - 3).toString()}",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        decoration: TextDecoration.none),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
