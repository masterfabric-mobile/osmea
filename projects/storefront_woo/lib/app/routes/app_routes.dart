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
import 'package:storefront_woo/app/models/navbar_item_model.dart';
import 'package:storefront_woo/app/utils/navbar_icon_helper.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/abstract/product_service.dart';

import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';
import 'package:get_it/get_it.dart';
import 'package:apis/apis.dart';
import 'package:apis/dio_config/dio_client/api_dio_client.dart';
import 'package:apis/network/remote/woocommerce/auth/abstract/woo_auth_service.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false, // Disable debug route bar to prevent freezing
  // Global route configuration
  routes: <RouteBase>[
    // Shell Route with Navbar for main app sections
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: _getNavbarForRoute(state.uri.path),
        );
      },
      routes: [
        // Home Page - Show products directly
        GoRoute(
          path: '/home',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage(
              child: HomeView(
                arguments: const {'home': true},
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

        // Search Page
        // GoRoute(
        //   path: '/search',
        //   pageBuilder: (BuildContext context, GoRouterState state) {
        //     return CustomTransitionPage(
        //       child: store_search.SearchView(
        //         goRoute: (String path) {
        //           if (path.contains('home')) {
        //             context.go('/home');
        //           } else if (path.contains('product-detail')) {
        //             context.go('/product-detail');
        //           } else {
        //             context.go('/search');
        //           }
        //         },
        //       ),
        //       transitionsBuilder:
        //           (context, animation, secondaryAnimation, child) {
        //             return FadeTransition(opacity: animation, child: child);
        //           },
        //       transitionDuration: const Duration(milliseconds: 300),
        //     );
        //   },
        // ),

        // Saved Page
        GoRoute(
          path: '/saved',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage(
              child: WishlistView(
                goRoute: (String path) {
                  if (path.contains('home')) {
                    context.go('/home');
                  } else {
                    context.go('/saved');
                  }
                },
                arguments: const {'saved': true},
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

            // Extract query from URL if present
            final query = state.uri.queryParameters['query'];

            return CustomTransitionPage(
              child: _AutoFocusSearchView(
                searchFocusNode: searchFocusNode,
                initialQuery: query,
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

        // Cart Page
        GoRoute(
          path: '/cart',
          pageBuilder: (BuildContext context, GoRouterState state) {
            // Get cart token from extra (route params) or use default
            final extra = state.extra as Map<String, dynamic>?;
            final arguments = {
              'cart': true,
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
            final arguments = <String, dynamic>{'products': true};

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
            return CustomTransitionPage(
              child: FavoriteCategoriesView(
                arguments: const {'favorite_categories': true},
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
                  arguments: const {'account': true},
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
                    // AccountCubit handles its own state clearing
                    // Platform-specific cleanup is provided via callback
                    await accountCubit.signOut(
                      onSignOut: () async {
                        // Platform-specific cleanup: cookies, wishlist, cart tokens, AuthCubit
                        debugPrint(
                          '🚪 Route: Starting platform-specific cleanup...',
                        );

                        // Step 1: Sign out from AuthCubit
                        try {
                          await authCubit.signOut();
                          debugPrint('✅ Route: AuthCubit signed out');
                        } catch (e) {
                          debugPrint(
                            '⚠️ Route: Failed to sign out from AuthCubit: $e',
                          );
                        }

                        // Step 2: Clear WooCommerce JWT token
                        try {
                          await WooJwtTokenStorage.clearToken();
                          debugPrint('✅ Route: WooJWT token cleared');
                        } catch (e) {
                          debugPrint(
                            '⚠️ Route: Failed to clear WooJWT token: $e',
                          );
                        }

                        // Step 3: Clear cart token
                        try {
                          await WooCartTokenStorage.clearCartToken();
                          debugPrint('✅ Route: WooCartToken cleared');
                        } catch (e) {
                          debugPrint(
                            '⚠️ Route: Failed to clear WooCartToken: $e',
                          );
                        }

                        // Step 4: Clear all cookies (WP cookies: wordpress_logged_in_, woocommerce_items_in_cart, wp_woocommerce_session_)
                        try {
                          await ApiDioClient.clearAllCookies();
                          debugPrint(
                            '✅ Route: All cookies cleared (including WP cookies)',
                          );
                        } catch (e) {
                          debugPrint('⚠️ Route: Failed to clear cookies: $e');
                        }

                        // Step 5: Clear wishlist (user-specific data)
                        try {
                          final wishlistViewModel =
                              GetIt.I<WishlistViewModel>();
                          wishlistViewModel.clearAll();
                          debugPrint('✅ Route: Wishlist cleared');
                        } catch (e) {
                          debugPrint('⚠️ Route: Failed to clear wishlist: $e');
                        }

                        debugPrint(
                          '✅ Route: Platform-specific cleanup completed',
                        );
                      },
                    );

                    // Step 5: Navigate to home after sign out
                    await Future.delayed(const Duration(milliseconds: 300));
                    if (context.mounted) {
                      debugPrint(
                        '🔀 Route: Navigating to /home after sign out...',
                      );
                      context.go('/home');
                      debugPrint('✅ Route: Navigation to /home completed');
                    } else {
                      debugPrint(
                        '⚠️ Route: Context not mounted, cannot navigate',
                      );
                    }
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
            final arguments = {'checkout': true, if (extra != null) ...extra};
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
            // Campaign screen will then navigate to home after 1.5 seconds
            debugPrint('🎯 Splash completed, navigating to campaign screen');
            context.go('/campaign');
          },
        );
      },
    ),

    // Campaign Screen Route - Shows campaign images for 1.5 seconds then navigates to home
    GoRoute(
      path: '/campaign',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return CustomTransitionPage(
          child: CampaignView(
            goRoute: (String path) {
              // Check user authentication status from AuthCubit (HydratedCubit state)
              // This ensures we use the persisted state, not just storage
              try {
                final authCubit = GetIt.I<AuthCubit>();
                final isAuthenticated =
                    authCubit.state is AuthAuthenticatedState &&
                    authCubit.isAuthenticated;

                if (!context.mounted) return;

                if (isAuthenticated) {
                  debugPrint(
                    '👤 User already authenticated (from AuthCubit), navigating to home',
                  );
                  context.go('/home');
                } else {
                  // User not authenticated, go to guest mode (onboarding → home)
                  if (path.contains(Routes.home.name)) {
                    context.go('/home'); // Allow guest mode
                  } else if (path.contains(Routes.onboarding.name)) {
                    context.go('/onboarding');
                  } else if (path.contains(Routes.signIn.name)) {
                    context.go('/auth');
                  } else {
                    // Default: home (guest mode enabled)
                    context.go('/home');
                  }
                }
              } catch (e) {
                debugPrint('⚠️ Error checking AuthCubit state: $e');
                // Fallback to storage check
                final authStorage = AuthStorageHelper();
                authStorage.isAuthenticated().then((isAuthenticated) {
                  if (!context.mounted) return;
                  if (isAuthenticated) {
                    debugPrint(
                      '👤 User already authenticated (from storage), navigating to home',
                    );
                    context.go('/home');
                  } else {
                    context.go('/home');
                  }
                });
              }
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
                    final loaded = await configHelper.loadConfig(
                      'assets/app_config.json',
                    );

                    debugPrint('📁 Config load result: $loaded');
                    debugPrint(
                      '📁 Config path: ${configHelper.getCurrentConfigPath()}',
                    );

                    final allConfig = configHelper.getAllConfig();
                    debugPrint('📊 Config keys: ${allConfig?.keys.toList()}');

                    final authKey =
                        allConfig?['woocommerce_configuration']?['auth_key']
                            as String? ??
                        'default-auth-key';

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
  ],
);

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
    return NavbarVariantStringExtension.fromString(variantString) ?? NavbarVariant.retailMain;
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
    return NavbarSizeStringExtension.fromString(sizeString) ?? NavbarSize.medium;
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
    return NavbarPositionStringExtension.fromString(positionString) ?? NavbarPosition.bottom;
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
    return NavbarIndicatorStyleStringExtension.fromString(indicatorString) ?? NavbarIndicatorStyle.none;
  } catch (e) {
    debugPrint('⚠️ Failed to load navbar indicator style: $e');
    return NavbarIndicatorStyle.none;
  }
}

/// Get navbar numeric property from config
double? _getNavbarDouble(
  AssetConfigHelper configHelper,
  String key,
) {
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

/// Get navbar for specific route
/// Calculates currentIndex from navbar configuration
Widget? _getNavbarForRoute(String location) {
  // Load navbar config to determine if route should show navbar
  try {
    final configHelper = AssetConfigHelper();
    final navbarConfig = configHelper.getObject('navbar_configuration');
    final isEnabled = navbarConfig?['enabled'] as bool? ?? true;
    if (!isEnabled) {
      return null;
    }

    final itemsList = navbarConfig?['items'] as List<dynamic>?;
    if (itemsList == null || itemsList.isEmpty) {
      // Fallback to hardcoded check
      return _getNavbarForRouteFallback(location);
    }

    // Parse items and find matching route
    final List<NavbarItemModel> itemModels = itemsList
        .map((item) => NavbarItemModel.fromConfig(item as Map<String, dynamic>))
        .toList();

    // Check if location matches any navbar route
    bool shouldShowNavbar = false;
    int? currentIndex;

    for (final model in itemModels) {
      // Check standard route
      if (location == model.route) {
        shouldShowNavbar = true;
        currentIndex = model.orderId;
        break;
      }
      // Check conditional routes
      if (model.isConditional) {
        if (location == model.authRoute || location == model.guestRoute) {
          shouldShowNavbar = true;
          currentIndex = model.orderId;
          break;
        }
      }
    }

    // Also check common routes for backward compatibility
    if (!shouldShowNavbar) {
      if (location == '/home' ||
          location == '/search' ||
          location == '/cart' ||
          location == '/saved' ||
          location == '/profile' ||
          location == '/auth') {
        shouldShowNavbar = true;
        // Find index from config or use fallback
        for (final model in itemModels) {
          if (location == model.route ||
              location == model.authRoute ||
              location == model.guestRoute) {
            currentIndex = model.orderId;
            break;
          }
        }
        // Fallback to hardcoded if not found in config
        currentIndex ??= _getFallbackIndex(location);
      }
    }

    if (!shouldShowNavbar || currentIndex == null) {
      return null;
    }

    // currentIndex is guaranteed to be non-null after the check above
    final finalCurrentIndex = currentIndex;

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
                  final borderWidth = _getNavbarDouble(configHelper, 'borderWidth');
                  final showBorder = _getNavbarBool(
                    configHelper,
                    'showBorder',
                    false,
                  );
                  final borderStyleString = configHelper.getObject('navbar_configuration')?['borderStyle'] as String?;
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
  // Show navbar only for main app sections
  if (location == '/home' ||
      location == '/search' ||
      location == '/cart' ||
      location == '/saved' ||
      location == '/profile') {
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
                  final borderWidth = _getNavbarDouble(configHelper, 'borderWidth');
                  final showBorder = _getNavbarBool(
                    configHelper,
                    'showBorder',
                    false,
                  );
                  final borderStyleString = configHelper.getObject('navbar_configuration')?['borderStyle'] as String?;
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
              final borderStyleString = (configHelper.getObject('navbar_configuration'))?['borderStyle'] as String?;
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
  final Function(String) goRoute;
  final Future<List<dynamic>> Function(String query) searchProvider;

  const _AutoFocusSearchView({
    required this.searchFocusNode,
    this.initialQuery,
    required this.goRoute,
    required this.searchProvider,
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

    // Check if we came from navbar (no auto-focus) or from searchbar tap (auto-focus)
    // We'll determine this based on whether there's an initial query or not
    // If there's an initial query, it means user typed in home searchbar, so auto-focus
    // If no initial query, it means user tapped navbar, so don't auto-focus
    _shouldAutoFocus =
        widget.initialQuery != null && widget.initialQuery!.isNotEmpty;

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
      showTitle: false,
      titleAlignment: AppBarTitleAlignment.center,
      showSearchIcon: true,
      onBackPressed: () => widget.goRoute('/home'),
      searchProvider: widget.searchProvider,
      resultBuilder: (context, results) {
        return SearchResultsGridWidget(products: results);
      },
      emptyStateBuilder: (context) {
        final searchCubit = context.read<SearchCubit>();
        return SearchEmptyStateWidget(searchCubit: searchCubit);
      },
    );
  }
}
