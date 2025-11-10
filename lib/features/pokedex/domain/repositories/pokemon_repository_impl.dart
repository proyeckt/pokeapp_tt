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

      final pokemons = <PokemonEntity>[];

      // Fetch details in parallel for better performance
      await Future.wait(model.results.map((result) async {
        try {
          final id =
              int.parse(result.url.split('/').where((s) => s.isNotEmpty).last);

          // Fetch details of this Pokémon
          final detailResponse =
              await _dio.get('https://pokeapi.co/api/v2/pokemon/$id');
          final data = detailResponse.data;

          final types = (data['types'] as List)
              .map<String>((t) => t['type']['name'].toString())
              .toList();

          final height = (data['height'] ?? 0) / 10.0; // decimetres → metres
          final weight = (data['weight'] ?? 0) / 10.0; // hectograms → kilograms
          final baseExp = data['base_experience'] ?? 0;

          pokemons.add(PokemonEntity(
            id: id,
            name: result.name,
            imageUrl:
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
            types: types,
            height: height,
            weight: weight,
            baseExperience: baseExp,
            abilities: const [],
            category: '',
            description: '',
            maleRate: 0,
            femaleRate: 0,
            weaknesses: const [],
          ));
        } catch (_) {
          // skip this Pokémon if details failed
        }
      }));

      return (pokemons, model.next);
    } catch (e) {
      throw Exception('Error al obtener los Pokémon: $e');
    }
  }

  @override
  Future<PokemonEntity> getPokemonDetails(int id) async {
    try {
      final detailsResponse =
          await _dio.get('https://pokeapi.co/api/v2/pokemon/$id');
      final speciesResponse =
          await _dio.get('https://pokeapi.co/api/v2/pokemon-species/$id');

      final data = detailsResponse.data;
      final species = speciesResponse.data;

      final types = (data['types'] as List)
          .map<String>((t) => t['type']['name'].toString())
          .toList();

      final height = (data['height'] as int) / 10; // m
      final weight = (data['weight'] as int) / 10; // kg

      final description = (species['flavor_text_entries'] as List)
          .firstWhere(
            (entry) => entry['language']['name'] == 'es',
            orElse: () => {'flavor_text': 'Sin descripción disponible.'},
          )['flavor_text']
          .toString()
          .replaceAll('\n', ' ')
          .replaceAll('\f', ' ');

      final category = species['genera']
          .firstWhere(
            (g) => g['language']['name'] == 'es',
            orElse: () => {'genus': 'Desconocido'},
          )['genus']
          .toString()
          .replaceAll(RegExp(r'pok[eé]mon', caseSensitive: false), '')
          .trim();

      final abilities = (data['abilities'] as List)
          .map<String>((a) => a['ability']['name'].toString())
          .toList();

      return PokemonEntity(
        id: id,
        name: data['name'],
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
        types: types,
        height: height,
        weight: weight,
        abilities: abilities,
        category: category,
        description: description,
        baseExperience: data['base_experience'] ?? 0,
        maleRate: 0,
        femaleRate: 0,
        weaknesses: const [],
      );
    } catch (e) {
      throw Exception('Error al obtener detalles del Pokémon: $e');
    }
  }
}
