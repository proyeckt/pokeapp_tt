import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeapp_tt/core/extensions/string_extensions.dart';
import 'package:pokeapp_tt/core/theme/colors.dart';
import 'package:pokeapp_tt/features/pokedex/presentation/controllers/favorites_controller.dart';
import 'package:pokeapp_tt/features/pokedex/presentation/controllers/pokemon_details_controller.dart';

class PokemonDetailsPage extends ConsumerWidget {
  final int pokemonId;

  const PokemonDetailsPage({super.key, required this.pokemonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pokemonDetailControllerProvider(pokemonId));

    final theme = Theme.of(context);

    final favorites = ref.watch(favoritesControllerProvider).value ?? [];
    final isFavorite = favorites.any((p) => p.id == pokemonId);
    final notifier = ref.read(favoritesControllerProvider.notifier);

    return Scaffold(
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (pokemon) => CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              leading: IconButton(
                  onPressed: () => Navigator.maybePop(context),
                  icon: Icon(Icons.arrow_back_ios_new, color: Colors.white)),
              backgroundColor: Colors.green,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade400,
                            Colors.green.shade700
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Hero(
                        tag: 'pokemon-${pokemon.id}',
                        child: Image.network(
                          pokemon.imageUrl,
                          height: 180,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                    icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 32,
                        color: isFavorite
                            ? Colors.redAccent
                            : Colors.white.withValues(alpha: 0.9)),
                    onPressed: () => notifier.toggleFavorite(pokemon)),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pokemon.name.capitalize(),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: AppColors.darkBlackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(pokemon.formattedId,
                        style: const TextStyle(
                            color: AppColors.lightBlackColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: (pokemon.types ?? [])
                          .map((t) => Chip(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 8.0),
                                label: Text(
                                  t.capitalize(),
                                  style: TextStyle(fontSize: 12),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadiusGeometry.circular(32)),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    Text(pokemon.description ?? 'Descripción no disponible',
                        style: const TextStyle(fontSize: 13)),
                    Divider(),
                    const SizedBox(height: 16),

                    // Weight & Height
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _StatBox(
                            title: 'Peso',
                            value: '${pokemon.weight} kg',
                            icon: Icons.fitness_center),
                        _StatBox(
                            title: 'Altura',
                            value: '${pokemon.height} m',
                            icon: Icons.height),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _StatBox(
                            title: 'Categoría',
                            value: pokemon.category ?? 'No disponible',
                            icon: Icons.category_outlined),
                        _StatBox(
                            title: 'Habilidad',
                            value: pokemon.abilities?.first ?? 'No disponible',
                            icon: Icons.catching_pokemon_outlined),
                      ],
                    ),
                    const SizedBox(height: 24),

                    _buildHeaderTitle(context, title: 'Debilidades'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: (pokemon.weaknesses ?? [])
                          .map((w) => Chip(label: Text(w.capitalize())))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderTitle(BuildContext context, {required String title}) =>
      Text(title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 17,
              color: AppColors.darkBlackColor,
              fontWeight: FontWeight.bold));
}

class _StatBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const _StatBox(
      {required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            Icon(icon, color: AppColors.lightBlackColor),
            SizedBox(width: 6),
            Text(title.toUpperCase(),
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightBlackColor)),
          ]),
          SizedBox(height: 6),
          Center(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.greyBorderColor)),
              child: Text(value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ]),
      ),
    );
  }
}
