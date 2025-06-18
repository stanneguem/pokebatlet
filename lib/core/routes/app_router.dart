import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/pokemon/presentation/pages/pokemon_list_page.dart';
import '../../features/pokemon/presentation/pages/favorites_page.dart';
import '../../features/pokemon/presentation/pages/pokemon_detail_page.dart';
import '../../features/pokemon/data/models/pokemon_model.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => PokemonListPage(),
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => FavoritesPage(),
    ),
    GoRoute(
      path: '/pokemon/:id',
      builder: (context, state) {
        final pokemon = state.extra as PokemonModel;
        return PokemonDetailPage(pokemon: pokemon);
      },
    ),
  ],
); 