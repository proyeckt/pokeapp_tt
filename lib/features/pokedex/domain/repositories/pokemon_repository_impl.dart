import 'package:dio/dio.dart';
import 'package:pokeapp_tt/features/pokedex/data/models/pokemon_response_model.dart';
import 'package:pokeapp_tt/features/pokedex/domain/entities/pokemon_entity.dart';
import 'package:pokeapp_tt/features/pokedex/domain/repositories/pokemon_repository.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final Dio _dio;

  PokemonRepositoryImpl(this._dio);

  @override
  Future<(List<PokemonEntity>, String?)> getPokemons({String? nextUrl}) async {
    try {
      final url = nextUrl ?? 'https://pokeapi.co/api/v2/pokemon?limit=20';
      final response = await _dio.get(url);
      final model = PokemonResponseModel.fromJson(response.data);

      final pokemons = model.results.map((e) {
        // Extract the Pokémon ID from the URL
        final id = int.parse(e.url.split('/').where((s) => s.isNotEmpty).last);

        return PokemonEntity(
          id: id,
          name: e.name,
          imageUrl:
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
        );
      }).toList();

      return (pokemons, model.next);
    } catch (e) {
      throw Exception('Error al obtener los Pokémon: $e');
    }
  }
}
