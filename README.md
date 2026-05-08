# Loup-Garou Premium

Prototype Flutter d'une application mobile Loup-Garou sombre, cinématique et extensible.

## Fonctionnalités incluses

- Mode **Pass & Play** sur un seul téléphone : choix du nombre de joueurs, sélection des rôles, mélange automatique, révélation sécurisée carte par carte.
- Architecture **multijoueur en ligne Firebase-ready** : contrats de repository pour salles, joueurs, votes, phases, permissions maître du jeu.
- UI dark fantasy : dégradés nocturnes, glow rouge/doré, cartes premium, transitions et structure prête pour brouillard, vibrations et audio.
- Dashboard maître du jeu : vision globale joueurs/rôles/état et actions de phase prévues.
- Modèles extensibles pour rôles personnalisés, statistiques, matchmaking, chat vocal et skins.

## Stack prévue

- Flutter
- Riverpod
- Firebase Authentication
- Cloud Firestore
- Firebase Realtime Database
- Firebase Storage

## Lancer le projet

```bash
flutter pub get
flutter run
```

> Les fichiers `firebase_options.dart` et la configuration native Firebase doivent être générés via FlutterFire CLI avant l'activation réelle du mode en ligne.
