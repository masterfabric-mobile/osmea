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

      try {
        final authCubit = GetIt.I<AuthCubit>();
        debugPrint('🔍 ProfileViewModel: Checking AuthCubit state...');
        debugPrint(
            '🔍 ProfileViewModel: AuthCubit state = ${authCubit.state.runtimeType}');

        if (authCubit.state is AuthAuthenticatedState) {
          final authState = authCubit.state as AuthAuthenticatedState;
          authJwtToken = authState.jwtToken;
          authUserData = authState.userData;
          debugPrint('✅ ProfileViewModel: Got JWT from AuthCubit');
        } else {
          debugPrint(
              '⚠️ ProfileViewModel: AuthCubit not authenticated - user is signed out');
          // User is not authenticated, set tokens to null
          authJwtToken = null;
          authUserData = null;
        }
      } catch (e) {
        debugPrint(
            '⚠️ ProfileViewModel: AuthCubit not available: $e');
        authJwtToken = null;
        authUserData = null;
      }

      // No need to load WooCommerce JWT token - we only use Core Auth JWT (single source of truth)
      // Core Auth JWT is managed by AuthCubit and AuthStorageHelper

      // Load cart token using WooCartTokenStorage (returns WooCartToken object)
      WooCartToken? cartToken;
      try {
        cartToken = await WooCartTokenStorage.loadCartToken();
        debugPrint(
          '🛒 ProfileViewModel: Cart token loaded: ${cartToken != null ? "Available" : "Not available"}',
        );
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
      final isAuthenticated = authJwtToken != null && authJwtToken.isNotEmpty;

      emit(ProfileLoadedState(
        jwtToken: null, // No longer using WooCommerce JWT
        cartToken: cartToken,
        authJwtToken: authJwtToken,
        authUserData: authUserData,
        isAuthenticated: isAuthenticated,
      ));
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
      debugPrint('🚪 Starting sign out process...');
      
      // Step 1: Clear all storage tokens FIRST (before updating AuthCubit state)
      // This prevents any race conditions or token reloading
      try {
        await WooJwtTokenStorage.clearToken();
        debugPrint('✅ WooJWT token cleared');
      } catch (e) {
        debugPrint('⚠️ Failed to clear WooJWT token: $e');
      }

      try {
        await WooCartTokenStorage.clearCartToken();
        debugPrint('✅ WooCartToken cleared');
      } catch (e) {
        debugPrint('⚠️ Failed to clear WooCartToken: $e');
      }

      try {
        final authStorage = AuthStorageHelper();
        await authStorage.clearToken(); // This clears both token and userData
        debugPrint('✅ AuthStorageHelper tokens and userData cleared');
      } catch (e) {
        debugPrint('⚠️ Failed to clear AuthStorageHelper: $e');
      }

      // Step 2: Update AuthCubit state AFTER clearing storage
      // This ensures state matches storage (no tokens = unauthenticated)
      try {
        final authCubit = GetIt.I<AuthCubit>();
        // Clear form state (email and password) first
        authCubit.resetForm();
        // Sign out from AuthCubit - this will emit AuthUnauthenticatedState
        await authCubit.signOut();
        debugPrint('✅ AuthCubit state updated to unauthenticated');
      } catch (e) {
        debugPrint('⚠️ Could not update AuthCubit: $e');
      }

      // Step 3: Clear local state variables
      _jwtToken = null; // WooCommerce JWT (not used, but clear for safety)
      _cartToken = null;
      _authJwtToken = null;
      _authUserData = null;

      // Step 4: Cart token is cleared - no need to create new one
      // New cart token will be created automatically on next cart API call
      debugPrint('🛒 Cart token cleared - new token will be created on next cart operation');

      debugPrint('✅ Sign out completed successfully');
      // Emit signed out state - ProfileView will handle navigation
      emit(ProfileSignedOutState());
    } catch (e) {
      debugPrint('❌ Error signing out: $e');
      emit(ProfileErrorState(message: 'Failed to sign out: $e'));
    }
  }

  @override
  ProfileState? fromJson(Map<String, dynamic> json) => null;

  @override
  Map<String, dynamic>? toJson(ProfileState state) => null;
}
