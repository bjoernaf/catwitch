import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

class Platform extends SpriteComponent with Hitbox, Collidable {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final shape = HitboxRectangle();
    addHitbox(shape);
    sprite = await Sprite.load("platform1.png");
    collidableType = CollidableType.passive;
  }
}
