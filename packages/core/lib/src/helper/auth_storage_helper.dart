import 'package:flutter/foundation.dart';
import 'package:core/src/helper/local_storage/local_storage_helper.dart';
import 'dart:convert';

/// 🔐 **OSMEA Auth Storage Helper**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Helper class to manage JWT token storage using LocalStorageHelper
///
/// {@category Helpers}
/// {@subCategory AuthStorage}

class AuthStorageHelper {
  static const String _tokenKey = 'auth_jwt_token';
  static const String _userDataKey = 'auth_user_data';
  static const String _tokenExpiryKey = 'auth_token_expiry';
  static const String _refreshTokenKey = 'auth_refresh_token';

  final LocalStorageHelper _storage = LocalStorageHelper();

  // Cache for token-related data
  String? _cachedToken;
  Map<String, dynamic>? _cachedUserData;
  DateTime? _cachedTokenExpiry;
  bool? _cachedIsAuthenticated;
  DateTime? _lastCacheUpdate;
  static const Duration _cacheValidityDuration = Duration(minutes: 1); // Cache valid for 1 minute

  /// Clear cache (call when token is saved/cleared)
  void _clearCache() {
    _cachedToken = null;
    _cachedUserData = null;
    _cachedTokenExpiry = null;
    _cachedIsAuthenticated = null;
    _lastCacheUpdate = null;
  }

