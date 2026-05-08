import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../shared/widgets/mystic_scaffold.dart';
import '../roles/role_catalog.dart';
import 'room_models.dart';

class HostRoomScreen extends StatefulWidget {
  const HostRoomScreen({super.key});

  @override
  State<HostRoomScreen> createState() => _HostRoomScreenState();
}

class _HostRoomScreenState extends State<HostRoomScreen> {
  final _nameController = TextEditingController(text: 'Maître du jeu');
  final Map<String, int> _deck = {'werewolf': 2, 'seer': 1, 'witch': 1, 'guard': 1, 'villager': 4};

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MysticScaffold(
      appBar: AppBar(title: const Text('Créer une salle'), backgroundColor: Colors.transparent),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Salle en ligne', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          const Text('Le créateur ne joue pas : il orchestre la nuit, les votes et les révélations.'),
          const SizedBox(height: 24),
          TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Pseudo créateur', filled: true)),
          const SizedBox(height: 22),
          Text('Cartes utilisées', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          for (final role in roleCatalog)
            Card(
              child: ListTile(
                leading: Text(role.icon, style: const TextStyle(fontSize: 28)),
                title: Text(role.name),
                subtitle: Text(role.power),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () => setState(() => _deck[role.id] = ((_deck[role.id] ?? 0) - 1).clamp(0, 99).toInt()), icon: const Icon(Icons.remove_circle_outline)),
                    Text('${_deck[role.id] ?? 0}', style: const TextStyle(fontWeight: FontWeight.w900)),
                    IconButton(onPressed: () => setState(() => _deck[role.id] = (_deck[role.id] ?? 0) + 1), icon: const Icon(Icons.add_circle_outline)),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 20),
          FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.key_rounded), label: const Text('Générer le code de salle')),
          const SizedBox(height: 12),
          const Text('FirebaseRoomRepository connectera ce bouton à Auth, Firestore, Realtime Database et Storage.'),
        ],
      ),
    );
  }
}

class JoinRoomScreen extends StatelessWidget {
  const JoinRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MysticScaffold(
      appBar: AppBar(title: const Text('Rejoindre'), backgroundColor: Colors.transparent),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Text('Entrer dans le village', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 18),
            const TextField(decoration: InputDecoration(labelText: 'Pseudo', filled: true)),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Code de salle', filled: true), textCapitalization: TextCapitalization.characters),
            const SizedBox(height: 18),
            FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.login_rounded), label: const Text('Rejoindre la salle')),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class LobbyScreen extends StatelessWidget {
  const LobbyScreen({super.key, required this.room});

  final GameRoom room;

  @override
  Widget build(BuildContext context) {
    return MysticScaffold(
      appBar: AppBar(title: Text('Salle ${room.roomCode}'), backgroundColor: Colors.transparent),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('${room.players.length} joueurs connectés', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          for (final player in room.players)
            Card(
              child: ListTile(
                leading: CircleAvatar(backgroundColor: player.connected ? AppColors.gold : AppColors.ash, child: Text(player.name.characters.first.toUpperCase())),
                title: Text(player.name),
                subtitle: Text(player.connected ? 'Connecté' : 'Déconnecté'),
                trailing: Icon(player.ready ? Icons.check_circle : Icons.hourglass_bottom_rounded, color: player.ready ? AppColors.gold : AppColors.ash),
              ),
            ),
          const SizedBox(height: 18),
          FilledButton(onPressed: () {}, child: const Text('Commencer la partie')),
        ],
      ),
    );
  }
}

class GameMasterDashboardScreen extends StatelessWidget {
  const GameMasterDashboardScreen({super.key, required this.room});

  final GameRoom room;

  @override
  Widget build(BuildContext context) {
    final sortedRoles = roleCatalog.where((role) => role.nightOrder < 99).toList()..sort((a, b) => a.nightOrder.compareTo(b.nightOrder));
    return MysticScaffold(
      appBar: AppBar(title: const Text('Maître du jeu'), backgroundColor: Colors.transparent),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Phase ${room.phase.name}', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 14),
          Wrap(spacing: 10, runSpacing: 10, children: [
            FilledButton(onPressed: () {}, child: const Text('Nuit')),
            OutlinedButton(onPressed: () {}, child: const Text('Jour')),
            OutlinedButton(onPressed: () {}, child: const Text('Vote')),
            OutlinedButton(onPressed: () {}, child: const Text('Finir')),
          ]),
          const SizedBox(height: 24),
          Text('Ordre de nuit', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          for (final role in sortedRoles) ListTile(leading: Text(role.icon), title: Text(role.name), subtitle: Text(role.power)),
          const Divider(),
          Text('Joueurs et rôles', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          for (final player in room.players)
            Card(
              child: ListTile(
                title: Text(player.name),
                subtitle: Text('Rôle : ${player.roleId ?? 'non attribué'}'),
                trailing: SegmentedButton<bool>(
                  segments: const [ButtonSegment(value: true, label: Text('Vivant')), ButtonSegment(value: false, label: Text('Mort'))],
                  selected: {player.alive},
                  onSelectionChanged: (_) {},
                ),
              ),
            ),
        ],
      ),
    );
  }
}
