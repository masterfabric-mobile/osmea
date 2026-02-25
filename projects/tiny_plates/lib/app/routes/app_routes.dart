import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:tiny_plates/app/views/view_dashboard/dashboard_shell.dart';
import 'package:tiny_plates/app/views/view_diary/diary_view.dart';
import 'package:tiny_plates/app/views/view_home/home_view.dart';
import 'package:tiny_plates/app/views/view_onboarding/onboarding_view.dart';
import 'package:tiny_plates/app/views/view_settings/settings_view.dart';

/// Splash from masterfabric_core. Onboarding from tiny_plates view_onboarding.
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
        return TinyPlatesOnboardingView(
          goRoute: (String path) {
            debugPrint('🎯 Onboarding navigate: $path');
            context.go(path);
          },
          arguments: const {'onboarding': true},
        );
      },
    ),

    /// Dashboard shell: wraps /home, /diary, /settings with bottom navbar.
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return DashboardShell(child: child);
      },
      routes: [
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
        GoRoute(
          path: '/diary',
          builder: (BuildContext context, GoRouterState state) {
            return const DiaryView();
          },
        ),
        GoRoute(
          path: '/settings',
          builder: (BuildContext context, GoRouterState state) {
            return const SettingsView();
          },
        ),
      ],
    ),
  ],
);
