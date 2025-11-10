import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeapp_tt/features/pokedex/domain/entities/pokemon_entity.dart';
import 'package:pokeapp_tt/features/pokedex/domain/repositories/pokemon_repository_impl.dart';
import 'package:pokeapp_tt/features/pokedex/domain/usecases/get_pokemon_detail_usecase.dart';

final pokemonDetailControllerProvider = StateNotifierProvider.family<
    PokemonDetailController, AsyncValue<PokemonEntity>, int>((ref, id) {
  final useCase = ref.watch(getPokemonDetailsUseCaseProvider);
  return PokemonDetailController(useCase, id);
});

final getPokemonDetailsUseCaseProvider = Provider<GetPokemonDetailsUseCase>(
  (ref) {
    final repository = PokemonRepositoryImpl(Dio());
    return GetPokemonDetailsUseCase(repository);
  },
);

class PokemonDetailController extends StateNotifier<AsyncValue<PokemonEntity>> {
  final GetPokemonDetailsUseCase _getDetails;
  final int id;

  PokemonDetailController(this._getDetails, this.id)
      : super(const AsyncValue.loading()) {
    loadDetails();
  }

  Future<void> loadDetails() async {
    try {
      final details = await _getDetails(id);
      state = AsyncValue.data(details);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
