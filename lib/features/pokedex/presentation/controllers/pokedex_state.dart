import 'package:pokeapp_tt/features/pokedex/domain/entities/pokemon_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokedex_state.freezed.dart';

@freezed
class PokedexState with _$PokedexState {
  const factory PokedexState({
    @Default([]) List<PokemonEntity> allPokemons,
    @Default([]) List<PokemonEntity> filteredPokemons,
    @Default(<String>{}) Set<String> selectedTypes,
    @Default('') String searchQuery,
    String? nextUrl,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _PokedexState;
}
