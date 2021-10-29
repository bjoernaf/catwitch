import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';

class Player extends SpriteComponent {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load("player.png");
  }
}