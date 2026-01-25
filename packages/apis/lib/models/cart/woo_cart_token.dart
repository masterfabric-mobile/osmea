import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:core/core.dart';

/// 🛒 WooCommerce Cart Token Model
///
/// Represents a cart token similar to JWT but for cart operations.
/// Cart tokens are used to maintain cart state across requests and
/// are automatically managed by the cart token interceptor.
class WooCartToken {
  /// 🛒 The actual cart token value
  final String cartToken;

  /// 🏬 Store URL this token belongs to
  final String storeUrl;

  /// 📅 When this token was issued/created
  final DateTime issuedAt;

  /// ⏰ When this token expires (if applicable)
  final DateTime? expiresAt;

  /// 🔄 Last time this token was refreshed/updated
  final DateTime? lastRefreshed;

  /// 📊 Additional metadata about the cart
  final Map<String, dynamic>? metadata;

  /// 🆔 Cart ID associated with this token
  final String? cartId;

  /// 👤 User ID associated with this cart (if logged in)
  final String? userId;

  const WooCartToken({
    required this.cartToken,
    required this.storeUrl,
    required this.issuedAt,
    this.expiresAt,
    this.lastRefreshed,
    this.metadata,
    this.cartId,
    this.userId,
  });

  /// Create WooCartToken from JSON
  factory WooCartToken.fromJson(Map<String, dynamic> json) {
    return WooCartToken(
      cartToken: json['cartToken'] as String? ?? '',
      storeUrl: json['storeUrl'] as String? ?? '',
      issuedAt: json['issuedAt'] != null
          ? DateTime.parse(json['issuedAt'] as String)
          : DateTime.now(),
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
      lastRefreshed: json['lastRefreshed'] != null
          ? DateTime.parse(json['lastRefreshed'] as String)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      cartId: json['cartId'] as String?,
      userId: json['userId'] as String?,
    );
  }

  /// Convert WooCartToken to JSON
  Map<String, dynamic> toJson() {
    return {
      'cartToken': cartToken,
      'storeUrl': storeUrl,
      'issuedAt': issuedAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'lastRefreshed': lastRefreshed?.toIso8601String(),
      'metadata': metadata,
      'cartId': cartId,
      'userId': userId,
    };
  }

  /// Create a copy of this token with updated fields
  WooCartToken copyWith({
    String? cartToken,
    String? storeUrl,
    DateTime? issuedAt,
    DateTime? expiresAt,
    DateTime? lastRefreshed,
    Map<String, dynamic>? metadata,
    String? cartId,
    String? userId,
  }) {
    return WooCartToken(
      cartToken: cartToken ?? this.cartToken,
      storeUrl: storeUrl ?? this.storeUrl,
      issuedAt: issuedAt ?? this.issuedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      lastRefreshed: lastRefreshed ?? this.lastRefreshed,
      metadata: metadata ?? this.metadata,
      cartId: cartId ?? this.cartId,
      userId: userId ?? this.userId,
    );
  }

  @override
  String toString() {
    return 'WooCartToken(cartToken: ${cartToken.length > 20 ? cartToken.substring(0, 20) + "..." : cartToken}, storeUrl: $storeUrl, issuedAt: $issuedAt, expiresAt: $expiresAt, cartId: $cartId, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WooCartToken &&
        other.cartToken == cartToken &&
        other.storeUrl == storeUrl &&
        other.issuedAt == issuedAt &&
        other.expiresAt == expiresAt &&
        other.lastRefreshed == lastRefreshed &&
        other.cartId == cartId &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return Object.hash(
      cartToken,
      storeUrl,
      issuedAt,
      expiresAt,
      lastRefreshed,
      cartId,
      userId,
    );
  }
}

