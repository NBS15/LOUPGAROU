import 'package:flutter_test/flutter_test.dart';
import 'package:loup_garou_premium/features/local_game/local_game_controller.dart';

void main() {
  test('local game distributes one hidden role per player', () {
    final controller = LocalGameController();

    controller.setPlayerCount(6);
    controller.start();

    expect(controller.state.seats, hasLength(6));
    expect(controller.state.cardVisible, isFalse);
    expect(controller.state.currentSeat?.index, 1);
  });

  test('reveal flow hides each card before next player', () {
    final controller = LocalGameController()..start();

    controller.revealCard();
    expect(controller.state.cardVisible, isTrue);

    controller.hideAndNext();
    expect(controller.state.cardVisible, isFalse);
    expect(controller.state.currentRevealIndex, 1);
  });
}
