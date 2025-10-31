/*
 * ProfileStates
 * -------------
 * States for profile view.
 */

import 'package:apis/models/auth/woo_jwt_token.dart';
import 'package:apis/models/cart/woo_cart_token.dart';

/// Base state for profile view
abstract class ProfileState {}

/// Initial state
class ProfileInitialState extends ProfileState {}

/// Loading state
class ProfileLoadingState extends ProfileState {}

/// Loaded state with token data
class ProfileLoadedState extends ProfileState {
  final WooJwtToken? jwtToken;
  final WooCartToken? cartToken;
  final String? authJwtToken;
  final Map<String, dynamic>? authUserData;
  final bool isAuthenticated;

  ProfileLoadedState({
    this.jwtToken,
    this.cartToken,
    this.authJwtToken,
    this.authUserData,
    required this.isAuthenticated,
  });
}

/// Signed out state
class ProfileSignedOutState extends ProfileState {}

/// Error state
class ProfileErrorState extends ProfileState {
  final String message;

  ProfileErrorState({required this.message});
}

