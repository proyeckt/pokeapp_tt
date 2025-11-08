import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokeapp_tt/features/onboarding/data/onboarding_steps.dart';
import 'package:pokeapp_tt/features/onboarding/pages/onboarding_page.dart';
import 'package:pokeapp_tt/main.dart';

// Route names for easy reference
class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String home = '/home';

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final RouteObserver<ModalRoute<void>> routeObserver =
      RouteObserver<ModalRoute<void>>();

  // Main router configuration
  static GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.onboarding,
    routes: _routes,
    debugLogDiagnostics: true,
    observers: [routeObserver],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: const Scaffold(body: Center(child: Text('Page not found'))),
    ),
  );

  static List<RouteBase> get _routes => [
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, __) => OnboardingPage(
        steps: onboardingSteps,
        onCompleted: () => context.push(AppRoutes.home),
        onSkipped: () => context.push(AppRoutes.home),
      ),
    ),
    GoRoute(path: '/home', builder: (_, __) => HomePage()),
  ];
}
