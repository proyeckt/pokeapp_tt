import 'package:flutter/material.dart';
import 'package:pokeapp_tt/features/onboarding/model/onboarding_step.dart';
import 'package:pokeapp_tt/features/onboarding/presentation/widgets/onboarding_step_widget.dart';

class OnboardingPage extends StatefulWidget {
  final List<OnboardingStep> steps;
  final VoidCallback onCompleted;
  final VoidCallback onSkipped;

  const OnboardingPage({
    super.key,
    required this.steps,
    required this.onCompleted,
    required this.onSkipped,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late PageController _pageController;
  bool _isLastStep = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    int currentPage = _pageController.hasClients
        ? _pageController.page?.round() ?? 0
        : 0;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Spacer(),
            Flexible(
              flex: 3,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.steps.length,
                onPageChanged: (index) {
                  setState(() {
                    _isLastStep = index == widget.steps.length - 1;
                  });
                },
                itemBuilder: (context, index) {
                  final step = widget.steps[index];
                  return OnboardingStepWidget(
                    step: step,
                    isLastStep: _isLastStep,
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.steps.length, (idx) {
                return AnimatedContainer(
                  width: idx == currentPage ? 24 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: idx == currentPage
                        ? Theme.of(context).colorScheme.secondary
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(
                      idx == currentPage ? 4 : 50,
                    ),
                  ),
                  duration: const Duration(milliseconds: 300),
                );
              }),
            ),
            SizedBox(height: 32),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
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
                onPressed: () {
                  if (currentPage < widget.steps.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    widget.onCompleted();
                  }
                },
                child: Text(
                  _isLastStep ? 'Empecemos' : 'Continuar',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Skip button (shown on all steps except the last)
            if (!_isLastStep)
              TextButton(
                onPressed: widget.onSkipped,
                child: Text(
                  'Omitir',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
