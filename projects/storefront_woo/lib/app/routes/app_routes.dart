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

    // Search Page
    GoRoute(
      path: '/search',
      builder: (BuildContext context, GoRouterState state) {
        // Extract query parameters if available
        final Map<String, String> params = state.uri.queryParameters;
        final String? query = params['q'];

        return SearchView(
          goRoute: (String path) {
            // Simple navigation handling
            if (path.startsWith('/search')) {
              context.go(path); // Navigate to search with parameters
            } else if (path.startsWith('/home')) {
              context.go('/home'); // Navigate to home
            } else {
              context.go('/home'); // Default fallback to home
            }
          },
          title: const Text('Search Products'),
          searchHint: 'Search for products, categories...',
          initialHistory: const [],
          searchController: TextEditingController(text: query),
          // Focus on search field automatically if no query provided
          searchFocusNode: query == null || query.isEmpty ? FocusNode() : null,
          // Navigation handling
          showBackButton: true,
          onBackPressed: () => context.go('/home'),
          // Configure search providers
          searchSuggestionProvider: (q) async {
            // Mock suggestions, replace with actual API call
            await Future.delayed(const Duration(milliseconds: 300));
            return ['$q products', '$q categories', 'bestselling $q'];
          },
          searchProvider: (q) async {
            // Mock search results, replace with WooCommerce API call
            await Future.delayed(const Duration(milliseconds: 800));
            return [
              {'name': 'Product with $q', 'price': '29.99'},
              {'name': 'Another $q item', 'price': '19.99'},
              {'name': '$q Category'},
            ];
          },
          onSearchResult: (results) {
            debugPrint('📊 Search results received: ${results.length}');
          },
          // Custom actions for the app bar with search bar
          // These will be passed to OsmeaAppBarWithSearchBar internally
          actions: [
            AppBarWithSearchBarAction(
              icon: const Icon(Icons.notifications_none),
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Notifications')));
              },
              tooltip: 'Notifications',
            ),
          ],
        );
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
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to the search page
              context.go('/search');
            },
            tooltip: 'Search',
          ),
        ],
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
