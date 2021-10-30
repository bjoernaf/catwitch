import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

import 'moveable.dart';

class Player extends MoveAndCollide {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    movementSpeed = 1;
    final shape = HitboxRectangle();
    addHitbox(shape);
    sprite = await Sprite.load("witch.png");
  }

}
