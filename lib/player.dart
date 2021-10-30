import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

import 'moveable.dart';

class Player extends MoveAndCollide {
  bool facingRight = true;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    movementSpeed = 1;
    final shape = HitboxRectangle();
    addHitbox(shape);
    sprite = await Sprite.load("witch.png");
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (falling) {
      // TODO HARDCODEED
      position.y += 200.0 * dt;
    }
    if (doMoveLeft) {
      position.x -= 100.0 * dt;
      doMoveLeft = false;
      if (facingRight) {
        flipHorizontally();
        facingRight = false;
      }
    }
    if (doMoveRight) {
      position.x += 100.0 * dt;
      doMoveRight = false;
      if (!facingRight) {
        flipHorizontally();
        facingRight = true;
      }
    }
    if (doJump) {
      // TODO Do nsomething beautiful
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
