import 'package:con/moveable.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

import 'platform.dart';

class GeneralEnemy extends MoveAndCollide {
  int life;
  int spriteSize;
  int attackDamage;

  GeneralEnemy(this.life, this.spriteSize, this.attackDamage);

  void die() {
    // TODO sprite die at position
  }

  void takeDamaged(int dmg) {
    int newLife = life - dmg;
    if (life < 0) {
      die();
    } else {
      life = newLife;
    }
  }

  // TODO Duplicate of Player methods, should have joint parent class
  void onCollision(Set<Vector2> points, Collidable other) {
    if (other is Platform) {
      falling = false;
    }
  }

  void onCollisionEnd(Collidable other) {
    if (other is Platform) {
      falling = true;
    }
  }
}

class ZombieEnemy extends GeneralEnemy {
  ZombieEnemy({
    int life = 20,
    int spriteSize = 1,
    int attackDamage = 5,
    double movementSpeed = 0.5,
  }) : super(
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
    sprite = await Sprite.load("zombie.png");
  }

  void roam() {
    // TODO: implement
  }
}
