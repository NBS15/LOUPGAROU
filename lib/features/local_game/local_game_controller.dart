import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../roles/role.dart';
import '../roles/role_catalog.dart';

class LocalSeat {
  const LocalSeat({required this.index, required this.role});

  final int index;
  final GameRole role;
}

class LocalGameState {
  const LocalGameState({
    this.playerCount = 8,
    this.selectedRoleIds = const ['werewolf', 'werewolf', 'seer', 'witch', 'guard', 'villager', 'villager', 'villager'],
    this.seats = const [],
    this.currentRevealIndex = 0,
    this.cardVisible = false,
  });

  final int playerCount;
  final List<String> selectedRoleIds;
  final List<LocalSeat> seats;
  final int currentRevealIndex;
  final bool cardVisible;

  bool get hasStarted => seats.isNotEmpty;
  bool get allRevealed => hasStarted && currentRevealIndex >= seats.length;
  LocalSeat? get currentSeat => allRevealed || !hasStarted ? null : seats[currentRevealIndex];

  LocalGameState copyWith({
    int? playerCount,
    List<String>? selectedRoleIds,
    List<LocalSeat>? seats,
    int? currentRevealIndex,
    bool? cardVisible,
  }) {
    return LocalGameState(
      playerCount: playerCount ?? this.playerCount,
      selectedRoleIds: selectedRoleIds ?? this.selectedRoleIds,
      seats: seats ?? this.seats,
      currentRevealIndex: currentRevealIndex ?? this.currentRevealIndex,
      cardVisible: cardVisible ?? this.cardVisible,
    );
  }
}

class LocalGameController extends StateNotifier<LocalGameState> {
  LocalGameController() : super(const LocalGameState());

  void setPlayerCount(int count) {
    final deck = [...state.selectedRoleIds];
    while (deck.length < count) {
      deck.add('villager');
    }
    state = state.copyWith(playerCount: count, selectedRoleIds: deck.take(count).toList());
  }

  void addRole(String roleId) {
    if (state.selectedRoleIds.length >= state.playerCount) return;
    state = state.copyWith(selectedRoleIds: [...state.selectedRoleIds, roleId]);
  }

  void removeRoleAt(int index) {
    if (index < 0 || index >= state.selectedRoleIds.length) return;
    final next = [...state.selectedRoleIds]..removeAt(index);
    state = state.copyWith(selectedRoleIds: next);
  }

  void start() {
    final random = Random.secure();
    final completedDeck = [...state.selectedRoleIds];
    while (completedDeck.length < state.playerCount) {
      completedDeck.add('villager');
    }
    completedDeck.shuffle(random);
    state = state.copyWith(
      seats: [
        for (var i = 0; i < state.playerCount; i++) LocalSeat(index: i + 1, role: roleById(completedDeck[i])),
      ],
      currentRevealIndex: 0,
      cardVisible: false,
    );
  }

  void revealCard() => state = state.copyWith(cardVisible: true);

  void hideAndNext() => state = state.copyWith(
        cardVisible: false,
        currentRevealIndex: state.currentRevealIndex + 1,
      );

  void reset() => state = const LocalGameState();
}

final localGameControllerProvider = StateNotifierProvider<LocalGameController, LocalGameState>((ref) {
  return LocalGameController();
});
