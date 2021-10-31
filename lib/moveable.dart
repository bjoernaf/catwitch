import 'package:con/player.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';

import 'animationstate.dart';
import 'platform.dart';
import 'shoot.dart';

class MoveAndCollide extends SpriteAnimationGroupComponent<AnimationState>
    with Hitbox, Collidable, HasGameRef {
  int life;
  bool falling = true;
  bool doMoveLeft = false;
  bool doMoveRight = false;
  bool doJump = false;
  bool doShoot = false;
  bool facingRight = false;
  double fallingSpeed = 1;
  double movementSpeed = 1;
  bool jumping = false;
  Collidable? currentCollide;
  Shot? shot;
  double shotTimeout = 1;
  double invulnerability = 0;
  static const double maxInvulnerability = 1;
  static const double maxShotTimeout = 1;

  MoveAndCollide(Map<AnimationState, SpriteAnimation> animations, this.life)
      : super(
          animations: animations,
          current: AnimationState.idle,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final shape = HitboxRectangle();
    addHitbox(shape);
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);
    invulnerability -= dt;
    shotTimeout -= dt;
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
      position.x += 100.0 * movementSpeed * dt;
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
    if (doShoot) {
      print("try shot");
      if (shot != null && shotTimeout <= 0) {
        double step = 1;
        print("shooting!");
        if (!facingRight) {
          step = -1;
        }
        shot?.position.x = position.x + step * size.x / 2;
        shot?.position.y = position.y;
        gameRef.add(shot!);
        shotTimeout = maxShotTimeout;
      }
      doShoot = false;
    }
  }

  @override
  void onCollision(Set<Vector2> points, Collidable other) {
    currentCollide = other;
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
    currentCollide = null;
    if (other is Platform) {
      falling = true;
    }
  }

  void setMoveAnimation(bool moving) {
    if (moving) {
      current = AnimationState.running;
    } else {
      current = AnimationState.idle;
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

  void shoot() {
    doShoot = true;
  }

  void takeDamage(int dmg) {
    print("life is $life taking damage $dmg");
    if (invulnerability <= 0) {
      if (this is Player) {
        gameRef.camera.shake(intensity: 30);
      }
      life -= dmg;
      if (life <= 0) {
        die();
      }
      if (this is Player) {
        invulnerability = maxInvulnerability;
      }
    }
  }

  void die() {
    removeFromParent();
  }
}
