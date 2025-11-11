import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

import 'package:storefront_woo/app/views/view_home/home_view.dart';
import 'package:storefront_woo/app/views/view_product_detail/product_detail_view.dart';
import 'package:storefront_woo/app/views/view_cart/cart_view.dart';
import 'package:storefront_woo/app/widgets/app_navbar.dart';
import 'package:storefront_woo/app/views/view_wishlist/wishlist_view.dart';
import 'package:storefront_woo/app/views/view_search/search_view.dart'
    as store_search;
import 'package:storefront_woo/app/views/view_auth_debug/auth_debug_view.dart';
import 'package:storefront_woo/app/views/view_profile/profile_view.dart';
import 'package:storefront_woo/app/views/view_checkout/checkout_view.dart';
import 'package:storefront_woo/app/views/view_orders/orders_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';
import 'package:get_it/get_it.dart';
import 'package:apis/apis.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  // Global route configuration
  routes: <RouteBase>[
    // Shell Route with Navbar for main app sections
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return BlocBuilder<WishlistViewModel, WishlistState>(
          bloc: GetIt.I<WishlistViewModel>(),
          builder: (context, wishlistState) {
            return Scaffold(
              body: child,
              bottomNavigationBar: _getNavbarForRoute(
                state.uri.path,
                GetIt.I<WishlistViewModel>().count,
              ),
            );
          },
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
        GoRoute(
          path: '/search',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage(
              child: store_search.SearchView(
                goRoute: (String path) {
                  if (path.contains('home')) {
                    context.go('/home');
                  } else if (path.contains('product-detail')) {
                    context.go('/product-detail');
                  } else {
                    context.go('/search');
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
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(milliseconds: 300),
            );
          },
        ),

        // Search Page
        GoRoute(
          path: '/search',
          builder: (BuildContext context, GoRouterState state) {
            return SearchView(
              arguments: const {'search': true},
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
              title: const Text('Search Products'),
              titleAlignment: AppBarTitleAlignment.center,
              showTitle: false,
              searchHint: 'Search for products...',
              searchBarSize: TextFieldSize.medium,
              showBackButton: true,
              showVoiceSearch: true,
              showBarcodeScanner: true,
              showSearchIcon: true,

              onBackPressed: () => context.go('/home'),
              // WooCommerce search provider will be integrated here
              searchProvider: (query) async {
                // TODO: Integrate with WooCommerce search API
                await Future.delayed(const Duration(milliseconds: 500));
                return ['Sample product 1', 'Sample product 2'];
              },

              onSearchResult: (results) {
                debugPrint('🔍 Search results: $results');
              },
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
      ],
    ),

    // Splash Screen Route
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return SplashView(
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
                  // Default: onboarding (guest mode enabled)
                  context.go('/onboarding');
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
                  context.go('/onboarding');
                }
              });
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
            'onSignIn': (String email, String password) async {
              final result = await authManager.login(
                email: email,
                password: password,
              );
              return result.isSuccess;
            },
            'onSignInSuccessTokenLoad': (AuthCubit authCubit) async {
              final jwtToken = await WooJwtTokenStorage.loadToken();
              if (jwtToken != null) {
                // Extract user data - check if it exists and has content
                Map<String, dynamic>? userData;
                if (jwtToken.userData != null &&
                    jwtToken.userData!.isNotEmpty) {
                  userData = jwtToken.userData;
                  debugPrint(
                    '✅ User data found in JWT token: ${userData?.keys.toList()}',
                  );
                } else {
                  debugPrint('⚠️ No user data in JWT token');
                }

                await authCubit.saveJwtToken(
                  jwtToken: jwtToken.accessToken,
                  userData: userData,
                  metadata: {'woo_jwt_token': jwtToken.toJson()},
                );
                debugPrint('✅ JWT token and user data saved to AuthCubit');
              } else {
                debugPrint('⚠️ No JWT token found in storage');
              }
            },
          },
        );
      },
    ),

    // Auth Debug Route (only visible when authenticated)
    GoRoute(
      path: '/auth-debug',
      builder: (BuildContext context, GoRouterState state) {
        return AuthDebugView(
          goRoute: (String path) {
            if (path.contains('home')) {
              context.go('/home');
            } else {
              context.go('/home');
            }
          },
        );
      },
    ),

    // Profile Route
    GoRoute(
      path: '/profile',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return CustomTransitionPage(
          child: ProfileView(
            goRoute: (String path) {
              debugPrint('🔀 ProfileView: goRoute called with path: $path');
              if (path.contains('home') || path == '/home') {
                debugPrint('🔀 ProfileView: Navigating to /home');
                context.go('/home');
              } else if (path.contains('orders') ||
                  path == '/orders' ||
                  path.startsWith('/orders/')) {
                debugPrint('🔀 ProfileView: Navigating to $path');
                context.go(path);
              } else if (path.contains('cart') || path == '/cart') {
                debugPrint('🔀 ProfileView: Navigating to /cart');
                context.go('/cart');
              } else if (path.contains('saved') || path == '/saved') {
                debugPrint('🔀 ProfileView: Navigating to /saved');
                context.go('/saved');
              } else if (path.contains('auth') || path == '/auth') {
                debugPrint('🔀 ProfileView: Navigating to /auth');
                context.go('/auth');
              } else {
                debugPrint('🔀 ProfileView: Navigating to path: $path');
                context.go(path);
              }
            },
            bottomNavigationBar: _getNavbarForRoute(
              state.uri.path,
              GetIt.I<WishlistViewModel>().count,
            ),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOutBack),
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
        return CustomTransitionPage(
          child: CheckoutView(
            arguments: const {'checkout': true},
            goRoute: (String path) {
              if (path.contains('cart')) {
                context.go('/cart');
              } else if (path.contains('orders')) {
                context.go('/orders');
              } else {
                context.go('/home');
              }
            },
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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

    // Orders Route (List)
    GoRoute(
      path: '/orders',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return CustomTransitionPage(
          child: OrdersView(
            arguments: const {'orders': true},
            goRoute: (String path) {
              if (path.contains('home')) {
                context.go('/home');
              } else if (path.contains('checkout')) {
                context.go('/checkout');
              } else {
                context.go('/home');
              }
            },
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
      },
    ),

    // Order Detail Route
    GoRoute(
      path: '/orders/:orderKey',
      pageBuilder: (BuildContext context, GoRouterState state) {
        final orderKey = state.pathParameters['orderKey'] ?? '';
        return CustomTransitionPage(
          child: OrdersView(
            arguments: {'orderDetail': true, 'orderKey': orderKey},
            goRoute: (String path) {
              if (path.contains('orders')) {
                context.go('/orders');
              } else if (path.contains('home')) {
                context.go('/home');
              } else {
                context.go('/orders');
              }
            },
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
      },
    ),
  ],
);

/// Get navbar for specific route
/// Navbar indexes: 0=Home, 1=Search, 2=Saved, 3=Cart, 4=Profile/Sign In
Widget? _getNavbarForRoute(String location, int wishlistCount) {
  // Show navbar only for main app sections
  if (location == '/home' ||
      location == '/search' ||
      location == '/cart' ||
      location == '/saved' ||
      location == '/profile') {
    if (location == '/home') {
      return AppNavbar(currentIndex: 0, wishlistCount: wishlistCount); // Home
    } else if (location == '/search') {
      return AppNavbar(currentIndex: 1, wishlistCount: wishlistCount); // Search
    } else if (location == '/saved') {
      return AppNavbar(currentIndex: 2, wishlistCount: wishlistCount); // Saved
    } else if (location == '/cart') {
      return AppNavbar(currentIndex: 3, wishlistCount: wishlistCount); // Cart
    } else if (location == '/profile') {
      return AppNavbar(
        currentIndex: 4,
        wishlistCount: wishlistCount,
      ); // Profile
    }
  }
  // No navbar for splash, onboarding, auth, product-detail, auth-debug
  return null;
}
