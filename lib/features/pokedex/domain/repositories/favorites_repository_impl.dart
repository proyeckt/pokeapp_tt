import 'package:pokeapp_tt/features/pokedex/data/datasources/favorite_local_datasource.dart';
import 'package:pokeapp_tt/features/pokedex/domain/entities/pokemon_entity.dart';
import 'package:pokeapp_tt/features/pokedex/domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;

  FavoritesRepositoryImpl({required this.localDataSource});

  @override
  Future<List<PokemonEntity>> loadFavorites() async {
    return localDataSource.loadFavorites();
  }

  @override
  Future<void> saveFavorites(List<PokemonEntity> favorites) async {
    await localDataSource.saveFavorites(favorites);
  }
}
