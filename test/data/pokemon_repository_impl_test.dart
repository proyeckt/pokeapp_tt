import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokeapp_tt/features/pokedex/domain/repositories/pokemon_repository_impl.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late PokemonRepositoryImpl repository;

  setUp(() {
    mockDio = MockDio();
    repository = PokemonRepositoryImpl(mockDio);
  });

  test('fetch pokemons', () async {
    when(() => mockDio.get(any())).thenAnswer((_) async => Response(
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

    final (pokemons, nextUrl) = await repository.getPokemons();
    expect(pokemons.first.name, 'bulbasaur');
    expect(nextUrl, isNull);
  });
}