/// 🛒 Cart Token Storage Manager using Core package's LocalStorageHelper
class WooCartTokenStorage {
  static const String _cartTokenKey = 'woo_cart_token';
  static const String _storeUrlKey = 'woo_cart_store_url';
  static const String _issuedAtKey = 'woo_cart_issued_at';
  static const String _expiresAtKey = 'woo_cart_expires_at';
  static const String _lastRefreshedKey = 'woo_cart_last_refreshed';
  static const String _metadataKey = 'woo_cart_metadata';
  static const String _cartIdKey = 'woo_cart_id';
  static const String _userIdKey = 'woo_cart_user_id';
  static const String _lastSavedKey = 'woo_cart_last_saved';
  // Must match WooCartTokenInterceptor nonce key to prevent stale nonce after logout.
  static const String _nonceStorageKey = 'woo_cart_nonce';

  // Core package's LocalStorageHelper instance
  static final LocalStorageHelper _storage = LocalStorageHelper();

  // Cache for cart token data
  static WooCartToken? _cachedToken;
  static DateTime? _lastCacheUpdate;
  static const Duration _cacheValidityDuration =
      Duration(minutes: 1); // Cache valid for 1 minute

  /// Clear cache (call when token is saved/cleared)
  static void _clearCache() {
    _cachedToken = null;
    _lastCacheUpdate = null;
  }

