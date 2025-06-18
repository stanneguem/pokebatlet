import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon_model.dart';

class PokemonRepository {
  final String baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<PokemonModel>> getPokemons({int limit = 100, int offset = 0}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/pokemon?limit=$limit&offset=$offset'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      
      final pokemons = await Future.wait(
        results.map((pokemon) async {
          final pokemonResponse = await http.get(Uri.parse(pokemon['url']));
          return PokemonModel.fromJson(json.decode(pokemonResponse.body));
        }),
      );

      return pokemons;
    } else {
      throw Exception('Failed to load pokemons');
    }
  }

  Future<List<PokemonModel>> searchPokemons(String query) async {
    if (query.isEmpty) {
      return getPokemons();
    }

    try {
      // L'API PokeAPI ne supporte pas directement la recherche partielle,
      // donc on fait une requête directe avec le nom/id
      final response = await http.get(
        Uri.parse('$baseUrl/pokemon/${query.toLowerCase()}'),
      );

      if (response.statusCode == 200) {
        final pokemon = PokemonModel.fromJson(json.decode(response.body));
        return [pokemon];
      }
    } catch (e) {
      // Si la recherche exacte échoue, on récupère une liste plus grande
      // et on filtre côté client
      final allPokemons = await getPokemons(limit: 100);
      return allPokemons
          .where((pokemon) =>
              pokemon.name.toLowerCase().contains(query.toLowerCase()) ||
              pokemon.id.toString() == query)
          .toList();
    }

    return [];
  }
} 