import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../shared/widgets/mystic_scaffold.dart';
import '../roles/role_catalog.dart';
import 'local_game_controller.dart';

class LocalGameScreen extends ConsumerWidget {
  const LocalGameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localGameControllerProvider);
    final controller = ref.read(localGameControllerProvider.notifier);
    return MysticScaffold(
      appBar: AppBar(title: const Text('Pass & Play'), backgroundColor: Colors.transparent),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 550),
        child: !state.hasStarted
            ? _SetupPanel(state: state, controller: controller)
            : state.allRevealed
                ? _ReadyPanel(onRestart: controller.reset)
                : _RevealPanel(state: state, controller: controller),
      ),
    );
  }
}

class _SetupPanel extends StatelessWidget {
  const _SetupPanel({required this.state, required this.controller});

  final LocalGameState state;
  final LocalGameController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('setup'),
      padding: const EdgeInsets.all(24),
      children: [
        Text('Composer la partie', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        const Text('Choisissez les joueurs, les rôles et laissez le village sombrer dans la nuit.'),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nombre de joueurs : ${state.playerCount}', style: const TextStyle(fontWeight: FontWeight.w800)),
                Slider(
                  min: 5,
                  max: 18,
                  divisions: 13,
                  value: state.playerCount.toDouble(),
                  onChanged: (value) => controller.setPlayerCount(value.round()),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (var i = 0; i < state.selectedRoleIds.length; i++)
                      InputChip(
                        avatar: Text(roleById(state.selectedRoleIds[i]).icon),
                        label: Text(roleById(state.selectedRoleIds[i]).name),
                        onDeleted: () => controller.removeRoleAt(i),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text('Ajouter un rôle', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final role in roleCatalog)
              OutlinedButton.icon(
                onPressed: () => controller.addRole(role.id),
                icon: Text(role.icon),
                label: Text(role.name),
              ),
          ],
        ),
        const SizedBox(height: 28),
        FilledButton.icon(
          onPressed: state.selectedRoleIds.length == state.playerCount ? controller.start : null,
          icon: const Icon(Icons.shuffle_rounded),
          label: const Text('Mélanger et distribuer'),
        ),
      ],
    );
  }
}

class _RevealPanel extends StatelessWidget {
  const _RevealPanel({required this.state, required this.controller});

  final LocalGameState state;
  final LocalGameController controller;

  @override
  Widget build(BuildContext context) {
    final seat = state.currentSeat!;
    return Padding(
      key: ValueKey('reveal-${seat.index}-${state.cardVisible}'),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(),
          Text('Joueur ${seat.index}', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(
            state.cardVisible ? 'Mémorisez votre rôle, puis cachez la carte.' : 'Prenez le téléphone seul et touchez la carte.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.mist),
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: state.cardVisible ? null : controller.revealCard,
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: state.cardVisible ? math.pi : 0),
              duration: const Duration(milliseconds: 650),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                final showFront = value > math.pi / 2;
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, .001)
                    ..rotateY(value),
                  child: showFront
                      ? Transform(alignment: Alignment.center, transform: Matrix4.rotationY(math.pi), child: _RoleCard(seat: seat))
                      : const _CardBack(),
                );
              },
            ),
          ),
          const Spacer(),
          if (state.cardVisible)
            FilledButton.icon(
              onPressed: controller.hideAndNext,
              icon: const Icon(Icons.visibility_off_rounded),
              label: const Text('Cacher la carte'),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _CardBack extends StatelessWidget {
  const _CardBack();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 310,
      height: 440,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: const LinearGradient(colors: [Color(0xFF321322), Color(0xFF121D38)]),
        border: Border.all(color: AppColors.gold.withOpacity(.42), width: 1.4),
        boxShadow: [BoxShadow(color: AppColors.crimson.withOpacity(.35), blurRadius: 50, offset: const Offset(0, 26))],
      ),
      child: const Center(child: Text('Touchez pour révéler\nvotre carte', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900))),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({required this.seat});

  final LocalSeat seat;

  @override
  Widget build(BuildContext context) {
    final role = seat.role;
    return Container(
      width: 310,
      height: 440,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF202A46), Color(0xFF0E111C)]),
        border: Border.all(color: AppColors.gold, width: 1.2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(role.icon, style: const TextStyle(fontSize: 78)),
          const SizedBox(height: 20),
          Text(role.name, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, color: AppColors.gold)),
          const SizedBox(height: 14),
          Text(role.description, textAlign: TextAlign.center),
          const Divider(height: 34),
          Text(role.power, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.mist)),
        ],
      ),
    );
  }
}

class _ReadyPanel extends StatelessWidget {
  const _ReadyPanel({required this.onRestart});

  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('ready'),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🌘', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            Text('La partie commence', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w900), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            const Text('Tous les rôles ont été distribués. Le maître du jeu peut lancer la première nuit.', textAlign: TextAlign.center),
            const SizedBox(height: 24),
            OutlinedButton(onPressed: onRestart, child: const Text('Nouvelle distribution')),
          ],
        ),
      ),
    );
  }
}
