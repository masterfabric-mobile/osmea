/*
 * AuthCubit
 * ---------
 * Central authentication state management using HydratedCubit.
 * Base implementation for authentication state management.
 * Specific implementations should extend this cubit.
 */

import 'package:flutter/foundation.dart';
import 'package:core/src/base/base_view_model_hydrated_cubit.dart';
import 'package:core/src/helper/auth_storage_helper.dart';
import 'package:core/src/views/auth/cubit/auth_state.dart';

/// 🔐 **OSMEA Auth Cubit**
///
/// Base authentication cubit using HydratedCubit storage.
/// This cubit manages core authentication state and persists it across app restarts.
/// Specific implementations (e.g., WooCommerce) should extend this cubit.
///
/// {@category ViewModels}
/// {@subCategory AuthCubit}

class AuthCubit extends BaseViewModelHydratedCubit<AuthState> {
  AuthCubit() : super(const AuthInitialState());

  final AuthStorageHelper _authStorage = AuthStorageHelper();
  
  // Prevent multiple concurrent loadTokens() calls
  bool _isLoadingTokens = false;
  DateTime? _lastLoadTime;
  static const Duration _loadDebounceDuration = Duration(seconds: 2); // Minimum 2 seconds between loads

  /// Check if user is authenticated
  bool get isAuthenticated {
    final currentState = state;
    if (currentState is AuthAuthenticatedState) {
      return currentState.isAuthenticated;
    }
    return false;
  }

  /// Get current JWT token string
  String? get jwtTokenString {
    final currentState = state;
    if (currentState is AuthAuthenticatedState) {
      return currentState.jwtToken;
    }
    return null;
  }

  /// Get current JWT token with Bearer prefix
  String? get jwtTokenHeader {
    final token = jwtTokenString;
    if (token != null && token.isNotEmpty) {
      return token.startsWith('Bearer ') ? token : 'Bearer $token';
    }
    return null;
  }

  /// Get current user data
  Map<String, dynamic>? get userData {
    final currentState = state;
    if (currentState is AuthAuthenticatedState) {
      return currentState.userData;
    }
    return null;
  }

  /// Get current metadata (platform-specific data like WooCommerce tokens)
  Map<String, dynamic>? get metadata {
    final currentState = state;
    if (currentState is AuthAuthenticatedState) {
      return currentState.metadata;
    }
    return null;
  }

  /// Get a specific metadata value by key
  T? getMetadataValue<T>(String key) {
    final meta = metadata;
    if (meta != null && meta.containsKey(key)) {
      return meta[key] as T?;
    }
    return null;
  }

  /// Load tokens from storage and update state
  /// This method reads from core AuthStorageHelper and syncs to HydratedCubit state
  /// Includes debounce to prevent excessive calls
  Future<void> loadTokens() async {
    // Prevent concurrent calls
    if (_isLoadingTokens) {
      debugPrint('⏸️ AuthCubit: Already loading tokens, skipping...');
      return;
    }
    
    // Debounce: Prevent calls within 2 seconds of last load
    if (_lastLoadTime != null) {
      final timeSinceLastLoad = DateTime.now().difference(_lastLoadTime!);
      if (timeSinceLastLoad < _loadDebounceDuration) {
        debugPrint('⏸️ AuthCubit: Too soon since last load (${timeSinceLastLoad.inMilliseconds}ms), skipping...');
        return;
      }
    }
    
    _isLoadingTokens = true;
    _lastLoadTime = DateTime.now();
    
    try {
      debugPrint('🔄 AuthCubit: Loading tokens from storage...');
      emit(const AuthLoadingState());

      // Load JWT token from Core AuthStorageHelper
      final jwtToken = await _authStorage.getToken();
      final userData = await _authStorage.getUserData();

      // Determine authentication status
      final authenticated = jwtToken != null && jwtToken.isNotEmpty;
      final isExpired = authenticated ? await _authStorage.isTokenExpired() : true;

      if (authenticated && !isExpired) {
        emit(
          AuthAuthenticatedState(
            jwtToken: jwtToken,
            userData: userData,
            isAuthenticated: true,
            metadata: null,
          ),
        );
        debugPrint('✅ AuthCubit: Tokens loaded and state updated');
      } else {
        emit(const AuthUnauthenticatedState());
        debugPrint('ℹ️ AuthCubit: No valid tokens found, user not authenticated');
      }
    } catch (e) {
      debugPrint('❌ AuthCubit: Error loading tokens: $e');
      emit(const AuthUnauthenticatedState());
    } finally {
      _isLoadingTokens = false;
    }
  }

