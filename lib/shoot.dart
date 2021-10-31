import 'package:con/enemy.dart';
import 'package:con/player.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'animationstate.dart';
import 'moveable.dart';

class Shot extends MoveAndCollide {
  late int speed;
  late int dmg;
  late bool monsterShoot;

  Shot(Map<AnimationState, SpriteAnimation> animations, int inSpeed,
      int inDamage, bool inMonster)
      : super(animations, 20) {
    speed = inSpeed;
    dmg = inDamage;
    monsterShoot = inMonster;
    falling = false;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x += speed * dt;
  }

  @override
  void onCollision(Set<Vector2> points, Collidable other) {
    print("hit");
    if ((other is Player) && monsterShoot) {
      other.takeDamage(dmg);
      removeFromParent();
    } else if ((other is GeneralEnemy) && !monsterShoot) {
      other.takeDamage(dmg);
      removeFromParent();
    }
  }
}
