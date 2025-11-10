import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokeapp_tt/features/pokedex/domain/repositories/pokemon_repository_impl.dart';
// Assuming imports for PokemonResponseModel, etc.

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late PokemonRepositoryImpl repository;

  setUp(() {
    mockDio = MockDio();
    repository = PokemonRepositoryImpl(mockDio);
    // Register fallback if needed for any() calls
    registerFallbackValue(Uri());
  });

  test('fetch pokemons', () async {
    // Mock list endpoint (basic results without types)
    when(() => mockDio.get('https://pokeapi.co/api/v2/pokemon?limit=20'))
        .thenAnswer((_) async => Response(
              data: {
                'count': 1,
                'results': [
                  {
                    'name': 'bulbasaur',
                    'url': 'https://pokeapi.co/api/v2/pokemon/1/'
                  }
                ],
                'next': null
              },
              statusCode: 200,
              requestOptions: RequestOptions(path: ''),
            ));

    // Mock details endpoint (with proper 'types' structure to avoid null cast)
    when(() => mockDio.get('https://pokeapi.co/api/v2/pokemon/1/'))
        .thenAnswer((_) async => Response(
              data: {
                'id': 1,
                'name': 'bulbasaur',
                'height': 7,
                'weight': 69,
                'base_experience': 64,
                'types': [
                  {
                    'slot': 1,
                    'type': {
                      'name': 'grass',
                      'url': 'https://pokeapi.co/api/v2/type/12/'
                    }
                  },
                  {
                    'slot': 2,
                    'type': {
                      'name': 'poison',
                      'url': 'https://pokeapi.co/api/v2/type/4/'
                    }
                  }
                ],
              },
              statusCode: 200,
              requestOptions: RequestOptions(path: '/pokemon/1/'),
            ));

    final (pokemons, nextUrl) = await repository.getPokemons();
    expect(pokemons, hasLength(1));
    expect(pokemons.first.name, 'bulbasaur');
    expect(pokemons.first.types, ['grass', 'poison']);
    expect(nextUrl, isNull);
  });
}
