import 'package:flutter/material.dart';

import '../../shared/widgets/mystic_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MysticScaffold(
      appBar: AppBar(title: const Text('Paramètres'), backgroundColor: Colors.transparent),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          SwitchListTile(value: true, onChanged: null, title: Text('Ambiance sonore'), subtitle: Text('Forêt nocturne, hurlements et transitions de phase.')),
          SwitchListTile(value: true, onChanged: null, title: Text('Vibrations'), subtitle: Text('Retour haptique lors des révélations et votes.')),
          SwitchListTile(value: true, onChanged: null, title: Text('Brouillard animé'), subtitle: Text('Effets visuels immersifs et désactivables.')),
          ListTile(title: Text('Fonctionnalités futures'), subtitle: Text('Skins, amis, classement, matchmaking, IA, streamer mode et notifications.')),
        ],
      ),
    );
  }
}
