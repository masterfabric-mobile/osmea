import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:core/src/views/routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  // Global route configuration
  routes: <RouteBase>[
    // Splash Screen Route
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return SplashView(
          goRoute: (String path) {
            if (path.contains(Routes.home.name)) {
              context.go('/home');
            } else if (path.contains(Routes.onboarding.name)) {
              context.go('/onboarding');
            } else {
              context.go('/home'); // Default fallback
            }
          },
        );
      },
    ),

    // Onboarding Route
    GoRoute(
      path: '/onboarding',
      builder: (BuildContext context, GoRouterState state) {
        return OnboardingView(
          goRoute: (String path) {
            if (path.contains(Routes.home.name)) {
              context.go('/home');
            } else {
              context.go('/home'); // Default fallback
            }
          },
          onCompleted: () {
            debugPrint('🎉 Onboarding completed!');
            context.go('/home');
          },
          onSkipped: () {
            debugPrint('⏭️ Onboarding skipped!');
            context.go('/home');
          },
          onError: (error) {
            debugPrint('❌ Onboarding error: $error');
            context.go('/home');
          },
        );
      },
    ),

    // Home Page
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const _MinimalistHomePage();
      },
    ),
  ],
);

/// 🏠 Default Home Page
class _MinimalistHomePage extends StatelessWidget {
  const _MinimalistHomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: OsmeaComponents.text(
          'Storefront Woo',
          color: OsmeaColors.black,
          textStyle: OsmeaTextStyle.titleLarge(
            context,
          ).copyWith(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: OsmeaComponents.container(
            padding: const EdgeInsets.all(32),
            child: OsmeaComponents.center(
              child: OsmeaComponents.column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Welcome Title
                  OsmeaComponents.text(
                    'Welcome to Storefront Woo',
                    color: OsmeaColors.black,
                    textAlign: TextAlign.center,
                    textStyle: OsmeaTextStyle.headlineSmall(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),

                  OsmeaComponents.sizedBox(height: 16),

                  // Welcome Subtitle
                  OsmeaComponents.text(
                    'Your WooCommerce powered store',
                    color: OsmeaColors.slate,
                    textAlign: TextAlign.center,
                    textStyle: OsmeaTextStyle.bodyMedium(context),
                  ),

                  OsmeaComponents.sizedBox(height: 48),

                  // Main Content
                  OsmeaComponents.text(
                    'This is the default home page. You can customize it according to your needs.',
                    color: OsmeaColors.pewter,
                    textAlign: TextAlign.center,
                    textStyle: OsmeaTextStyle.bodyMedium(context),
                  ),

                  OsmeaComponents.sizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