  /// 💾 Save cart token to storage using Core package's LocalStorageHelper
  static Future<void> saveCartToken(WooCartToken token) async {
    try {
      debugPrint('💾 Saving cart token using Core LocalStorageHelper...');
      debugPrint(
          '🛒 Cart token: ${token.cartToken.length > 20 ? token.cartToken.substring(0, 20) + "..." : token.cartToken}');
      debugPrint('🏬 Store URL: ${token.storeUrl}');
      debugPrint('📅 Issued at: ${token.issuedAt}');
      debugPrint('⏰ Expires at: ${token.expiresAt}');
      debugPrint('🆔 Cart ID: ${token.cartId}');
      debugPrint('👤 User ID: ${token.userId}');

      // Initialize Core package's LocalStorageHelper if not already done
      await _storage.init();

      // Save all cart token information using Core package's LocalStorageHelper
      debugPrint('🔍 Saving cart token fields to storage...');
      await _storage.setItem(_cartTokenKey, token.cartToken);
      debugPrint('🔍 Saved cart token');
      await _storage.setItem(_storeUrlKey, token.storeUrl);
      debugPrint('🔍 Saved store URL');
      await _storage.setItem(_issuedAtKey, token.issuedAt.toIso8601String());
      debugPrint('🔍 Saved issued at');
      await _storage.setItem(
          _expiresAtKey, token.expiresAt?.toIso8601String() ?? '');
      debugPrint('🔍 Saved expires at');
      await _storage.setItem(
          _lastRefreshedKey, token.lastRefreshed?.toIso8601String() ?? '');
      debugPrint('🔍 Saved last refreshed');
      await _storage.setItem(_metadataKey, json.encode(token.metadata ?? {}));
      debugPrint('🔍 Saved metadata');
      await _storage.setItem(_cartIdKey, token.cartId ?? '');
      debugPrint('🔍 Saved cart ID');
      await _storage.setItem(_userIdKey, token.userId ?? '');
      debugPrint('🔍 Saved user ID');
      await _storage.setItem(_lastSavedKey, DateTime.now().toIso8601String());
      debugPrint('🔍 Saved last saved time');

      debugPrint(
          '✅ Cart token saved using Core LocalStorageHelper successfully');

      // Update cache
      _cachedToken = token;
      _lastCacheUpdate = DateTime.now();

      // Verify the token was saved correctly
      final savedToken = await loadCartToken();
      if (savedToken != null) {
        debugPrint('✅ Cart token verification successful');
      } else {
        debugPrint('❌ Cart token verification failed');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error saving cart token using Core LocalStorageHelper: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// 📖 Load cart token from storage using Core package's LocalStorageHelper (with cache)
  static Future<WooCartToken?> loadCartToken() async {
    try {
      // Return cached token if available and valid
      if (_cachedToken != null && _lastCacheUpdate != null) {
        final cacheAge = DateTime.now().difference(_lastCacheUpdate!);
        if (cacheAge < _cacheValidityDuration) {
          // Return cached token without debug log
          return _cachedToken;
        }
      }

      // Only log when actually loading from storage
      debugPrint('📖 Loading cart token from storage...');

      // Initialize Core package's LocalStorageHelper if not already done
      await _storage.init();

      // Load all cart token information using Core package's LocalStorageHelper
      final cartToken = await _storage.getItem(_cartTokenKey);
      final storeUrl = await _storage.getItem(_storeUrlKey);
      final issuedAtString = await _storage.getItem(_issuedAtKey);
      final expiresAtString = await _storage.getItem(_expiresAtKey);
      final lastRefreshedString = await _storage.getItem(_lastRefreshedKey);
      final metadataString = await _storage.getItem(_metadataKey);
      final cartId = await _storage.getItem(_cartIdKey);
      final userId = await _storage.getItem(_userIdKey);

      debugPrint('🔍 Loaded from Core LocalStorageHelper:');
      debugPrint(
          '  - Cart token: ${cartToken != null ? "Present" : "Not found"}');
      debugPrint('  - Store URL: $storeUrl');
      debugPrint('  - Issued at: $issuedAtString');
      debugPrint('  - Expires at: $expiresAtString');
      debugPrint('  - Last refreshed: $lastRefreshedString');
      debugPrint('  - Cart ID: $cartId');
      debugPrint('  - User ID: $userId');
      debugPrint(
          '  - Metadata: ${metadataString != null ? "Present" : "Not found"}');

      // Check if we have the minimum required data
      if (cartToken == null ||
          cartToken.isEmpty ||
          storeUrl == null ||
          storeUrl.isEmpty) {
        debugPrint(
            '❌ No cart token or store URL found in Core LocalStorageHelper');
        return null;
      }

      // Parse the token data
      DateTime issuedAt;
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

      DateTime? expiresAt;
      if (expiresAtString != null && expiresAtString.isNotEmpty) {
        try {
          expiresAt = DateTime.parse(expiresAtString);
        } catch (e) {
          debugPrint('❌ Error parsing expiresAt: $e');
          expiresAt = null;
        }
      }

      DateTime? lastRefreshed;
      if (lastRefreshedString != null && lastRefreshedString.isNotEmpty) {
        try {
          lastRefreshed = DateTime.parse(lastRefreshedString);
        } catch (e) {
          debugPrint('❌ Error parsing lastRefreshed: $e');
          lastRefreshed = null;
        }
      }

      Map<String, dynamic>? metadata;
      if (metadataString != null && metadataString.isNotEmpty) {
        try {
          metadata = json.decode(metadataString) as Map<String, dynamic>;
        } catch (e) {
          debugPrint('❌ Error parsing metadata: $e');
          metadata = null;
        }
      }

      final token = WooCartToken(
        cartToken: cartToken,
        storeUrl: storeUrl,
        issuedAt: issuedAt,
        expiresAt: expiresAt,
        lastRefreshed: lastRefreshed,
        metadata: metadata,
        cartId: cartId?.isNotEmpty == true ? cartId : null,
        userId: userId?.isNotEmpty == true ? userId : null,
      );

      debugPrint(
          '✅ Cart token loaded using Core LocalStorageHelper successfully');

      // Update cache
      _cachedToken = token;
      _lastCacheUpdate = DateTime.now();

      return token;
    } catch (e, stackTrace) {
      debugPrint(
          '❌ Error loading cart token using Core LocalStorageHelper: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      return null;
    }
  }

  /// 🗑️ Clear cart token from storage using Core package's LocalStorageHelper
  static Future<void> clearCartToken() async {
    try {
      debugPrint('🗑️ Clearing cart token using Core LocalStorageHelper...');

      // Initialize Core package's LocalStorageHelper if not already done
      await _storage.init();

      // Remove all cart token information using Core package's LocalStorageHelper
      await _storage.removeItem(_cartTokenKey);
      await _storage.removeItem(_storeUrlKey);
      await _storage.removeItem(_issuedAtKey);
      await _storage.removeItem(_expiresAtKey);
      await _storage.removeItem(_lastRefreshedKey);
      await _storage.removeItem(_metadataKey);
      await _storage.removeItem(_cartIdKey);
      await _storage.removeItem(_userIdKey);
      await _storage.removeItem(_lastSavedKey);
      // Also clear nonce used for Store API cart requests.
      await _storage.removeItem(_nonceStorageKey);

      // Clear cache
      _clearCache();

      debugPrint(
          '✅ Cart token cleared using Core LocalStorageHelper successfully');
    } catch (e, stackTrace) {
      debugPrint(
          '❌ Error clearing cart token using Core LocalStorageHelper: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// 🔄 Update cart token with new data (preserves existing data)
  static Future<void> updateCartToken({
    String? cartToken,
    String? storeUrl,
    DateTime? issuedAt,
    DateTime? expiresAt,
    DateTime? lastRefreshed,
    Map<String, dynamic>? metadata,
    String? cartId,
    String? userId,
  }) async {
    try {
      // Load existing token
      final existingToken = await loadCartToken();

      if (existingToken != null) {
        // Update with new data, preserving existing data where new data is null
        final updatedToken = existingToken.copyWith(
          cartToken: cartToken ?? existingToken.cartToken,
          storeUrl: storeUrl ?? existingToken.storeUrl,
          issuedAt: issuedAt ?? existingToken.issuedAt,
          expiresAt: expiresAt ?? existingToken.expiresAt,
          lastRefreshed: lastRefreshed ?? existingToken.lastRefreshed,
          metadata: metadata ?? existingToken.metadata,
          cartId: cartId ?? existingToken.cartId,
          userId: userId ?? existingToken.userId,
        );

        await saveCartToken(updatedToken);
        debugPrint('✅ Cart token updated successfully');
      } else {
        // Create new token if none exists
        final newToken = WooCartToken(
          cartToken: cartToken ?? '',
          storeUrl: storeUrl ?? '',
          issuedAt: issuedAt ?? DateTime.now(),
          expiresAt: expiresAt,
          lastRefreshed: lastRefreshed,
          metadata: metadata,
          cartId: cartId,
          userId: userId,
        );

        await saveCartToken(newToken);
        debugPrint('✅ New cart token created successfully');
      }
    } catch (e) {
      debugPrint('❌ Error updating cart token: $e');
      rethrow;
    }
  }

  /// 🧹 Cleanup expired cart tokens using Core package's LocalStorageHelper
  static Future<void> cleanupExpiredCartTokens() async {
    try {
      debugPrint('🧹 Cleaning up expired cart tokens...');

      final token = await loadCartToken();
      if (token != null && token.expiresAt != null) {
        if (DateTime.now().isAfter(token.expiresAt!)) {
          debugPrint('🗑️ Cart token has expired, clearing...');
          await clearCartToken();
        } else {
          debugPrint('✅ Cart token is still valid');
        }
      } else {
        debugPrint('ℹ️ No cart token or no expiration date found');
      }
    } catch (e) {
      debugPrint('❌ Error cleaning up expired cart tokens: $e');
    }
  }

  /// 🔍 Check if cart token exists and is valid
  static Future<bool> hasValidCartToken() async {
    try {
      final token = await loadCartToken();
      if (token == null) return false;

      // Check if token has expired
      if (token.expiresAt != null && DateTime.now().isAfter(token.expiresAt!)) {
        debugPrint('⚠️ Cart token has expired');
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('❌ Error checking cart token validity: $e');
      return false;
    }
  }

  /// 📊 Get cart token information for debugging
  static Future<Map<String, dynamic>?> getCartTokenInfo() async {
    try {
      final token = await loadCartToken();
      if (token == null) return null;

      return {
        'cartToken': token.cartToken.length > 20
            ? '${token.cartToken.substring(0, 20)}...'
            : token.cartToken,
        'storeUrl': token.storeUrl,
        'issuedAt': token.issuedAt.toIso8601String(),
        'expiresAt': token.expiresAt?.toIso8601String(),
        'lastRefreshed': token.lastRefreshed?.toIso8601String(),
        'cartId': token.cartId,
        'userId': token.userId,
        'metadata': token.metadata,
        'isExpired': token.expiresAt != null
            ? DateTime.now().isAfter(token.expiresAt!)
            : false,
      };
    } catch (e) {
      debugPrint('❌ Error getting cart token info: $e');
      return null;
    }
  }
}
