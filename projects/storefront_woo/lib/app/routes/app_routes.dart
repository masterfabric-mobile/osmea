import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:storefront_woo/app/views/view_home/home_view.dart';
import 'package:storefront_woo/app/views/view_product_detail/product_detail_view.dart';
import 'package:storefront_woo/app/views/view_product_list/product_list_view.dart';
import 'package:storefront_woo/app/views/view_cart/cart_view.dart';
import 'package:storefront_woo/app/views/view_wishlist/wishlist_view.dart';
import 'package:storefront_woo/app/views/view_checkout/checkout_view.dart';
import 'package:storefront_woo/app/views/view_campaign/campaign_view.dart';
import 'package:storefront_woo/app/views/view_favorite_categories/favorite_categories_view.dart';
import 'package:storefront_woo/app/views/view_search/widgets/search_results_grid_widget.dart';
import 'package:storefront_woo/app/views/view_search/widgets/search_empty_state_widget.dart';
import 'package:storefront_woo/app/views/view_orders_history/orders_history_view.dart';
import 'package:storefront_woo/app/views/view_user_profile/user_profile_view.dart';
import 'package:storefront_woo/app/views/view_user_profile/addresses/user_addresses_sub_view.dart';
import 'package:storefront_woo/app/views/view_user_profile/settings/user_settings_sub_view.dart';
import 'package:storefront_woo/app/views/view_user_profile/metadata/user_metadata_sub_view.dart';
import 'package:storefront_woo/app/views/view_user_profile/preferences/user_preferences_sub_view.dart';
import 'package:storefront_woo/app/views/view_user_profile/contracts/user_contracts_sub_view.dart';
import 'package:storefront_woo/app/views/view_order_detail/order_detail_view.dart';
import 'package:storefront_woo/app/models/navbar_item_model.dart';
import 'package:storefront_woo/app/utils/navbar_icon_helper.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/abstract/product_service.dart';

import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';
import 'package:get_it/get_it.dart';
import 'package:apis/apis.dart';
import 'package:apis/dio_config/dio_client/api_dio_client.dart';
import 'package:apis/network/remote/woocommerce/auth/abstract/woo_auth_service.dart';
import 'package:apis/network/remote/woocommerce/users_manager/abstract/osmea_users_manager_service.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_addresses_response.dart';
// Unused import - commented out
// import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_orders_response.dart';

/// Handle campaign navigation - checks onboarding status and navigates accordingly
Future<void> _handleCampaignNavigation(BuildContext context) async {
  // Check user authentication status from AuthCubit (HydratedCubit state)
  // This ensures we use the persisted state, not just storage
  try {
    final authCubit = GetIt.I<AuthCubit>();
    final isAuthenticated =
        authCubit.state is AuthAuthenticatedState && authCubit.isAuthenticated;

    if (!context.mounted) return;

    if (isAuthenticated) {
      debugPrint(
        '👤 User already authenticated (from AuthCubit), navigating to home',
      );
      context.go('/home');
    } else {
      // User not authenticated, check onboarding status
      final onboardingHelper = OnboardingStorageHelper();
      final hasSeenOnboarding = await onboardingHelper.hasSeenOnboarding();

      // Check if onboarding is enabled in config
      final configHelper = AssetConfigHelper();
      final onboardingEnabled = configHelper.getBool(
        'feature_flags.onboarding_enabled',
        true,
      );

      if (!context.mounted) return;

      if (onboardingEnabled && !hasSeenOnboarding) {
        // First-time user, show onboarding
        debugPrint('📚 First-time user, navigating to onboarding');
        context.go('/onboarding');
      } else {
        // User has seen onboarding or onboarding is disabled, go to home
        debugPrint(
          '🏠 User has seen onboarding or onboarding disabled, navigating to home',
        );
        context.go('/home');
      }
    }
  } catch (e) {
    debugPrint('⚠️ Error checking AuthCubit/Onboarding state: $e');
    // Fallback: check onboarding status
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
        context.go('/onboarding');
      } else {
        context.go('/home');
      }
    } catch (e2) {
      debugPrint('⚠️ Error in fallback onboarding check: $e2');
      // Final fallback: go to home
      if (context.mounted) {
        context.go('/home');
      }
    }
  }
}

/// Custom ErrorHandlingView for route errors
/// Shows route-specific error messages using app_config.json configuration
class _RouteErrorHandlingView extends ErrorHandlingView {
  final String errorPath;
  final Exception? error;

  _RouteErrorHandlingView({
    required this.errorPath,
    this.error,
    required super.goRoute,
    super.onGoHome,
    super.onGoBack,
  }) : super(arguments: const {'routeError': true});

