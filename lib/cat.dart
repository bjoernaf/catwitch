import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

import 'moveable.dart';
import 'animationstate.dart';
import 'shoot.dart';
import 'player.dart';

class Cat extends MoveAndCollide {
  bool foundCat = false;

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
  void update(double dt) {
    super.update(dt);
    if (foundCat && gameRef.camera.zoom < 8) {
      gameRef.camera.zoom += dt;
    }
    if (gameRef.camera.zoom >= 8) {
      current = AnimationState.angry;
    }
  }

  @override
  void onCollision(Set<Vector2> points, Collidable other) {
    super.onCollision(points, other);
    life += 100;
    if (other is Player) {
      gameRef.camera.followComponent(this);
      foundCat = true;
    }
  }
}
