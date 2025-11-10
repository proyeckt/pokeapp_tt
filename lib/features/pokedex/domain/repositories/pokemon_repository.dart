import 'package:pokeapp_tt/features/pokedex/domain/entities/pokemon_entity.dart';

abstract class PokemonRepository {
  Future<(List<PokemonEntity>, String?)> getPokemons({String? nextUrl});
  Future<PokemonEntity> getPokemonDetails(int id);
}
