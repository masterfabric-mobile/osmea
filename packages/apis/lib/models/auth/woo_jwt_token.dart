import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:core/core.dart';

/// 🔐 JWT Token model for WooCommerce authentication
class WooJwtToken {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final DateTime issuedAt;
  final String? refreshToken;
  final String? scope;
  final Map<String, dynamic>? userData;

  const WooJwtToken({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.issuedAt,
    this.refreshToken,
    this.scope,
    this.userData,
  });

  factory WooJwtToken.fromJson(Map<String, dynamic> json) {
    // { "access_token": "..." }  |  { "jwt": "..." }  |  { "token": "..." }
    final dynamic accessCandidate =
        json['access_token'] ?? json['jwt'] ?? json['token'];
    final String accessToken = accessCandidate?.toString() ?? '';

    final String tokenType =
        (json['token_type'] ?? json['type'] ?? 'Bearer').toString();

    final dynamic exp = json['expires_in'];
    final int expiresIn =
        exp is int ? exp : int.tryParse(exp?.toString() ?? '') ?? 3600;

    final dynamic issuedRaw = json['issued_at'] ?? json['iat'];
    DateTime issuedAt;
    if (issuedRaw == null) {
      issuedAt = DateTime.now();
    } else if (issuedRaw is int) {
      issuedAt =
          DateTime.fromMillisecondsSinceEpoch(issuedRaw * 1000, isUtc: true)
              .toLocal();
    } else {
      issuedAt = DateTime.tryParse(issuedRaw.toString()) ?? DateTime.now();
    }

    final String? refreshToken = json['refresh_token']?.toString();
    final String? scope = json['scope']?.toString();
    final Map<String, dynamic>? userData =
        json['user_data'] is Map<String, dynamic>
            ? json['user_data'] as Map<String, dynamic>
            : null;

    return WooJwtToken(
      accessToken: accessToken,
      tokenType: tokenType,
      expiresIn: expiresIn,
      issuedAt: issuedAt,
      refreshToken: refreshToken,
      scope: scope,
      userData: userData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
      'issued_at': issuedAt.toIso8601String(),
      'refresh_token': refreshToken,
      'scope': scope,
      'user_data': userData,
    };
  }

  @override
  String toString() {
    return 'WooJwtToken(accessToken: ${accessToken.length > 20 ? accessToken.substring(0, 20) + "..." : accessToken}, tokenType: $tokenType, expiresIn: $expiresIn, issuedAt: $issuedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WooJwtToken &&
        other.accessToken == accessToken &&
        other.tokenType == tokenType &&
        other.expiresIn == expiresIn &&
        other.issuedAt == issuedAt &&
        other.refreshToken == refreshToken &&
        other.scope == scope;
  }

  @override
  int get hashCode {
    return accessToken.hashCode ^
        tokenType.hashCode ^
        expiresIn.hashCode ^
        issuedAt.hashCode ^
        refreshToken.hashCode ^
        scope.hashCode;
  }
}

/// Extension to add computed properties
extension WooJwtTokenExtension on WooJwtToken {
  /// Get token expiry date
  DateTime get expiresAt {
    return issuedAt.add(Duration(seconds: expiresIn));
  }

  /// Check if token is expired
  bool get isExpired {
    return DateTime.now().isAfter(expiresAt);
  }

  /// Check if token needs refresh (expires in less than 10 minutes)
  bool get needsRefresh {
    final refreshThreshold = Duration(minutes: 10);
    return DateTime.now().isAfter(expiresAt.subtract(refreshThreshold));
  }

  /// Get authorization header value
  String get authorizationHeader {
    return '$tokenType $accessToken';
  }
}

