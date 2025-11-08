import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeapp_tt/features/pokedex/presentation/controllers/pokedex_controller.dart';
import 'package:pokeapp_tt/features/pokedex/presentation/widgets/pokemon_card.dart';

class PokedexPage extends ConsumerWidget {
  const PokedexPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pokedexControllerProvider);
    final controller = ref.read(pokedexControllerProvider.notifier);

    return SafeArea(
      child: Scaffold(
        body: state.when(
          data: (pokemons) => NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                controller.loadMore();
              }
              return false;
            },
            child: ListView.builder(
              itemCount: pokemons.length,
              itemBuilder: (context, index) =>
                  PokemonCard(pokemon: pokemons[index]),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child:
                Text('Error: $err', style: const TextStyle(color: Colors.red)),
          ),
        ),
      ),
    );
  }
}
