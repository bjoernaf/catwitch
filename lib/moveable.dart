import 'package:con/enemy.dart';
import 'package:con/player.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'platform.dart';

enum AnimationState {
  idle,
  running,
  shooting,
}

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
  double invulnerability = 1;
  static const double maxInvulnerability = 1;
  static const double maxShotTimeout = 1;

  MoveAndCollide(Map<AnimationState, SpriteAnimation> animations, this.life)
      : super(
          animations: animations,
          current: AnimationState.idle,
        );

  @override
  void update(double dt) {
    super.update(dt);
    invulnerability -= dt;
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
      if (shot != null && shotTimeout <= 0) {
        shot.position.x = position.x;
        shot.position.y = position.y;
        gameRef.add(shot);
        doShoot = false;
      }
      shotTimeout = maxShotTimeout;
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
    if (invulnerability <= 0) {
      int newLife = life - dmg;
      if (life < 0) {
        die();
      } else {
        life = newLife;
      }
      invulnerability = maxInvulnerability;
    }
  }

  void die() {
    removeFromParent();
  }
}

class Shoot extends SpriteAnimationGroupComponent<AnimationState>
    with Hitbox, Collidable {
  late bool faceRight;
  late int speed;
  late int dmg;
  late bool mosterShoot;

  Shoot(
    Map<AnimationState, SpriteAnimation> animations,
  ) : super(
          animations: animations,
          current: AnimationState.idle,
        );

  @override
  void update(double dt) {
    super.update(dt);
    if (faceRight) {
      position.x += speed * dt;
    } else {
      position.x -= speed * dt;
    }
  }

  @override
  void onCollision(Set<Vector2> points, Collidable other) {
    if ((other is Player) && mosterShoot) {
      other.takeDamage(dmg);
    } else if ((other is GeneralEnemy) && !mosterShoot) {
      other.takeDamage(dmg);
    }
    removeFromParent();
  }
}
