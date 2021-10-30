import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'platform.dart';

class MoveAndCollide extends SpriteComponent with Hitbox, Collidable {
  bool falling = true;
  bool doMoveLeft = false;
  bool doMoveRight = false;
  bool doJump = false;
  bool facingRight = false;
  double fallingSpeed = 1;
  double movementSpeed = 1;
  bool jumping = false;

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
      if (facingRight) {
        flipHorizontally();
        facingRight = false;
      }
    }
    if (doMoveRight) {
      position.x += 100.0 * dt;
      if (!facingRight) {
        flipHorizontally();
        facingRight = true;
      }
    }
    if (doJump) {
      if (!jumping) {
        jumping = true;
        fallingSpeed = -10;
        position.y -= 10;
        falling = true;
      }
      doJump = false;
    }
  }

  @override
  void onCollision(Set<Vector2> points, Collidable other) {
    if (other is Platform) {
      falling = false;
      if (position.y < (other.position.y + size.y / 2)) {
        jumping = false;
        position.y = other.position.y - size.y / 2;
      } else {
        fallingSpeed = 1;
        falling = true;
        position.y = other.position.y + other.size.y + size.y / 2;
      }
    }
  }

  @override
  void onCollisionEnd(Collidable other) {
    if (other is Platform) {
      falling = true;
    }
  }

  void moveLeft(bool b) {
    doMoveLeft = b;
  }

  void moveRight(bool b) {
    doMoveRight = b;
  }

  void jump() {
    doJump = true;
  }
}
