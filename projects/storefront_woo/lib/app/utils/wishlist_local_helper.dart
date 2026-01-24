/*
 * WishlistLocalHelper
 * -------------------
 * Utility class for managing wishlist items in local storage.
 * Stores pending operations (add/remove) to sync with API later.
 */

import 'dart:convert';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

class WishlistLocalHelper {
  static final WishlistLocalHelper _instance = WishlistLocalHelper._internal();
  factory WishlistLocalHelper() => _instance;
  WishlistLocalHelper._internal();

  final LocalStorageHelper _storage = LocalStorageHelper();
  static const String _wishlistItemsKey = 'wishlist_items_local';
  static const String _pendingAddKey = 'wishlist_pending_add';
  static const String _pendingRemoveKey = 'wishlist_pending_remove';

  /// Initialize storage
  Future<void> init() async {
    try {
      await _storage.init();
      debugPrint('💖 WishlistLocalHelper: Storage initialized successfully');
    } catch (e) {
      debugPrint('⚠️ WishlistLocalHelper: Error initializing storage: $e');
      rethrow;
    }
  }

  /// Get all wishlist product IDs from local storage
  Future<List<int>> getWishlistProductIds() async {
    try {
      await init();
      final data = await _storage.getItem(_wishlistItemsKey);
      
      if (data == null || data.toString().isEmpty) {
        return [];
      }

      final jsonString = data.toString();
      final List<dynamic> jsonList = json.decode(jsonString);
      final productIds = jsonList.map((e) => int.parse(e.toString())).toList();
      debugPrint('💖 WishlistLocalHelper: Loaded ${productIds.length} wishlist items from local');
      return productIds;
    } catch (e) {
      debugPrint('⚠️ Error getting wishlist product IDs: $e');
      return [];
    }
  }

  /// Check if a product is in local wishlist
  Future<bool> isInWishlist(int productId) async {
    final wishlist = await getWishlistProductIds();
    return wishlist.contains(productId);
  }

  /// Add product to local wishlist (immediate)
  Future<bool> addToLocalWishlist(int productId) async {
    try {
      await init();
      final wishlist = await getWishlistProductIds();
      
      if (wishlist.contains(productId)) {
        debugPrint('💖 WishlistLocalHelper: Product $productId already in local wishlist');
        return true; // Already in wishlist
      }

      wishlist.add(productId);
      final jsonString = json.encode(wishlist);
      await _storage.setItem(_wishlistItemsKey, jsonString);
      
      // Add to pending add list for API sync
      await _addToPendingAdd(productId);
      
      debugPrint('✅ WishlistLocalHelper: Added product $productId to local wishlist');
      return true;
    } catch (e) {
      debugPrint('⚠️ Error adding product to local wishlist: $e');
      return false;
    }
  }

  /// Remove product from local wishlist (immediate)
  Future<bool> removeFromLocalWishlist(int productId) async {
    try {
      await init();
      final wishlist = await getWishlistProductIds();
      
      if (!wishlist.contains(productId)) {
        debugPrint('💖 WishlistLocalHelper: Product $productId not in local wishlist');
        return true; // Already not in wishlist
      }

      wishlist.remove(productId);
      final jsonString = json.encode(wishlist);
      await _storage.setItem(_wishlistItemsKey, jsonString);
      
      // Add to pending remove list for API sync
      await _addToPendingRemove(productId);
      
      debugPrint('✅ WishlistLocalHelper: Removed product $productId from local wishlist');
      return true;
    } catch (e) {
      debugPrint('⚠️ Error removing product from local wishlist: $e');
      return false;
    }
  }

  /// Get pending add operations
  Future<List<int>> getPendingAdd() async {
    try {
      await init();
      final data = await _storage.getItem(_pendingAddKey);
      
      if (data == null || data.toString().isEmpty) {
        return [];
      }

      final jsonString = data.toString();
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((e) => int.parse(e.toString())).toList();
    } catch (e) {
      debugPrint('⚠️ Error getting pending add: $e');
      return [];
    }
  }

  /// Get pending remove operations
  Future<List<int>> getPendingRemove() async {
    try {
      await init();
      final data = await _storage.getItem(_pendingRemoveKey);
      
      if (data == null || data.toString().isEmpty) {
        return [];
      }

      final jsonString = data.toString();
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((e) => int.parse(e.toString())).toList();
    } catch (e) {
      debugPrint('⚠️ Error getting pending remove: $e');
      return [];
    }
  }

  /// Add product to pending add list
  Future<void> _addToPendingAdd(int productId) async {
    try {
      final pending = await getPendingAdd();
      if (!pending.contains(productId)) {
        pending.add(productId);
        final jsonString = json.encode(pending);
        await _storage.setItem(_pendingAddKey, jsonString);
      }
    } catch (e) {
      debugPrint('⚠️ Error adding to pending add: $e');
    }
  }

  /// Add product to pending remove list
  Future<void> _addToPendingRemove(int productId) async {
    try {
      final pending = await getPendingRemove();
      if (!pending.contains(productId)) {
        pending.add(productId);
        final jsonString = json.encode(pending);
        await _storage.setItem(_pendingRemoveKey, jsonString);
      }
    } catch (e) {
      debugPrint('⚠️ Error adding to pending remove: $e');
    }
  }

  /// Mark pending add as synced (remove from pending)
  Future<void> markAddAsSynced(int productId) async {
    try {
      await init();
      final pending = await getPendingAdd();
      pending.remove(productId);
      final jsonString = json.encode(pending);
      await _storage.setItem(_pendingAddKey, jsonString);
      debugPrint('✅ WishlistLocalHelper: Marked product $productId add as synced');
    } catch (e) {
      debugPrint('⚠️ Error marking add as synced: $e');
    }
  }

  /// Mark pending remove as synced (remove from pending)
  Future<void> markRemoveAsSynced(int productId) async {
    try {
      await init();
      final pending = await getPendingRemove();
      pending.remove(productId);
      final jsonString = json.encode(pending);
      await _storage.setItem(_pendingRemoveKey, jsonString);
      debugPrint('✅ WishlistLocalHelper: Marked product $productId remove as synced');
    } catch (e) {
      debugPrint('⚠️ Error marking remove as synced: $e');
    }
  }

  /// Sync local wishlist with server data (replace local with server data)
  Future<void> syncFromServer(List<int> serverProductIds) async {
    try {
      await init();
      final jsonString = json.encode(serverProductIds);
      await _storage.setItem(_wishlistItemsKey, jsonString);
      debugPrint('✅ WishlistLocalHelper: Synced ${serverProductIds.length} items from server');
    } catch (e) {
      debugPrint('⚠️ Error syncing from server: $e');
    }
  }

  /// Clear all local wishlist data
  Future<void> clearAll() async {
    try {
      await init();
      await _storage.removeItem(_wishlistItemsKey);
      await _storage.removeItem(_pendingAddKey);
      await _storage.removeItem(_pendingRemoveKey);
      debugPrint('✅ WishlistLocalHelper: Cleared all local wishlist data');
    } catch (e) {
      debugPrint('⚠️ Error clearing local wishlist: $e');
    }
  }
}
