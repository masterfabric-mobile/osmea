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
import 'package:storefront_woo/app/views/view_profile/models/profile_view_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';
import 'package:apis/network/remote/woocommerce/auth/abstract/woo_auth_service.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/request/user_login_request.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/request/user_signup_request.dart';
import 'package:apis/models/auth/woo_jwt_token.dart';
import 'package:get_it/get_it.dart';

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
                  position: Tween<Offset>(
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
            // Check user authentication status
            final authStorage = AuthStorageHelper();
            authStorage.isAuthenticated().then((isAuthenticated) {
              if (!context.mounted) return;
              if (isAuthenticated) {
                debugPrint('👤 User already authenticated, navigating to home');
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
            });
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
        // Check if user is already authenticated - redirect to profile
        AuthStorageHelper().isAuthenticated().then((isAuthenticated) {
          if (isAuthenticated && context.mounted) {
            debugPrint('👤 User already authenticated, redirecting to profile');
            context.go('/profile');
          }
        });

        // Get initial tab from query parameter (0 = Sign In, 1 = Sign Up)
        final initialTab =
            int.tryParse(state.uri.queryParameters['tab'] ?? '0') ?? 0;
        // Extract brand name from store URL
        String extractBrandNameFromUrl(String storeUrl) {
          try {
            // Remove protocol (http://, https://)
            var url = storeUrl.replaceAll(RegExp(r'https?://'), '');

            // Remove port if exists
            url = url.split(':').first;

            // Get first part of domain (subdomain or domain)
            var parts = url.split('.');

            // If it's a subdomain.domain.tld, use subdomain
            // If it's domain.tld, use domain
            var brandName = parts.isNotEmpty ? parts.first : 'woocomm';

            debugPrint(
              '🔍 Extracted brand name: $brandName from URL: $storeUrl',
            );
            return brandName;
          } catch (e) {
            debugPrint(
              '⚠️ Error extracting brand name: $e, using default: woocomm',
            );
            return 'woocomm';
          }
        }

        // Handle sign in with auth service
        Future<bool> handleSignIn(String username, String password) async {
          try {
            debugPrint('🔐 Starting sign in for user: $username');

            // Get brand name and store URL from app_config.json
            final configHelper = AssetConfigHelper();
            await configHelper.loadConfig('assets/app_config.json');

            final storeUrl = configHelper.getString(
              'woocommerce_configuration.store_url',
              'http://your_store_url.com',
            );

            // Try to get brand_name from config, if not found extract from URL
            var brandName = configHelper.getString(
              'woocommerce_configuration.brand_name',
              '',
            );

            if (brandName.isEmpty) {
              // Extract brand name from store URL as fallback
              brandName = extractBrandNameFromUrl(storeUrl);
            }

            debugPrint('🏪 Using brand name: $brandName');
            debugPrint('🌐 Store URL: $storeUrl');

            // Get WooAuthService from GetIt
            final authService = GetIt.I<WooAuthService>();

            // Create login request
            final loginRequest = UserLoginRequest(
              email: username,
              password: password,
              rememberMe: true,
            );

            // Call API with brand name from config
            final response = await authService.userLogin(
              brandName,
              loginRequest,
            );

            debugPrint('🔍 API response received: ${response.success}');

            if (response.success && response.data != null) {
              // Get JWT token from jwt or accessToken field
              final jwtTokenString =
                  response.data!.jwt ?? response.data!.accessToken;

              if (jwtTokenString != null && jwtTokenString.isNotEmpty) {
                // Create WooJwtToken
                final wooJwtToken = WooJwtToken(
                  accessToken: jwtTokenString,
                  tokenType: response.data!.tokenType ?? 'Bearer',
                  expiresIn: response.data!.expiresIn ?? 3600,
                  issuedAt: response.data!.issuedAt ?? DateTime.now(),
                  refreshToken: response.data!.refreshToken,
                  scope: response.data!.scope,
                  userData: response.data!.user != null
                      ? response.data!.user!.toJson()
                      : <String, dynamic>{},
                );

                // Save to all storages for backward compatibility
                final authStorage = AuthStorageHelper();
                await authStorage.saveToken(jwtTokenString);
                if (response.data!.user != null) {
                  await authStorage.saveUserData(response.data!.user!.toJson());
                }
                await WooJwtTokenStorage.saveToken(wooJwtToken);

                // Save to AuthCubit (HydratedCubit storage) - this is the primary storage now
                try {
                  AuthCubit? authCubit;
                  try {
                    authCubit = GetIt.I<AuthCubit>();
                  } catch (e) {
                    // AuthCubit not registered - register it now as singleton
                    debugPrint(
                      '⚠️ AuthCubit not in GetIt, registering manually...',
                    );
                    authCubit = AuthCubit();
                    GetIt.instance.registerSingleton<AuthCubit>(authCubit);
                    debugPrint(
                      '✅ AuthCubit manually registered',
                    );
                  }

                  // Save token - this will update the state immediately
                  // Also save WooCommerce-specific tokens as metadata
                  await authCubit.saveJwtToken(
                    jwtToken: jwtTokenString,
                    userData: response.data!.user?.toJson(),
                    metadata: {
                      'wooJwtToken': wooJwtToken.toJson(),
                      // Cart token will be added by cart interceptor
                    },
                  );
                  debugPrint(
                    '✅ AuthCubit: JWT token saved and state updated',
                  );
                } catch (e) {
                  debugPrint(
                    '⚠️ AuthCubit: Error saving token to AuthCubit: $e',
                  );
                  // Continue anyway - tokens saved to other storages
                }

                debugPrint(
                  '✅ Sign in successful - Tokens saved to all storages including AuthCubit',
                );
                return true;
              } else {
                debugPrint('❌ JWT token not found in response');
                return false;
              }
            } else {
              debugPrint(
                '❌ Sign in failed: ${response.message ?? response.error}',
              );
              return false;
            }
          } catch (e) {
            debugPrint('❌ Sign in error: $e');
            return false;
          }
        }

        // Handle sign up with auth service
        Future<bool> handleSignUp(
          String email,
          String password,
          bool marketingConsent,
        ) async {
          try {
            debugPrint('🔐 Starting sign up for user: $email');

            // Get brand name and store URL from app_config.json
            final configHelper = AssetConfigHelper();
            await configHelper.loadConfig('assets/app_config.json');

            final storeUrl = configHelper.getString(
              'woocommerce_configuration.store_url',
              'http://your_store_url.com',
            );

            var brandName = configHelper.getString(
              'woocommerce_configuration.brand_name',
              '',
            );

            if (brandName.isEmpty) {
              brandName = extractBrandNameFromUrl(storeUrl);
            }

            debugPrint('🏪 Using brand name: $brandName');
            debugPrint('🌐 Store URL: $storeUrl');
            debugPrint('📧 User email: $email');

            // Get WooAuthService from GetIt
            final authService = GetIt.I<WooAuthService>();

            // Get AUTH_KEY from config (required by API)
            final authKey = configHelper.getString(
              'woocommerce_configuration.auth_key',
              'default_auth_key',
            );

            // Extract first and last name from email
            final emailParts = email.split('@');
            final username = emailParts.isNotEmpty ? emailParts.first : 'User';

            // Create sign up request
            final signUpRequest = UserSignUpRequest(
              email: email,
              password: password,
              firstName: username,
              lastName: 'User',
              authKey: authKey,
              userMeta: UserMeta(
                acceptTerms: true,
                subscribeNewsletter: marketingConsent,
              ),
            );

            // Call API
            final response = await authService.userSignUp(
              brandName,
              signUpRequest,
            );

            debugPrint('🔍 API response received: ${response.success}');
            debugPrint('📦 Response data: ${response.data}');
            debugPrint('📝 Response message: ${response.message}');

            // Check if user was successfully created
            final messageContainsSuccess = response.message != null &&
                (response.message!.toLowerCase().contains(
                          'successfully created',
                        ) ||
                    response.message!.toLowerCase().contains(
                          'created successfully',
                        ));

            if (response.success || messageContainsSuccess) {
              debugPrint('✅ Sign up successful!');
              if (response.data != null) {
                debugPrint('👤 User ID: ${response.data!.userId}');
                debugPrint('📧 Email: ${response.data!.email}');
              }
              return true;
            } else {
              debugPrint(
                '❌ Sign up failed: ${response.message ?? response.error}',
              );
              return false;
            }
          } catch (e) {
            debugPrint('❌ Sign up error: $e');
            return false;
          }
        }

        return AuthView(
          goRoute: (String path) {
            if (path.contains(Routes.home.name)) {
              context.go('/home');
            }
          },
          initialTab: initialTab,
          defaultRedirectPath:
              '/profile', // Default redirect path after successful sign in
          onSignInSuccess: () async {
            debugPrint('✅ Sign in successful! Navigating...');

            // Check AuthCubit state immediately
            try {
              final authCubit = GetIt.I<AuthCubit>();
              debugPrint(
                  '🔍 onSignInSuccess: AuthCubit state = ${authCubit.state.runtimeType}');
              if (authCubit.state is AuthAuthenticatedState) {
                final authState = authCubit.state as AuthAuthenticatedState;
                debugPrint(
                    '🔍 onSignInSuccess: isAuthenticated = ${authState.isAuthenticated}');
                debugPrint(
                    '🔍 onSignInSuccess: jwtToken exists = ${authState.jwtToken != null}');
              }
            } catch (e) {
              debugPrint('⚠️ Could not check AuthCubit state: $e');
            }

            // Small delay to ensure UI updates
            await Future.delayed(const Duration(milliseconds: 300));

            if (!context.mounted) return;

            // Check if there's a return path
            final returnTo = state.uri.queryParameters['returnTo'];
            if (returnTo != null && returnTo.isNotEmpty) {
              debugPrint('🔄 Navigating to return path: $returnTo');
              context.go(returnTo);
            } else {
              // Navigate to profile after successful sign in
              const defaultPath = '/profile';
              debugPrint('👤 Navigating to profile page: $defaultPath');
              context.go(defaultPath);
            }
          },
          onSignInError: (error) {
            debugPrint('❌ Sign in error: $error');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error), backgroundColor: Colors.red),
            );
          },
          onSignUpSuccess: () {
            debugPrint('✅ Sign up successful!');
            // After successful registration, switch to Sign In tab
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '✅ Account created successfully! You can sign in now.',
                ),
                backgroundColor: Colors.green,
              ),
            );
            context.go('/auth?tab=0'); // Switch to Sign In tab
          },
          onSignUpError: (error) {
            debugPrint('❌ Sign up error: $error');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error), backgroundColor: Colors.red),
            );
          },
          onForgotPasswordTap: () {
            debugPrint('🔑 Forgot password tapped');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Password reset feature coming soon!'),
                backgroundColor: Colors.blue,
                duration: Duration(seconds: 2),
              ),
            );
          },
          arguments: {
            'auth': true,
            'onSignIn': handleSignIn,
            'onSignUp': handleSignUp,
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
      builder: (BuildContext context, GoRouterState state) {
        return BlocProvider<ProfileViewModel>(
          create: (context) => GetIt.I<ProfileViewModel>(),
          child: BlocBuilder<WishlistViewModel, WishlistState>(
            bloc: GetIt.I<WishlistViewModel>(),
            builder: (context, wishlistState) {
              return ProfileView(
                goRoute: (String path) {
                  if (path.contains('home')) {
                    context.go('/home');
                  } else {
                    context.go('/home');
                  }
                },
                bottomNavigationBar: _getNavbarForRoute(
                  state.uri.path,
                  GetIt.I<WishlistViewModel>().count,
                ),
              );
            },
          ),
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
  ],
);

/// Get navbar for specific route
/// Navbar indexes: 0=Home, 1=Search, 2=Saved, 3=Cart, 4=Profile/Sign In
Widget? _getNavbarForRoute(String location, int wishlistCount) {
  // Show navbar only for main app sections
  if (location == '/home' ||
      location == '/cart' ||
      location == '/saved' ||
      location == '/search' ||
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
