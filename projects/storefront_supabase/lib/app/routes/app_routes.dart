import 'package:storefront_supabase/app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart' hide SearchView;

import 'package:storefront_supabase/app/views/view_home/home_view.dart';
import 'package:storefront_supabase/app/views/view_product_detail/product_detail_view.dart';
import 'package:storefront_supabase/app/views/view_cart/cart_view.dart';
import 'package:storefront_supabase/app/views/view_categories/categories_view.dart';
import 'package:storefront_supabase/app/views/view_favorites/favorites_view.dart';
import 'package:storefront_supabase/app/views/view_profile/profile_view.dart';
import 'package:storefront_supabase/app/views/view_search/search_view.dart';
import 'package:storefront_supabase/app/views/view_settings/settings_view.dart';

class MainScreen extends StatefulWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});


  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<NavbarItem> _navItems = [
    NavbarItem(text: 'Home', icon: const Icon(Icons.home), onTap: () {}),
    NavbarItem(text: 'Categories', icon: const Icon(Icons.category), onTap: () {}),
    NavbarItem(text: 'My Cart', icon: const Icon(Icons.shopping_cart), onTap: () {}),
    NavbarItem(text: 'Favorites', icon: const Icon(Icons.favorite), onTap: () {}),
    NavbarItem(text: 'Profile', icon: const Icon(Icons.person), onTap: () {}),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: OsmeaComponents.navbar(
        items: _navItems,
        variant: NavbarVariant.primary,
        size: NavbarSize.medium,
        currentIndex: _calculateSelectedIndex(context),
        onItemTap: (int idx) => _onItemTapped(idx, context),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/categories')) return 1;
    if (location.startsWith('/cart')) return 2;
    if (location.startsWith('/favorites')) return 3;
    if (location.startsWith('/profile') || location.startsWith('/settings')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/categories');
        break;
      case 2:
        context.go('/cart');
        break;
      case 3:
        context.go('/favorites');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
          SplashView(goRoute: (String path) => context.go(path)),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (BuildContext context, GoRouterState state) =>
          OnboardingView(goRoute: (String path) => context.go(path)),
    ),
    ShellRoute(
      builder: (context, state, child) => MainScreen(child: child),
      routes: [
        GoRoute(
          path: '/settings',
          builder: (BuildContext context, GoRouterState state) {
            return SettingsView(goRoute: (String path) => context.go(path));
          },
        ),
        GoRoute(
          path: '/product-detail/:id',
          builder: (BuildContext context, GoRouterState state) {
            final productId = state.pathParameters['id'];
            final product = state.extra as Product?;
            return ProductDetailView(
              goRoute: (String path) => context.go(path),
              arguments: {
                'productId': productId,
                'product': product,
              },
            );
          },
        ),
        GoRoute(
          path: '/home',
          builder: (BuildContext context, GoRouterState state) =>
              SupabaseHomeView(goRoute: (String path) => context.go(path)),
        ),
        GoRoute(
          path: '/categories',
          builder: (BuildContext context, GoRouterState state) =>
              CategoriesView(goRoute: (String path) => context.go(path)),
        ),
        GoRoute(
          path: '/cart',
          builder: (BuildContext context, GoRouterState state) =>
              CartView(goRoute: (String path) => context.go(path)),
        ),
        GoRoute(
          path: '/favorites',
          builder: (BuildContext context, GoRouterState state) =>
              FavoritesView(goRoute: (String path) => context.go(path)),
        ),
        GoRoute(
          path: '/profile',
          builder: (BuildContext context, GoRouterState state) =>
              ProfileView(goRoute: (String path) => context.go(path)),
        ),
        GoRoute(
          path: '/search',
          builder: (BuildContext context, GoRouterState state) =>
              SearchView(goRoute: (String path) => context.go(path)),
        ),
      ],
    ),
  ],
);
