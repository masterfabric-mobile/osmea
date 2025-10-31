/*
 * AuthDebugStates
 * ---------------
 * States for auth debug view.
 */

import 'package:apis/models/auth/woo_jwt_token.dart';
import 'package:apis/models/cart/woo_cart_token.dart';

/// Base state for auth debug view
abstract class AuthDebugState {}

/// Initial state
class AuthDebugInitialState extends AuthDebugState {}

/// Loading state
class AuthDebugLoadingState extends AuthDebugState {}

/// Loaded state with token data
class AuthDebugLoadedState extends AuthDebugState {
  final WooJwtToken? jwtToken;
  final WooCartToken? cartToken;
  final String? authJwtToken;
  final Map<String, dynamic>? authUserData;

  AuthDebugLoadedState({
    this.jwtToken,
    this.cartToken,
    this.authJwtToken,
    this.authUserData,
  });
}

/// Error state
class AuthDebugErrorState extends AuthDebugState {
  final String message;

  AuthDebugErrorState({required this.message});
}

