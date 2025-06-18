# Flutter Pokédex

Une application moderne de Pokédex développée avec Flutter, utilisant l'architecture feature-first et GetX pour la gestion d'état.

## Fonctionnalités

- 🔍 Recherche de Pokémon par nom ou numéro
- 💖 Système de favoris avec stockage local
- 📊 Affichage détaillé des statistiques
- 🎨 Interface utilisateur moderne avec design pastel
- ⚡ Navigation fluide entre les pages

## Technologies utilisées

- Flutter
- GetX pour la gestion d'état
- SQLite pour le stockage local
- PokeAPI pour les données
- Go Router pour la navigation

## Installation

1. Assurez-vous d'avoir Flutter installé sur votre machine
2. Clonez ce repository
3. Exécutez `flutter pub get` pour installer les dépendances
4. Lancez l'application avec `flutter run`

## Structure du projet

```
lib/
  ├── core/
  │   └── routes/
  │       └── app_router.dart
  └── features/
      └── pokemon/
          ├── data/
          │   ├── models/
          │   │   └── pokemon_model.dart
          │   └── repositories/
          │       ├── favorite_pokemon_db.dart
          │       └── pokemon_repository.dart
          └── presentation/
              ├── controllers/
              │   └── pokemon_controller.dart
              └── pages/
                  ├── favorites_page.dart
                  ├── pokemon_detail_page.dart
                  └── pokemon_list_page.dart
```

## Captures d'écran

[À venir]

## Contribution

Les contributions sont les bienvenues ! N'hésitez pas à ouvrir une issue ou une pull request.

## Licence

MIT
