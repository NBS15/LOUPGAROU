import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme.dart';
import 'features/home/home_screen.dart';
import 'features/home/settings_screen.dart';
import 'features/local_game/local_game_screen.dart';
import 'features/online_game/online_screens.dart';

void main() {
  runApp(const ProviderScope(child: LoupGarouApp()));
}

class LoupGarouApp extends StatelessWidget {
  const LoupGarouApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Loup-Garou Premium',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/local', builder: (context, state) => const LocalGameScreen()),
    GoRoute(path: '/host', builder: (context, state) => const HostRoomScreen()),
    GoRoute(path: '/join', builder: (context, state) => const JoinRoomScreen()),
    GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
  ],
);
