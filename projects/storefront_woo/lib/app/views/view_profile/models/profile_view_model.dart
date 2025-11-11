/*
 * ProfileViewModel
 * ----------------
 * ViewModel for profile view to manage user authentication status and tokens.
 */

import 'package:flutter/foundation.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';
import 'package:apis/apis.dart';
import 'package:apis/dio_config/dio_client/api_dio_client.dart';
import 'package:storefront_woo/app/views/view_profile/models/module/states.dart';

@injectable
class ProfileViewModel extends BaseViewModelHydratedCubit<ProfileState> {
  ProfileViewModel() : super(ProfileInitialState());

  WooJwtToken? _jwtToken;
  WooCartToken? _cartToken;
  String? _authJwtToken;
  Map<String, dynamic>? _authUserData;

  // Arguments holder for route/widget inputs
  final Map<String, dynamic> _arguments = {};
  void setArguments(Map<String, dynamic> args) {
    _arguments
      ..clear()
      ..addAll(args);
  }

  Map<String, dynamic> get arguments => Map.unmodifiable(_arguments);

  WooJwtToken? get jwtToken => _jwtToken;
  WooCartToken? get cartToken => _cartToken;
  String? get authJwtToken => _authJwtToken;
  Map<String, dynamic>? get authUserData => _authUserData;

  Future<void> loadProfile() async {
    try {
      debugPrint('🔄 ProfileViewModel: loadProfile() called');
      emit(ProfileLoadingState());

      // Get data from AuthCubit only (no double query - AuthCubit already uses AuthStorageHelper)
      String? authJwtToken;
      Map<String, dynamic>? authUserData;
      bool isAuthenticatedFromCubit = false;

      try {
        final authCubit = GetIt.I<AuthCubit>();
        debugPrint('🔍 ProfileViewModel: Checking AuthCubit state...');
        debugPrint(
          '🔍 ProfileViewModel: AuthCubit state = ${authCubit.state.runtimeType}',
        );

        // Wait for AuthCubit state to be AuthAuthenticatedState if it's not yet
        // This handles the case where ProfileView loads before AuthCubit state is updated after signin
        if (authCubit.state is! AuthAuthenticatedState) {
          debugPrint('⏳ ProfileViewModel: Waiting for AuthCubit to be authenticated...');
          // Wait up to 2 seconds for AuthCubit state to update
          for (int i = 0; i < 20; i++) {
            await Future.delayed(const Duration(milliseconds: 100));
            if (authCubit.state is AuthAuthenticatedState) {
              debugPrint('✅ ProfileViewModel: AuthCubit state updated to AuthAuthenticatedState');
              break;
            }
          }
        }

        if (authCubit.state is AuthAuthenticatedState) {
          final authState = authCubit.state as AuthAuthenticatedState;
          authJwtToken = authState.jwtToken;
          authUserData = authState.userData;
          isAuthenticatedFromCubit = true;
          debugPrint('✅ ProfileViewModel: Got JWT from AuthCubit');
        } else {
          isAuthenticatedFromCubit = false;
          debugPrint(
            '⚠️ ProfileViewModel: AuthCubit not authenticated - user is signed out (state: ${authCubit.state.runtimeType})',
          );
          // User is not authenticated, set tokens to null
          authJwtToken = null;
          authUserData = null;
        }
      } catch (e) {
        isAuthenticatedFromCubit = false;
        debugPrint('⚠️ ProfileViewModel: AuthCubit not available: $e');
        authJwtToken = null;
        authUserData = null;
      }

      // Ensure the UI never shows a stale JWT if cubit is unauthenticated
      if (!isAuthenticatedFromCubit) {
        authJwtToken = null;
        debugPrint(
          '🔒 ProfileViewModel: Force-cleared displayed JWT due to unauthenticated state',
        );
      }

      // If not authenticated, proactively clear platform tokens to avoid showing stale data
      final isCurrentlyAuthenticated = isAuthenticatedFromCubit;
      if (!isCurrentlyAuthenticated) {
        try {
          await WooJwtTokenStorage.clearToken();
          debugPrint(
            '✅ ProfileViewModel: Cleared WooJWT token (unauthenticated)',
          );
        } catch (e) {
          debugPrint(
            '⚠️ ProfileViewModel: Failed to clear WooJWT token (unauthenticated): $e',
          );
        }
        try {
          await WooCartTokenStorage.clearCartToken();
          debugPrint(
            '✅ ProfileViewModel: Cleared WooCartToken (unauthenticated)',
          );
        } catch (e) {
          debugPrint(
            '⚠️ ProfileViewModel: Failed to clear WooCartToken (unauthenticated): $e',
          );
        }
      }

      // No need to load WooCommerce JWT token - we only use Core Auth JWT (single source of truth)
      // Core Auth JWT is managed by AuthCubit and AuthStorageHelper

      // Load cart token only when authenticated to avoid immediate regeneration after sign-out
      WooCartToken? cartToken;
      try {
        if (isCurrentlyAuthenticated) {
          cartToken = await WooCartTokenStorage.loadCartToken();
          debugPrint(
            '🛒 ProfileViewModel: Cart token loaded: ${cartToken != null ? "Available" : "Not available"}',
          );
        } else {
          cartToken = null;
          debugPrint(
            '🛒 ProfileViewModel: Skipping cart token load (user unauthenticated)',
          );
        }
      } catch (e) {
        debugPrint('⚠️ ProfileViewModel: Could not load WooCartToken: $e');
        // Cart token is automatically handled by WooCartTokenInterceptor
        // No need for fallback - interceptor manages token lifecycle
      }

      // Clear WooCommerce JWT token (not used anymore - single JWT source)
      _jwtToken = null;
      _authJwtToken = authJwtToken;
      _authUserData = authUserData;
      _cartToken = cartToken;

      // Authentication status should only be based on AuthCubit state
      // Single JWT token source (Core Auth JWT managed by AuthCubit)
      final isAuthenticated = isAuthenticatedFromCubit;

      emit(
        ProfileLoadedState(
          jwtToken: null, // No longer using WooCommerce JWT
          cartToken: cartToken,
          authJwtToken: authJwtToken,
          authUserData: authUserData,
          isAuthenticated: isAuthenticated,
        ),
      );
    } catch (e) {
      debugPrint('❌ Error loading profile: $e');
      emit(ProfileErrorState(message: 'Failed to load profile: $e'));
    }
  }