  @override
  Future<void> initialContent(viewModel, BuildContext context) async {
    debugPrint('🎯 Route Error Handling View Start!');
    debugPrint('📍 Error path: $errorPath');
    debugPrint('❌ Error: $error');

    // Load error handling config from app_config.json
    await viewModel.loadErrorHandlingConfig();

    // Show route error with custom message
    // Error message will be styled according to app_config.json configuration
    final errorMessage =
        'The route "$errorPath" could not be found. '
        'Please check the URL and try again.';

    await viewModel.showError(
      errorType: ErrorType.general,
      errorMessage: errorMessage,
      errorCode: 'ROUTE_NOT_FOUND',
    );
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false, // Disable debug route bar to prevent freezing
  // Deep linking support - redirect configuration
  redirect: (BuildContext context, GoRouterState state) {
    // Handle deep links and redirects here if needed
    // For now, return null to allow normal navigation
    return null;
  },
  // Error handling for deep links - uses ErrorHandlingView from core package
  errorBuilder: (BuildContext context, GoRouterState state) {
    debugPrint('⚠️ Route error: ${state.error} for path: ${state.uri.path}');

    // Use ErrorHandlingView from core package with app_config.json configuration
    return ErrorHandlingProvider(
      child: _RouteErrorHandlingView(
        errorPath: state.uri.path,
        error: state.error,
        goRoute: (String path) {
          if (path.contains('home') || path == '/home') {
            context.go('/home');
          } else {
            context.go(path);
          }
        },
        onGoHome: () => context.go('/home'),
        onGoBack: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/home');
          }
        },
      ),
    );
  },
  // Global route configuration
  routes: <RouteBase>[
    // Shell Route with Navbar for main app sections
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        // Get navbar widget - always returns navbar if route should show it (config'de olsa da olmasa da)
        final navbar = _getNavbarForRoute(state.uri.path, null);

        return _AppShellWithMiniCart(
          child: child,
          navbar: navbar,
          currentPath: state.uri.path,
          routeExtra: null,
        );
      },
      routes: [
        // Home Page - Show products directly
        GoRoute(
          path: '/home',
          pageBuilder: (BuildContext context, GoRouterState state) {
            // Extract route extra for navbar control
            final routeExtra = state.extra as Map<String, dynamic>?;
            final arguments = {
              'home': true,
              'showNavbar': routeExtra?['showNavbar'] ?? true,
              ...?routeExtra,
            };

            return CustomTransitionPage(
              child: HomeView(
                arguments: arguments,
                goRoute: (String path) {
                  if (path.contains('products')) {
                    context.go('/products');
                  } else if (path.contains('product-detail')) {
                    context.go('/product-detail');
                  } else if (path.contains('cart')) {
                    context.go('/cart');
                  } else {
                    context.go('/home');
                  }
                },
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(milliseconds: 300),
            );
          },
        ),

        // Saved Page
        GoRoute(
          path: '/saved',
          pageBuilder: (BuildContext context, GoRouterState state) {
            // Extract route extra for navbar control
            final routeExtra = state.extra as Map<String, dynamic>?;
            final arguments = {
              'saved': true,
              'showNavbar': routeExtra?['showNavbar'] ?? true,
              ...?routeExtra,
            };

            return CustomTransitionPage(
              child: WishlistView(
                goRoute: (String path) {
                  if (path.contains('home')) {
                    context.go('/home');
                  } else {
                    context.go('/saved');
                  }
                },
                arguments: arguments,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0.0, 1.0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOutCubic,
                            ),
                          ),
                      child: child,
                    );
                  },
              transitionDuration: const Duration(milliseconds: 400),
            );
          },
        ),

        // Search Page
        GoRoute(
          path: '/search',
          pageBuilder: (BuildContext context, GoRouterState state) {
            // Create focus node for auto-focusing search input
            final searchFocusNode = FocusNode();

            // Extract query and fromHome flag from URL if present
            final query = state.uri.queryParameters['query'];
            final fromHome = state.uri.queryParameters['fromHome'] == 'true';
            // Note: Search route shows navbar by default (it's a main navigation item)
            // Navbar visibility is controlled by _getNavbarForRoute based on route path

            return CustomTransitionPage(
              child: _AutoFocusSearchView(
                searchFocusNode: searchFocusNode,
                initialQuery: query,
                fromHome: fromHome,
                goRoute: (String path) {
                  if (path.contains('home')) {
                    context.go('/home');
                  } else if (path.contains('cart')) {
                    context.go('/cart');
                  } else if (path.contains('product-detail')) {
                    context.go('/product-detail');
                  } else {
                    context.go('/home');
                  }
                },
                searchProvider: (query) async {
                  try {
                    final productService = GetIt.I<ProductService>();
                    final products = await productService.listAllProducts(
                      apiVersion: 'v1',
                      search: query,
                      page: 1,
                      perPage: 20,
                    );
                    debugPrint(
                      '🔍 Found ${products.length} products for query: $query',
                    );
                    return products;
                  } catch (e) {
                    debugPrint('❌ Search error: $e');
                    return [];
                  }
                },
                // No local search history suggestions.
                // (User requested: don't show past searches.)
                searchSuggestionProvider: null,
                initialHistory: const [],
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Smooth fade transition that feels like no transition
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(milliseconds: 150),
            );
          },
        ),

        // Cart Page
        GoRoute(
          path: '/cart',
          pageBuilder: (BuildContext context, GoRouterState state) {
            // Get cart token from extra (route params) or use default
            final extra = state.extra as Map<String, dynamic>?;
            final arguments = {
              'cart': true,
              'showNavbar': extra?['showNavbar'] ?? true,
              if (extra != null && extra.containsKey('cartToken'))
                'cartToken': extra['cartToken'] as String?,
            };
            return CustomTransitionPage(
              child: CartView(
                arguments: arguments,
                goRoute: (String path) {
                  if (path.contains('home')) {
                    context.go('/home');
                  } else if (path.contains('product-detail')) {
                    context.go('/product-detail');
                  } else {
                    context.go('/home');
                  }
                },
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOutCubic,
                            ),
                          ),
                      child: child,
                    );
                  },
              transitionDuration: const Duration(milliseconds: 400),
            );
          },
        ),

        // Products List Page
        GoRoute(
          path: '/products',
          pageBuilder: (BuildContext context, GoRouterState state) {
            // Parse query parameters
            final queryParams = state.uri.queryParameters;
            final routeExtra = state.extra as Map<String, dynamic>?;
            final arguments = <String, dynamic>{
              'products': true,
              'showNavbar': routeExtra?['showNavbar'] ?? true,
            };

            // Add category_id from query parameters if present
            if (queryParams.containsKey('category_id')) {
              final categoryIdStr = queryParams['category_id'];
              if (categoryIdStr != null) {
                final categoryId = int.tryParse(categoryIdStr);
                if (categoryId != null) {
                  arguments['category_id'] = categoryId;
                }
              }
            }

            return CustomTransitionPage(
              child: ProductListView(
                arguments: arguments,
                goRoute: (String path) {
                  if (path.contains('home')) {
                    context.go('/home');
                  } else if (path.contains('product-detail')) {
                    context.go('/product-detail');
                  } else if (path.contains('cart')) {
                    context.go('/cart');
                  } else {
                    context.go('/home');
                  }
                },
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOutCubic,
                            ),
                          ),
                      child: child,
                    );
                  },
              transitionDuration: const Duration(milliseconds: 400),
            );
          },
        ),

        // Favorite Categories Route
        GoRoute(
          path: '/favorite-categories',
          pageBuilder: (BuildContext context, GoRouterState state) {
            // Extract route extra for navbar control
            final routeExtra = state.extra as Map<String, dynamic>?;
            final arguments = {
              'favorite_categories': true,
              'showNavbar': routeExtra?['showNavbar'] ?? true,
              ...?routeExtra,
            };

            return CustomTransitionPage(
              child: FavoriteCategoriesView(
                arguments: arguments,
                goRoute: (String path) {
                  if (path.contains('home')) {
                    context.go('/home');
                  } else if (path.contains('products')) {
                    context.go(path);
                  } else {
                    context.go('/favorite-categories');
                  }
                },
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(milliseconds: 300),
            );
          },
        ),

        // Profile Route (using AccountView from core package)
        GoRoute(
          path: '/profile',
          pageBuilder: (BuildContext context, GoRouterState state) {
            // Get AccountCubit and AuthCubit for platform-specific auth state listening
            final accountCubit = GetIt.I<AccountCubit>();
            final authCubit = GetIt.I<AuthCubit>();

            // Load user API data and set it to AccountCubit
            // This ensures profile data is always fresh (user can update their info)
            _loadUserApiData(accountCubit);

            // Extract route extra for navbar control
            final routeExtra = state.extra as Map<String, dynamic>?;
            final arguments = {
              'account': true,
              'showNavbar': routeExtra?['showNavbar'] ?? true,
              ...?routeExtra,
            };

            return CustomTransitionPage(
              child: BlocListener<AuthCubit, AuthState>(
                bloc: authCubit,
                listener: (context, authState) {
                  // If AuthCubit becomes authenticated, refresh profile data
                  if (authState is AuthAuthenticatedState) {
                    debugPrint(
                      '👤 Route: AuthCubit authenticated, refreshing profile...',
                    );
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      // Reload user API data and refresh profile
                      _loadUserApiData(accountCubit);
                      accountCubit.refreshProfile();
                    });
                  }
                },
                child: AccountView(
                  arguments: arguments,
                  goRoute: (String path) {
                    debugPrint(
                      '🔀 AccountView: goRoute called with path: $path',
                    );
                    if (path.contains('home') || path == '/home') {
                      debugPrint('🔀 AccountView: Navigating to /home');
                      context.go('/home');
                    } else if (path.contains('cart') || path == '/cart') {
                      debugPrint('🔀 AccountView: Navigating to /cart');
                      context.go('/cart');
                    } else if (path.contains('saved') || path == '/saved') {
                      debugPrint('🔀 AccountView: Navigating to /saved');
                      context.go('/saved');
                    } else if (path.contains('auth') || path == '/auth') {
                      debugPrint('🔀 AccountView: Navigating to /auth');
                      context.go('/auth');
                    } else {
                      debugPrint('🔀 AccountView: Navigating to path: $path');
                      context.go(path);
                    }
                  },
                  onSignOut: () async {
                    // Capture router instance early so we can navigate even if the
                    // original BuildContext becomes unmounted during async cleanup.
                    final router = GoRouter.of(context);

                    // AccountCubit handles its own state clearing
                    // Platform-specific cleanup is provided via callback
                    await accountCubit.signOut(
                      onSignOut: () async {
                        // Platform-specific cleanup: cookies, wishlist, cart tokens, Woo JWT
                        //
                        // NOTE: Do NOT call AuthCubit.signOut() here.
                        // Core AccountWidget already signs out AuthCubit as part of the
                        // comprehensive sign-out flow. Calling it here can cause duplicate
                        // state transitions and intermittent navigation issues.
                        debugPrint(
                          '🚪 Route: Starting platform-specific cleanup...',
                        );

                        // Step 1: Clear WooCommerce JWT token
                        try {
                          await WooJwtTokenStorage.clearToken();
                          debugPrint('✅ Route: WooJWT token cleared');
                        } catch (e) {
                          debugPrint(
                            '⚠️ Route: Failed to clear WooJWT token: $e',
                          );
                        }

                        // Step 2: Clear cart token
                        try {
                          await WooCartTokenStorage.clearCartToken();
                          debugPrint('✅ Route: WooCartToken cleared');
                        } catch (e) {
                          debugPrint(
                            '⚠️ Route: Failed to clear WooCartToken: $e',
                          );
                        }

                        // Step 3: Clear all cookies (WP cookies: wordpress_logged_in_, woocommerce_items_in_cart, wp_woocommerce_session_)
                        try {
                          await ApiDioClient.clearAllCookies();
                          debugPrint(
                            '✅ Route: All cookies cleared (including WP cookies)',
                          );
                        } catch (e) {
                          debugPrint('⚠️ Route: Failed to clear cookies: $e');
                        }

                        // Step 4: Clear wishlist (user-specific data)
                        try {
                          final wishlistViewModel =
                              GetIt.I<WishlistViewModel>();
                          await wishlistViewModel.clearAll();
                          debugPrint('✅ Route: Wishlist cleared');
                        } catch (e) {
                          debugPrint('⚠️ Route: Failed to clear wishlist: $e');
                        }

                        debugPrint(
                          '✅ Route: Platform-specific cleanup completed',
                        );
                      },
                    );

                    // Navigate to home after sign out.
                    debugPrint(
                      '🔀 Route: Navigating to /home after sign out...',
                    );
                    router.go('/home');
                    debugPrint('✅ Route: Navigation to /home completed');
                  },
                ),
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(milliseconds: 300),
            );
          },
        ),

        // About Route
        GoRoute(
          path: '/about',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage(
              child: AboutView(
                goRoute: (String path) {
                  debugPrint('🔀 AboutView: goRoute called with path: $path');
                  context.go(path);
                },
                // AboutView will load configuration from app_config.json internally
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(milliseconds: 300),
            );
          },
        ),

        // Contact Us Route
        GoRoute(
          path: '/contact-us',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage(
              child: ContactUsView(
                goRoute: (String path) {
                  debugPrint(
                    '🔀 ContactUsView: goRoute called with path: $path',
                  );
                  context.go(path);
                },
                // ContactUsView will load configuration from app_config.json internally
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(milliseconds: 300),
            );
          },
        ),

        // FAQ Route
        GoRoute(
          path: '/faq',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage(
              child: FAQView(
                goRoute: (String path) {
                  debugPrint('🔀 FAQView: goRoute called with path: $path');
                  context.go(path);
                },
                // FAQView will load configuration from app_config.json internally
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(milliseconds: 300),
            );
          },
        ),

        // Orders History Route
        GoRoute(
          path: '/orders-history',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage(
              child: OrdersHistoryView(
                arguments: const {'orders_history': true},
                goRoute: (String path) {
                  debugPrint(
                    '🔀 OrdersHistoryView: goRoute called with path: $path',
                  );
                  if (path.contains('profile') || path == '/profile') {
                    context.go('/profile');
                  } else {
                    context.go(path);
                  }
                },
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(milliseconds: 300),
            );
          },
        ),

        // User Profile Route
        GoRoute(
          path: '/user-profile',
          pageBuilder: (BuildContext context, GoRouterState state) {
            final routeExtra = state.extra as Map<String, dynamic>?;
            final arguments = {
              'user_profile': true,
              'showNavbar':
                  routeExtra?['showNavbar'] ??
                  true, // Navbar shown on all pages
              ...?routeExtra,
            };

            return CustomTransitionPage(
              child: UserProfileView(
                arguments: arguments,
                goRoute: (String path) {
                  debugPrint(
                    '🔀 UserProfileView: goRoute called with path: $path',
                  );
                  if (path.contains('profile') || path == '/profile') {
                    context.go('/profile');
                  } else {
                    context.go(path);
                  }
                },
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(milliseconds: 300),
            );
          },
          routes: [
            // User Addresses Route
            GoRoute(
              path: 'addresses',
              pageBuilder: (BuildContext context, GoRouterState state) {
                final routeExtra = state.extra as Map<String, dynamic>?;
                final arguments = {
                  'addresses': true,
                  'showNavbar':
                      routeExtra?['showNavbar'] ??
                      true, // Navbar shown on all pages
                  ...?routeExtra,
                };

                return CustomTransitionPage(
                  child: UserAddressesView(
                    arguments: arguments,
                    goRoute: (String path) {
                      context.go(path);
                    },
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                  transitionDuration: const Duration(milliseconds: 300),
                );
              },
            ),
            // User Settings Route
            GoRoute(
              path: 'settings',
              pageBuilder: (BuildContext context, GoRouterState state) {
                final routeExtra = state.extra as Map<String, dynamic>?;
                final arguments = {
                  'settings': true,
                  'showNavbar':
                      routeExtra?['showNavbar'] ??
                      true, // Navbar shown on all pages
                  ...?routeExtra,
                };

                return CustomTransitionPage(
                  child: UserSettingsView(
                    arguments: arguments,
                    goRoute: (String path) {
                      context.go(path);
                    },
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                  transitionDuration: const Duration(milliseconds: 300),
                );
              },
            ),
            // User Metadata Route
            GoRoute(
              path: 'metadata',
              pageBuilder: (BuildContext context, GoRouterState state) {
                final routeExtra = state.extra as Map<String, dynamic>?;
                final arguments = {
                  'metadata': true,
                  'showNavbar':
                      routeExtra?['showNavbar'] ??
                      true, // Navbar shown on all pages
                  ...?routeExtra,
                };

                return CustomTransitionPage(
                  child: UserMetadataView(
                    arguments: arguments,
                    goRoute: (String path) {
                      context.go(path);
                    },
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                  transitionDuration: const Duration(milliseconds: 300),
                );
              },
            ),
            // User Preferences Route
            GoRoute(
              path: 'preferences',
              pageBuilder: (BuildContext context, GoRouterState state) {
                final routeExtra = state.extra as Map<String, dynamic>?;
                final arguments = {
                  'preferences': true,
                  'showNavbar':
                      routeExtra?['showNavbar'] ??
                      true, // Navbar shown on all pages
                  ...?routeExtra,
                };

                return CustomTransitionPage(
                  child: UserPreferencesView(
                    arguments: arguments,
                    goRoute: (String path) {
                      context.go(path);
                    },
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                  transitionDuration: const Duration(milliseconds: 300),
                );
              },
            ),
            // User Contracts Route
            GoRoute(
              path: 'contracts',
              pageBuilder: (BuildContext context, GoRouterState state) {
                final routeExtra = state.extra as Map<String, dynamic>?;
                final arguments = {
                  'contracts': true,
                  'showNavbar':
                      routeExtra?['showNavbar'] ??
                      true, // Navbar shown on all pages
                  ...?routeExtra,
                };

                return CustomTransitionPage(
                  child: UserContractsView(
                    arguments: arguments,
                    goRoute: (String path) {
                      context.go(path);
                    },
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                  transitionDuration: const Duration(milliseconds: 300),
                );
              },
            ),
          ],
        ),

        // Order Detail Route
        GoRoute(
          path: '/order-detail/:orderId',
          pageBuilder: (BuildContext context, GoRouterState state) {
            final orderId =
                int.tryParse(state.pathParameters['orderId'] ?? '0') ?? 0;
            final routeExtra = state.extra as Map<String, dynamic>?;
            final arguments = {
              'order_detail': true,
              'orderId': orderId,
              'showNavbar':
                  routeExtra?['showNavbar'] ??
                  true, // Navbar shown on all pages
              ...?routeExtra,
            };

            return CustomTransitionPage(
              child: OrderDetailView(
                arguments: arguments,
                goRoute: (String path) {
                  debugPrint(
                    '🔀 OrderDetailView: goRoute called with path: $path',
                  );
                  if (path.contains('orders-history') ||
                      path == '/orders-history') {
                    context.go('/orders-history');
                  } else {
                    context.go(path);
                  }
                },
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(milliseconds: 300),
            );
          },
        ),

        // Product Detail Route
        GoRoute(
          path: '/product-detail/:productId',
          pageBuilder: (BuildContext context, GoRouterState state) {
            final productId = int.tryParse(
              state.pathParameters['productId'] ?? '0',
            );
            // Get cart token from extra (route params) or use default
            final extra = state.extra as Map<String, dynamic>?;
            final arguments = {
              'productDetail': true,
              'showNavbar':
                  extra?['showNavbar'] ?? true, // Navbar shown on all pages
              if (extra != null && extra.containsKey('cartToken'))
                'cartToken': extra['cartToken'] as String?,
            };
            return CustomTransitionPage(
              child: ProductDetailView(
                productId: productId ?? 0,
                arguments: arguments,
                goRoute: (String path) {
                  if (path.contains('home')) {
                    context.go('/home');
                  } else {
                    context.go('/home');
                  }
                },
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return ScaleTransition(
                      scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOutBack,
                        ),
                      ),
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
              transitionDuration: const Duration(milliseconds: 500),
            );
          },
        ),

        // Checkout Route
        GoRoute(
          path: '/checkout',
          pageBuilder: (BuildContext context, GoRouterState state) {
            final extra = state.extra as Map<String, dynamic>?;
            final arguments = {
              'checkout': true,
              'showNavbar':
                  extra?['showNavbar'] ?? true, // Navbar shown on all pages
              if (extra != null) ...extra,
            };
            return CustomTransitionPage(
              child: CheckoutView(
                arguments: arguments,
                goRoute: (String path) {
                  if (path.contains('home')) {
                    context.go('/home');
                  } else if (path.contains('cart')) {
                    context.go('/cart');
                  } else {
                    context.go('/home');
                  }
                },
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0.0, 1.0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOutCubic,
                            ),
                          ),
                      child: child,
                    );
                  },
              transitionDuration: const Duration(milliseconds: 400),
            );
          },
        ),

        // Empty View Route
        GoRoute(
          path: '/empty/:emptyType',
          pageBuilder: (BuildContext context, GoRouterState state) {
            final emptyTypeStr = state.pathParameters['emptyType'] ?? 'general';
            final emptyType = EmptyType.values.firstWhere(
              (type) => type.name == emptyTypeStr,
              orElse: () => EmptyType.general,
            );

            // Get custom parameters from query
            final queryParams = state.uri.queryParameters;
            final customTitle = queryParams['title'];
            final customDescription = queryParams['description'];
            final customImagePath = queryParams['imagePath'];
            final customIconPath = queryParams['iconPath'];
            final actionPath = queryParams['actionPath'] ?? '/home';

            return CustomTransitionPage(
              child: EmptyView(
                goRoute: (String path) {
                  if (path.contains('home')) {
                    context.go('/home');
                  } else if (path.contains('cart')) {
                    context.go('/cart');
                  } else if (path.contains('saved')) {
                    context.go('/saved');
                  } else {
                    context.go(path);
                  }
                },
                emptyType: emptyType,
                customTitle: customTitle,
                customDescription: customDescription,
                customImagePath: customImagePath,
                customIconPath: customIconPath,
                onActionPressed: () {
                  context.go(actionPath);
                },
                arguments: {'emptyView': true, 'emptyType': emptyTypeStr},
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(milliseconds: 300),
            );
          },
        ),

        // Loading View Route
        GoRoute(
          path: '/loading/:loadingType',
          pageBuilder: (BuildContext context, GoRouterState state) {
            final loadingTypeStr =
                state.pathParameters['loadingType'] ?? 'general';
            final loadingType = LoadingModelType.values.firstWhere(
              (type) => type.name == loadingTypeStr,
              orElse: () => LoadingModelType.general,
            );

            // Get custom parameters from query
            final queryParams = state.uri.queryParameters;
            final customTitle = queryParams['title'];
            final customDescription = queryParams['description'];
            final targetRoute = queryParams['targetRoute'];

            return CustomTransitionPage(
              child: LoadingView(
                goRoute: (String path) {
                  if (path.contains('home')) {
                    context.go('/home');
                  } else if (path.contains('cart')) {
                    context.go('/cart');
                  } else if (path.contains('saved')) {
                    context.go('/saved');
                  } else {
                    context.go(path);
                  }
                },
                loadingType: loadingType,
                loadingPageModel:
                    customTitle != null || customDescription != null
                    ? LoadingPageModel(
                        title: customTitle ?? 'Loading...',
                        description: customDescription ?? 'Please wait',
                        loadingType: loadingType,
                        autoNavigateOnComplete: targetRoute != null,
                        targetRoute: targetRoute,
                      )
                    : null,
                onCompleted: targetRoute != null
                    ? () {
                        // Navigate to target route when loading completes
                        context.go(targetRoute);
                      }
                    : null,
                arguments: {'loadingView': true, 'loadingType': loadingTypeStr},
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(milliseconds: 300),
            );
          },
        ),
      ],
    ),

    // Splash Screen Route
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return SplashView(
          goRoute: (String path) {
            // After splash, navigate to campaign screen first
            // Campaign screen will then check onboarding and navigate accordingly
            debugPrint('🎯 Splash completed, navigating to campaign screen');
            context.go('/campaign');
          },
        );
      },
    ),

    // Campaign Screen Route - Shows campaign images for 1.5 seconds then navigates to onboarding or home
    GoRoute(
      path: '/campaign',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return CustomTransitionPage(
          child: CampaignView(
            goRoute: (String path) {
              // Async navigation logic - check onboarding status and navigate accordingly
              _handleCampaignNavigation(context);
            },
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
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
            } else if (path.contains(Routes.signIn.name)) {
              context.go('/auth');
            } else {
              context.go('/home'); // Default to home (guest mode)
            }
          },
          onCompleted: () {
            debugPrint('🎉 Onboarding completed! Going to home (guest mode)');
            context.go('/home');
          },
          onSkipped: () {
            debugPrint('⏭️ Onboarding skipped! Going to home (guest mode)');
            context.go('/home');
          },
          onError: (error) {
            debugPrint('❌ Onboarding error: $error, going to home anyway');
            context.go('/home');
          },
        );
      },
    ),

    // Auth Route (Combined Sign In + Sign Up with TabBar)
    GoRoute(
      path: '/auth',
      builder: (BuildContext context, GoRouterState state) {
        // Get initial tab from query parameter (0 = Sign In, 1 = Sign Up)
        final initialTab =
            int.tryParse(state.uri.queryParameters['tab'] ?? '0') ?? 0;

        // Get auth manager (APIs package)
        final authManager = GetIt.I<WooAuthManager>();

        return AuthView(
          goRoute: (String path) {
            debugPrint('🔀 AuthView: goRoute called with path: $path');
            if (path.contains('home') || path == '/home') {
              debugPrint('🔀 AuthView: Navigating to /home');
              context.go('/home');
            } else if (path.contains('profile') || path == '/profile') {
              debugPrint('🔀 AuthView: Navigating to /profile');
              context.go('/profile');
            } else {
              debugPrint('🔀 AuthView: Navigating to path: $path');
              context.go(path);
            }
          },
          initialTab: initialTab,
          defaultRedirectPath: '/home',
          onSignInSuccess: () {
            debugPrint('✅ Sign in successful! Navigating to /home');
            context.go('/home');
          },
          onSignInError: (String error) {
            debugPrint('❌ Sign in error: $error');
            // Show error snackbar to user
            context.snackbarError(
              'Password or email is incorrect,please try again',
              duration: const Duration(seconds: 3),
            );
          },
          onSignUpError: (String error) {
            debugPrint('❌ Sign up error: $error');
            // Show error snackbar to user
            context.snackbarError(error, duration: const Duration(seconds: 3));
          },
          onForgotPasswordTap: () {
            context.push('/auth/forgot-password');
          },
          arguments: {
            'auth': true,
            'onSignIn': (String email, String password, {bool? rememberMe}) async {
              final result = await authManager.login(
                email: email,
                password: password,
              );
              // rememberMe parameter is available here for future use if needed
              if (rememberMe != null) {
                debugPrint('💾 Remember me preference: $rememberMe');
              }
              return result.isSuccess;
            },
            'onSignInSuccessTokenLoad': (AuthCubit authCubit) async {
              final jwtToken = await WooJwtTokenStorage.loadToken();
              if (jwtToken != null) {
                // Extract user data - check if it exists and has content
                Map<String, dynamic> userData;
                if (jwtToken.userData != null &&
                    jwtToken.userData!.isNotEmpty) {
                  userData = Map<String, dynamic>.from(jwtToken.userData!);
                  debugPrint(
                    '✅ User data found in JWT token: ${userData.keys.toList()}',
                  );
                  debugPrint('📧 Email in userData: ${userData['email']}');
                } else {
                  debugPrint('⚠️ No user data in JWT token');
                  userData = {};
                }

                // Ensure email is in userData (it should be from UserInfo)
                // Email might be null in UserInfo, so we need to ensure it's set
                final emailValue = userData['email'];
                if (emailValue == null ||
                    (emailValue is String && emailValue.isEmpty)) {
                  debugPrint('⚠️ Email not found in userData');

                  // Priority 1: Try to get email from login form (signInEmail)
                  // This is the email the user entered during login
                  String? loginEmail;
                  try {
                    final formState = authCubit.state;
                    if (formState is AuthFormState &&
                        formState.signInEmail.isNotEmpty) {
                      loginEmail = formState.signInEmail;
                      debugPrint('📧 Email from login form: $loginEmail');
                    }
                  } catch (e) {
                    debugPrint('⚠️ Error getting email from formState: $e');
                  }

                  // Priority 2: Try to get email from JWT token's userData
                  if (loginEmail == null || loginEmail.isEmpty) {
                    if (jwtToken.userData != null &&
                        jwtToken.userData!['email'] != null) {
                      loginEmail = jwtToken.userData!['email'] as String?;
                      debugPrint(
                        '📧 Email from JWT token userData: $loginEmail',
                      );
                    }
                  }

                  // Priority 3: Try to get email from AuthCubit userData (if already saved)
                  if (loginEmail == null || loginEmail.isEmpty) {
                    try {
                      final authUserData = authCubit.userData;
                      if (authUserData != null &&
                          authUserData['email'] != null) {
                        loginEmail = authUserData['email'] as String?;
                        debugPrint(
                          '📧 Email from AuthCubit userData: $loginEmail',
                        );
                      }
                    } catch (e) {
                      debugPrint('⚠️ Error getting email from AuthCubit: $e');
                    }
                  }

                  // Set email in userData if found
                  if (loginEmail != null && loginEmail.isNotEmpty) {
                    userData['email'] = loginEmail;
                    debugPrint('✅ Email set in userData: ${userData['email']}');
                  } else {
                    debugPrint('⚠️ Email not found from any source');
                  }
                } else {
                  debugPrint(
                    '✅ Email already in userData: ${userData['email']}',
                  );
                }

                // Prepare metadata with JWT token info
                Map<String, dynamic> metadata = {
                  'woo_jwt_token': jwtToken.toJson(),
                };

                // Call getUsersMe API to get full user information
                try {
                  debugPrint('👤 Calling getUsersMe API...');
                  final authService = GetIt.I<WooAuthService>();
                  final authHeader = 'Bearer ${jwtToken.accessToken}';

                  final userMeResponse = await authService.getUsersMe(
                    authHeader,
                  );
                  debugPrint('✅ getUsersMe API call successful');
                  debugPrint(
                    '👤 User ID: ${userMeResponse.id}, Name: ${userMeResponse.name}',
                  );

                  // Add getUsersMe response to metadata
                  // IMPORTANT: Store name as-is from getUsersMe, do NOT combine firstName + lastName
                  metadata['get_users_me'] = {
                    'id': userMeResponse.id,
                    'name': userMeResponse.name,
                    'url': userMeResponse.url,
                    'description': userMeResponse.description,
                    'link': userMeResponse.link,
                    'slug': userMeResponse.slug,
                    'avatar_urls': userMeResponse.avatarUrls?.toJson(),
                    'is_super_admin': userMeResponse.isSuperAdmin,
                    'woocommerce_meta': userMeResponse.woocommerceMeta
                        ?.toJson(),
                  };
                  debugPrint(
                    '👤 Stored getUsersMe name in metadata: "${userMeResponse.name}"',
                  );

                  // Also merge user data from getUsersMe response if available
                  if (userMeResponse.name != null ||
                      userMeResponse.slug != null) {
                    // userData is already initialized above, no need for ??=
                    if (userMeResponse.name != null) {
                      userData['name'] = userMeResponse.name;
                      userData['display_name'] = userMeResponse.name;
                    }
                    if (userMeResponse.id != null) {
                      userData['id'] = userMeResponse.id;
                    }
                    if (userMeResponse.slug != null) {
                      userData['slug'] = userMeResponse.slug;
                      userData['username'] =
                          userMeResponse.slug; // Add username field
                    }
                  }

                  debugPrint('✅ getUsersMe data added to metadata');
                } catch (e) {
                  debugPrint('⚠️ Error calling getUsersMe API: $e');
                  // Don't block login if getUsersMe fails
                  // Continue with login process
                }

                await authCubit.saveJwtToken(
                  jwtToken: jwtToken.accessToken,
                  userData: userData,
                  metadata: metadata,
                );
                debugPrint('✅ JWT token and user data saved to AuthCubit');

                // Sync local wishlist to server after successful login
                // Logic is handled in WishlistViewModel, not in route file
                try {
                  final wishlistViewModel = GetIt.I<WishlistViewModel>();
                  await wishlistViewModel.syncLocalItemsAfterLogin();
                } catch (e) {
                  debugPrint('⚠️ Error syncing wishlist after login: $e');
                  // Don't block login if wishlist sync fails
                }

                // Load and cache user addresses after successful login
                // This prevents slow API calls every time addresses are needed
                // Note: We wait a bit after login to ensure backend has processed the user data
                try {
                  // Wait a short time for backend to process user data after login
                  await Future.delayed(const Duration(milliseconds: 500));

                  debugPrint(
                    '📍 [ADDRESS CACHE] Loading user addresses for caching...',
                  );
                  final usersManagerService =
                      GetIt.I<OsmeaUsersManagerService>();

                  // Try to fetch addresses with retry mechanism
                  GetUserAddressesResponse? addressesResponse;
                  int retryCount = 0;
                  const maxRetries = 2;

                  while (retryCount <= maxRetries) {
                    try {
                      addressesResponse = await usersManagerService
                          .getUserAddresses();
                      debugPrint(
                        '📍 [ADDRESS CACHE] API Response: ${addressesResponse.addresses.length} addresses received',
                      );

                      // If we got addresses (even if 0), cache them
                      // But if we got 0 and it's the first try, wait and retry once
                      if (addressesResponse.addresses.isNotEmpty ||
                          retryCount > 0) {
                        break; // Success or already retried
                      }

                      // If 0 addresses on first try, wait and retry
                      if (retryCount == 0 &&
                          addressesResponse.addresses.isEmpty) {
                        debugPrint(
                          '⚠️ [ADDRESS CACHE] Got 0 addresses on first try, waiting 1 second and retrying...',
                        );
                        await Future.delayed(const Duration(seconds: 1));
                        retryCount++;
                        continue;
                      }
                    } catch (e) {
                      debugPrint(
                        '⚠️ [ADDRESS CACHE] Error fetching addresses (attempt ${retryCount + 1}): $e',
                      );
                      if (retryCount < maxRetries) {
                        await Future.delayed(
                          Duration(milliseconds: 500 * (retryCount + 1)),
                        );
                        retryCount++;
                        continue;
                      }
                      rethrow;
                    }
                    break;
                  }

                  if (addressesResponse != null) {
                    // Cache addresses in local storage
                    final storage = LocalStorageHelper();
                    final addressesJson = jsonEncode(
                      addressesResponse.addresses
                          .map((addr) => addr.toJson())
                          .toList(),
                    );
                    await storage.setItem(
                      'user_addresses_cache',
                      addressesJson,
                    );
                    final timestamp = DateTime.now().toIso8601String();
                    await storage.setItem(
                      'user_addresses_cache_timestamp',
                      timestamp,
                    );

                    debugPrint(
                      '✅ [ADDRESS CACHE] User addresses cached successfully',
                    );
                    debugPrint(
                      '   📦 Cached ${addressesResponse.addresses.length} addresses',
                    );
                    debugPrint('   🕐 Cache timestamp: $timestamp');
                    debugPrint('   💾 Cache key: user_addresses_cache');
                  }

                  // Cache order addresses in background (this is slow, so don't block login)
                  // Order addresses will be loaded from cache when user visits addresses page
                  _cacheOrdersInBackground(usersManagerService);
                } catch (e, stackTrace) {
                  debugPrint(
                    '❌ [ADDRESS CACHE] Error caching user addresses after login: $e',
                  );
                  debugPrint('   Stack trace: $stackTrace');
                  // Don't block login if address caching fails
                  // Addresses will be loaded when user visits the addresses page
                }
              } else {
                debugPrint('⚠️ No JWT token found in storage');
              }
            },
            'onSignUp':
                (
                  String email,
                  String password,
                  String firstName,
                  String lastName,
                  bool marketingConsent,
                ) async {
                  try {
                    // Get auth key from config
                    final configHelper = AssetConfigHelper();
                    // TODO: Fix config loading - loadConfigWithPlatform and AppConfigPaths are undefined
                    // final loaded = await configHelper.loadConfigWithPlatform(
                    //   AppConfigPaths.baseConfigPath,
                    // );

                    // debugPrint('📁 Config load result: $loaded');
                    // debugPrint(
                    //   '📁 Config path: ${configHelper.getCurrentConfigPath()}',
                    // );

                    // final allConfig = configHelper.getAllConfig();
                    // debugPrint('📊 Config keys: ${allConfig?.keys.toList()}');

                    // Simple direct config read
                    final authKey = configHelper.getString(
                      'woocommerce_configuration.auth_key',
                    );

                    debugPrint('📞 Calling authManager.signUp...');
                    final result = await authManager.signUp(
                      email: email,
                      password: password,
                      authKey: authKey,
                      firstName: firstName,
                      lastName: lastName,
                      acceptTerms: true,
                      subscribeNewsletter: marketingConsent,
                    );

                    debugPrint(
                      '📞 authManager.signUp returned: isSuccess=${result.isSuccess}',
                    );
                    debugPrint('📞 Result message: ${result.message}');
                    debugPrint('📞 Result error: ${result.error}');

                    // After successful sign up, trigger sign in through AuthCubit
                    // This will properly handle token loading and state management
                    if (result.isSuccess) {
                      debugPrint(
                        '✅ Sign up successful, storing credentials for auto sign-in...',
                      );
                      // Store the credentials temporarily so AuthCubit.signIn can use them
                      // We'll trigger signIn after this callback returns true
                      return true;
                    } else {
                      debugPrint('❌ Sign up failed: ${result.message}');
                      return false;
                    }
                  } catch (e, stackTrace) {
                    debugPrint('❌ Sign up error in callback: $e');
                    debugPrint('❌ Stack trace: $stackTrace');
                    return false;
                  }
                },
          },
        );
      },
    ),

    // Forgot Password (full-page from core, config from app_config.json)
    GoRoute(
      path: '/auth/forgot-password',
      builder: (BuildContext context, GoRouterState state) {
        final authManager = GetIt.I<WooAuthManager>();
        final configHelper = AssetConfigHelper();
        final authConfig = configHelper.getObject('auth_configuration');
        final config = authConfig is Map<String, dynamic> ? authConfig : null;
        return ForgotPasswordView(
          config: config,
          goRoute: (String path) {
            if (path == '/auth' || path.contains('auth')) {
              context.pop();
            } else {
              context.go(path);
            }
          },
          onSendResetEmail: (String email) async {
            final result = await authManager.sendResetPassword(email: email);
            if (!context.mounted) return false;
            if (result.isSuccess) {
              if (context.mounted) {
                context.snackbarSuccess(
                  result.message,
                  title: 'Reset link sent',
                  duration: const Duration(seconds: 4),
                );
              }
              return true;
            }
            throw Exception(result.message);
          },
          onBack: () => context.pop(),
        );
      },
    ),
  ],
);

