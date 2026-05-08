import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import 'room_models.dart';
import 'room_repository.dart';

class FirebaseRoomRepository implements RoomRepository {
  FirebaseRoomRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required FirebaseDatabase realtimeDatabase,
    required FirebaseStorage storage,
  })  : _firestore = firestore,
        _auth = auth,
        _realtimeDatabase = realtimeDatabase,
        _storage = storage;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseDatabase _realtimeDatabase;
  final FirebaseStorage _storage;
  final _uuid = const Uuid();

  @override
  Future<GameRoom> createRoom({required String hostName, required Map<String, int> roleDeck}) async {
    final user = _auth.currentUser ?? await _auth.signInAnonymously().then((value) => value.user!);
    final roomCode = _uuid.v4().replaceAll('-', '').substring(0, 4).toUpperCase();
    final roomRef = _firestore.collection('rooms').doc();
    await roomRef.set({
      'roomCode': roomCode,
      'hostId': user.uid,
      'status': 'waiting',
      'phase': 'lobby',
      'roleDeck': roleDeck,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await roomRef.collection('players').doc(user.uid).set({
      'name': hostName,
      'role': null,
      'alive': true,
      'connected': true,
      'ready': true,
      'isHost': true,
    });
    await _presence(roomRef.id, user.uid).set(ServerValue.timestamp);
    return GameRoom(
      id: roomRef.id,
      roomCode: roomCode,
      hostId: user.uid,
      status: RoomStatus.waiting,
      phase: GamePhase.lobby,
      createdAt: DateTime.now(),
      players: [PlayerProfile(id: user.uid, name: hostName, ready: true)],
    );
  }

  @override
  Future<void> joinRoom({required String roomCode, required String playerName}) async {
    final user = _auth.currentUser ?? await _auth.signInAnonymously().then((value) => value.user!);
    final snapshot = await _firestore.collection('rooms').where('roomCode', isEqualTo: roomCode).limit(1).get();
    if (snapshot.docs.isEmpty) {
      throw StateError('Salle introuvable');
    }
    final roomRef = snapshot.docs.first.reference;
    await roomRef.collection('players').doc(user.uid).set({
      'name': playerName,
      'role': null,
      'alive': true,
      'connected': true,
      'ready': false,
      'isHost': false,
    }, SetOptions(merge: true));
    await _presence(roomRef.id, user.uid).set(ServerValue.timestamp);
  }

  @override
  Future<void> setReady({required String roomId, required String playerId, required bool ready}) {
    return _firestore.collection('rooms').doc(roomId).collection('players').doc(playerId).update({'ready': ready});
  }

  @override
  Future<void> startGame({required String roomId}) {
    return _firestore.collection('rooms').doc(roomId).update({'status': 'playing', 'phase': 'night'});
  }

  @override
  Future<void> setPhase({required String roomId, required GamePhase phase}) {
    return _firestore.collection('rooms').doc(roomId).update({'phase': phase.name});
  }

  @override
  Future<void> eliminatePlayer({required String roomId, required String playerId}) {
    return _firestore.collection('rooms').doc(roomId).collection('players').doc(playerId).update({'alive': false});
  }

  @override
  Future<void> submitVote({required String roomId, required VoteRecord vote}) {
    return _firestore.collection('rooms').doc(roomId).collection('votes').doc(vote.voterId).set({
      'voterId': vote.voterId,
      'targetId': vote.targetId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<GameRoom> watchRoom(String roomId) async* {
    await for (final roomDoc in _firestore.collection('rooms').doc(roomId).snapshots()) {
      final data = roomDoc.data();
      if (data == null) continue;
      final players = await roomDoc.reference.collection('players').get();
      yield GameRoom(
        id: roomDoc.id,
        roomCode: data['roomCode'] as String,
        hostId: data['hostId'] as String,
        status: RoomStatus.values.byName(data['status'] as String),
        phase: GamePhase.values.byName(data['phase'] as String),
        createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        players: players.docs.map((doc) {
          final player = doc.data();
          return PlayerProfile(
            id: doc.id,
            name: player['name'] as String,
            roleId: player['role'] as String?,
            alive: player['alive'] as bool? ?? true,
            connected: player['connected'] as bool? ?? true,
            ready: player['ready'] as bool? ?? false,
          );
        }).toList(),
      );
    }
  }

  DatabaseReference _presence(String roomId, String playerId) {
    _storage.ref('rooms/$roomId/placeholders/.keep');
    return _realtimeDatabase.ref('presence/$roomId/$playerId');
  }
}
