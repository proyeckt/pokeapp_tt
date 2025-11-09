import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/pokemon_entity.dart';

class FavoritesLocalDataSource {
  static const _key = 'favorites_list';

  Future<List<PokemonEntity>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    return jsonList
        .map((item) => PokemonEntity.fromJson(jsonDecode(item)))
        .toList();
  }

  Future<void> saveFavorites(List<PokemonEntity> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList =
        favorites.map((pokemon) => jsonEncode(pokemon.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }
}
