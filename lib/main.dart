import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import 'enemy.dart';
import "moveable.dart";
import 'platform.dart';
import 'player.dart';
import 'animationstate.dart';
import 'cat.dart';

enum tapType {none, left, right, jump, shoot}

class Background extends SpriteComponent with HasGameRef {

  Background(Vector2 size, Sprite sprite) : super(size: size, sprite: sprite);

  Future<void> onLoad() async {
  }

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
  late final Player A;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugMode = true;

    final sprite = await Sprite.load('bg.png');
    Background bg = Background(size, sprite);
    bg.position.x = 0;
    bg.position.y = 0;
    add(bg);

    add(Platform(0, 900, size.x, 64));
    add(Platform(16, 80, 128, 64));
    add(Platform(128, 300, 128, 64));
    add(Platform(356, 500, 128, 64));
    add(Platform((size.x / 2 - 20), 700, 128, 64));

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
      loop: false,
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
    add(A);
    camera.followComponent(A);

    final zombieSprite = await loadSprite("zombie.png");
    final zombieAnimation =
        SpriteAnimation.spriteList([zombieSprite], stepTime: double.infinity);
    final zombieAnimations = {AnimationState.idle: zombieAnimation};
    add(ZombieEnemy(zombieAnimations, size.x / 2, size.y / 2, 50, 100));
    add(ZombieEnemy(zombieAnimations, 16, 0, 50, 100));
    add(ZombieEnemy(zombieAnimations, 128, 100, 50, 100));
    add(ZombieEnemy(zombieAnimations, 256, 300, 50, 100));

    final catSprite = await loadSprite("cat.png");
    final catAnimation =
        SpriteAnimation.spriteList([catSprite], stepTime: double.infinity);
    final catAnimations = {AnimationState.idle: catAnimation};
    
    add(Cat(catAnimations, 700, 300, 50, 100));
  }

  final Map<int, tapType> taps = {};

  void onTapDown(int pointerId, TapDownInfo ti) {
    double x = ti.eventPosition.global.x;
    double y = ti.eventPosition.global.y;

    if (x < size.x / 3) {
      A.moveLeft(true);
      taps[pointerId] = tapType.left;
    } else if (x > size.x * 2 / 3) {
      A.moveRight(true);
      taps[pointerId] = tapType.right;
    } else if (y > size.y * 4.0 / 5.0) {
      A.jump();
      taps[pointerId] = tapType.jump;
    } else if (x >= size.x / 3 && x <=size.x * 2 / 3 &&
               y <= size.y * 4.0 / 5.0) {
      A.shoot();
      taps[pointerId] = tapType.shoot;
    }
  }

  void handleTapEnding(int pointerId) {
    tapType type = tapType.none;
    if (taps[pointerId] != null) {
      type = taps[pointerId] ?? tapType.none;
    }

    if (type == tapType.left) {
      A.moveLeft(false);
    } else if (type == tapType.right) {
      A.moveRight(false);
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
