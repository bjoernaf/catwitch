import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';

class Player extends SpriteComponent {

  var falling = true;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load("witch.png");
  }

  @override
  void update(double dt) {
    if (falling) {
      position.y += 200.0 * dt;
    }
  }
}
