import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:storefront_woo/app/views/view_home/home_view.dart';
import 'package:storefront_woo/app/views/view_product_detail/product_detail_view.dart';
import 'package:storefront_woo/app/views/view_product_list/product_list_view.dart';
import 'package:storefront_woo/app/views/view_cart/cart_view.dart';
import 'package:storefront_woo/app/views/view_wishlist/wishlist_view.dart';
import 'package:storefront_woo/app/views/view_search/widgets/search_results_grid_widget.dart';
import 'package:storefront_woo/app/views/view_search/widgets/search_empty_state_widget.dart';
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
          bottomNavigationBar: _getNavbarForRoute(
            state.uri.path,
          ),
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
              child: SearchView(
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
                searchHint: 'Search for products...',
                showBackButton: true,
                showTitle: false,
                onBackPressed: () => context.go('/home'),

                // WooCommerce search provider
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

                // Custom result builder for product grid
                resultBuilder: (context, results) {
                  return SearchResultsGridWidget(products: results);
                },

                // Empty state with categories and brands
                emptyStateBuilder: (context) {
                  // Get SearchCubit from context to enable category/brand search
                  final searchCubit = context.read<SearchCubit>();
                  return SearchEmptyStateWidget(searchCubit: searchCubit);
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
            return CustomTransitionPage(
              child: ProductListView(
                arguments: const {'products': true},
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

    // Profile Route (using AccountView from core package)
    GoRoute(
      path: '/profile',
      pageBuilder: (BuildContext context, GoRouterState state) {
        // Get AccountCubit and AuthCubit for platform-specific auth state listening
        final accountCubit = GetIt.I<AccountCubit>();
        final authCubit = GetIt.I<AuthCubit>();

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
                  accountCubit.refreshProfile();
                });
              }
            },
            child: AccountView(
              arguments: const {'account': true},
              goRoute: (String path) {
                debugPrint('🔀 AccountView: goRoute called with path: $path');
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
                // Platform-specific cleanup: cookies, wishlist, cart tokens
                debugPrint('🚪 Route: Starting platform-specific cleanup...');

                // Step 1: Clear WooCommerce JWT token
                try {
                  await WooJwtTokenStorage.clearToken();
                  debugPrint('✅ Route: WooJWT token cleared');
                } catch (e) {
                  debugPrint('⚠️ Route: Failed to clear WooJWT token: $e');
                }

                // Step 2: Clear cart token
                try {
                  await WooCartTokenStorage.clearCartToken();
                  debugPrint('✅ Route: WooCartToken cleared');
                } catch (e) {
                  debugPrint('⚠️ Route: Failed to clear WooCartToken: $e');
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
                  final wishlistViewModel = GetIt.I<WishlistViewModel>();
                  wishlistViewModel.clearAll();
                  debugPrint('✅ Route: Wishlist cleared');
                } catch (e) {
                  debugPrint('⚠️ Route: Failed to clear wishlist: $e');
                }

                debugPrint('✅ Route: Platform-specific cleanup completed');

                // Step 5: Navigate to home after sign out
                await Future.delayed(const Duration(milliseconds: 300));
                if (context.mounted) {
                  debugPrint('🔀 Route: Navigating to /home after sign out...');
                  context.go('/home');
                  debugPrint('✅ Route: Navigation to /home completed');
                } else {
                  debugPrint('⚠️ Route: Context not mounted, cannot navigate');
                }
              },
              bottomNavigationBar: _getNavbarForRoute(
                state.uri.path,
              ),
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
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
        final loadingTypeStr = state.pathParameters['loadingType'] ?? 'general';
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
            loadingPageModel: customTitle != null || customDescription != null
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
Widget? _getNavbarForRoute(String location) {
  // Show navbar only for main app sections
  if (location == '/home' ||
      location == '/search' ||
      location == '/cart' ||
      location == '/saved' ||
      location == '/profile') {
    int currentIndex = 0;
    if (location == '/home') {
      currentIndex = 0;
    } else if (location == '/search') {
      currentIndex = 1;
    } else if (location == '/saved') {
      currentIndex = 2;
    } else if (location == '/cart') {
      currentIndex = 3;
    } else if (location == '/profile') {
      currentIndex = 4;
    }

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

                  return OsmeaComponents.navbar(
                    variant: NavbarVariant.transparent,
                    size: NavbarSize.medium,
                    position: NavbarPosition.bottom,
                    currentIndex: currentIndex,
                    borderColor: OsmeaColors.silver,
                    elevation: .5,
                    backgroundColor: OsmeaColors.white,
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

              return OsmeaComponents.navbar(
                variant: NavbarVariant.transparent,
                size: NavbarSize.medium,
                position: NavbarPosition.bottom,
                currentIndex: currentIndex,
                borderColor: OsmeaColors.silver,
                elevation: .5,
                backgroundColor: OsmeaColors.white,
                items: items,
                onItemTap: (index) =>
                    _navigateToPage(context, index, isAuthenticated),
              );
            }
          },
        );
      },
    );
  }
  // No navbar for splash, onboarding, auth, product-detail, products
  return null;
}

/// Build navbar items based on authentication status
List<NavbarItem> _buildNavbarItems(
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
        filledColor: OsmeaColors.nordicBlue,
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

/// Navigate to page based on index
void _navigateToPage(BuildContext context, int index, bool isAuthenticated) {
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
  }
}
