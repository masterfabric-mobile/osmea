/*
 * AuthState
 * ---------
 * State definitions for authentication management.
 * Base implementation for authentication state.
 */

/// Base state for authentication
abstract class AuthState {
  const AuthState();
}

/// Initial state - no tokens loaded
class AuthInitialState extends AuthState {
  const AuthInitialState();
}

/// Authentication state with tokens
class AuthAuthenticatedState extends AuthState {
  final String? jwtToken;
  final Map<String, dynamic>? userData;
  final bool isAuthenticated;
  /// Additional metadata for platform-specific implementations (e.g., WooCommerce tokens)
  final Map<String, dynamic>? metadata;

  const AuthAuthenticatedState({
    this.jwtToken,
    this.userData,
    required this.isAuthenticated,
    this.metadata,
  });

  /// Create from JSON for HydratedCubit persistence
  factory AuthAuthenticatedState.fromJson(Map<String, dynamic> json) {
    return AuthAuthenticatedState(
      jwtToken: json['jwtToken'] as String?,
      userData: json['userData'] as Map<String, dynamic>?,
      isAuthenticated: json['isAuthenticated'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON for HydratedCubit persistence
  Map<String, dynamic> toJson() {
    return {
      'jwtToken': jwtToken,
      'userData': userData,
      'isAuthenticated': isAuthenticated,
      'metadata': metadata,
    };
  }

  /// Copy with method for state updates
  AuthAuthenticatedState copyWith({
    String? jwtToken,
    Map<String, dynamic>? userData,
    bool? isAuthenticated,
    Map<String, dynamic>? metadata,
  }) {
    return AuthAuthenticatedState(
      jwtToken: jwtToken ?? this.jwtToken,
      userData: userData ?? this.userData,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Unauthenticated state - user logged out
class AuthUnauthenticatedState extends AuthState {
  const AuthUnauthenticatedState();
}

/// Loading state - tokens are being loaded
class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

