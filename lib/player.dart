import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

import 'platform.dart';

class Player extends SpriteComponent with Hitbox, Collidable {
  bool falling = true;
  bool doMoveLeft = false;
  bool doMoveRight = false;
  bool doJump = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final shape = HitboxRectangle();
    addHitbox(shape);
    sprite = await Sprite.load("witch.png");
  }

  @override
  void update(double dt) {
    if (falling) {
      // TODO HARDCODEED
      position.y += 200.0 * dt;
    }
    if (doMoveLeft) {
      position.x -= 100.0 * dt;
      doMoveLeft = false;
    }
    if (doMoveRight) {
      position.x += 100.0 * dt;
      doMoveRight = false;
    }
    if (doJump) {
      // TODO Do nsomething beautiful
    }
  }

  void onCollision(Set<Vector2> points, Collidable other) {
    print("Collided with $other");
    if (other is Platform) {
      falling = false;
    }
  }

  void onCollisionEnd(Collidable other) {
    print("Stopped colliding with $other");
    if (other is Platform) {
      falling = true;
    }
  }

  void moveLeft() {
    doMoveLeft = true;
  }

  void moveRight() {
    doMoveRight = true;
  }

  void jump() {
    doJump = true;
  }
}
