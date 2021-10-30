import 'package:con/moveable.dart';
import 'package:con/platform.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

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
    roam();
  }

  void roam() {
    if (!(currentCollide == null) & (currentCollide is Platform)) {
      double xmin = currentCollide!.position.x;
      double xmax = currentCollide!.position.x + size.x;

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
