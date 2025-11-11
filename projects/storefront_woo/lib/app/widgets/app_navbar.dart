/*
 * AppNavbar
 * ---------
 * Centralized navigation bar for the storefront app.
 * Provides consistent navigation across all views.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Centralized navigation bar widget
class AppNavbar extends StatefulWidget {
  final int currentIndex;
  final Function(int)? onItemTap;
  final int wishlistCount;

  const AppNavbar({
    super.key,
    required this.currentIndex,
    this.onItemTap,
    this.wishlistCount = 0,
  });

  @override
  State<AppNavbar> createState() => _AppNavbarState();
}

class _AppNavbarState extends State<AppNavbar> {
  bool _isAuthenticated = false;
  bool _isLoading = true;
  DateTime? _lastAuthCheck;
  static const Duration _authCheckInterval = Duration(
    seconds: 10,
  ); // Check every 10 seconds instead of every build

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
    // Set up periodic check (only once)
    _schedulePeriodicCheck();
  }

  void _schedulePeriodicCheck() {
    // Only check periodically if needed (not on every build)
    Future.delayed(_authCheckInterval, () {
      if (mounted) {
        final now = DateTime.now();
        // Only check if enough time has passed
        if (_lastAuthCheck == null ||
            now.difference(_lastAuthCheck!) >= _authCheckInterval) {
          _checkAuthStatus();
        }
        // Schedule next check
        _schedulePeriodicCheck();
      }
    });
  }

  Future<void> _checkAuthStatus() async {
    try {
      // Check auth status - use direct token check to bypass cache if needed
      final authHelper = AuthStorageHelper();

      // First check token directly (bypasses cache)
      final token = await authHelper.getToken();
      final hasToken = token != null && token.isNotEmpty;

      // If token exists, verify it's not expired
      bool isAuthenticated = false;
      if (hasToken) {
        // Use isAuthenticated which checks expiry
        isAuthenticated = await authHelper.isAuthenticated();
      }

      if (mounted) {
        setState(() {
          _isAuthenticated = isAuthenticated;
          _isLoading = false;
          _lastAuthCheck = DateTime.now();
        });
      }
    } catch (e) {
      debugPrint('❌ Error checking auth status in navbar: $e');
      if (mounted) {
        setState(() {
          _isAuthenticated = false;
          _isLoading = false;
          _lastAuthCheck = DateTime.now();
        });
      }
    }
  }

  @override
  void didUpdateWidget(AppNavbar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if AuthCubit is available and force a state check
    try {
      final authCubit = GetIt.I<AuthCubit>();
      debugPrint(
        '📱 Navbar didUpdateWidget: AuthCubit state = ${authCubit.state.runtimeType}',
      );
      if (authCubit.state is AuthAuthenticatedState) {
        final authState = authCubit.state as AuthAuthenticatedState;
        debugPrint(
          '📱 Navbar didUpdateWidget: isAuthenticated = ${authState.isAuthenticated}',
        );
      }
    } catch (e) {
      debugPrint('⚠️ Navbar didUpdateWidget: AuthCubit not available: $e');
    }

    // Always check auth status when widget updates (route changed or rebuild)
    // This ensures navbar updates immediately after sign in
    final now = DateTime.now();
    if (_lastAuthCheck == null ||
        now.difference(_lastAuthCheck!) >= const Duration(milliseconds: 500)) {
      // Check immediately if enough time passed (500ms to prevent excessive calls)
      _checkAuthStatus();
    }
  }

  bool _hasLoadedTokens = false; // Flag to prevent multiple loadTokens() calls

  @override
  Widget build(BuildContext context) {
    // Try to get AuthCubit from GetIt - if available, listen to it for real-time updates
    try {
      final authCubit = GetIt.I<AuthCubit>();

      // Listen to AuthCubit for real-time auth status updates
      return BlocBuilder<AuthCubit, AuthState>(
        bloc: authCubit,
        builder: (context, authState) {
          debugPrint(
            '📱 Navbar Builder: Building with state ${authState.runtimeType}',
          );

          // Determine authentication status
          // Only authenticated if state is AuthAuthenticatedState AND has valid JWT token
          final isAuthenticated = authState is AuthAuthenticatedState &&
              authState.isAuthenticated &&
              authState.jwtToken != null &&
              authState.jwtToken!.isNotEmpty;

          debugPrint('📱 Navbar Builder: isAuthenticated = $isAuthenticated');
          debugPrint('📱 Navbar Builder: State type = ${authState.runtimeType}');
          if (authState is AuthAuthenticatedState) {
            debugPrint('📱 Navbar Builder: JWT token = ${authState.jwtToken != null && authState.jwtToken!.isNotEmpty ? "Present" : "Missing"}');
          }

          // Update local state to keep it in sync with AuthCubit
          if (mounted && _isAuthenticated != isAuthenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _isAuthenticated = isAuthenticated;
                  _isLoading = false;
                });
                debugPrint('📱 Navbar: Local state updated to match AuthCubit');
              }
            });
          }

          // Only trigger initial load once if state is initial (not unauthenticated)
          // Don't load tokens if user just signed out (AuthUnauthenticatedState)
          // Prevent infinite loop by checking if we've already loaded
          if (!_hasLoadedTokens && authState is AuthInitialState) {
            _hasLoadedTokens =
                true; // Mark as loaded to prevent multiple calls
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                debugPrint('📱 Navbar: Loading tokens from storage...');
                authCubit.loadTokens();
              }
            });
          }

          // If state is AuthAuthenticatedState but jwtToken is null/empty, 
          // this means state was restored from persistence but token was cleared
          // Call loadTokens() once to sync state with storage
          if (authState is AuthAuthenticatedState) {
            final authStateTyped = authState;
            // If jwtToken is null/empty, state is invalid - need to sync with storage
            if ((authStateTyped.jwtToken == null || authStateTyped.jwtToken!.isEmpty) && !_hasLoadedTokens) {
              _hasLoadedTokens = true; // Mark as loaded to prevent multiple calls
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  debugPrint('📱 Navbar: AuthAuthenticatedState has no jwtToken, syncing with storage...');
                  authCubit.loadTokens();
                }
              });
            } else if (authStateTyped.jwtToken != null && authStateTyped.jwtToken!.isNotEmpty) {
              // Valid authenticated state - allow reload if needed later
              _hasLoadedTokens = false;
            }
          }

          // Reset flag if we transition from authenticated to unauthenticated (signout)
          // This prevents loadTokens() from being called after signout
          if (authState is AuthUnauthenticatedState) {
            _hasLoadedTokens =
                true; // Mark as loaded to prevent loadTokens() after signout
            debugPrint('📱 Navbar: User signed out - state is AuthUnauthenticatedState');
          }

          return _buildNavbar(context, isAuthenticated);
          },
        );
    } catch (e) {
      // Fallback to AuthStorageHelper if AuthCubit not available
      debugPrint(
        '⚠️ AuthCubit not available in GetIt, using AuthStorageHelper: $e',
      );

      // Always check auth status on build (especially after navigation from sign in)
      final now = DateTime.now();
      if (_lastAuthCheck == null ||
          now.difference(_lastAuthCheck!) >=
              const Duration(milliseconds: 500)) {
        // Check auth status if enough time passed (500ms to prevent excessive calls)
        _checkAuthStatus();
      }

      // Use cached value during loading
      if (_isLoading) {
        return FutureBuilder<bool>(
          future: AuthStorageHelper().isAuthenticated(),
          builder: (context, snapshot) {
            final isAuthenticated = snapshot.data ?? false;
            if (snapshot.hasData) {
              // Update state once
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && _isLoading) {
                  setState(() {
                    _isAuthenticated = isAuthenticated;
                    _isLoading = false;
                    _lastAuthCheck = DateTime.now();
                  });
                }
              });
            }
            return _buildNavbar(context, isAuthenticated);
          },
        );
      }

      return _buildNavbar(context, _isAuthenticated);
    }
  }

  Widget _buildNavbar(BuildContext context, bool isAuthenticated) {
    return OsmeaComponents.navbar(
      variant: NavbarVariant.transparent,
      size: NavbarSize.medium,
      position: NavbarPosition.bottom,
      currentIndex: widget.currentIndex,
      borderColor: OsmeaColors.silver,
      elevation: .5,
      backgroundColor: OsmeaColors.white,
      items: _getNavbarItems(context, isAuthenticated),
      onItemTap:
          widget.onItemTap ??
          (index) => _navigateToPage(context, index, isAuthenticated),
    );
  }

  /// Get navbar items (5 items: Home, Search, Saved, Cart, Profile/Sign In)
  List<NavbarItem> _getNavbarItems(BuildContext context, bool isAuthenticated) {
    final count = widget.wishlistCount;

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
        icon: Icon(count > 0 ? Icons.favorite : Icons.favorite_outline),
        onTap: () => context.go('/saved'),
        tooltip: 'Saved Items',
      ),
      NavbarItem(
        text: 'Cart',
        icon: Icon(Icons.shopping_cart_outlined),
        onTap: () => context.go('/cart'),
        tooltip: 'Shopping Cart',
      ),
      NavbarItem(
        text: isAuthenticated ? 'Profile' : 'Sign In',
        icon: Icon(
          isAuthenticated ? Icons.person_outline : Icons.login_outlined,
        ),
        onTap: () {
          if (isAuthenticated) {
            // Navigate to profile page
            context.go('/profile');
          } else {
            // Navigate to sign in page
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
          // Navigate to profile page
          context.go('/profile');
        } else {
          // Navigate to sign in page
          context.go('/auth');
        }
        break;
    }
  }
}
