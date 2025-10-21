import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_home/home_view.dart';
import 'package:storefront_woo/app/views/view_product_detail/product_detail_view.dart';
import 'package:apis/network/remote/woocommerce/auth/abstract/woo_auth_service.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/request/user_login_request.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/request/user_signup_request.dart';
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
                  context.go('/auth'); // Redirect to auth first
                } else if (path.contains(Routes.onboarding.name)) {
                  context.go('/onboarding');
                } else if (path.contains(Routes.signIn.name)) {
                  context.go('/auth');
                } else {
                  // Default: onboarding then auth
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
              context.go('/auth'); // Default to auth
            }
          },
          onCompleted: () {
            debugPrint('🎉 Onboarding completed!');
            context.go('/auth');
          },
          onSkipped: () {
            debugPrint('⏭️ Onboarding skipped!');
            context.go('/auth');
          },
          onError: (error) {
            debugPrint('❌ Onboarding error: $error');
            context.go('/auth');
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

        // Handle sign up with auth service
        Future<bool> handleSignUp(String email, String password) async {
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
              acceptTerms: true,
              subscribeNewsletter: false,
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
            final messageContainsSuccess =
                response.message != null &&
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
          onSignInSuccess: () {
            debugPrint('✅ Sign in successful!');
            context.go('/home');
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
          arguments: {
            'auth': true,
            'onSignIn': handleSignIn,
            'onSignUp': handleSignUp,
          },
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
