import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';
import '../../shared/widgets/mystic_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MysticScaffold(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 24),
          Text('LOUP-GAROU', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(
            'Une expérience sociale premium, nocturne et cinématique.',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.mist),
          ),
          const SizedBox(height: 34),
          _HeroCard(onPlayLocal: () => context.go('/local')),
          const SizedBox(height: 22),
          _ModeTile(
            icon: Icons.groups_2_rounded,
            title: 'Créer une salle',
            subtitle: 'Deviens maître du jeu, configure les rôles et partage un code.',
            onTap: () => context.go('/host'),
          ),
          _ModeTile(
            icon: Icons.meeting_room_rounded,
            title: 'Rejoindre une salle',
            subtitle: 'Entre un code et reviens automatiquement après déconnexion.',
            onTap: () => context.go('/join'),
          ),
          _ModeTile(
            icon: Icons.tune_rounded,
            title: 'Paramètres',
            subtitle: 'Audio, vibrations, accessibilité et préférences de partie.',
            onTap: () => context.go('/settings'),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.onPlayLocal});

  final VoidCallback onPlayLocal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(colors: [Color(0xFF22101B), Color(0xFF111B35)]),
        border: Border.all(color: AppColors.gold.withOpacity(.28)),
        boxShadow: [BoxShadow(color: AppColors.crimson.withOpacity(.24), blurRadius: 42, offset: const Offset(0, 24))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🌕', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 18),
          Text('Jouer sur un téléphone', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          const Text('Passez le téléphone, révélez les cartes une à une, puis lancez la partie autour de la table.'),
          const SizedBox(height: 20),
          FilledButton.icon(onPressed: onPlayLocal, icon: const Icon(Icons.style_rounded), label: const Text('Mode Pass & Play')),
        ],
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({required this.icon, required this.title, required this.subtitle, required this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppColors.gold.withOpacity(.14),
          child: Icon(icon, color: AppColors.gold),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}
