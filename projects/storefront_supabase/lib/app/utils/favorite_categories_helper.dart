/*
 * FavoriteCategoriesHelper
 * ------------------------
 * Utility class for managing favorite categories in local storage.
 * Works for any user without server sync.
 */

import 'dart:convert';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

class FavoriteCategoriesHelper {
  static final FavoriteCategoriesHelper _instance =
      FavoriteCategoriesHelper._internal();
  factory FavoriteCategoriesHelper() => _instance;
  FavoriteCategoriesHelper._internal();

  final LocalStorageHelper _storage = LocalStorageHelper();
  static const String _storageKey = 'favorite_categories';

  /// Initialize storage
  Future<void> init() async {
    try {
      await _storage.init();
      debugPrint('💖 FavoriteCategoriesHelper: Storage initialized successfully');
    } catch (e) {
      debugPrint('⚠️ FavoriteCategoriesHelper: Error initializing storage: $e');
      rethrow;
    }
  }

  /// Get all favorite category IDs
  Future<List<String>> getFavoriteCategoryIds() async {
    try {
      await init();
      final data = await _storage.getItem(_storageKey);
      
      if (data == null || data.toString().isEmpty) {
        return [];
      }

      final jsonString = data.toString();
      final List<dynamic> jsonList = json.decode(jsonString);
      final favoriteIds = jsonList.map((e) => e.toString()).toList();
      return favoriteIds;
    } catch (e) {
      debugPrint('⚠️ Error getting favorite category IDs: $e');
      return [];
    }
  }

  /// Check if a category is favorited
  Future<bool> isFavorite(String categoryId) async {
    final favorites = await getFavoriteCategoryIds();
    return favorites.contains(categoryId);
  }

  /// Toggle favorite status for a category
  Future<bool> toggleFavorite(String categoryId) async {
    final isFav = await isFavorite(categoryId);
    if (isFav) {
      return await removeFavorite(categoryId);
    } else {
      return await addFavorite(categoryId);
    }
  }

  /// Add a category to favorites
  Future<bool> addFavorite(String categoryId) async {
    try {
      await init();
      final favorites = await getFavoriteCategoryIds();
      if (favorites.contains(categoryId)) {
        return true; // Already favorited
      }

      favorites.add(categoryId);
      final jsonString = json.encode(favorites);
      await _storage.setItem(_storageKey, jsonString);
      debugPrint('✅ Added category $categoryId to favorites');
      return true;
    } catch (e) {
      debugPrint('⚠️ Error adding favorite category: $e');
      return false;
    }
  }

  /// Remove a category from favorites
  Future<bool> removeFavorite(String categoryId) async {
    try {
      await init();
      final favorites = await getFavoriteCategoryIds();
      if (!favorites.contains(categoryId)) {
        return true; // Already not favorited
      }

      favorites.remove(categoryId);
      final jsonString = json.encode(favorites);
      await _storage.setItem(_storageKey, jsonString);
      debugPrint('✅ Removed category $categoryId from favorites');
      return true;
    } catch (e) {
      debugPrint('⚠️ Error removing favorite category: $e');
      return false;
    }
  }

  /// Clear all favorite categories
  Future<void> clearAll() async {
    try {
      await init();
      await _storage.removeItem(_storageKey);
      debugPrint('✅ Cleared all favorite categories');
    } catch (e) {
      debugPrint('⚠️ Error clearing favorite categories: $e');
    }
  }
}
