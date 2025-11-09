import 'package:pokeapp_tt/features/pokedex/domain/entities/pokemon_entity.dart';

abstract class FavoritesRepository {
  Future<List<PokemonEntity>> loadFavorites();
  Future<void> saveFavorites(List<PokemonEntity> favorites);
}
