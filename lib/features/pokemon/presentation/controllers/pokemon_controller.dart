import 'package:get/get.dart';
import '../../data/models/pokemon_model.dart';
import '../../data/repositories/pokemon_repository.dart';
import '../../data/repositories/favorite_pokemon_db.dart';
import 'dart:async';

class PokemonController extends GetxController {
  final PokemonRepository _repository = PokemonRepository();
  final FavoritePokemonDb _favoriteDb = FavoritePokemonDb();
  final RxList<PokemonModel> pokemons = <PokemonModel>[].obs;
  final RxList<PokemonModel> favoritePokemons = <PokemonModel>[].obs;
  final RxSet<int> favoriteIds = <int>{}.obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString searchQuery = ''.obs;
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    fetchPokemons();
    loadFavorites();
    ever(searchQuery, (_) => _onSearchChanged());
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  Future<void> fetchPokemons() async {
    try {
      isLoading.value = true;
      error.value = '';
      final result = await _repository.getPokemons();
      pokemons.value = result.map((p) => p.copyWith(isFavorite: favoriteIds.contains(p.id))).toList();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadFavorites() async {
    final ids = await _favoriteDb.getFavorites();
    favoriteIds.value = ids.toSet();
    // Mettre à jour les listes
    favoritePokemons.value = pokemons.where((p) => favoriteIds.contains(p.id)).toList();
    pokemons.value = pokemons.map((p) => p.copyWith(isFavorite: favoriteIds.contains(p.id))).toList();
  }

  Future<void> toggleFavorite(PokemonModel pokemon) async {
    if (favoriteIds.contains(pokemon.id)) {
      await _favoriteDb.removeFavorite(pokemon.id);
      favoriteIds.remove(pokemon.id);
    } else {
      await _favoriteDb.addFavorite(pokemon.id);
      favoriteIds.add(pokemon.id);
    }
    // Mettre à jour les listes
    favoritePokemons.value = pokemons.where((p) => favoriteIds.contains(p.id)).toList();
    pokemons.value = pokemons.map((p) => p.copyWith(isFavorite: favoriteIds.contains(p.id))).toList();
    update();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch();
    });
  }

  Future<void> _performSearch() async {
    try {
      isLoading.value = true;
      error.value = '';
      final results = await _repository.searchPokemons(searchQuery.value);
      pokemons.value = results.map((p) => p.copyWith(isFavorite: favoriteIds.contains(p.id))).toList();
      favoritePokemons.value = pokemons.where((p) => favoriteIds.contains(p.id)).toList();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }
} 