/// Cache user orders in background after login
/// This caches orders which can be used to extract addresses and for other purposes
/// Note: This is a slow operation (many API calls), so it runs in background
Future<void> _cacheOrdersInBackground(
  OsmeaUsersManagerService usersManagerService,
) async {
  // Run in background without blocking
  Future.microtask(() async {
    try {
      debugPrint(
        '📍 [ORDER CACHE] Starting to cache user orders in background...',
      );

      // Get order IDs from getUserDashboard
      List<int> orderIds = [];
      try {
        final dashboard = await usersManagerService.getUserDashboard(
          includeOrders: true,
          ordersLimit: 100,
        );
        orderIds = dashboard.orders.map((o) => o.id).toList();
        debugPrint('✅ [ORDER CACHE] Got ${orderIds.length} order IDs');
      } catch (e) {
        debugPrint('⚠️ [ORDER CACHE] Failed to get orders: $e');
        return;
      }

      if (orderIds.isEmpty) {
        debugPrint('⚠️ [ORDER CACHE] No orders found, caching empty list');
        final storage = LocalStorageHelper();
        await storage.setItem('user_orders_cache', jsonEncode([]));
        await storage.setItem(
          'user_orders_cache_timestamp',
          DateTime.now().toIso8601String(),
        );
        return;
      }

      // Fetch detailed order information (limit to 50 to avoid too many calls)
      final List<Map<String, dynamic>> detailedOrders = [];
      final limitedOrderIds = orderIds.take(50).toList();

      debugPrint(
        '📦 [ORDER CACHE] Fetching ${limitedOrderIds.length} order details...',
      );

      for (final orderId in limitedOrderIds) {
        try {
          final detailedOrder = await usersManagerService.getUserOrder(orderId);
          // Convert to JSON for caching
          detailedOrders.add(detailedOrder.toJson());
        } catch (e) {
          debugPrint('⚠️ [ORDER CACHE] Failed to retrieve order $orderId: $e');
        }
      }

      // Cache the orders
      final storage = LocalStorageHelper();
      final ordersJson = jsonEncode(detailedOrders);
      await storage.setItem('user_orders_cache', ordersJson);
      await storage.setItem(
        'user_orders_cache_timestamp',
        DateTime.now().toIso8601String(),
      );

      debugPrint('✅ [ORDER CACHE] Cached ${detailedOrders.length} orders');
      debugPrint('   💾 Cache key: user_orders_cache');
    } catch (e, stackTrace) {
      debugPrint('❌ [ORDER CACHE] Error caching orders: $e');
      debugPrint('   Stack trace: $stackTrace');
      // Don't throw - this is background operation
    }
  });
}

