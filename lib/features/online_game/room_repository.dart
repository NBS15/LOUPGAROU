import 'room_models.dart';

abstract interface class RoomRepository {
  Future<GameRoom> createRoom({required String hostName, required Map<String, int> roleDeck});
  Future<void> joinRoom({required String roomCode, required String playerName});
  Future<void> setReady({required String roomId, required String playerId, required bool ready});
  Future<void> startGame({required String roomId});
  Future<void> setPhase({required String roomId, required GamePhase phase});
  Future<void> eliminatePlayer({required String roomId, required String playerId});
  Future<void> submitVote({required String roomId, required VoteRecord vote});
  Stream<GameRoom> watchRoom(String roomId);
}
