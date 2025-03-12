import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:sep490/presentation/pages/ultility/game/flappy_bird/game/assets.dart';
import 'package:sep490/presentation/pages/ultility/game/flappy_bird/game/bird_movement.dart';
import 'package:sep490/presentation/pages/ultility/game/flappy_bird/game/configuration.dart';
import 'package:sep490/presentation/pages/ultility/game/flappy_bird/game/flappy_bird_game.dart';

class Bird extends SpriteGroupComponent<BirdMovement>
    with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  Bird();

  int score = 0;
  double velocityY = 0.0; // Tốc độ di chuyển theo trục Y
  double gravity = 500; // Gia tốc trọng trường
  double jumpForce = -300; // Lực nhảy

  @override
  Future<void> onLoad() async {
    final birdMidFlap = await gameRef.loadSprite(Assets.birdMidFlap);
    final birdUpFlap = await gameRef.loadSprite(Assets.birdUpFlap);
    final birdDownFlap = await gameRef.loadSprite(Assets.birdDownFlap);

    size = Vector2(50, 40);
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);

    sprites = {
      BirdMovement.middle: birdMidFlap,
      BirdMovement.up: birdUpFlap,
      BirdMovement.down: birdDownFlap,
    };

    current = BirdMovement.middle;
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Cập nhật vận tốc theo trọng lực
    velocityY += gravity * dt;
    position.y += velocityY * dt;

    // Kiểm tra nếu chạm đất
    if (position.y >= gameRef.size.y - Config.groundHeight - size.y) {
      position.y = gameRef.size.y - Config.groundHeight - size.y;
      gameOver();
    }

    // Kiểm tra nếu chim chạm mép trên màn hình
    if (position.y < 0) {
      position.y = 0;
      velocityY = 0;
    }

    // Đổi trạng thái hình ảnh dựa trên tốc độ rơi
    if (velocityY < 0) {
      current = BirdMovement.up;
    } else {
      current = BirdMovement.down;
    }
  }

  void fly() {
    velocityY = jumpForce; // Reset vận tốc để chim bay lên
    current = BirdMovement.up;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    gameOver();
  }

  void reset() {
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    velocityY = 0;
    score = 0;
  }

  void gameOver() {
    gameRef.isHit = true;
    gameRef.overlays.add('gameOver');
    gameRef.pauseEngine();
  }
}