/// Get navbar colors from config
Color _getNavbarColor(
  AssetConfigHelper configHelper,
  String key,
  Color defaultValue,
) {
  try {
    final navbarConfig = configHelper.getObject('navbar_configuration');
    final colorString = navbarConfig?[key] as String?;
    if (colorString != null && colorString.isNotEmpty) {
      // Handle hex color strings
      if (colorString.startsWith('#')) {
        final hexString = colorString.substring(1);
        if (hexString.length == 6) {
          return Color(int.parse('FF$hexString', radix: 16));
        } else if (hexString.length == 8) {
          return Color(int.parse(hexString, radix: 16));
        }
      }
    }
  } catch (e) {
    debugPrint('⚠️ Failed to load navbar color $key: $e');
  }
  return defaultValue;
}

/// Get navbar elevation from config
double _getNavbarElevation(AssetConfigHelper configHelper) {
  try {
    final navbarConfig = configHelper.getObject('navbar_configuration');
    final elevation = navbarConfig?['elevation'] as num?;
    if (elevation != null) {
      return elevation.toDouble();
    }
  } catch (e) {
    debugPrint('⚠️ Failed to load navbar elevation: $e');
  }
  return 0.5;
}

/// Get navbar variant from config
NavbarVariant _getNavbarVariant(AssetConfigHelper configHelper) {
  try {
    final navbarConfig = configHelper.getObject('navbar_configuration');
    final variantString = navbarConfig?['variant'] as String?;
    return NavbarVariantStringExtension.fromString(variantString) ??
        NavbarVariant.retailMain;
  } catch (e) {
    debugPrint('⚠️ Failed to load navbar variant: $e');
    return NavbarVariant.retailMain;
  }
}

