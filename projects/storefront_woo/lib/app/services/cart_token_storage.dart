/*
 * CartTokenStorage
 * ----------------
 * Service for managing cart token storage following OSMEA architecture.
 * Uses core package LocalStorageHelper for consistent storage management.
 */

import 'package:flutter/foundation.dart';
import 'package:core/core.dart';

/// Service for managing cart token storage
class CartTokenStorage {
  static const String _cartTokenKey = 'woo_cart_token';
  static const String _cartTokenExpiryKey = 'woo_cart_token_expiry';

  static final LocalStorageHelper _storage = LocalStorageHelper();

  /// Saves cart token to storage
  static Future<bool> saveCartToken(String token, {Duration? expiry}) async {
    try {
      await _storage.init();

      // Save token
      await _storage.setItem(_cartTokenKey, token);

      // Save expiry if provided
      if (expiry != null) {
        final expiryTime = DateTime.now().add(expiry).toIso8601String();
        await _storage.setItem(_cartTokenExpiryKey, expiryTime);
      }

      debugPrint('✅ Cart token saved successfully');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to save cart token: $e');
      return false;
    }
  }

  /// Loads cart token from storage
  static Future<String?> loadCartToken() async {
    try {
      await _storage.init();

      // Check if token exists
      final token = await _storage.getItem(_cartTokenKey);
      if (token == null || token.isEmpty) {
        debugPrint('⚠️ No cart token found in storage');
        return null;
      }

      // Check if token is expired
      final expiryString = await _storage.getItem(_cartTokenExpiryKey);
      if (expiryString != null && expiryString.isNotEmpty) {
        final expiryDate = DateTime.parse(expiryString);
        if (DateTime.now().isAfter(expiryDate)) {
          debugPrint('⚠️ Cart token has expired, removing from storage');
          await clearCartToken();
          return null;
        }
      }

      debugPrint('✅ Cart token loaded successfully');
      return token;
    } catch (e) {
      debugPrint('❌ Failed to load cart token: $e');
      return null;
    }
  }

  /// Clears cart token from storage
  static Future<bool> clearCartToken() async {
    try {
      await _storage.init();

      await _storage.removeItem(_cartTokenKey);
      await _storage.removeItem(_cartTokenExpiryKey);

      debugPrint('✅ Cart token cleared successfully');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to clear cart token: $e');
      return false;
    }
  }

  /// Checks if cart token exists and is valid
  static Future<bool> hasValidCartToken() async {
    try {
      final token = await loadCartToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      debugPrint('❌ Failed to check cart token validity: $e');
      return false;
    }
  }

  /// Gets cart token info for debugging
  static Future<Map<String, dynamic>> getCartTokenInfo() async {
    try {
      await _storage.init();

      final token = await _storage.getItem(_cartTokenKey);
      final expiryString = await _storage.getItem(_cartTokenExpiryKey);

      return {
        'hasToken': token != null && token.isNotEmpty,
        'tokenLength': token?.length ?? 0,
        'expiryString': expiryString,
        'isExpired': expiryString != null && expiryString.isNotEmpty
            ? DateTime.now().isAfter(DateTime.parse(expiryString))
            : false,
      };
    } catch (e) {
      debugPrint('❌ Failed to get cart token info: $e');
      return {
        'hasToken': false,
        'tokenLength': 0,
        'expiryString': null,
        'isExpired': false,
        'error': e.toString(),
      };
    }
  }
}
