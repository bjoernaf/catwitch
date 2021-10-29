
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';

class Player extends PositionComponent {
  static final _paint = Paint()..color = Colors.white;

  @override
    void render(Canvas canvas) {
      super.render(canvas);
      canvas.drawRect(size.toRect(), _paint);
    }
}



class SpaceShooterGame extends FlameGame {
  @override
    Future<void> onLoad() async {
      await super.onLoad();

      final PositionComponent A = Player();
      A.position = size / 2;
      A.position.x += 100;
      A.width = 50;
      A.height = 100;
      A.anchor = Anchor.center;
      final PositionComponent B = Player();
      B.position = size / 2;
      B.width = 50;
      B.height = 100;
      B.anchor = Anchor.center;

      add(A);
      add(B);
    }
}


void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}