/// Get navbar size from config
NavbarSize _getNavbarSize(AssetConfigHelper configHelper) {
  try {
    final navbarConfig = configHelper.getObject('navbar_configuration');
    final sizeString = navbarConfig?['size'] as String?;
    return NavbarSizeStringExtension.fromString(sizeString) ??
        NavbarSize.medium;
  } catch (e) {
    debugPrint('⚠️ Failed to load navbar size: $e');
    return NavbarSize.medium;
  }
}

/// Get navbar position from config
NavbarPosition _getNavbarPosition(AssetConfigHelper configHelper) {
  try {
    final navbarConfig = configHelper.getObject('navbar_configuration');
    final positionString = navbarConfig?['position'] as String?;
    return NavbarPositionStringExtension.fromString(positionString) ??
        NavbarPosition.bottom;
  } catch (e) {
    debugPrint('⚠️ Failed to load navbar position: $e');
    return NavbarPosition.bottom;
  }
}

/// Get navbar boolean property from config
bool _getNavbarBool(
  AssetConfigHelper configHelper,
  String key,
  bool defaultValue,
) {
  try {
    final navbarConfig = configHelper.getObject('navbar_configuration');
    final value = navbarConfig?[key] as bool?;
    if (value != null) {
      return value;
    }
  } catch (e) {
    debugPrint('⚠️ Failed to load navbar $key: $e');
  }
  return defaultValue;
}

/// Get navbar style from config
NavbarStyle? _getNavbarStyle(AssetConfigHelper configHelper) {
  try {
    final navbarConfig = configHelper.getObject('navbar_configuration');
    final styleString = navbarConfig?['style'] as String?;
    return NavbarStyleStringExtension.fromString(styleString);
  } catch (e) {
    debugPrint('⚠️ Failed to load navbar style: $e');
    return null; // Auto-detect if not specified
  }
}

/// Get navbar indicator style from config
NavbarIndicatorStyle _getNavbarIndicatorStyle(AssetConfigHelper configHelper) {
  try {
    final navbarConfig = configHelper.getObject('navbar_configuration');
    final indicatorString = navbarConfig?['indicatorStyle'] as String?;
    return NavbarIndicatorStyleStringExtension.fromString(indicatorString) ??
        NavbarIndicatorStyle.none;
  } catch (e) {
    debugPrint('⚠️ Failed to load navbar indicator style: $e');
    return NavbarIndicatorStyle.none;
  }
}

/// Get navbar numeric property from config
double? _getNavbarDouble(AssetConfigHelper configHelper, String key) {
  try {
    final navbarConfig = configHelper.getObject('navbar_configuration');
    final value = navbarConfig?[key];
    if (value is num) {
      return value.toDouble();
    }
  } catch (e) {
    debugPrint('⚠️ Failed to load navbar $key: $e');
  }
  return null;
}

