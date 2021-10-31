import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

import 'moveable.dart';
import 'animationstate.dart';
import 'shoot.dart';

class Cat extends MoveAndCollide {
  Cat(
    Map<AnimationState, SpriteAnimation> animations,
    double x, double y, double w, double h, {
    int spriteSize = 1,
    double movementSpeed = 0.5,
  }) : super(
          animations,
          spriteSize,
        ) {
    position.x = x;
    position.y = y;
    width = w;
    height = h;
  }

  @override
  void onCollision(Set<Vector2> points, Collidable other) {
    super.onCollision(points, other);
    life += 100;
  }
}
