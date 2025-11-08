import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../../domain/usecases/get_pokemons_usecase.dart';

final pokedexControllerProvider =
    StateNotifierProvider<PokedexController, AsyncValue<List<PokemonEntity>>>((
  ref,
) {
  final useCase = ref.watch(getPokemonsUseCaseProvider);
  return PokedexController(useCase);
});

final getPokemonsUseCaseProvider = Provider<GetPokemonsUseCase>((ref) {
  throw UnimplementedError('Provide GetPokemonsUseCase at runtime');
});

class PokedexController extends StateNotifier<AsyncValue<List<PokemonEntity>>> {
  final GetPokemonsUseCase _getPokemons;
  String? _nextUrl;
  bool _isLoadingMore = false;

  PokedexController(this._getPokemons) : super(const AsyncLoading()) {
    loadInitial();
  }

  Future<void> loadInitial() async {
    try {
      final (pokemons, nextUrl) = await _getPokemons(null);
      _nextUrl = nextUrl;
      state = AsyncData(pokemons);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || _nextUrl == null) return;
    _isLoadingMore = true;

    try {
      final (newPokemons, nextUrl) = await _getPokemons(_nextUrl);
      _nextUrl = nextUrl;

      final current = state.value ?? [];
      state = AsyncData([...current, ...newPokemons]);
    } catch (e, st) {
      state = AsyncError(e, st);
    } finally {
      _isLoadingMore = false;
    }
  }
}
