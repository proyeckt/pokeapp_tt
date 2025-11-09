import 'package:flutter/material.dart';

class SoonPage extends StatelessWidget {
  VoidCallback? onRetry;
  SoonPage({super.key, this.onRetry});

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
              'assets/images/poke_soon.png',
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
              '¡Muy pronto disponible!',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Estamos trabajando para traerte esta sección. Vuelve más adelante para descubrir todas las novedades.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            )
          ],
        ),
      ),
    );
  }
}