/// 🔐 JWT Token Storage Manager using Core package's LocalStorageHelper
class WooJwtTokenStorage {
  static const String _tokenKey = 'woo_jwt_token';
  static const String _refreshTokenKey = 'woo_refresh_token';
  static const String _tokenExpiryKey = 'woo_token_expiry';
  static const String _userDataKey = 'woo_user_data';
  static const String _tokenTypeKey = 'woo_token_type';
  static const String _tokenScopeKey = 'woo_token_scope';
  static const String _issuedAtKey = 'woo_issued_at';
  static const String _expiresInKey = 'woo_expires_in';
  static const String _lastSavedKey = 'woo_last_saved';

  // Core package's LocalStorageHelper instance
  static final LocalStorageHelper _storage = LocalStorageHelper();

  // Cache for token data
  static WooJwtToken? _cachedToken;
  static DateTime? _lastCacheUpdate;
  static const Duration _cacheValidityDuration =
      Duration(minutes: 1); // Cache valid for 1 minute

  /// Clear cache (call when token is saved/cleared)
  static void _clearCache() {
    _cachedToken = null;
    _lastCacheUpdate = null;
  }

  /// 💾 Save JWT token to storage using Core package's LocalStorageHelper
  static Future<void> saveToken(WooJwtToken token) async {
    try {
      debugPrint('💾 Saving JWT token using Core LocalStorageHelper...');
      debugPrint(
          '🔐 Access token: ${token.accessToken.length > 20 ? token.accessToken.substring(0, 20) + "..." : token.accessToken}');
      debugPrint('🔑 Token type: ${token.tokenType}');
      debugPrint('⏰ Expires in: ${token.expiresIn} seconds');
      debugPrint('📅 Issued at: ${token.issuedAt}');
      debugPrint(
          '🔄 Refresh token: ${token.refreshToken != null ? "Present" : "Not present"}');
      debugPrint('📊 Scope: ${token.scope ?? "None"}');
      debugPrint(
          '👤 User data: ${token.userData != null ? "Present" : "Not present"}');

      // Debug expiresAt calculation
      try {
        debugPrint('🔍 Calculating expiresAt...');
        debugPrint('🔍 issuedAt: ${token.issuedAt}');
        debugPrint('🔍 expiresIn: ${token.expiresIn}');
        debugPrint('🔍 expiresIn type: ${token.expiresIn.runtimeType}');

        final expiresAt = token.expiresAt;
        debugPrint('📅 Expires at: $expiresAt');
      } catch (e) {
        debugPrint('❌ Error calculating expiresAt: $e');
        debugPrint('❌ issuedAt: ${token.issuedAt}');
        debugPrint('❌ expiresIn: ${token.expiresIn}');
        debugPrint('❌ expiresIn type: ${token.expiresIn.runtimeType}');
        rethrow;
      }

      // Initialize Core package's LocalStorageHelper if not already done
      await _storage.init();

      // Save all token information using Core package's LocalStorageHelper
      debugPrint('🔍 Saving token fields to storage...');
      await _storage.setItem(_tokenKey, token.accessToken);
      debugPrint('🔍 Saved access token');
      await _storage.setItem(_refreshTokenKey, token.refreshToken ?? '');
      debugPrint('🔍 Saved refresh token');
      await _storage.setItem(_tokenTypeKey, token.tokenType);
      debugPrint('🔍 Saved token type');
      await _storage.setItem(_tokenScopeKey, token.scope ?? '');
      debugPrint('🔍 Saved scope');
      await _storage.setItem(_issuedAtKey, token.issuedAt.toIso8601String());
      debugPrint('🔍 Saved issued at');
      await _storage.setItem(_expiresInKey, token.expiresIn);
      debugPrint('🔍 Saved expires in');
      await _storage.setItem(
          _tokenExpiryKey, token.expiresAt.toIso8601String());
      debugPrint('🔍 Saved expires at');
      await _storage.setItem(_userDataKey, json.encode(token.userData ?? {}));
      debugPrint('🔍 Saved user data');
      await _storage.setItem(_lastSavedKey, DateTime.now().toIso8601String());
      debugPrint('🔍 Saved last saved time');

      debugPrint(
          '✅ JWT token saved using Core LocalStorageHelper successfully');

      // Update cache
      _cachedToken = token;
      _lastCacheUpdate = DateTime.now();

      debugPrint('🔍 Verification - Reading back from storage:');

      // Verify the token was saved correctly
      final savedToken = await loadToken();
      if (savedToken != null) {
        debugPrint('✅ Token verification successful');
        debugPrint(
            '🔐 Saved access token: ${savedToken.accessToken.length > 20 ? savedToken.accessToken.substring(0, 20) + "..." : savedToken.accessToken}');
        debugPrint('🔑 Saved token type: ${savedToken.tokenType}');
        debugPrint('⏰ Saved expires in: ${savedToken.expiresIn} seconds');
      } else {
        debugPrint('❌ Token verification failed - token not found in storage');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error saving JWT token using Core LocalStorageHelper: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// 📖 Load JWT token from storage using Core package's LocalStorageHelper (with cache)
  static Future<WooJwtToken?> loadToken() async {
    try {
      // Return cached token if available and valid
      if (_cachedToken != null && _lastCacheUpdate != null) {
        final cacheAge = DateTime.now().difference(_lastCacheUpdate!);
        if (cacheAge < _cacheValidityDuration) {
          // Return cached token if not expired (without debug log)
          if (!_cachedToken!.isExpired) {
            return _cachedToken;
          } else {
            // Token expired, clear cache
            _clearCache();
          }
        }
      }

      // Only log when actually loading from storage
      debugPrint('📖 Loading JWT token from storage...');

      // Initialize Core package's LocalStorageHelper if not already done
      await _storage.init();

      // Load all token information using Core package's LocalStorageHelper
      final accessToken = await _storage.getItem(_tokenKey);
      final refreshToken = await _storage.getItem(_refreshTokenKey);
      final tokenType = await _storage.getItem(_tokenTypeKey);
      final scope = await _storage.getItem(_tokenScopeKey);
      final issuedAtString = await _storage.getItem(_issuedAtKey);
      final expiresIn = await _storage.getItem(_expiresInKey);
      final userDataString = await _storage.getItem(_userDataKey);

      debugPrint('🔍 Loaded from Core LocalStorageHelper:');
      debugPrint(
          '  - Access token: ${accessToken != null ? "Present" : "Not found"}');
      debugPrint(
          '  - Refresh token: ${refreshToken != null ? "Present" : "Not found"}');
      debugPrint('  - Token type: $tokenType');
      debugPrint('  - Scope: $scope');
      debugPrint('  - Issued at: $issuedAtString');
      debugPrint('  - Expires in: $expiresIn');
      debugPrint(
          '  - User data: ${userDataString != null ? "Present" : "Not found"}');

      // Check if we have the minimum required data
      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('❌ No access token found in Core LocalStorageHelper');
        return null;
      }

      // Parse the token data
      DateTime? issuedAt;
      if (issuedAtString != null && issuedAtString.isNotEmpty) {
        try {
          issuedAt = DateTime.parse(issuedAtString);
        } catch (e) {
          debugPrint('❌ Error parsing issuedAt: $e');
          issuedAt = DateTime.now();
        }
      } else {
        issuedAt = DateTime.now();
      }

      int? expiresInSeconds;
      if (expiresIn != null) {
        if (expiresIn is int) {
          expiresInSeconds = expiresIn;
        } else if (expiresIn is String) {
          expiresInSeconds = int.tryParse(expiresIn) ?? 3600;
        } else {
          expiresInSeconds = 3600;
        }
      } else {
        expiresInSeconds = 3600;
      }

      Map<String, dynamic>? userData;
      if (userDataString != null && userDataString.isNotEmpty) {
        try {
          userData = json.decode(userDataString);
        } catch (e) {
          debugPrint('❌ Error parsing user data: $e');
          userData = {};
        }
      }

      // Create the token object
      final token = WooJwtToken(
        accessToken: accessToken,
        tokenType: tokenType ?? 'Bearer',
        expiresIn: expiresInSeconds,
        issuedAt: issuedAt,
        refreshToken: refreshToken?.isNotEmpty == true ? refreshToken : null,
        scope: scope?.isNotEmpty == true ? scope : null,
        userData: userData,
      );

      debugPrint(
          '✅ JWT token loaded using Core LocalStorageHelper successfully');
      debugPrint(
          '🔐 Loaded access token: ${token.accessToken.length > 20 ? token.accessToken.substring(0, 20) + "..." : token.accessToken}');
      debugPrint('🔑 Loaded token type: ${token.tokenType}');
      debugPrint('⏰ Loaded expires in: ${token.expiresIn} seconds');
      debugPrint('📅 Loaded issued at: ${token.issuedAt}');
      debugPrint(
          '🔄 Loaded refresh token: ${token.refreshToken != null ? "Present" : "Not present"}');
      debugPrint('📊 Loaded scope: ${token.scope ?? "None"}');
      debugPrint(
          '👤 Loaded user data: ${token.userData != null ? "Present" : "Not present"}');

      // Update cache
      _cachedToken = token;
      _lastCacheUpdate = DateTime.now();

      return token;
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading JWT token using Core LocalStorageHelper: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      return null;
    }
  }

  /// 🗑️ Clear JWT token from storage using Core package's LocalStorageHelper
  static Future<void> clearToken() async {
    try {
      debugPrint('🗑️ Clearing JWT token using Core LocalStorageHelper...');

      // Initialize Core package's LocalStorageHelper if not already done
      await _storage.init();

      // Remove all token information using Core package's LocalStorageHelper
      await _storage.removeItem(_tokenKey);
      await _storage.removeItem(_refreshTokenKey);
      await _storage.removeItem(_tokenTypeKey);
      await _storage.removeItem(_tokenScopeKey);
      await _storage.removeItem(_issuedAtKey);
      await _storage.removeItem(_expiresInKey);
      await _storage.removeItem(_tokenExpiryKey);
      await _storage.removeItem(_userDataKey);
      await _storage.removeItem(_lastSavedKey);

      // Clear cache
      _clearCache();

      debugPrint(
          '✅ JWT token cleared using Core LocalStorageHelper successfully');
    } catch (e, stackTrace) {
      debugPrint(
          '❌ Error clearing JWT token using Core LocalStorageHelper: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// 🧹 Cleanup expired tokens using Core package's LocalStorageHelper
  static Future<void> cleanupExpiredTokens() async {
    try {
      debugPrint(
          '🧹 Cleaning up expired tokens using Core LocalStorageHelper...');

      // Initialize Core package's LocalStorageHelper if not already done
      await _storage.init();

      final token = await loadToken();
      if (token != null && token.isExpired) {
        debugPrint('🗑️ Token is expired, clearing it...');
        await clearToken();
        debugPrint('✅ Expired token cleared successfully');
      } else {
        debugPrint('✅ Token is still valid, no cleanup needed');
      }
    } catch (e, stackTrace) {
      debugPrint(
          '❌ Error cleaning up expired tokens using Core LocalStorageHelper: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// 📊 Get storage statistics using Core package's LocalStorageHelper
  static Future<Map<String, dynamic>> getStorageStats() async {
    try {
      debugPrint(
          '📊 Getting storage statistics using Core LocalStorageHelper...');

      // Initialize Core package's LocalStorageHelper if not already done
      await _storage.init();

      final allItems = await _storage.getAllItems();
      final jwtKeys =
          allItems.keys.where((key) => key.startsWith('woo_')).length;

      final stats = {
        'platform': kIsWeb ? 'web' : 'mobile',
        'storageType': 'Core LocalStorageHelper',
        'totalKeys': allItems.length,
        'jwtKeys': jwtKeys,
        'hasToken': await hasToken(),
      };

      debugPrint('📊 Storage statistics: $stats');
      return stats;
    } catch (e, stackTrace) {
      debugPrint(
          '❌ Error getting storage statistics using Core LocalStorageHelper: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      return {
        'platform': kIsWeb ? 'web' : 'mobile',
        'storageType': 'Core LocalStorageHelper',
        'error': e.toString(),
      };
    }
  }

  /// 🔍 Check if token is expired
  static Future<bool> isTokenExpired() async {
    final token = await loadToken();
    return token?.isExpired ?? true;
  }

  /// 🔄 Check if token needs refresh
  static Future<bool> needsRefresh() async {
    final token = await loadToken();
    return token?.needsRefresh ?? true;
  }

  /// 📋 Get token information
  static Future<Map<String, dynamic>?> getTokenInfo() async {
    final token = await loadToken();
    if (token == null) return null;

    return {
      'accessToken': token.accessToken,
      'tokenType': token.tokenType,
      'expiresIn': token.expiresIn,
      'issuedAt': token.issuedAt.toIso8601String(),
      'expiresAt': token.expiresAt.toIso8601String(),
      'isExpired': token.isExpired,
      'needsRefresh': token.needsRefresh,
      'refreshToken': token.refreshToken,
      'scope': token.scope,
      'userData': token.userData,
    };
  }

  /// ✅ Check if token exists
  static Future<bool> hasToken() async {
    final token = await loadToken();
    return token != null;
  }

  /// ⏰ Get token expiry date
  static Future<DateTime?> getTokenExpiry() async {
    final token = await loadToken();
    return token?.expiresAt;
  }

  /// 👤 Get user data
  static Future<Map<String, dynamic>?> getUserData() async {
    final token = await loadToken();
    return token?.userData;
  }

  /// 🔄 Update user data
  static Future<void> updateUserData(Map<String, dynamic> userData) async {
    final token = await loadToken();
    if (token != null) {
      final updatedToken = WooJwtToken(
        accessToken: token.accessToken,
        tokenType: token.tokenType,
        expiresIn: token.expiresIn,
        issuedAt: token.issuedAt,
        refreshToken: token.refreshToken,
        scope: token.scope,
        userData: userData,
      );
      await saveToken(updatedToken);
    }
  }

  /// 🧪 Test token storage functionality
  static Future<void> testTokenStorage() async {
    try {
      debugPrint(
          '🧪 Testing JWT token storage using Core LocalStorageHelper...');

      // Test saving a dummy token
      final testToken = WooJwtToken(
        accessToken: 'test_token_12345',
        tokenType: 'Bearer',
        expiresIn: 3600,
        issuedAt: DateTime.now(),
        refreshToken: 'test_refresh_token',
        scope: 'read write',
        userData: {'test': 'data'},
      );

      await saveToken(testToken);
      debugPrint('✅ Test token saved successfully');

      // Test loading the token
      final loadedToken = await loadToken();
      if (loadedToken != null) {
        debugPrint('✅ Test token loaded successfully');
        debugPrint('🔐 Loaded token: ${loadedToken.accessToken}');
        debugPrint('🔑 Loaded type: ${loadedToken.tokenType}');
        debugPrint('⏰ Loaded expires in: ${loadedToken.expiresIn}');
        debugPrint('👤 Loaded user data: ${loadedToken.userData}');
      } else {
        debugPrint('❌ Test token loading failed');
      }

      // Test clearing the token
      await clearToken();
      debugPrint('✅ Test token cleared successfully');

      // Verify token is cleared
      final clearedToken = await loadToken();
      if (clearedToken == null) {
        debugPrint('✅ Token clearing verification successful');
      } else {
        debugPrint('❌ Token clearing verification failed');
      }

      debugPrint('✅ JWT token storage test completed successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ JWT token storage test failed: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }
}
