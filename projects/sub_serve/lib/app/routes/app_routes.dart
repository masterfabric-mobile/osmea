import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:sub_serve/app/views/view_home/home_view.dart';

/// Splash ve Onboarding sayfaları masterfabric_core ^0.0.15 paketinden gelir
/// (SplashView, OnboardingView, OnboardingStorageHelper, AssetConfigHelper).

/// After splash, check onboarding and navigate to /onboarding or /home.
Future<void> _handleSplashNavigation(BuildContext context) async {
  try {
    final onboardingHelper = OnboardingStorageHelper();
    final hasSeenOnboarding = await onboardingHelper.hasSeenOnboarding();

    final configHelper = AssetConfigHelper();
    final onboardingEnabled = configHelper.getBool(
      'feature_flags.onboarding_enabled',
      true,
    );

    if (!context.mounted) return;

    if (onboardingEnabled && !hasSeenOnboarding) {
      debugPrint('📚 First-time user, navigating to onboarding');
      context.go('/onboarding');
    } else {
      debugPrint('🏠 Navigating to home');
      context.go('/home');
    }
  } catch (e) {
    debugPrint('⚠️ Error checking onboarding state: $e');
    if (context.mounted) {
      context.go('/home');
    }
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return SplashView(
          goRoute: (String path) {
            debugPrint('🎯 Splash completed, checking onboarding');
            _handleSplashNavigation(context);
          },
        );
      },
    ),
    GoRoute(
      path: '/onboarding',
      builder: (BuildContext context, GoRouterState state) {
        return OnboardingView(
          goRoute: (String path) {
            debugPrint('🎯 Onboarding navigate: $path');
            OnboardingStorageHelper().markOnboardingSeen();
            context.go('/home');
          },
        );
      },
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        final args = state.uri.queryParameters.isEmpty
            ? <String, dynamic>{'home': true}
            : Map<String, dynamic>.from(state.uri.queryParameters);
        return HomeView(
          goRoute: (String path) => context.go(path),
          arguments: args,
        );
      },
    ),
  ],
);