/// Determines if navbar should be shown for a given route path
/// Navbar is shown on all pages except auth, onboarding, campaign, and special pages
bool _shouldShowNavbarForPath(String path) {
  // Routes that should NOT show navbar (only special pages like auth, onboarding, etc.)
  final hideNavbarRoutes = [
    '/auth', // Authentication pages
    '/onboarding', // Onboarding flow
    '/campaign', // Campaign splash
    '/', // Root/splash route
    '/empty', // Empty state pages
    '/loading', // Loading pages
  ];

  // Check if path matches exactly or starts with any hide navbar route
  for (final route in hideNavbarRoutes) {
    if (path == route || path.startsWith('$route/')) {
      debugPrint('🚫 Navbar hidden for route: $path (matches: $route)');
      return false;
    }
  }

  // Default: show navbar for all other routes (including product-detail, checkout, order-detail, etc.)
  debugPrint('✅ Navbar shown for route: $path');
  return true;
}

/// Get navbar for specific route
/// Always returns navbar widget if route should show navbar (config'de olsa da olmasa da)
/// Calculates currentIndex from navbar configuration or uses fallback
Widget? _getNavbarForRoute(String location, Map<String, dynamic>? routeExtra) {
  // First check if route should show navbar
  if (!_shouldShowNavbarForPath(location)) {
    return null;
  }

  // Load navbar config
  try {
    final configHelper = AssetConfigHelper();
    final navbarConfig = configHelper.getObject('navbar_configuration');
    final isEnabled = navbarConfig?['enabled'] as bool? ?? true;
    if (!isEnabled) {
      return null;
    }

    final itemsList = navbarConfig?['items'] as List<dynamic>?;
    final List<NavbarItemModel> itemModels =
        itemsList != null && itemsList.isNotEmpty
        ? itemsList
              .map(
                (item) =>
                    NavbarItemModel.fromConfig(item as Map<String, dynamic>),
              )
              .toList()
        : [];

    // Try to find currentIndex from config
    int? currentIndex;

    if (itemModels.isNotEmpty) {
      for (final model in itemModels) {
        // Check standard route
        if (location == model.route) {
          currentIndex = model.orderId;
          break;
        }
        // Check conditional routes
        if (model.isConditional) {
          if (location == model.authRoute || location == model.guestRoute) {
            currentIndex = model.orderId;
            break;
          }
        }
      }
    }

    // If not found in config, try fallback index or use default
    // _getFallbackIndex always returns a value (defaults to 0), so currentIndex will never be null
    final finalCurrentIndex = currentIndex != null
        ? currentIndex
        : _getFallbackIndex(location);

    // Return a Builder widget to access context
    // Use BlocBuilder with optimized buildWhen to prevent rebuild loops
    return Builder(
      builder: (context) {
        // Listen to WishlistViewModel for count updates
        return BlocBuilder<WishlistViewModel, WishlistState>(
          bloc: GetIt.I<WishlistViewModel>(),
          buildWhen: (previous, current) {
            // Rebuild when wishlist count changes
            final prevCount = previous is WishlistLoadedState
                ? previous.items.length
                : 0;
            final currCount = current is WishlistLoadedState
                ? current.items.length
                : 0;
            return prevCount != currCount;
          },
          builder: (context, wishlistState) {
            final wishlistCount = wishlistState is WishlistLoadedState
                ? wishlistState.items.length
                : 0;

            // Get AuthCubit from GetIt to listen to auth state changes
            try {
              final authCubit = GetIt.I<AuthCubit>();
              // Use BlocBuilder only for reactive updates, with strict buildWhen
              return BlocBuilder<AuthCubit, AuthState>(
                bloc: authCubit,
                buildWhen: (previous, current) {
                  // Only rebuild if authentication status actually changed
                  final prevAuth =
                      previous is AuthAuthenticatedState &&
                      previous.isAuthenticated &&
                      previous.jwtToken != null &&
                      previous.jwtToken!.isNotEmpty;
                  final currAuth =
                      current is AuthAuthenticatedState &&
                      current.isAuthenticated &&
                      current.jwtToken != null &&
                      current.jwtToken!.isNotEmpty;
                  // Only rebuild if auth status changed, not on every state change
                  return prevAuth != currAuth;
                },
                builder: (context, authState) {
                  // Determine authentication status
                  final isAuthenticated =
                      authState is AuthAuthenticatedState &&
                      authState.isAuthenticated &&
                      authState.jwtToken != null &&
                      authState.jwtToken!.isNotEmpty;

                  // Build navbar items
                  final items = _buildNavbarItems(
                    context,
                    isAuthenticated,
                    wishlistCount,
                  );

                  // Get all properties from config
                  final configHelper = AssetConfigHelper();
                  final variant = _getNavbarVariant(configHelper);
                  final size = _getNavbarSize(configHelper);
                  final position = _getNavbarPosition(configHelper);
                  final backgroundColor = _getNavbarColor(
                    configHelper,
                    'backgroundColor',
                    OsmeaColors.white,
                  );
                  final borderColor = _getNavbarColor(
                    configHelper,
                    'borderColor',
                    OsmeaColors.silver,
                  );
                  final activeColor = _getNavbarColor(
                    configHelper,
                    'selectedIconColor',
                    OsmeaColors.black,
                  );
                  final inactiveColor = _getNavbarColor(
                    configHelper,
                    'unselectedIconColor',
                    OsmeaColors.grayMaterial[600] ?? OsmeaColors.pewter,
                  );
                  final elevation = _getNavbarElevation(configHelper);
                  final showLabels = _getNavbarBool(
                    configHelper,
                    'showLabels',
                    true,
                  );
                  final showIcons = _getNavbarBool(
                    configHelper,
                    'showIcons',
                    true,
                  );
                  final centerItems = _getNavbarBool(
                    configHelper,
                    'centerItems',
                    true,
                  );
                  final style = _getNavbarStyle(configHelper);
                  final indicatorStyle = _getNavbarIndicatorStyle(configHelper);
                  final indicatorColor = _getNavbarColor(
                    configHelper,
                    'indicatorColor',
                    activeColor,
                  );
                  final borderWidth = _getNavbarDouble(
                    configHelper,
                    'borderWidth',
                  );
                  final showBorder = _getNavbarBool(
                    configHelper,
                    'showBorder',
                    false,
                  );
                  final borderStyleString =
                      configHelper.getObject(
                            'navbar_configuration',
                          )?['borderStyle']
                          as String?;
                  BorderStyle? borderStyle;
                  if (borderStyleString != null) {
                    switch (borderStyleString.toLowerCase()) {
                      case 'solid':
                        borderStyle = BorderStyle.solid;
                        break;
                      case 'none':
                        borderStyle = BorderStyle.none;
                        break;
                    }
                  }

                  return OsmeaComponents.navbar(
                    variant: variant,
                    size: size,
                    position: position,
                    style: style,
                    indicatorStyle: indicatorStyle,
                    indicatorColor: indicatorColor,
                    currentIndex: finalCurrentIndex,
                    borderColor: borderColor,
                    borderWidth: borderWidth,
                    borderStyle: borderStyle,
                    showBorder: showBorder,
                    elevation: elevation,
                    backgroundColor: backgroundColor,
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                    showLabels: showLabels,
                    showIcons: showIcons,
                    centerItems: centerItems,
                    items: items,
                    onItemTap: (index) =>
                        _navigateToPage(context, index, isAuthenticated),
                  );
                },
              );
            } catch (e) {
              debugPrint('⚠️ AuthCubit not available, using fallback: $e');
              // Fallback: use direct state check without FutureBuilder (non-blocking)
              bool isAuthenticated = false;
              try {
                final authCubit = GetIt.I<AuthCubit>();
                final authState = authCubit.state;
                isAuthenticated =
                    authState is AuthAuthenticatedState &&
                    authState.isAuthenticated &&
                    authState.jwtToken != null &&
                    authState.jwtToken!.isNotEmpty;
              } catch (_) {
                // If AuthCubit not available, default to false
                isAuthenticated = false;
              }

              final items = _buildNavbarItems(
                context,
                isAuthenticated,
                wishlistCount,
              );

              // Get all properties from config
              final configHelper = AssetConfigHelper();
              final variant = _getNavbarVariant(configHelper);
              final size = _getNavbarSize(configHelper);
              final position = _getNavbarPosition(configHelper);
              final backgroundColor = _getNavbarColor(
                configHelper,
                'backgroundColor',
                OsmeaColors.white,
              );
              final borderColor = _getNavbarColor(
                configHelper,
                'borderColor',
                OsmeaColors.silver,
              );
              final activeColor = _getNavbarColor(
                configHelper,
                'selectedIconColor',
                OsmeaColors.black,
              );
              final inactiveColor = _getNavbarColor(
                configHelper,
                'unselectedIconColor',
                OsmeaColors.grayMaterial[600] ?? OsmeaColors.pewter,
              );
              final elevation = _getNavbarElevation(configHelper);
              final showLabels = _getNavbarBool(
                configHelper,
                'showLabels',
                true,
              );
              final showIcons = _getNavbarBool(configHelper, 'showIcons', true);
              final centerItems = _getNavbarBool(
                configHelper,
                'centerItems',
                true,
              );

              return OsmeaComponents.navbar(
                variant: variant,
                size: size,
                position: position,
                currentIndex: finalCurrentIndex,
                borderColor: borderColor,
                elevation: elevation,
                backgroundColor: backgroundColor,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                showLabels: showLabels,
                showIcons: showIcons,
                centerItems: centerItems,
                items: items,
                onItemTap: (index) =>
                    _navigateToPage(context, index, isAuthenticated),
              );
            }
          },
        );
      },
    );
  } catch (e) {
    debugPrint('⚠️ Error loading navbar config for route: $e');
    return _getNavbarForRouteFallback(location);
  }
}

