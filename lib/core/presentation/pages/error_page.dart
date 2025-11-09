import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  VoidCallback? onRetry;
  ErrorPage({super.key, this.onRetry});

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
              'Algo salió mal...',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No pudimos cargar la información en este momento. Verifica tu conexión o intenta nuevamente más tarde.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            _buildRetryButton(context)
          ],
        ),
      ),
    );
  }

  Widget _buildRetryButton(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
        ),
        onPressed: onRetry,
        child: Text(
          'Reintentar',
          style: theme.textTheme.titleMedium
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
