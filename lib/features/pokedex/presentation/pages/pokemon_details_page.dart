import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeapp_tt/core/extensions/string_extensions.dart';
import 'package:pokeapp_tt/core/presentation/pages/error_page.dart';
import 'package:pokeapp_tt/core/theme/colors.dart';
import 'package:pokeapp_tt/core/utils/pokemon_type_mapper.dart';
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
    final favoritesController = ref.read(favoritesControllerProvider.notifier);
    final detailsController =
        ref.read(pokemonDetailControllerProvider(pokemonId).notifier);

    return Scaffold(
      body: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => ErrorPage(onRetry: detailsController.loadDetails),
          data: (pokemon) {
            final typeColor = PokemonTypeMapper.getTypeColor(
                pokemon.types?.first ?? 'normal');
            final typeImage =
                PokemonTypeMapper.getTypeImagePath(pokemon.types?.first ?? '');
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 250,
                  pinned: true,
                  leading: IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      icon:
                          Icon(Icons.arrow_back_ios_new, color: Colors.white)),
                  // backgroundColor: typeColor,
                  flexibleSpace: FlexibleSpaceBar(
                      background: ClipPath(
                    clipper: CurvedBottomClipper(),
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                typeColor.withValues(alpha: 0.4),
                                typeColor
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 50,
                          child: Image.asset(
                            height: 200,
                            width: 200,
                            typeImage,
                            fit: BoxFit.contain,
                            color: Colors.white.withValues(alpha: 0.1),
                            colorBlendMode: BlendMode.srcATop,
                            errorBuilder: (context, error, stackTrace) =>
                                SizedBox(),
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
                  )),
                  actions: [
                    IconButton(
                        icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 32,
                            color: isFavorite
                                ? Colors.redAccent
                                : Colors.white.withValues(alpha: 0.9)),
                        onPressed: () =>
                            favoritesController.toggleFavorite(pokemon)),
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
                                      PokemonTypeMapper.getSpanishType(t)
                                          .capitalize(),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                    backgroundColor: typeColor,
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
                                value:
                                    pokemon.abilities?.first ?? 'No disponible',
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
            );
          }),
    );
  }

  Widget _buildHeaderTitle(BuildContext context, {required String title}) =>
      Text(title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 17,
              color: AppColors.darkBlackColor,
              fontWeight: FontWeight.bold));
}

class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60); // Start curve higher
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 60, // Dip down for wave effect
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
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
