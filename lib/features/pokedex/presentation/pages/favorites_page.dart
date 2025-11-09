import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeapp_tt/core/theme/styles.dart';
import 'package:pokeapp_tt/features/pokedex/presentation/controllers/favorites_controller.dart';
import 'package:pokeapp_tt/features/pokedex/presentation/widgets/animated_favorite_pokemon_card.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesState = ref.watch(favoritesControllerProvider);
    final notifier = ref.read(favoritesControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        titleTextStyle: AppStyles.appBarTitleStyle,
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: Icon(Icons.arrow_back_ios_new)),
      ),
      body: SafeArea(
        child: favoritesState.when(
          data: (favorites) {
            if (favorites.isEmpty) {
              return const _EmptyFavoritesView();
            }
            return ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final pokemon = favorites[index];

                  return AnimatedFavoritePokemonCard(
                    key: ValueKey('fav_${pokemon.id}'),
                    pokemon: pokemon,
                    onRemove: () => notifier.removeFavoriteById(pokemon.id),
                    onToggleFavorite: () => notifier.toggleFavorite(pokemon),
                  );
                });
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Text(
              'Error cargando favoritos: $err',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyFavoritesView extends StatelessWidget {
  const _EmptyFavoritesView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/poke_error.png',
              errorBuilder: (context, error, stackTrace) => Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade200),
                child: const Icon(Icons.image_not_supported, size: 100),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No has marcado ningún Pokémon como favorito',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Haz clic en el icono de corazón de tus Pokémon favoritos y aparecerán aquí.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
