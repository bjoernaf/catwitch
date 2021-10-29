import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';

class GeneralEnemy extends SpriteComponent {

  // TODO Implement

}

class ZombieEnemy extends GeneralEnemy {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load("zombie.png");
  }
}