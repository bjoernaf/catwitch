import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import 'enemy.dart';
import 'platform.dart';
import 'player.dart';

class SpaceShooterGame extends FlameGame
    with HasCollidables, MultiTouchTapDetector {
  late final Player A;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugMode = true;
    final Platform P1 = Platform();
    P1.width = 64 * 2;
    P1.height = 32 * 2;
    P1.position.x = (size.x / 2 - 20); //* 2;
    P1.position.y = 400 * 2;

    final Platform P2 = Platform();
    P2.width = 64 * 2;
    P2.height = 32 * 2;
    P2.position.x = 8 * 2;
    P2.position.y = 20 * 2;

    final Platform P3 = Platform();
    P3.width = 64 * 2;
    P3.height = 32 * 2;
    P3.position.x = (size.x / 2 + 20); //* 2;
    P3.position.y = 300 * 2;

    add(P1);
    add(P2);
    add(P3);

    A = Player();
    A.position.y = 200;
    A.position.x = size.x / 2;
    A.width = 50;
    A.height = 100;
    A.anchor = Anchor.center;
    final PositionComponent B = ZombieEnemy();
    B.position = size / 2;
    B.width = 50;
    B.height = 100;
    B.anchor = Anchor.center;

    add(A);
    add(B);
  }

  void onTapDown(int pointerId, TapDownInfo ti) {
    double x = ti.eventPosition.global.x;
    double y = ti.eventPosition.global.y;

    if (x < size.x / 3) {
      A.moveLeft();
    } else if (x > size.x * 2 / 3) {
      A.moveRight();
    } else if (y > size.y * 4.0 / 5.0) {
      A.jump();
    }
  }
}

void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}