/// Fallback navbar route check if config fails
Widget? _getNavbarForRouteFallback(String location) {
  // Check if route should show navbar
  final shouldShow = _shouldShowNavbarForPath(location);
  if (!shouldShow) {
    return null;
  }

  // Show navbar for main app sections and other routes that should show navbar
  if (location == '/home' ||
      location == '/search' ||
      location == '/cart' ||
      location == '/saved' ||
      location == '/profile' ||
      location.startsWith('/products') ||
      location.startsWith('/product-detail') ||
      location.startsWith('/checkout') ||
      location.startsWith('/order-detail') ||
      location.startsWith('/user-profile') ||
      location.startsWith('/favorite-categories') ||
      location.startsWith('/orders-history') ||
      location == '/about' ||
      location == '/contact-us' ||
      location == '/faq') {
    final currentIndex = _getFallbackIndex(location);

    // Return a Builder widget to access context
    return Builder(
      builder: (context) {
        // Listen to WishlistViewModel for count updates
        return BlocBuilder<WishlistViewModel, WishlistState>(
          bloc: GetIt.I<WishlistViewModel>(),
          buildWhen: (previous, current) {
            final prevCount = previous is WishlistLoadedState
                ? previous.items.length
                : 0;
            final currCount = current is WishlistLoadedState
                ? current.items.length
                : 0;
            return prevCount != currCount;
          },
          builder: (context, wishlistState) {
            final wishlistCount = wishlistState is WishlistLoadedState
                ? wishlistState.items.length
                : 0;

            try {
              final authCubit = GetIt.I<AuthCubit>();
              return BlocBuilder<AuthCubit, AuthState>(
                bloc: authCubit,
                buildWhen: (previous, current) {
                  final prevAuth =
                      previous is AuthAuthenticatedState &&
                      previous.isAuthenticated &&
                      previous.jwtToken != null &&
                      previous.jwtToken!.isNotEmpty;
                  final currAuth =
                      current is AuthAuthenticatedState &&
                      current.isAuthenticated &&
                      current.jwtToken != null &&
                      current.jwtToken!.isNotEmpty;
                  return prevAuth != currAuth;
                },
                builder: (context, authState) {
                  final isAuthenticated =
                      authState is AuthAuthenticatedState &&
                      authState.isAuthenticated &&
                      authState.jwtToken != null &&
                      authState.jwtToken!.isNotEmpty;

                  final items = _buildFallbackNavbarItems(
                    context,
                    isAuthenticated,
                    wishlistCount,
                  );

                  // Get all properties from config
                  final configHelper = AssetConfigHelper();
                  final variant = _getNavbarVariant(configHelper);
                  final size = _getNavbarSize(configHelper);
                  final position = _getNavbarPosition(configHelper);
                  final backgroundColor = _getNavbarColor(
                    configHelper,
                    'backgroundColor',
                    OsmeaColors.white,
                  );
                  final borderColor = _getNavbarColor(
                    configHelper,
                    'borderColor',
                    OsmeaColors.silver,
                  );
                  final activeColor = _getNavbarColor(
                    configHelper,
                    'selectedIconColor',
                    OsmeaColors.black,
                  );
                  final inactiveColor = _getNavbarColor(
                    configHelper,
                    'unselectedIconColor',
                    OsmeaColors.grayMaterial[600] ?? OsmeaColors.pewter,
                  );
                  final elevation = _getNavbarElevation(configHelper);
                  final showLabels = _getNavbarBool(
                    configHelper,
                    'showLabels',
                    true,
                  );
                  final showIcons = _getNavbarBool(
                    configHelper,
                    'showIcons',
                    true,
                  );
                  final centerItems = _getNavbarBool(
                    configHelper,
                    'centerItems',
                    true,
                  );
                  final style = _getNavbarStyle(configHelper);
                  final indicatorStyle = _getNavbarIndicatorStyle(configHelper);
                  final indicatorColor = _getNavbarColor(
                    configHelper,
                    'indicatorColor',
                    activeColor,
                  );
                  final borderWidth = _getNavbarDouble(
                    configHelper,
                    'borderWidth',
                  );
                  final showBorder = _getNavbarBool(
                    configHelper,
                    'showBorder',
                    false,
                  );
                  final borderStyleString =
                      configHelper.getObject(
                            'navbar_configuration',
                          )?['borderStyle']
                          as String?;
                  BorderStyle? borderStyle;
                  if (borderStyleString != null) {
                    switch (borderStyleString.toLowerCase()) {
                      case 'solid':
                        borderStyle = BorderStyle.solid;
                        break;
                      case 'none':
                        borderStyle = BorderStyle.none;
                        break;
                    }
                  }

                  return OsmeaComponents.navbar(
                    variant: variant,
                    size: size,
                    position: position,
                    style: style,
                    indicatorStyle: indicatorStyle,
                    indicatorColor: indicatorColor,
                    currentIndex: currentIndex,
                    borderColor: borderColor,
                    borderWidth: borderWidth,
                    borderStyle: borderStyle,
                    showBorder: showBorder,
                    elevation: elevation,
                    backgroundColor: backgroundColor,
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                    showLabels: showLabels,
                    showIcons: showIcons,
                    centerItems: centerItems,
                    items: items,
                    onItemTap: (index) => _navigateToPageFallback(
                      context,
                      index,
                      isAuthenticated,
                    ),
                  );
                },
              );
            } catch (e) {
              debugPrint('⚠️ AuthCubit not available in fallback: $e');
              bool isAuthenticated = false;
              try {
                final authCubit = GetIt.I<AuthCubit>();
                final authState = authCubit.state;
                isAuthenticated =
                    authState is AuthAuthenticatedState &&
                    authState.isAuthenticated &&
                    authState.jwtToken != null &&
                    authState.jwtToken!.isNotEmpty;
              } catch (_) {
                isAuthenticated = false;
              }

              final items = _buildFallbackNavbarItems(
                context,
                isAuthenticated,
                wishlistCount,
              );

              // Get all properties from config
              final configHelper = AssetConfigHelper();
              final variant = _getNavbarVariant(configHelper);
              final size = _getNavbarSize(configHelper);
              final position = _getNavbarPosition(configHelper);
              final backgroundColor = _getNavbarColor(
                configHelper,
                'backgroundColor',
                OsmeaColors.white,
              );
              final borderColor = _getNavbarColor(
                configHelper,
                'borderColor',
                OsmeaColors.silver,
              );
              final activeColor = _getNavbarColor(
                configHelper,
                'selectedIconColor',
                OsmeaColors.black,
              );
              final inactiveColor = _getNavbarColor(
                configHelper,
                'unselectedIconColor',
                OsmeaColors.grayMaterial[600] ?? OsmeaColors.pewter,
              );
              final elevation = _getNavbarElevation(configHelper);
              final showLabels = _getNavbarBool(
                configHelper,
                'showLabels',
                true,
              );
              final showIcons = _getNavbarBool(configHelper, 'showIcons', true);
              final centerItems = _getNavbarBool(
                configHelper,
                'centerItems',
                true,
              );
              final style = _getNavbarStyle(configHelper);
              final indicatorStyle = _getNavbarIndicatorStyle(configHelper);
              final indicatorColor = _getNavbarColor(
                configHelper,
                'indicatorColor',
                activeColor,
              );
              final borderWidth = _getNavbarDouble(configHelper, 'borderWidth');
              final showBorder = _getNavbarBool(
                configHelper,
                'showBorder',
                false,
              );
              final borderStyleString =
                  (configHelper.getObject(
                        'navbar_configuration',
                      ))?['borderStyle']
                      as String?;
              BorderStyle? borderStyle;
              if (borderStyleString != null) {
                switch (borderStyleString.toLowerCase()) {
                  case 'solid':
                    borderStyle = BorderStyle.solid;
                    break;
                  case 'none':
                    borderStyle = BorderStyle.none;
                    break;
                }
              }

              return OsmeaComponents.navbar(
                variant: variant,
                size: size,
                position: position,
                style: style,
                indicatorStyle: indicatorStyle,
                indicatorColor: indicatorColor,
                currentIndex: currentIndex,
                borderColor: borderColor,
                borderWidth: borderWidth,
                borderStyle: borderStyle,
                showBorder: showBorder,
                elevation: elevation,
                backgroundColor: backgroundColor,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                showLabels: showLabels,
                showIcons: showIcons,
                centerItems: centerItems,
                items: items,
                onItemTap: (index) =>
                    _navigateToPageFallback(context, index, isAuthenticated),
              );
            }
          },
        );
      },
    );
  }
  return null;
}

/// Get fallback index for route (backward compatibility)
int _getFallbackIndex(String location) {
  if (location == '/home') {
    return 0;
  } else if (location == '/search') {
    return 1;
  } else if (location == '/saved') {
    return 2;
  } else if (location == '/cart') {
    return 3;
  } else if (location == '/profile') {
    return 4;
  }
  return 0;
}

/// Build navbar items based on configuration from app_config.json
List<NavbarItem> _buildNavbarItems(
  BuildContext context,
  bool isAuthenticated,
  int wishlistCount,
) {
  try {
    final configHelper = AssetConfigHelper();
    final navbarConfig = configHelper.getObject('navbar_configuration');

    // Check if navbar is enabled
    final isEnabled = navbarConfig?['enabled'] as bool? ?? true;
    if (!isEnabled) {
      return [];
    }

    // Get items array
    final itemsList = navbarConfig?['items'] as List<dynamic>?;
    if (itemsList == null || itemsList.isEmpty) {
      debugPrint('⚠️ No navbar items found in config, using fallback');
      return _buildFallbackNavbarItems(context, isAuthenticated, wishlistCount);
    }

    // Parse items from config
    final List<NavbarItemModel> itemModels = itemsList
        .map((item) => NavbarItemModel.fromConfig(item as Map<String, dynamic>))
        .toList();

    // Sort by order_id
    itemModels.sort((a, b) => a.orderId.compareTo(b.orderId));

    // Convert models to NavbarItem widgets
    return itemModels.map((model) {
      return _buildNavbarItemFromModel(
        context,
        model,
        isAuthenticated,
        wishlistCount,
      );
    }).toList();
  } catch (e) {
    debugPrint('❌ Error loading navbar config: $e');
    return _buildFallbackNavbarItems(context, isAuthenticated, wishlistCount);
  }
}

