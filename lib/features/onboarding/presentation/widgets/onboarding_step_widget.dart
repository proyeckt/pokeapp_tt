import 'package:flutter/material.dart';
import 'package:pokeapp_tt/core/theme/colors.dart';
import 'package:pokeapp_tt/features/onboarding/model/onboarding_step.dart';

class OnboardingStepWidget extends StatelessWidget {
  final OnboardingStep step;
  final bool isLastStep;

  const OnboardingStepWidget({
    super.key,
    required this.step,
    required this.isLastStep,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image
            Image.asset(
              step.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade200),
                child: const Icon(Icons.image_not_supported, size: 100),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    step.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: AppColors.darkBlackColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Description
                  Text(
                    step.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.lightBlackColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
