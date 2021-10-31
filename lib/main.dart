import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'animationstate.dart';
import 'cat.dart';
import 'enemy.dart';
import 'platform.dart';
import 'player.dart';

enum tapType { none, left, right, jump, shoot }

class Background extends SpriteComponent with HasGameRef {
  Background(Vector2 size, Sprite sprite) : super(size: size, sprite: sprite);

  Future<void> onLoad() async {}

  @override
  void onResize() {
    width = gameRef.size.x;
    height = gameRef.size.y;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x = gameRef.camera.position.x;
    position.y = gameRef.camera.position.y;
  }
}

class SpaceShooterGame extends FlameGame
    with HasCollidables, MultiTouchTapDetector {
  late final Player player;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugMode = true;

    final sprite = await Sprite.load('bg.png');
    Background bg = Background(size, sprite);
    bg.position.x = 0;
    bg.position.y = 0;
    add(bg);

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

    const int boardSize = 2000;
    const int minDistance = 200;
    const int maxDistance = 300;
    const int minWidth = 100;
    const int maxWidth = 200;
    const int platformHeight = 32;

    Platform first = Platform(100, 100, 100, platformHeight as double);
    add(first);

    Random rng = new Random();
    double w = 100;
    double lastX = 0;
    double lastY = 0;
    for (int y = 0; y < boardSize; y += (w as int) + 110) {
      for (int x = 200 + minDistance; x < boardSize; x += (w as int) + minDistance + (rng.nextInt(maxDistance - minDistance) as int)) {
        w = minWidth + (rng.nextInt(maxWidth - minWidth) as double);
        lastX = x + (rng.nextInt(60) as double);
        lastY = y as double;
        Platform current = Platform(lastX, lastY, w, platformHeight as double);
        add(ZombieEnemy(zombieAnimations, lastX + 10, lastY - 80, 50, 100));
        add(current);
      }
    }
    add(Cat(catAnimations, lastX + 10, lastY - 80, 492 / 10, 630 / 10));
    player.position.y = 50;
    player.position.x = 150;
    player.width = 50;
    player.height = 100;
    add(player);
    camera.followComponent(player);
  }

  final Map<int, tapType> taps = {};

  @override
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

  @override
  void onTapUp(int pointerId, _) {
    handleTapEnding(pointerId);
  }

  @override
  void onTapCancel(int pointerId) {
    handleTapEnding(pointerId);
  }
}

void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}
