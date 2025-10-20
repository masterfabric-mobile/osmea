import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_home/home_view.dart';
import 'package:storefront_woo/app/views/view_product_detail/product_detail_view.dart';
import 'package:apis/network/remote/woocommerce/auth/abstract/woo_auth_service.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/request/user_login_request.dart';
import 'package:get_it/get_it.dart';

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
            // Check user authentication status
            final authStorage = AuthStorageHelper();
            authStorage.isAuthenticated().then((isAuthenticated) {
              if (isAuthenticated) {
                debugPrint('👤 User already authenticated, navigating to home');
                context.go('/home');
              } else {
                // User not authenticated, follow normal flow
                if (path.contains(Routes.home.name)) {
                  context.go('/sign-in'); // Redirect to sign in first
                } else if (path.contains(Routes.onboarding.name)) {
                  context.go('/onboarding');
                } else if (path.contains(Routes.signIn.name)) {
                  context.go('/sign-in');
                } else {
                  // Default: onboarding then sign-in
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
              context.go('/sign-in');
            } else {
              context.go('/sign-in'); // Default to sign in
            }
          },
          onCompleted: () {
            debugPrint('🎉 Onboarding completed!');
            context.go('/sign-in');
          },
          onSkipped: () {
            debugPrint('⏭️ Onboarding skipped!');
            context.go('/sign-in');
          },
          onError: (error) {
            debugPrint('❌ Onboarding error: $error');
            context.go('/sign-in');
          },
        );
      },
    ),

    // Sign In Route
    GoRoute(
      path: '/sign-in',
      builder: (BuildContext context, GoRouterState state) {
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
              final jwtToken = response.data!.jwt ?? response.data!.accessToken;

              if (jwtToken != null && jwtToken.isNotEmpty) {
                // Save token to storage
                final authStorage = AuthStorageHelper();
                await authStorage.saveToken(jwtToken);

                // Save user data
                if (response.data!.user != null) {
                  await authStorage.saveUserData(response.data!.user!.toJson());
                }

                debugPrint('✅ Sign in successful - Token saved');
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

        return SignInView(
          goRoute: (String path) {
            if (path.contains(Routes.home.name)) {
              context.go('/home');
            }
          },
          onSignInSuccess: () {
            debugPrint('✅ Sign in successful!');
            context.go('/home');
          },
          onSignInError: (error) {
            debugPrint('❌ Sign in error: $error');
            // Show error message to user
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error), backgroundColor: Colors.red),
            );
          },
          arguments: {'sign_in': true, 'onSignIn': handleSignIn},
        );
      },
    ),

    // Home Page - Show products directly
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return HomeView(
          arguments: const {'home': true},
          goRoute: (String path) {
            if (path.contains('products')) {
              context.go('/products');
            } else if (path.contains('product-detail')) {
              context.go('/product-detail');
            } else {
              context.go('/home');
            }
          },
        );
      },
    ),

    // Product Detail Route
    GoRoute(
      path: '/product-detail/:productId',
      builder: (BuildContext context, GoRouterState state) {
        final productId = int.tryParse(
          state.pathParameters['productId'] ?? '0',
        );
        return ProductDetailView(
          productId: productId ?? 0,
          arguments: const {'productDetail': true},
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
  ],
);
