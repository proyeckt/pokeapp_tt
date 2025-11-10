import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeapp_tt/features/pokedex/domain/entities/pokemon_entity.dart';
import 'package:pokeapp_tt/features/pokedex/domain/repositories/pokemon_repository_impl.dart';
import 'package:pokeapp_tt/features/pokedex/domain/usecases/get_pokemons_usecase.dart';
import 'package:pokeapp_tt/features/pokedex/presentation/controllers/pokedex_state.dart';

final pokedexControllerProvider =
    StateNotifierProvider<PokedexController, PokedexState>((ref) {
  final useCase = ref.watch(getPokemonsUseCaseProvider);
  return PokedexController(useCase);
});

final getPokemonsUseCaseProvider = Provider<GetPokemonsUseCase>((ref) {
  final repository = PokemonRepositoryImpl(Dio());
  return GetPokemonsUseCase(repository);
});

class PokedexController extends StateNotifier<PokedexState> {
  final GetPokemonsUseCase _getPokemons;
  bool _isFetching = false;

  PokedexController(this._getPokemons) : super(PokedexState(isLoading: true)) {
    _loadPokemons();
  }

  Future<void> _loadPokemons({bool isRefresh = false}) async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      final url = isRefresh ? null : state.nextUrl;
      final (pokemons, nextUrl) = await _getPokemons(url);

      final allPokemons =
          isRefresh ? pokemons : [...state.allPokemons, ...pokemons];

      state = state.copyWith(
        allPokemons: allPokemons,
        filteredPokemons: _applyFilters(allPokemons,
            query: state.searchQuery, selectedTypes: state.selectedTypes),
        nextUrl: nextUrl,
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al obtener los Pokémon: $e',
      );
    } finally {
      _isFetching = false;
    }
  }

  Future<void> reloadPokemons() async {
    state = state.copyWith(
      isLoading: true,
      allPokemons: [],
      filteredPokemons: [],
      nextUrl: null,
      errorMessage: null,
    );
    await _loadPokemons(isRefresh: true);
  }

  Future<void> loadMore() async {
    if (state.nextUrl == null || _isFetching) return;
    await _loadPokemons();
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(
      searchQuery: query,
      filteredPokemons: _applyFilters(
        state.allPokemons,
        query: query,
        selectedTypes: state.selectedTypes,
      ),
    );
  }

  void toggleTypeFilter(String type) {
    final selected = {...state.selectedTypes}; // clone the current set

    if (selected.contains(type)) {
      selected.remove(type);
    } else {
      selected.add(type);
    }

    final filtered = selected.isEmpty
        ? state.allPokemons
        : state.allPokemons
            .where((p) => (p.types ?? []).any((t) => selected.contains(t)))
            .toList();

    state = state.copyWith(
      selectedTypes: selected,
      filteredPokemons: filtered,
    );
  }

  List<PokemonEntity> _applyFilters(
    List<PokemonEntity> pokemons, {
    required String query,
    required Set<String> selectedTypes,
  }) {
    return pokemons.where((pokemon) {
      final matchesQuery = query.isEmpty ||
          pokemon.name.toLowerCase().contains(query.toLowerCase());
      final matchesType = selectedTypes.isEmpty ||
          (pokemon.types ?? [])
              .any((t) => selectedTypes.contains(t.toLowerCase()));
      return matchesQuery && matchesType;
    }).toList();
  }

  void clearFilters() {
    state = state.copyWith(
      selectedTypes: <String>{},
      filteredPokemons: state.allPokemons,
      searchQuery: '',
    );
  }
}
