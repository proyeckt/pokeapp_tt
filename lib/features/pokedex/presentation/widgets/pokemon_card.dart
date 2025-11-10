import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokeapp_tt/core/extensions/string_extensions.dart';
import 'package:pokeapp_tt/core/theme/colors.dart';
import 'package:pokeapp_tt/core/utils/pokemon_type_mapper.dart';
import '../../domain/entities/pokemon_entity.dart';

class PokemonCard extends StatefulWidget {
  final PokemonEntity pokemon;
  final VoidCallback? onFavoriteToggle;
  final bool isFavorite;
  final double cardHeight;

  const PokemonCard(
      {super.key,
      required this.pokemon,
      this.onFavoriteToggle,
      this.isFavorite = false,
      this.cardHeight = 128});

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Keep this widget alive when off-screen

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final types = widget.pokemon.types ?? <String>[];
    String primaryType =
        types.isNotEmpty ? types.first.toLowerCase() : 'normal';
    final primaryColor = PokemonTypeMapper.getTypeColor(primaryType);
    final cardBgColor = primaryColor.withValues(alpha: 0.4);
    final typeImage = PokemonTypeMapper.getTypeImagePath(primaryType);

    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        color: cardBgColor,
        elevation: 2,
        child: InkWell(
          onTap: () => context.push('/pokemonDetails/${widget.pokemon.id}'),
          child: SizedBox(
              height: widget.cardHeight,
              width: double.infinity,
              child: Stack(children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Left column: ID, Name, Types
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.pokemon.formattedId,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.lightBlackColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Pokémon name
                          Text(
                            widget.pokemon.name.capitalize(),
                            style: theme.textTheme.headlineSmall?.copyWith(
                                fontSize: 22,
                                color: AppColors.darkBlackColor,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis),
                          ),
                          const SizedBox(height: 2),
                          // Types chips
                          Flexible(
                            child: Wrap(
                              spacing: 8,
                              children:
                                  (widget.pokemon.types ?? []).map((type) {
                                final typeColor =
                                    PokemonTypeMapper.getTypeColor(
                                        type.toLowerCase());
                                return Chip(
                                  padding: EdgeInsets.all(2.0),
                                  label: Text(
                                    PokemonTypeMapper.getSpanishType(type)
                                        .capitalize(),
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                  backgroundColor: typeColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(32)),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Right: Pokémon image
                  Container(
                    width: widget.cardHeight,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(children: [
                        Positioned(
                          top: 20,
                          left: 12,
                          child: Image.asset(
                            height: 100,
                            width: 100,
                            typeImage,
                            fit: BoxFit.contain,
                            color: Colors.white.withValues(alpha: 0.1),
                            colorBlendMode: BlendMode.srcATop,
                            errorBuilder: (context, error, stackTrace) =>
                                SizedBox(),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          top: 40,
                          child: Image.network(
                            widget.pokemon.imageUrl,
                            fit: BoxFit.contain,
                            width: 80,
                            height: 80,
                            errorBuilder: (context, error, stack) => Icon(
                                Icons.image_not_supported,
                                size: 80,
                                color: Colors.white24),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ]),
                Positioned(
                    top: 6,
                    right: 6,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1.6,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: InkWell(
                              onTap: widget.onFavoriteToggle,
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Icon(
                                  widget.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: widget.isFavorite
                                      ? Colors.redAccent
                                      : Colors.white.withValues(alpha: 0.9),
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ))),
              ])),
        ));
  }
}
