import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokeapp_tt/features/pokedex/presentation/widgets/pokemon_card.dart';
import 'package:pokeapp_tt/features/pokedex/domain/entities/pokemon_entity.dart';

void main() {
  testWidgets('renders pokemon name and favorite icon', (tester) async {
    const pokemon = PokemonEntity(
      id: 25,
      name: 'pikachu',
      imageUrl: '',
      types: ['electric'],
      height: 4,
      weight: 60,
      baseExperience: 112,
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: PokemonCard(pokemon: pokemon),
      ),
    ));

    expect(find.text('Pikachu'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
  });
}
