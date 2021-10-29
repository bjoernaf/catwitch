import 'package:flame/components.dart';

class GeneralEnemy extends SpriteComponent {
  int life;
  int spriteSize;
  int attackDamage;
  double fallingSpeed = 1;

  GeneralEnemy(this.life, this.spriteSize, this.attackDamage);

  bool isFalling() {
    // TODO implement
    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    while (isFalling()) {
      fallingSpeed += 9.82 * dt;
      position.y += fallingSpeed;
    }
  }

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

  // TODO Implement

}

class ZombieEnemy extends GeneralEnemy {
  ZombieEnemy(int life, int spriteSize, int attackDamage)
      : super(life, spriteSize, attackDamage);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load("zombie.png");
  }
}
