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
import 'package:storefront_woo/app/services/cart_token_storage.dart';
import 'package:storefront_woo/app/views/view_profile/models/module/states.dart';

@injectable
class ProfileViewModel extends BaseViewModelHydratedCubit<ProfileState> {
  ProfileViewModel() : super(ProfileInitialState());

  WooJwtToken? _jwtToken;
  WooCartToken? _cartToken;
  String? _authJwtToken;
  Map<String, dynamic>? _authUserData;

  WooJwtToken? get jwtToken => _jwtToken;
  WooCartToken? get cartToken => _cartToken;
  String? get authJwtToken => _authJwtToken;
  Map<String, dynamic>? get authUserData => _authUserData;

  Future<void> loadProfile() async {
    try {
      emit(ProfileLoadingState());

      // First, try to get data from AuthCubit (HydratedCubit)
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
              '⚠️ ProfileViewModel: AuthCubit not authenticated, loading from storage...');
          // Load from storage as fallback
          final authStorage = AuthStorageHelper();
          authJwtToken = await authStorage.getToken();
          authUserData = await authStorage.getUserData();
        }
      } catch (e) {
        debugPrint(
            '⚠️ ProfileViewModel: AuthCubit not available, loading from storage: $e');
        // Fallback to AuthStorageHelper
        final authStorage = AuthStorageHelper();
        authJwtToken = await authStorage.getToken();
        authUserData = await authStorage.getUserData();
      }

      // Load JWT token from WooCommerce storage
      final jwtToken = await WooJwtTokenStorage.loadToken();

      // Load cart token using WooCartTokenStorage (returns WooCartToken object)
      WooCartToken? cartToken;
      try {
        cartToken = await WooCartTokenStorage.loadCartToken();
        debugPrint(
          '🛒 ProfileViewModel: Cart token loaded: ${cartToken != null ? "Available" : "Not available"}',
        );
      } catch (e) {
        debugPrint('⚠️ ProfileViewModel: Could not load WooCartToken: $e');
        // Fallback to string-based CartTokenStorage
        final cartTokenString = await CartTokenStorage.loadCartToken();
        if (cartTokenString != null && cartTokenString.isNotEmpty) {
          // Create a basic WooCartToken from string
          final configHelper = AssetConfigHelper();
          await configHelper.loadConfig();
          final storeUrl = configHelper.getString(
            'woocommerce_configuration.store_url',
            'http://woocomm.store',
          );
          cartToken = WooCartToken(
            cartToken: cartTokenString,
            storeUrl: storeUrl,
            issuedAt: DateTime.now(),
          );
          debugPrint('🛒 ProfileViewModel: Created WooCartToken from string');
        }
      }

      _jwtToken = jwtToken;
      _authJwtToken = authJwtToken;
      _authUserData = authUserData;
      _cartToken = cartToken;

      final isAuthenticated = (jwtToken != null && !jwtToken.isExpired) ||
          (authJwtToken != null && authJwtToken.isNotEmpty);

      emit(ProfileLoadedState(
        jwtToken: jwtToken,
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
      // Clear all tokens
      await WooJwtTokenStorage.clearToken();
      await CartTokenStorage.clearCartToken();
      final authStorage = AuthStorageHelper();
      await authStorage.clearToken();

      // Update AuthCubit to refresh navbar immediately
      try {
        final authCubit = GetIt.I<AuthCubit>();
        await authCubit.signOut();
        debugPrint('✅ AuthCubit cleared for navbar update');
      } catch (e) {
        debugPrint('⚠️ Could not clear AuthCubit: $e');
      }

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
