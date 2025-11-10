import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokeapp_tt/features/pokedex/domain/repositories/pokemon_repository.dart';
import 'package:pokeapp_tt/features/pokedex/presentation/controllers/pokedex_controller.dart';
import 'package:pokeapp_tt/features/pokedex/domain/entities/pokemon_entity.dart';
import 'package:pokeapp_tt/features/pokedex/domain/usecases/get_pokemons_usecase.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

void main() {
  group('PokedexController', () {
    late MockPokemonRepository mockRepo;
    late GetPokemonsUseCase useCase;

    setUp(() {
      mockRepo = MockPokemonRepository();
      useCase = GetPokemonsUseCase(mockRepo);
      // Mock the repo's method that the use case calls internally
      when(() => mockRepo.getPokemons()).thenAnswer((_) async => (
            [
              const PokemonEntity(
                id: 1,
                name: 'bulbasaur',
                imageUrl: '',
                types: ['grass'],
                height: 7,
                weight: 69,
                baseExperience: 64,
              )
            ],
            null,
          ));
    });

    tearDown(() {
      mockRepo = MockPokemonRepository();
    });

    test('should load pokemons successfully', () async {
      final container = ProviderContainer(
        overrides: [
          getPokemonsUseCaseProvider.overrideWithValue(useCase),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(pokedexControllerProvider.notifier);

      await controller.reloadPokemons();

      final state = container.read(pokedexControllerProvider);
      expect(state.allPokemons.isNotEmpty, true);
      expect(state.allPokemons.first.name, 'bulbasaur');
    });
  });
}
