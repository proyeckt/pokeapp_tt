import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeapp_tt/features/pokedex/domain/repositories/pokemon_repository_impl.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../../domain/usecases/get_pokemons_usecase.dart';

final pokedexControllerProvider =
    StateNotifierProvider<PokedexController, AsyncValue<List<PokemonEntity>>>(
  (ref) {
    final useCase = ref.watch(getPokemonsUseCaseProvider);
    return PokedexController(useCase);
  },
);

final getPokemonsUseCaseProvider = Provider<GetPokemonsUseCase>((ref) {
  final repository = PokemonRepositoryImpl(Dio());
  return GetPokemonsUseCase(repository);
});

class PokedexController extends StateNotifier<AsyncValue<List<PokemonEntity>>> {
  final GetPokemonsUseCase _getPokemons;
  String? _nextUrl;
  bool _isFetching = false;

  PokedexController(this._getPokemons) : super(const AsyncValue.loading()) {
    _loadPokemons();
  }

  Future<void> _loadPokemons({bool isRefresh = false}) async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      final url = isRefresh ? null : _nextUrl;
      final (pokemons, nextUrl) = await _getPokemons(url);
      _nextUrl = nextUrl;

      // If refresh, replace the list; otherwise concatenate
      state = AsyncValue.data(
        isRefresh ? pokemons : [...(state.value ?? []), ...pokemons],
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      _isFetching = false;
    }
  }

  Future<void> reloadPokemons() async {
    _nextUrl = null;
    state = const AsyncValue.loading();
    await _loadPokemons(isRefresh: true);
  }

  Future<void> loadMore() async {
    if (_nextUrl == null || _isFetching) return;
    await _loadPokemons();
  }
}
