import 'package:flutter_test/flutter_test.dart';
import 'package:pokeapp_tt/features/pokedex/domain/entities/pokemon_entity.dart';

void main() {
  group('PokemonEntity', () {
    test('should format ID correctly', () {
      const pokemon = PokemonEntity(
        id: 25,
        name: 'pikachu',
        imageUrl: 'url',
        types: ['electric'],
        height: 4,
        weight: 60,
        baseExperience: 112,
      );

      expect(pokemon.formattedId, 'N°025');
      expect(pokemon.displayHeight, '0.4 m');
      expect(pokemon.displayWeight, '6.0 kg');
    });
  });
}