  Future<void> refreshProfile() async {
    await loadProfile();
  }

  Future<void> signOut() async {
    try {
      debugPrint('🚪 ProfileViewModel: Starting sign out process...');

      // Step 1: Clear all platform-specific tokens FIRST
      try {
        await WooJwtTokenStorage.clearToken();
        debugPrint('✅ ProfileViewModel: WooJWT token cleared');
      } catch (e) {
        debugPrint('⚠️ ProfileViewModel: Failed to clear WooJWT token: $e');
      }

      try {
        await WooCartTokenStorage.clearCartToken();
        debugPrint('✅ ProfileViewModel: WooCartToken cleared');
      } catch (e) {
        debugPrint('⚠️ ProfileViewModel: Failed to clear WooCartToken: $e');
      }

      // Step 2: Sign out from AuthCubit - this will:
      // - Clear AuthStorageHelper (Core JWT token and userData)
      // - Emit AuthUnauthenticatedState
      // - Clear HydratedCubit persistence
      try {
        final authCubit = GetIt.I<AuthCubit>();
        // Clear form state (email and password) first
        authCubit.resetForm();
        // Sign out from AuthCubit - this handles all Core token clearing
        await authCubit.signOut();
        debugPrint('✅ ProfileViewModel: AuthCubit sign out completed');

        // Small delay to ensure state propagation
        await Future.delayed(const Duration(milliseconds: 50));

        // Verify AuthCubit state is unauthenticated
        if (authCubit.state is AuthUnauthenticatedState) {
          debugPrint(
            '✅ ProfileViewModel: AuthCubit state confirmed as unauthenticated',
          );
        } else {
          debugPrint(
            '⚠️ ProfileViewModel: AuthCubit state is ${authCubit.state.runtimeType}, expected AuthUnauthenticatedState',
          );
          // Try signOut again if state is not correct
          try {
            await authCubit.signOut();
            debugPrint('✅ ProfileViewModel: Retried AuthCubit signOut');
          } catch (e2) {
            debugPrint('⚠️ ProfileViewModel: Retry signOut failed: $e2');
          }
        }
      } catch (e) {
        debugPrint('⚠️ ProfileViewModel: Could not update AuthCubit: $e');
        // Even if AuthCubit fails, try to sign out again
        try {
          final authCubit = GetIt.I<AuthCubit>();
          await authCubit.signOut();
          debugPrint(
            '✅ ProfileViewModel: Retried AuthCubit signOut after error',
          );
        } catch (e2) {
          debugPrint(
            '⚠️ ProfileViewModel: Could not retry AuthCubit signOut: $e2',
          );
        }
      }

      // Defensive clean-up: ensure platform tokens are cleared after sign-out
      try {
        await WooJwtTokenStorage.clearToken();
        debugPrint('✅ ProfileViewModel: Post-signout WooJWT token cleared');
      } catch (e) {
        debugPrint(
          '⚠️ ProfileViewModel: Post-signout failed to clear WooJWT token: $e',
        );
      }

      try {
        await WooCartTokenStorage.clearCartToken();
        debugPrint('✅ ProfileViewModel: Post-signout WooCartToken cleared');
      } catch (e) {
        debugPrint(
          '⚠️ ProfileViewModel: Post-signout failed to clear WooCartToken: $e',
        );
      }

      // Step 3: Clear all cookies (WP cookies: wordpress_logged_in_, woocommerce_items_in_cart, wp_woocommerce_session_)
      try {
        await ApiDioClient.clearAllCookies();
        debugPrint(
          '✅ ProfileViewModel: All cookies cleared (including WP cookies)',
        );
      } catch (e) {
        debugPrint('⚠️ ProfileViewModel: Failed to clear cookies: $e');
      }

      // Step 4: Clear local state variables
      _jwtToken = null;
      _cartToken = null;
      _authJwtToken = null;
      _authUserData = null;

      debugPrint('✅ ProfileViewModel: Sign out completed successfully');

      // Step 4: Emit signed out state - ProfileView will handle navigation
      emit(ProfileSignedOutState());
    } catch (e) {
      debugPrint('❌ ProfileViewModel: Error signing out: $e');
      emit(ProfileErrorState(message: 'Failed to sign out: $e'));
    }
  }

  @override
  ProfileState? fromJson(Map<String, dynamic> json) => null;

  @override
  Map<String, dynamic>? toJson(ProfileState state) => null;
}
