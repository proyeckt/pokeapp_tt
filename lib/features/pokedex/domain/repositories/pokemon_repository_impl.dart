import 'package:dio/dio.dart';
import 'package:pokeapp_tt/features/pokedex/data/models/pokemon_response_model.dart';
import 'package:pokeapp_tt/features/pokedex/domain/entities/pokemon_entity.dart';
import 'package:pokeapp_tt/features/pokedex/domain/repositories/pokemon_repository.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final Dio _dio;
  final _cache = <int, PokemonEntity>{};

  PokemonRepositoryImpl(this._dio);

  @override
  Future<(List<PokemonEntity>, String?)> getPokemons({String? nextUrl}) async {
    final url = nextUrl ?? 'https://pokeapi.co/api/v2/pokemon?limit=20';
    final response = await _dio.get(url);
    final model = PokemonResponseModel.fromJson(response.data);

    final futures = model.results.map((e) async {
      final id = int.parse(e.url.split('/').where((s) => s.isNotEmpty).last);

      final detailsResponse = await _dio.get(e.url);
      final data = detailsResponse.data;

      final types = (data['types'] as List)
          .map<String>((t) => t['type']['name'].toString())
          .toList();

      // Base data for list display
      return PokemonEntity(
        id: id,
        name: e.name,
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
        types: types,
        height: 0,
        weight: 0,
        baseExperience: 0,
        abilities: [],
        category: '',
        description: '',
        maleRate: null,
        femaleRate: null,
        weaknesses: [],
      );
    }).toList();

    final pokemons = await Future.wait(futures);
    return (pokemons, model.next);
  }

  @override
  Future<PokemonEntity> getPokemonDetails(int id) async {
    // Return cached if exists
    if (_cache.containsKey(id)) {
      return _cache[id]!;
    }

    // Otherwise, fetch from API
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

      final height = (data['height'] as num).toDouble();
      final weight = (data['weight'] as num).toDouble();

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

      final pokemon = PokemonEntity(
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

      // Store pokemon to cached elements
      _cache[id] = pokemon;

      return pokemon;
    } catch (e) {
      throw Exception('Error al obtener detalles del Pokémon: $e');
    }
  }
}