  /// Save JWT token to cubit state and storage
  /// This should be called after successful sign in
  /// [metadata] can be used for platform-specific data (e.g., WooCommerce tokens)
  Future<void> saveJwtToken({
    String? jwtToken,
    Map<String, dynamic>? userData,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      debugPrint('💾 AuthCubit: Saving JWT token...');

      // Save to storage for backward compatibility
      if (jwtToken != null) {
        await _authStorage.saveToken(jwtToken);
        if (userData != null) {
          await _authStorage.saveUserData(userData);
        }
      }

      // Update cubit state
      final currentState = state;
      if (currentState is AuthAuthenticatedState) {
        // Merge metadata if provided
        final mergedMetadata = metadata != null
            ? {...?currentState.metadata, ...metadata}
            : currentState.metadata;

        emit(
          currentState.copyWith(
            jwtToken: jwtToken ?? currentState.jwtToken,
            userData: userData ?? currentState.userData,
            isAuthenticated: jwtToken != null && jwtToken.isNotEmpty,
            metadata: mergedMetadata,
          ),
        );
      } else {
        emit(
          AuthAuthenticatedState(
            jwtToken: jwtToken,
            userData: userData,
            isAuthenticated: jwtToken != null && jwtToken.isNotEmpty,
            metadata: metadata,
          ),
        );
      }

      debugPrint('✅ AuthCubit: JWT token saved successfully');
    } catch (e) {
      debugPrint('❌ AuthCubit: Error saving JWT token: $e');
    }
  }

  /// Clear all tokens and sign out
  Future<void> signOut() async {
    try {
      debugPrint('🚪 AuthCubit: Signing out...');

      // Clear storage
      await _authStorage.clearToken();

      // Update cubit state
      emit(const AuthUnauthenticatedState());

      debugPrint('✅ AuthCubit: Sign out successful');
    } catch (e) {
      debugPrint('❌ AuthCubit: Error signing out: $e');
    }
  }

  /// Refresh tokens from storage
  /// This is useful when tokens might have been updated externally
  Future<void> refreshTokens() async {
    await loadTokens();
  }

  /// Update metadata (for platform-specific implementations)
  /// This allows adding/updating metadata without changing the JWT token
  void updateMetadata(Map<String, dynamic> newMetadata) {
    final currentState = state;
    if (currentState is AuthAuthenticatedState) {
      final mergedMetadata = {...?currentState.metadata, ...newMetadata};
      emit(currentState.copyWith(metadata: mergedMetadata));
    }
  }

  /// Clear metadata
  void clearMetadata() {
    final currentState = state;
    if (currentState is AuthAuthenticatedState) {
      emit(currentState.copyWith(metadata: null));
    }
  }

  /// Serialize state to JSON for HydratedCubit persistence
  @override
  Map<String, dynamic>? toJson(AuthState state) {
    if (state is AuthAuthenticatedState) {
      return state.toJson();
    }
    // Don't persist initial, loading, or unauthenticated states
    return null;
  }

  /// Deserialize state from JSON for HydratedCubit persistence
  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    try {
      // Check if state has authentication data
      if (json['isAuthenticated'] == true || json['jwtToken'] != null) {
        return AuthAuthenticatedState.fromJson(json);
      }
      return const AuthUnauthenticatedState();
    } catch (e) {
      debugPrint('❌ AuthCubit: Error deserializing state: $e');
      return const AuthUnauthenticatedState();
    }
  }
}

