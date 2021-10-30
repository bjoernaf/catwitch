import 'package:con/moveable.dart';
import 'package:con/platform.dart';
import 'package:con/player.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

import 'platform.dart';

class GeneralEnemy extends MoveAndCollide {
  int spriteSize;
  int attackDamage;

  GeneralEnemy(
    Map<AnimationState, SpriteAnimation> animations,
    int life,
    this.spriteSize,
    this.attackDamage,
  ) : super(animations, life);

  @override
  void onCollision(Set<Vector2> points, Collidable other) {
    super.onCollision(points, other);
    if (other is Player) {
      other.takeDamage(attackDamage);
    }
  }
}

class ZombieEnemy extends GeneralEnemy {
  ZombieEnemy(
    Map<AnimationState, SpriteAnimation> animations, {
    int life = 20,
    int spriteSize = 1,
    int attackDamage = 5,
    double movementSpeed = 0.5,
  }) : super(
          animations,
          life,
          spriteSize,
          attackDamage,
        );

  @override
  Future<void> onLoad() async {
    movementSpeed = 0.5;
    await super.onLoad();
    final shape = HitboxRectangle();
    addHitbox(shape);
  }

  @override
  void update(double dt) {
    super.update(dt);
    roam();
  }

  void roam() {
    if (!(currentCollide == null) && (currentCollide is Platform)) {
      double xmin = currentCollide!.position.x + size.x / 2;
      double xmax =
          currentCollide!.position.x + currentCollide!.size.x - size.x / 2;

      if (facingRight) {
        if (position.x < xmax) {
          moveRight();
        } else {
          facingRight = false;
        }
      } else {
        if (position.x > xmin) {
          moveLeft();
        } else {
          facingRight = true;
        }
      }
    }
  }
}
