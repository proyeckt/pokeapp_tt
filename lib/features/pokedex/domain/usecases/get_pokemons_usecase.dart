import 'package:pokeapp_tt/core/usecase/usecase.dart';
import 'package:pokeapp_tt/features/pokedex/domain/entities/pokemon_entity.dart';
import 'package:pokeapp_tt/features/pokedex/domain/repositories/pokemon_repository.dart';

class GetPokemonsUseCase
    implements UseCase<(List<PokemonEntity>, String?), String?> {
  final PokemonRepository repository;

  GetPokemonsUseCase(this.repository);

  @override
  Future<(List<PokemonEntity>, String?)> call(String? nextUrl) async {
    return await repository.getPokemons(nextUrl: nextUrl);
  }
}