/// Build a single NavbarItem from NavbarItemModel
NavbarItem _buildNavbarItemFromModel(
  BuildContext context,
  NavbarItemModel model,
  bool isAuthenticated,
  int wishlistCount,
) {
  // Get text, route, and icon based on auth state
  final text = model.getText(isAuthenticated);
  final route = model.getRoute(isAuthenticated);
  final iconName = model.getIconName(isAuthenticated);

  // Build icon widget
  Widget iconWidget;

  if (model.isAnimated && model.filledIconName != null) {
    // Animated icon (e.g., Saved/Wishlist)
    final filledIcon = NavbarIconHelper.getIconData(model.filledIconName!);
    final emptyIcon = NavbarIconHelper.getIconData(model.iconName);

    iconWidget = AnimatedNavbarIcon(
      value: wishlistCount,
      filledIcon: filledIcon,
      emptyIcon: emptyIcon,
      filledColor: OsmeaColors.black,
    );
  } else {
    // Standard icon
    final iconData = NavbarIconHelper.getIconData(iconName);
    iconWidget = Icon(iconData);
  }

  // Determine animation type
  NavbarItemAnimationType animationType = NavbarItemAnimationType.none;
  if (model.isAnimated && model.animationType != null) {
    switch (model.animationType) {
      case 'scale':
        animationType = NavbarItemAnimationType.scale;
        break;
      case 'bounce':
        animationType = NavbarItemAnimationType.bounce;
        break;
      case 'pulse':
        animationType = NavbarItemAnimationType.pulse;
        break;
      case 'shake':
        animationType = NavbarItemAnimationType.shake;
        break;
      default:
        animationType = NavbarItemAnimationType.none;
    }
  }

  // Determine animation trigger value
  dynamic animationTrigger;
  int? iconAnimationTrigger;
  if (model.isAnimated &&
      model.animationTrigger == 'wishlist_count' &&
      wishlistCount >= 0) {
    animationTrigger = wishlistCount;
    iconAnimationTrigger = wishlistCount;
  }

  return NavbarItem(
    text: text,
    icon: iconWidget,
    onTap: () => context.go(route),
    tooltip: model.tooltip ?? text,
    animationType: animationType,
    animationTrigger: animationTrigger,
    iconAnimationTrigger: iconAnimationTrigger,
  );
}

/// Fallback navbar items if config fails to load
List<NavbarItem> _buildFallbackNavbarItems(
  BuildContext context,
  bool isAuthenticated,
  int wishlistCount,
) {
  return [
    NavbarItem(
      text: 'Home',
      icon: Icon(Icons.home_outlined),
      onTap: () => context.go('/home'),
      tooltip: 'Home',
    ),
    NavbarItem(
      text: 'Search',
      icon: Icon(Icons.search_outlined),
      onTap: () => context.go('/search'),
      tooltip: 'Search',
    ),
    NavbarItem(
      text: 'Saved',
      icon: AnimatedNavbarIcon(
        value: wishlistCount,
        filledIcon: Icons.favorite,
        emptyIcon: Icons.favorite_outline,
        filledColor: OsmeaColors.black,
      ),
      onTap: () => context.go('/saved'),
      tooltip: 'Saved Items',
      animationType: NavbarItemAnimationType.scale,
      animationTrigger: wishlistCount,
      iconAnimationTrigger: wishlistCount,
    ),
    NavbarItem(
      text: 'Cart',
      icon: Icon(Icons.shopping_cart_outlined),
      onTap: () => context.go('/cart'),
      tooltip: 'Shopping Cart',
    ),
    NavbarItem(
      text: isAuthenticated ? 'Profile' : 'Sign In',
      icon: Icon(isAuthenticated ? Icons.person_outline : Icons.login_outlined),
      onTap: () {
        if (isAuthenticated) {
          context.go('/profile');
        } else {
          context.go('/auth');
        }
      },
      tooltip: isAuthenticated ? 'Profile' : 'Sign In',
    ),
  ];
}

/// Load user API data and set it to AccountCubit
/// This fetches fresh user data from the API (username, email, etc.)
Future<void> _loadUserApiData(AccountCubit accountCubit) async {
  try {
    debugPrint('🔍 AccountCubit Route: Loading user API data...');
    final jwtToken = await WooJwtTokenStorage.loadToken();
    if (jwtToken != null && jwtToken.accessToken.isNotEmpty) {
      debugPrint('🔍 AccountCubit Route: JWT token found, calling API...');
      final authService = GetIt.I<WooAuthService>();
      final authHeader = 'Bearer ${jwtToken.accessToken}';
      final userMeResponse = await authService.getUsersMe(authHeader);

      debugPrint('✅ AccountCubit Route: getUsersMe API call successful');
      debugPrint(
        '👤 AccountCubit Route: User name from API (raw): "${userMeResponse.name}"',
      );

      // Prepare user data map with username, email, etc.
      final userData = {
        'id': userMeResponse.id,
        'name': userMeResponse.name, // Use name directly, no processing
        'url': userMeResponse.url,
        'description': userMeResponse.description,
        'link': userMeResponse.link,
        'slug': userMeResponse.slug,
        'avatar_urls': userMeResponse.avatarUrls?.toJson(),
        'is_super_admin': userMeResponse.isSuperAdmin,
        'woocommerce_meta': userMeResponse.woocommerceMeta?.toJson(),
      };

      debugPrint(
        '👤 AccountCubit Route: Setting user data with name: "${userData['name']}"',
      );
      accountCubit.setUserApiData(userData);
    } else {
      debugPrint('⚠️ AccountCubit Route: No JWT token found');
      accountCubit.setUserApiData(null);
    }
  } catch (e, stackTrace) {
    debugPrint('⚠️ AccountCubit Route: Error calling getUsersMe API: $e');
    debugPrint('⚠️ AccountCubit Route: Stack trace: $stackTrace');
    accountCubit.setUserApiData(null);
  }
}

/// Navigate to page based on index using navbar configuration
void _navigateToPage(BuildContext context, int index, bool isAuthenticated) {
  try {
    final configHelper = AssetConfigHelper();
    final navbarConfig = configHelper.getObject('navbar_configuration');
    final itemsList = navbarConfig?['items'] as List<dynamic>?;

    if (itemsList == null || itemsList.isEmpty) {
      // Fallback to hardcoded navigation
      _navigateToPageFallback(context, index, isAuthenticated);
      return;
    }

    // Parse items and find item at index
    final List<NavbarItemModel> itemModels = itemsList
        .map((item) => NavbarItemModel.fromConfig(item as Map<String, dynamic>))
        .toList();

    // Sort by order_id
    itemModels.sort((a, b) => a.orderId.compareTo(b.orderId));

    // Find item at the specified index
    if (index >= 0 && index < itemModels.length) {
      final model = itemModels[index];
      final route = model.getRoute(isAuthenticated);
      context.go(route);
    } else {
      debugPrint('⚠️ Invalid navbar index: $index');
      // Fallback to hardcoded navigation
      _navigateToPageFallback(context, index, isAuthenticated);
    }
  } catch (e) {
    debugPrint('❌ Error navigating from navbar config: $e');
    // Fallback to hardcoded navigation
    _navigateToPageFallback(context, index, isAuthenticated);
  }
}

/// Fallback navigation if config fails
void _navigateToPageFallback(
  BuildContext context,
  int index,
  bool isAuthenticated,
) {
  switch (index) {
    case 0: // Home
      context.go('/home');
      break;
    case 1: // Search
      context.go('/search');
      break;
    case 2: // Saved
      context.go('/saved');
      break;
    case 3: // Cart
      context.go('/cart');
      break;
    case 4: // Profile/Sign In
      if (isAuthenticated) {
        context.go('/profile');
      } else {
        context.go('/auth');
      }
      break;
    default:
      context.go('/home');
  }
}

/// Wrapper widget that auto-focuses the search input when navigated to
class _AutoFocusSearchView extends StatefulWidget {
  final FocusNode searchFocusNode;
  final String? initialQuery;
  final bool fromHome;
  final Function(String) goRoute;
  final Future<List<dynamic>> Function(String query) searchProvider;
  final Future<List<String>> Function(String query)? searchSuggestionProvider;
  final List<String> initialHistory;

  const _AutoFocusSearchView({
    required this.searchFocusNode,
    this.initialQuery,
    this.fromHome = false,
    required this.goRoute,
    required this.searchProvider,
    this.searchSuggestionProvider,
    this.initialHistory = const [],
  });

  @override
  State<_AutoFocusSearchView> createState() => _AutoFocusSearchViewState();
}

class _AutoFocusSearchViewState extends State<_AutoFocusSearchView> {
  late TextEditingController _searchController;
  bool _shouldAutoFocus = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);

    // Check if we came from navbar (no auto-focus) or from home searchbar (auto-focus)
    // If fromHome is true, it means user tapped home searchbar, so auto-focus
    // If fromHome is false, it means user tapped navbar, so don't auto-focus
    _shouldAutoFocus = widget.fromHome;

    // Request focus after the frame is built only if should auto-focus
    if (_shouldAutoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.searchFocusNode.canRequestFocus) {
          widget.searchFocusNode.requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    widget.searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchView(
      goRoute: widget.goRoute,
      title: const Text('Search Products'),
      searchHint: 'Search for products...',
      searchController: _searchController,
      searchFocusNode: widget.searchFocusNode,
      showBackButton: true,
      showTitle: true,
      titleAlignment: AppBarTitleAlignment.center,
      showSearchIcon: true,
      // Don't show search history.
      maxHistoryItems: 0,
      searchSuggestionProvider: widget.searchSuggestionProvider,
      initialHistory: widget.initialHistory,
      onSearchSubmitted: null,
      onBackPressed: () => widget.goRoute('/home'),
      searchProvider: widget.searchProvider,
      resultBuilder: (context, results) {
        return SearchResultsGridWidget(products: results);
      },
      emptyStateBuilder: (context) {
        final searchCubit = context.read<SearchCubit>();
        // Show skeleton if coming from navbar (fromHome is false)
        return SearchEmptyStateWidget(
          searchCubit: searchCubit,
          searchProvider: widget.searchProvider,
          showSkeleton: !widget.fromHome,
        );
      },
    );
  }
}

/// App shell wrapper with navbar visibility control and deep linking support
class _AppShellWithMiniCart extends StatefulWidget {
  final Widget child;
  final Widget? navbar;
  final String currentPath;
  final Map<String, dynamic>? routeExtra;

  const _AppShellWithMiniCart({
    required this.child,
    this.navbar,
    required this.currentPath,
    this.routeExtra,
  });

  @override
  State<_AppShellWithMiniCart> createState() => _AppShellWithMiniCartState();
}

class _AppShellWithMiniCartState extends State<_AppShellWithMiniCart> {
  @override
  Widget build(BuildContext context) {
    // Navbar visibility is already determined in ShellRoute builder
    // If navbar is null, it means the route shouldn't show navbar
    return Scaffold(body: widget.child, bottomNavigationBar: widget.navbar);
  }
}
