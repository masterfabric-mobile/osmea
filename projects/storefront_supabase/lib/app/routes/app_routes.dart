import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

import 'package:storefront_supabase/app/views/view_home/home_view.dart';
import 'package:storefront_supabase/app/views/view_product_detail/product_detail_view.dart';
import 'package:storefront_supabase/app/views/view_favorites/favorites_view.dart';
import 'package:storefront_supabase/app/views/view_login/login_view.dart';
import 'package:storefront_supabase/app/views/view_signup/signup_view.dart';
import 'package:storefront_supabase/app/views/view_settings/settings_view.dart';

class MainScreen extends StatelessWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/favorites')) {
      return 1;
    }
    if (location.startsWith('/settings')) {
      return 2;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/favorites');
        break;
      case 2:
        context.go('/settings');
        break;
    }
  }
}


final GoRouter appRouter = GoRouter(
  initialLocation: '/home', // Change initial route to home, which is part of ShellRoute
  // Global route configuration
  routes: <RouteBase>[
    // Splash Screen Route (still accessible directly)
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

    // Login Page
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return LoginView(goRoute: (String path) => context.go(path));
      },
    ),

    // Signup Page
    GoRoute(
      path: '/signup',
      builder: (BuildContext context, GoRouterState state) {
        return SignupView(goRoute: (String path) => context.go(path));
      },
    ),
    
    // Product Detail Page
    GoRoute(
      path: '/product-detail/:id',
      builder: (BuildContext context, GoRouterState state) {
        final productId = state.pathParameters['id'];
        return ProductDetailView(
          goRoute: (String path) => context.go(path),
          arguments: {'productId': productId},
        );
      },
    ),

    // ShellRoute for main navigation (Home, Favorites, Settings)
    ShellRoute(
      builder: (context, state, child) => MainScreen(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (BuildContext context, GoRouterState state) {
            return SupabaseHomeView(goRoute: (String path) => context.go(path));
          },
        ),
        GoRoute(
          path: '/favorites',
          builder: (BuildContext context, GoRouterState state) {
            return FavoritesView(goRoute: (String path) => context.go(path));
          },
        ),
        GoRoute(
          path: '/settings',
          builder: (BuildContext context, GoRouterState state) {
            return SettingsView(goRoute: (String path) => context.go(path));
          },
        ),
      ],
    ),
  ],
);
