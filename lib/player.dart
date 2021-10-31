import 'package:flame/components.dart';

import 'animationstate.dart';
import 'moveable.dart';
import 'shoot.dart';

class Player extends MoveAndCollide {
  late final List<Sprite> shotSprites;

  Player(Map<AnimationState, SpriteAnimation> animations)
      : super(animations, 20);

  Map<AnimationState, SpriteAnimation> getShot() {
    final shotAnimations = SpriteAnimation.spriteList(
      [
        shotSprites[0],
        shotSprites[1],
        shotSprites[2],
        shotSprites[1],
        shotSprites[0],
      ],
      stepTime: 0.1,
    );
    return {AnimationState.idle: shotAnimations};
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    shotSprites = await Future.wait(
      List.generate(3, (i) => gameRef.loadSprite("shot${i + 1}.png")),
    );
    current = AnimationState.idle;
    life = 50;
  }

  @override
  void shoot() {
    int speed = -100;
    if (facingRight) {
      speed *= -1;
    }
    shot = Shot(getShot(), speed, 10, false);
    animations[AnimationState.shooting]?.reset();
    current = AnimationState.shooting;
    shot?.width = size.x;
    shot?.height = size.x / 4;
    super.shoot();
  }
}
