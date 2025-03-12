import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/parallax.dart';
import 'package:sep490/presentation/pages/ultility/game/flappy_bird/game/assets.dart';
import 'package:sep490/presentation/pages/ultility/game/flappy_bird/game/configuration.dart';
import 'package:sep490/presentation/pages/ultility/game/flappy_bird/game/flappy_bird_game.dart';

class Clouds extends ParallaxComponent<FlappyBirdGame>
    with HasGameRef<FlappyBirdGame> {
  Clouds();

  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load(Assets.clouds);
    position = Vector2(x, -(gameRef.size.y - Config.cloudsHeight));
    parallax = Parallax([
      ParallaxLayer(
        ParallaxImage(image, fill: LayerFill.none),
      ),
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    parallax?.baseVelocity.x = Config.gameSpeed;
  }
}