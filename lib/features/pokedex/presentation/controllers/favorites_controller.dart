import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeapp_tt/features/pokedex/data/datasources/favorite_local_datasource.dart';
import 'package:pokeapp_tt/features/pokedex/domain/entities/pokemon_entity.dart';
import 'package:pokeapp_tt/features/pokedex/domain/repositories/favorites_repository_impl.dart';

/// --- Favorites State Notifier ---
class FavoritesNotifier extends StateNotifier<AsyncValue<List<PokemonEntity>>> {
  final FavoritesRepositoryImpl repository;

  FavoritesNotifier(this.repository) : super(const AsyncValue.loading()) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final favorites = await repository.loadFavorites();
      state = AsyncValue.data(favorites);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleFavorite(PokemonEntity pokemon) async {
    final current = state.value ?? [];
    final isFav = current.any((p) => p.id == pokemon.id);
    final updated = isFav
        ? current.where((p) => p.id != pokemon.id).toList()
        : [...current, pokemon];

    state = AsyncValue.data(updated);
    await repository.saveFavorites(updated);
  }

  bool isFavorite(PokemonEntity pokemon) {
    final current = state.value ?? [];
    return current.any((p) => p.id == pokemon.id);
  }

  Future<void> removeFavorite(PokemonEntity pokemon) async {
    await removeFavoriteById(pokemon.id);
  }

  Future<void> removeFavoriteById(int id) async {
    final current = state.value ?? [];
    final updated = current.where((p) => p.id != id).toList();
    state = AsyncValue.data(updated);
    await repository.saveFavorites(updated);
  }
}

/// --- Providers ---
final favoritesLocalDataSourceProvider =
    Provider<FavoritesLocalDataSource>((ref) => FavoritesLocalDataSource());

final favoritesRepositoryProvider = Provider<FavoritesRepositoryImpl>(
  (ref) => FavoritesRepositoryImpl(
    localDataSource: ref.watch(favoritesLocalDataSourceProvider),
  ),
);

final favoritesControllerProvider =
    StateNotifierProvider<FavoritesNotifier, AsyncValue<List<PokemonEntity>>>(
        (ref) {
  final repository = ref.watch(favoritesRepositoryProvider);
  return FavoritesNotifier(repository);
});
