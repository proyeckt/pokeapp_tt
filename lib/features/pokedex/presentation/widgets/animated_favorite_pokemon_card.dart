import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pokeapp_tt/core/theme/colors.dart';
import 'package:pokeapp_tt/features/pokedex/domain/entities/pokemon_entity.dart';
import 'package:pokeapp_tt/features/pokedex/presentation/widgets/pokemon_card.dart';

class AnimatedFavoritePokemonCard extends StatefulWidget {
  final PokemonEntity pokemon;
  final VoidCallback onRemove;
  final VoidCallback onToggleFavorite;

  const AnimatedFavoritePokemonCard({
    super.key,
    required this.pokemon,
    required this.onRemove,
    required this.onToggleFavorite,
  });

  @override
  State<AnimatedFavoritePokemonCard> createState() =>
      AnimatedFavoriteCardSPokemontate();
}

class AnimatedFavoriteCardSPokemontate
    extends State<AnimatedFavoritePokemonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  bool _isAnimatingOut = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Fade from 1 -> 0
    _fade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Slide slightly to the right as it fades (you can invert direction)
    _slide = Tween<Offset>(begin: Offset.zero, end: const Offset(0.2, 0.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  Future<void> _handleRemove() async {
    if (_isAnimatingOut) return;
    setState(() => _isAnimatingOut = true);

    // 1️⃣ Reproduce animación local
    await _controller.forward();

    // 2️⃣ Deja que el frame termine antes de mutar el provider
    if (mounted) {
      Future.microtask(widget.onRemove);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Keep widget in tree until onRemove is called (which happens after animation)
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Slidable(
            key: ValueKey(widget.pokemon.id),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.3,
              children: [
                // Use your custom container so it sits flush with the card
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.removeActionColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: InkWell(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      onTap: _handleRemove,
                      child: const Center(
                        child: Icon(
                          Icons.delete_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            child: PokemonCard(
              pokemon: widget.pokemon,
              isFavorite: true,
              onFavoriteToggle: widget.onToggleFavorite,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
