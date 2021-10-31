import 'package:flame/components.dart';

import 'animationstate.dart';
import 'moveable.dart';
import 'shoot.dart';

class Player extends MoveAndCollide {
  Player(Map<AnimationState, SpriteAnimation> animations)
      : super(animations, 20);

  late final Sprite shoot1;
  late final Sprite shoot2;
  late final Sprite shoot3;

  Map<AnimationState, SpriteAnimation> getShoot() {
    final flyingShotAnimation = SpriteAnimation.spriteList(
      [
        shoot1,
        shoot2,
        shoot3,
        shoot2,
      ],
      stepTime: 0.1,
    );
    return {AnimationState.idle: flyingShotAnimation};
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    shoot1 = await gameRef.loadSprite("shot.png");
    shoot2 = await gameRef.loadSprite("shot.png");
    shoot3 = await gameRef.loadSprite("shot.png");
    current = AnimationState.idle;
    life = 50;
    movementSpeed = 2;
  }

  @override
  void shoot() {
    int speed = -100;
    if (facingRight) {
      speed *= -1;
    }
    shot = Shoot(getShoot(), speed, 10, false);
    animations[AnimationState.shooting]?.reset();
    current = AnimationState.shooting;
    shot?.width = size.x;
    shot?.height = size.x / 4;
    super.shoot();
  }
}
