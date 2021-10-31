import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import 'animationstate.dart';
import 'cat.dart';
import 'enemy.dart';
import 'platform.dart';
import 'player.dart';

enum tapType { none, left, right, jump, shoot }

class SpaceShooterGame extends FlameGame
    with HasCollidables, MultiTouchTapDetector {
  late final Player player;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugMode = true;
    add(Platform(0, 900, size.x, 64));
    add(Platform(16, 80, 128, 64));
    add(Platform(128, 300, 128, 64));
    add(Platform(356, 500, 128, 64));
    add(Platform(size.x / 2, 500, 128, 64));
    add(Platform((size.x / 2 - 20), 700, 128, 64));

    final playerIdleSprite = await loadSprite("witch.png");
    final playerIdleAnimation = SpriteAnimation.spriteList(
      [playerIdleSprite],
      stepTime: double.infinity,
    );

    final shootingAnimations = await Future.wait(
      List.generate(5, (i) => loadSprite("witchshooting${i + 1}.png")),
    );
    final playerShootingAnimation = SpriteAnimation.spriteList(
      [
        shootingAnimations[0],
        shootingAnimations[1],
        shootingAnimations[2],
        shootingAnimations[3],
        shootingAnimations[4],
        shootingAnimations[3],
        shootingAnimations[2],
        shootingAnimations[1],
        shootingAnimations[0],
      ],
      stepTime: 0.1,
      loop: false,
    );
    final playerAnimations = {
      AnimationState.idle: playerIdleAnimation,
      AnimationState.shooting: playerShootingAnimation
    };
    player = Player(playerAnimations);
    player.position.y = 200;
    player.position.x = size.x / 2;
    player.width = 50;
    player.height = 100;
    add(player);

    final zombieSprite = await Future.wait(
      List.generate(3, (i) => loadSprite("zombie${i + 1}.png")),
    );
    final zombieWalkingAnimations = SpriteAnimation.spriteList(
      [
        zombieSprite[0],
        zombieSprite[1],
        zombieSprite[2],
        zombieSprite[1],
        zombieSprite[0],
      ],
      stepTime: 0.2,
    );
    final zombieAnimations = {
      AnimationState.idle: zombieWalkingAnimations,
    };
    //add(ZombieEnemy(zombieAnimations, size.x / 2, size.y / 2, 50, 100));
    add(ZombieEnemy(zombieAnimations, 16, 0, 50, 100));
    add(ZombieEnemy(zombieAnimations, 128, 100, 50, 100));
    add(ZombieEnemy(zombieAnimations, 256, 300, 50, 100));

    final catSprite = await Future.wait(
      List.generate(5, (i) => loadSprite("cat${i + 1}.png")),
    );
    final catTailAnimations = SpriteAnimation.spriteList(
      [
        catSprite[0],
        catSprite[1],
        catSprite[2],
        catSprite[1],
        catSprite[0],
        catSprite[3],
        catSprite[4],
        catSprite[3],
        catSprite[0],
      ],
      stepTime: 0.1,
    );
    final catAnimations = {
      AnimationState.idle: catTailAnimations,
    };
    add(Cat(catAnimations, 700, 300, 492 / 10, 630 / 10));
  }

  final Map<int, tapType> taps = {};

  void onTapDown(int pointerId, TapDownInfo ti) {
    double x = ti.eventPosition.global.x;
    double y = ti.eventPosition.global.y;

    if (x < size.x / 3) {
      player.moveLeft(true);
      taps[pointerId] = tapType.left;
    } else if (x > size.x * 2 / 3) {
      player.moveRight(true);
      taps[pointerId] = tapType.right;
    } else if (y > size.y * 4.0 / 5.0) {
      player.jump();
      taps[pointerId] = tapType.jump;
    } else if (x >= size.x / 3 &&
        x <= size.x * 2 / 3 &&
        y <= size.y * 4.0 / 5.0) {
      player.shoot();
      taps[pointerId] = tapType.shoot;
    }
  }

  void handleTapEnding(int pointerId) {
    tapType type = tapType.none;
    if (taps[pointerId] != null) {
      type = taps[pointerId] ?? tapType.none;
    }

    if (type == tapType.left) {
      player.moveLeft(false);
    } else if (type == tapType.right) {
      player.moveRight(false);
    }

    taps.remove(pointerId);
  }

  void onTapUp(int pointerId, _) {
    handleTapEnding(pointerId);
  }

  void onTapCancel(int pointerId) {
    handleTapEnding(pointerId);
  }
}

void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}
