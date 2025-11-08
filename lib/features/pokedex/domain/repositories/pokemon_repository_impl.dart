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

      final pokemons = model.results
          .map((e) => PokemonEntity(name: e.name, imageUrl: e.url))
          .toList();

      return (pokemons, model.next);
    } catch (e) {
      throw Exception('Error al obtener los Pokémon: $e');
    }
  }
}
