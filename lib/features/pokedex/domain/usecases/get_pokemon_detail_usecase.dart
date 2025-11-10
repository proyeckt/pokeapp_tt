import 'package:pokeapp_tt/features/pokedex/domain/entities/pokemon_entity.dart';
import 'package:pokeapp_tt/features/pokedex/domain/repositories/pokemon_repository.dart';

class GetPokemonDetailsUseCase {
  final PokemonRepository repository;

  GetPokemonDetailsUseCase(this.repository);

  Future<PokemonEntity> call(int id) {
    return repository.getPokemonDetails(id);
  }
}
