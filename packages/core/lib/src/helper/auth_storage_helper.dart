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

  /// 💾 Save JWT token to storage
  Future<void> saveToken(String token) async {
    try {
      debugPrint('💾 Saving JWT token...');
      await _storage.init();
      await _storage.setItem(_tokenKey, token);
      debugPrint('✅ JWT token saved successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Error saving JWT token: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// 📖 Load JWT token from storage
  Future<String?> getToken() async {
    try {
      debugPrint('📖 Loading JWT token...');
      await _storage.init();
      final token = await _storage.getItem(_tokenKey);

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
      debugPrint('✅ User data saved successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Error saving user data: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// 📖 Load user data from storage
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      debugPrint('📖 Loading user data...');
      await _storage.init();
      final userDataString = await _storage.getItem(_userDataKey);

      if (userDataString != null && userDataString.isNotEmpty) {
        final userData = json.decode(userDataString) as Map<String, dynamic>;
        debugPrint('✅ User data loaded successfully');
        return userData;
      }

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

  /// 📖 Load token expiry from storage
  Future<DateTime?> getTokenExpiry() async {
    try {
      debugPrint('📖 Loading token expiry...');
      await _storage.init();
      final expiryString = await _storage.getItem(_tokenExpiryKey);

      if (expiryString != null && expiryString.isNotEmpty) {
        final expiry = DateTime.parse(expiryString);
        debugPrint('✅ Token expiry loaded successfully');
        return expiry;
      }

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

  /// ✅ Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) return false;

      final isExpired = await isTokenExpired();
      return !isExpired;
    } catch (e) {
      debugPrint('❌ Error checking authentication: $e');
      return false;
    }
  }
}
