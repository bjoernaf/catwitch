import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'platform.dart';

class MoveAndCollide extends SpriteComponent with Hitbox, Collidable {
  bool falling = true;
  bool doMoveLeft = false;
  bool doMoveRight = false;
  bool doJump = false;

  double fallingSpeed = 1;
  double movementSpeed = 1;

  @override
  void update(double dt) {
    if (falling) {
      fallingSpeed += 9.82 * dt;
      position.y += fallingSpeed;
    } else {
      fallingSpeed = 1;
    }
    if (doMoveLeft) {
      position.x -= 100.0 * movementSpeed * dt;
      doMoveLeft = false;
    }
    if (doMoveRight) {
      position.x += 100.0 * dt;
      doMoveRight = false;
    }
    if (doJump) {
      fallingSpeed = -100;
    }
  }

  @override
  void onCollision(Set<Vector2> points, Collidable other) {
    if (other is Platform) {
      falling = false;
    }
  }

  @override
  void onCollisionEnd(Collidable other) {
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
