import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeapp_tt/core/constants/pokemon_types.dart';
import 'package:pokeapp_tt/core/extensions/string_extensions.dart';
import 'package:pokeapp_tt/core/presentation/pages/error_page.dart';
import 'package:pokeapp_tt/core/theme/colors.dart';
import 'package:pokeapp_tt/core/utils/pokemon_type_mapper.dart';
import 'package:pokeapp_tt/features/pokedex/presentation/controllers/favorites_controller.dart';
import 'package:pokeapp_tt/features/pokedex/presentation/controllers/pokedex_controller.dart';
import 'package:pokeapp_tt/features/pokedex/presentation/widgets/pokemon_card.dart';

class PokedexPage extends ConsumerWidget {
  const PokedexPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pokedexControllerProvider);
    final controller = ref.read(pokedexControllerProvider.notifier);

    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Search field
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.grey),
                        hintText: 'Buscar Pokémon...',
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onChanged: controller.updateSearchQuery,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Filter button
                  Container(
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.filter_list_rounded,
                            color: AppColors.lightBlackColor),
                        onPressed: () => _openFilterSheet(context, ref),
                      )),
                ],
              ),
            ),

            // 🔹 Result counter & clear filter
            if (state.filteredPokemons.isNotEmpty &&
                state.selectedTypes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 8, right: 20),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                          'Se han encontrado ${state.filteredPokemons.length} resultados',
                          style: const TextStyle(fontSize: 12),
                          softWrap: true),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: controller.clearFilters,
                      child: const Text(
                        'Borrar filtro',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 8),

            // 🔹 Pokémon List
            Expanded(
              child: Builder(
                builder: (_) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.errorMessage != null) {
                    return ErrorPage(onRetry: controller.reloadPokemons);
                  } else if (state.filteredPokemons.isEmpty) {
                    return const Center(
                      child: Text('No se encontraron Pokémon.'),
                    );
                  }

                  final pokemons = state.filteredPokemons;

                  return NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                        controller.loadMore();
                      }
                      return false;
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 8),
                      itemCount: pokemons.length,
                      itemBuilder: (context, index) {
                        final pokemon = pokemons[index];
                        final favorites =
                            ref.watch(favoritesControllerProvider).value ?? [];
                        final isFavorite =
                            favorites.any((p) => p.id == pokemon.id);
                        final notifier =
                            ref.read(favoritesControllerProvider.notifier);

                        return PokemonCard(
                          pokemon: pokemon,
                          isFavorite: isFavorite,
                          onFavoriteToggle: () =>
                              notifier.toggleFavorite(pokemon),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFilterSheet(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) {
          return Consumer(
            builder: (context, ref, _) {
              final state = ref.watch(pokedexControllerProvider);
              final controller = ref.read(pokedexControllerProvider.notifier);
              final height = MediaQuery.of(context).size.height * 0.6;
              return Container(
                height: height,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: const Text(
                        'Filtra por tus preferencias',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Tipo',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const Divider(),

                    // List of checkboxes
                    Expanded(
                      child: ListView(
                        children: kPokemonTypes.map((type) {
                          final isSelected = state.selectedTypes.contains(type);

                          return CheckboxListTile(
                            title: Text(
                              PokemonTypeMapper.getSpanishType(type)
                                  .capitalize(),
                            ),
                            activeColor: AppColors.tertiaryColor,
                            value: isSelected,
                            checkboxShape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadiusGeometry.circular(4.0),
                                side: BorderSide(
                                    color: AppColors.greyBorderColor)),
                            onChanged: (_) => controller.toggleTypeFilter(type),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Apply and Cancel buttons
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12)),
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Aplicar',
                              style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: AppColors.greySolidColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12)),
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancelar',
                              style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