  /// 💾 Save JWT token to storage
  Future<void> saveToken(String token) async {
    try {
      debugPrint('💾 Saving JWT token...');
      await _storage.init();
      await _storage.setItem(_tokenKey, token);
      // Update cache
      _cachedToken = token;
      _cachedIsAuthenticated = null; // Invalidate auth cache
      _lastCacheUpdate = DateTime.now();
      debugPrint('✅ JWT token saved successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Error saving JWT token: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// 📖 Load JWT token from storage (with cache)
  Future<String?> getToken() async {
    try {
      // Return cached token if available and within validity period
      if (_cachedToken != null && _lastCacheUpdate != null) {
        final cacheAge = DateTime.now().difference(_lastCacheUpdate!);
        // Cache is valid for 1 minute to prevent excessive DB calls
        if (cacheAge < _cacheValidityDuration) {
          // Return cached token without debug log
          return _cachedToken;
        }
      }

      // Only log when actually loading from storage
      debugPrint('📖 Loading JWT token from storage...');
      await _storage.init();
      final token = await _storage.getItem(_tokenKey);

      // Update cache
      _cachedToken = token;
      _lastCacheUpdate = DateTime.now();

      if (token != null && token.isNotEmpty) {
        debugPrint('✅ JWT token loaded successfully');
        return token;
      }

      debugPrint('ℹ️ No JWT token found');
      return null;
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading JWT token: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      return null;
    }
  }

  /// 🗑️ Clear JWT token from storage
  Future<void> clearToken() async {
    try {
      debugPrint('🗑️ Clearing JWT token...');
      await _storage.init();
      await _storage.removeItem(_tokenKey);
      await _storage.removeItem(_userDataKey);
      await _storage.removeItem(_tokenExpiryKey);
      await _storage.removeItem(_refreshTokenKey);
      // Clear cache
      _clearCache();
      debugPrint('✅ JWT token cleared successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Error clearing JWT token: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// 💾 Save user data to storage
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      debugPrint('💾 Saving user data...');
      await _storage.init();
      await _storage.setItem(_userDataKey, json.encode(userData));
      // Update cache
      _cachedUserData = userData;
      _lastCacheUpdate = DateTime.now();
      debugPrint('✅ User data saved successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Error saving user data: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// 📖 Load user data from storage (with cache)
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      // Return cached user data if available and within validity period
      if (_cachedUserData != null && _lastCacheUpdate != null) {
        final cacheAge = DateTime.now().difference(_lastCacheUpdate!);
        if (cacheAge < _cacheValidityDuration) {
          // Return cached user data without debug log
          return _cachedUserData;
        }
      }

      // Only log when actually loading from storage
      debugPrint('📖 Loading user data from storage...');
      await _storage.init();
      final userDataString = await _storage.getItem(_userDataKey);

      if (userDataString != null && userDataString.isNotEmpty) {
        final userData = json.decode(userDataString) as Map<String, dynamic>;
        // Update cache
        _cachedUserData = userData;
        _lastCacheUpdate = DateTime.now();
        debugPrint('✅ User data loaded successfully');
        return userData;
      }

      // Update cache with null
      _cachedUserData = null;
      _lastCacheUpdate = DateTime.now();
      debugPrint('ℹ️ No user data found');
      return null;
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading user data: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      return null;
    }
  }

  /// 💾 Save refresh token to storage
  Future<void> saveRefreshToken(String refreshToken) async {
    try {
      debugPrint('💾 Saving refresh token...');
      await _storage.init();
      await _storage.setItem(_refreshTokenKey, refreshToken);
      debugPrint('✅ Refresh token saved successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Error saving refresh token: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// 📖 Load refresh token from storage
  Future<String?> getRefreshToken() async {
    try {
      debugPrint('📖 Loading refresh token...');
      await _storage.init();
      final refreshToken = await _storage.getItem(_refreshTokenKey);

      if (refreshToken != null && refreshToken.isNotEmpty) {
        debugPrint('✅ Refresh token loaded successfully');
        return refreshToken;
      }

      debugPrint('ℹ️ No refresh token found');
      return null;
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading refresh token: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      return null;
    }
  }

  /// 💾 Save token expiry to storage
  Future<void> saveTokenExpiry(DateTime expiry) async {
    try {
      debugPrint('💾 Saving token expiry...');
      await _storage.init();
      await _storage.setItem(_tokenExpiryKey, expiry.toIso8601String());
      debugPrint('✅ Token expiry saved successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Error saving token expiry: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// 📖 Load token expiry from storage (with cache)
  Future<DateTime?> getTokenExpiry() async {
    try {
      // Return cached expiry if available and within validity period
      if (_cachedTokenExpiry != null && _lastCacheUpdate != null) {
        final cacheAge = DateTime.now().difference(_lastCacheUpdate!);
        if (cacheAge < _cacheValidityDuration) {
          // Return cached expiry without debug log
          return _cachedTokenExpiry;
        }
      }

      // Only log when actually loading from storage
      debugPrint('📖 Loading token expiry from storage...');
      await _storage.init();
      final expiryString = await _storage.getItem(_tokenExpiryKey);

      if (expiryString != null && expiryString.isNotEmpty) {
        final expiry = DateTime.parse(expiryString);
        // Update cache
        _cachedTokenExpiry = expiry;
        _lastCacheUpdate = DateTime.now();
        debugPrint('✅ Token expiry loaded successfully');
        return expiry;
      }

      // Update cache with null
      _cachedTokenExpiry = null;
      _lastCacheUpdate = DateTime.now();
      debugPrint('ℹ️ No token expiry found');
      return null;
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading token expiry: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      return null;
    }
  }

  /// 🔍 Check if token is expired
  Future<bool> isTokenExpired() async {
    try {
      final expiry = await getTokenExpiry();
      if (expiry == null) return true;

      return DateTime.now().isAfter(expiry);
    } catch (e) {
      debugPrint('❌ Error checking token expiry: $e');
      return true;
    }
  }

  /// ✅ Check if user is authenticated (with cache)
  Future<bool> isAuthenticated() async {
    try {
      // Return cached auth status if available and within validity period
      if (_cachedIsAuthenticated != null && _lastCacheUpdate != null) {
        final cacheAge = DateTime.now().difference(_lastCacheUpdate!);
        if (cacheAge < _cacheValidityDuration) {
          // Return cached auth status without debug log
          return _cachedIsAuthenticated!;
        }
      }

      // Only check token when cache is invalid
      final token = await getToken();
      if (token == null || token.isEmpty) {
        _cachedIsAuthenticated = false;
        _lastCacheUpdate = DateTime.now();
        return false;
      }

      final isExpired = await isTokenExpired();
      final authenticated = !isExpired;
      // Update cache
      _cachedIsAuthenticated = authenticated;
      _lastCacheUpdate = DateTime.now();
      return authenticated;
    } catch (e) {
      debugPrint('❌ Error checking authentication: $e');
      return false;
    }
  }
}
