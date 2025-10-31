/*
 * AuthDebugViewModel
 * -----------------
 * ViewModel for auth debug view to manage token loading state.
 */

import 'package:flutter/foundation.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:apis/models/auth/woo_jwt_token.dart';
import 'package:apis/models/cart/woo_cart_token.dart';
import 'package:apis/apis.dart';
import 'package:storefront_woo/app/views/view_auth_debug/models/module/states.dart';

@injectable
class AuthDebugViewModel
    extends BaseViewModelHydratedCubit<AuthDebugState> {
  AuthDebugViewModel() : super(AuthDebugInitialState());

  WooJwtToken? _jwtToken;
  WooCartToken? _cartToken;
  String? _authJwtToken;
  Map<String, dynamic>? _authUserData;

  WooJwtToken? get jwtToken => _jwtToken;
  WooCartToken? get cartToken => _cartToken;
  String? get authJwtToken => _authJwtToken;
  Map<String, dynamic>? get authUserData => _authUserData;

  Future<void> loadTokens() async {
    try {
      emit(AuthDebugLoadingState());

      // Load JWT token from WooCommerce storage
      final jwtToken = await WooJwtTokenStorage.loadToken();

      // Load JWT token from Core AuthStorageHelper
      final authStorage = AuthStorageHelper();
      final authJwtToken = await authStorage.getToken();
      final authUserData = await authStorage.getUserData();

      // Load cart token
      final cartToken = await WooCartTokenStorage.loadCartToken();

      _jwtToken = jwtToken;
      _authJwtToken = authJwtToken;
      _authUserData = authUserData;
      _cartToken = cartToken;

      emit(AuthDebugLoadedState(
        jwtToken: jwtToken,
        cartToken: cartToken,
        authJwtToken: authJwtToken,
        authUserData: authUserData,
      ));
    } catch (e) {
      debugPrint('❌ Error loading tokens: $e');
      emit(AuthDebugErrorState(message: 'Failed to load tokens: $e'));
    }
  }

  Future<void> refreshTokens() async {
    await loadTokens();
  }

  @override
  AuthDebugState? fromJson(Map<String, dynamic> json) => null;

  @override
  Map<String, dynamic>? toJson(AuthDebugState state) => null;
}

