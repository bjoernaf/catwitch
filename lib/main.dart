import 'package:con/moveable.dart';
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

    final playerIdleSprite = await loadSprite("witch.png");
    final playerIdleAnimation = SpriteAnimation.spriteList(
      [playerIdleSprite],
      stepTime: double.infinity,
    );
    //TODO: make loop
    final playerShooting1 = await loadSprite("witchshooting1.png");
    final playerShooting2 = await loadSprite("witchshooting2.png");
    final playerShooting3 = await loadSprite("witchshooting3.png");
    final playerShooting4 = await loadSprite("witchshooting4.png");
    final playerShooting5 = await loadSprite("witchshooting5.png");
    final playerShootingAnimation = SpriteAnimation.spriteList(
      [
        playerShooting1,
        playerShooting2,
        playerShooting3,
        playerShooting4,
        playerShooting5,
        playerShooting4,
        playerShooting3,
        playerShooting2,
      ],
      stepTime: 0.1,
    );
    final playerAnimations = {
      AnimationState.idle: playerIdleAnimation,
      AnimationState.shooting: playerShootingAnimation
    };
    A = Player(playerAnimations);
    A.position.y = 200;
    A.position.x = size.x / 2;
    A.width = 50;
    A.height = 100;
    A.anchor = Anchor.center;
    final zombieSprite = await loadSprite("zombie.png");
    final zombieAnimation =
        SpriteAnimation.spriteList([zombieSprite], stepTime: double.infinity);
    final zombieAnimations = {AnimationState.idle: zombieAnimation};
    final PositionComponent B = ZombieEnemy(zombieAnimations);
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
