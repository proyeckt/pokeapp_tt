import 'dart:ui';

import 'package:flutter/material.dart';
import '../../domain/entities/pokemon_entity.dart';

class PokemonCard extends StatefulWidget {
  final PokemonEntity pokemon;
  final VoidCallback? onFavoriteToggle;
  final bool isFavorite;

  const PokemonCard({
    super.key,
    required this.pokemon,
    this.onFavoriteToggle,
    this.isFavorite = false,
  });

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
    final gradient = LinearGradient(
      colors: [
        theme.colorScheme.primary.withValues(alpha: 0.9),
        theme.colorScheme.secondary.withValues(alpha: 0.7),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {},
        child: Container(
          height: 128,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: gradient,
          ),
          child: Stack(
            children: [
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
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'N°${widget.pokemon.id.toString().padLeft(3, '0')}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Pokémon name
                    Text(
                      widget.pokemon.name[0].toUpperCase() +
                          widget.pokemon.name.substring(1),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
