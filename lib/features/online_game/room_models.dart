enum RoomStatus { waiting, playing, ended }
enum GamePhase { lobby, night, day, vote, results, ended }

class PlayerProfile {
  const PlayerProfile({
    required this.id,
    required this.name,
    this.roleId,
    this.alive = true,
    this.connected = true,
    this.ready = false,
  });

  final String id;
  final String name;
  final String? roleId;
  final bool alive;
  final bool connected;
  final bool ready;
}

class GameRoom {
  const GameRoom({
    required this.id,
    required this.roomCode,
    required this.hostId,
    required this.status,
    required this.phase,
    required this.createdAt,
    required this.players,
  });

  final String id;
  final String roomCode;
  final String hostId;
  final RoomStatus status;
  final GamePhase phase;
  final DateTime createdAt;
  final List<PlayerProfile> players;
}

class VoteRecord {
  const VoteRecord({required this.voterId, required this.targetId});

  final String voterId;
  final String targetId;
}
