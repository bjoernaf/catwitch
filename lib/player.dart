import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

import 'moveable.dart';

class Player extends MoveAndCollide {
  Player(Map<AnimationState, SpriteAnimation> animations)
      : super(animations, 20);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    movementSpeed = 1;
    final shape = HitboxRectangle();
    current = AnimationState.shooting;
    addHitbox(shape);
  }

}
