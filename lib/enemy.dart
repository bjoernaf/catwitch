import 'package:flame/components.dart';

class GeneralEnemy extends SpriteComponent {
  int life;
  int spriteSize;
  int attackDamage;
  double fallingSpeed = 1;
  double movementSpeed;

  GeneralEnemy(
    this.life,
    this.spriteSize,
    this.attackDamage,
    this.movementSpeed,
  );

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

  void moveRight() {
    // TODO Implement
  }

  void moveLeft() {
    // TODO Implement
  }

  void jump() {
    // TODO Implement
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
          movementSpeed,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load("zombie.png");
  }

  void roam() {
    // TODO: implement
  }
}
