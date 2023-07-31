import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pacman/path.dart';
import 'package:pacman/pixel.dart';
import 'package:pacman/player.dart';
import 'package:pacman/ghost.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int nsqs = nrow * 17;
  static int nrow = 11;
  int player = nrow * 15 + 1;
  int ghost = nrow * 15 + 2;
  bool mouthclosed = false;
  int score = 0;

  static List<int> barriers = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    22,
    33,
    44,
    55,
    66,
    77,
    99,
    110,
    121,
    132,
    143,
    154,
    165,
    176,
    177,
    178,
    179,
    180,
    181,
    182,
    183,
    184,
    185,
    186,
    175,
    164,
    153,
    142,
    131,
    120,
    109,
    87,
    76,
    65,
    54,
    43,
    32,
    21,
    24,
    35,
    46,
    57,
    26,
    37,
    38,
    39,
    28,
    30,
    41,
    52,
    63,
    59,
    70,
    61,
    72,
    78,
    79,
    80,
    81,
    83,
    84,
    85,
    86,
    100,
    101,
    102,
    103,
    105,
    106,
    107,
    108,
    114,
    125,
    116,
    127,
    123,
    134,
    145,
    156,
    147,
    148,
    149,
    158,
    160,
    129,
    140,
    151,
    162,
  ];

  List<int> food = [];
  List<int> vis = [];

  void getfood() {
    for (int i = 0; i < nsqs; i++) {
      if (!barriers.contains(i)) {
        food.add(i);
      }
    }
  }

  String dir = "right";

  void startgame() {
    getfood();
    moveghost();
    Duration duration = const Duration(milliseconds: 100);
    Timer.periodic(duration, (timer) {
      setState(() {
        mouthclosed = !mouthclosed;
      });
      if (food.contains(player)) {
        score++;
        food.remove(player);
        vis.add(player);
      }
      switch (dir) {
        case "left":
          left();
          break;
        case "right":
          right();
          break;
        case "up":
          up();
          break;
        case "down":
          down();
          break;
      }
    });
  }

  String ghostdir = "left";
  void moveghost() {
    Duration gs = const Duration(milliseconds: 500);

    // old logic IT WORKS THO!!
    /* Timer.periodic(gs, (timer) {
      if (!barriers.contains(ghost - 1) && ghostdir != "right") {
        ghostdir = "left";
      } else if (!barriers.contains(ghost - nrow) && ghostdir != "down") {
        ghostdir = "up";
      } else if (!barriers.contains(ghost + nrow) && ghostdir != "up") {
        ghostdir = "down";
      } else if (!barriers.contains(ghost + 1) && ghostdir != "left") {
        ghostdir = "right";
      }
      switch (ghostdir) {
        case "right":
          setState(() {
            ghost++;
          });
          break;
        case "up":
          setState(() {
            ghost -= nrow;
          });
          break;
        case "left":
          ghost--;
          break;
        case "down":
          ghost += nrow;
          break;
      }
    }); */

    Timer.periodic(gs, (timer) {
      switch (ghostdir) {
        case "left":
          if (!barriers.contains(ghost - 1)) {
            setState(() {
              ghost--;
            });
          } else {
            if (!barriers.contains(ghost + nrow)) {
              setState(() {
                ghost += nrow;
                ghostdir = "down";
              });
            } else if (!barriers.contains(ghost + 1)) {
              setState(() {
                ghost++;
                ghostdir = "right";
              });
            } else if (!barriers.contains(ghost - nrow)) {
              setState(() {
                ghost -= nrow;
                ghostdir = "up";
              });
            }
          }
          break;
        case "right":
          if (!barriers.contains(ghost + 1)) {
            setState(() {
              ghost++;
            });
          } else {
            if (!barriers.contains(ghost - nrow)) {
              setState(() {
                ghost -= nrow;
                ghostdir = "up";
              });
            } else if (!barriers.contains(ghost + nrow)) {
              setState(() {
                ghost += nrow;
                ghostdir = "down";
              });
            } else if (!barriers.contains(ghost - 1)) {
              setState(() {
                ghost--;
                ghostdir = "left";
              });
            }
          }
          break;
        case "up":
          if (!barriers.contains(ghost - nrow)) {
            setState(() {
              ghost -= nrow;
              ghostdir = "up";
            });
          } else {
            if (!barriers.contains(ghost + 1)) {
              setState(() {
                ghost++;
                ghostdir = "right";
              });
            } else if (!barriers.contains(ghost - 1)) {
              setState(() {
                ghost--;
                ghostdir = "left";
              });
            } else if (!barriers.contains(ghost + nrow)) {
              setState(() {
                ghost += nrow;
                ghostdir = "down";
              });
            }
          }
          break;
        case "down":
          if (!barriers.contains(ghost + nrow)) {
            setState(() {
              ghost += nrow;
              ghostdir = "down";
            });
          } else {
            if (!barriers.contains(ghost - 1)) {
              setState(() {
                ghost--;
                ghostdir = "left";
              });
            } else if (!barriers.contains(ghost + 1)) {
              setState(() {
                ghost++;
                ghostdir = "right";
              });
            } else if (!barriers.contains(ghost - nrow)) {
              setState(() {
                ghost -= nrow;
                ghostdir = "up";
              });
            }
          }
          break;
      }
    });
  }

  void left() {
    if (!barriers.contains(player - 1)) {
      setState(() {
        player--;
      });
    }
  }

  void right() {
    if (!barriers.contains(player + 1)) {
      setState(() {
        player++;
      });
    }
  }

  void up() {
    if (!barriers.contains(player - nrow)) {
      setState(() {
        player -= nrow;
      });
    }
  }

  void down() {
    if (!barriers.contains(player + nrow)) {
      setState(() {
        player += nrow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
              flex: 5,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0) {
                    dir = "down";
                  } else if (details.delta.dy < 0) {
                    dir = "up";
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx > 0) {
                    dir = "right";
                  } else if (details.delta.dx < 0) {
                    dir = "left";
                  }
                },
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: nsqs,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: nrow),
                    itemBuilder: (BuildContext context, int index) {
                      if (mouthclosed && player == index) {
                        return Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.yellow[400],
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      } else if (ghost == index) {
                        return const Ghost();
                      } else if (player == index) {
                        switch (dir) {
                          case "left":
                            return Transform.rotate(
                              angle: pi,
                              child: const Player(),
                            );
                          case "right":
                            return const Player();
                          case "up":
                            return Transform.rotate(
                              angle: 3 * pi / 2,
                              child: const Player(),
                            );
                          case "down":
                            return Transform.rotate(
                              angle: pi / 2,
                              child: const Player(),
                            );
                          default:
                            return const Player();
                        }
                      } else if (barriers.contains(index)) {
                        return Pixel(
                          innercolor: Colors.blue[800],
                          outercolor: Colors.blue[900],
                        );
                      } else if (!barriers.contains(index) &&
                          vis.contains(index)) {
                        return const MyPath(
                          innercolor: Colors.black,
                          outercolor: Colors.black,
                        );
                      } else {
                        return MyPath(
                          innercolor: Colors.yellow[400],
                          outercolor: Colors.black,
                        );
                      }
                    }),
              )),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Score: $score",
                  style: const TextStyle(fontSize: 40, color: Colors.white),
                ),
                GestureDetector(
                  onTap: startgame,
                  child: const Text(
                    "P L A Y",
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
