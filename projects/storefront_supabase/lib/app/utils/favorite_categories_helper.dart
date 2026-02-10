/*
 * FavoriteCategoriesHelper
 * ------------------------
 * Artık local storage yerine Supabase `favorites` tablosundaki `category_id`
 * kolonunu kullanarak kategori favorilerini yönetir.
 */

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoriteCategoriesHelper {
  static final FavoriteCategoriesHelper _instance =
      FavoriteCategoriesHelper._internal();
  factory FavoriteCategoriesHelper() => _instance;
  FavoriteCategoriesHelper._internal();

  SupabaseClient get _client => Supabase.instance.client;

  /// Kullanıcının favori kategori id listesi (favorites.category_id üzerinden)
  Future<List<String>> getFavoriteCategoryIds() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await _client
          .from('favorites')
          .select('category_id')
          .eq('user_id', userId)
          .not('category_id', 'is', null);

      final list = response as List<dynamic>;
      return list
          .map((e) => (e as Map<String, dynamic>)['category_id']?.toString())
          .whereType<String>()
          .toList();
    } catch (e) {
      debugPrint('⚠️ Error getting favorite category IDs: $e');
      return [];
    }
  }

  /// Kategori favori mi? (favorites.category_id üzerinden)
  Future<bool> isFavorite(String categoryId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        // Anon veya giriş yoksa, RLS anon izin veriyorsa yine de çalışır;
        // ama explicit olarak false dönmek daha güvenli olabilir.
        return false;
      }

      final response = await _client
          .from('favorites')
          .select('id')
          .eq('user_id', userId)
          .eq('category_id', categoryId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      debugPrint('⚠️ Error checking favorite category ($categoryId): $e');
      return false;
    }
  }

  /// Favori durumunu toggle et
  Future<bool> toggleFavorite(String categoryId) async {
    final isFav = await isFavorite(categoryId);
    if (isFav) {
      return await removeFavorite(categoryId);
    } else {
      return await addFavorite(categoryId);
    }
  }

  /// Kategoriyi favorilere ekle (favorites.category_id)
  Future<bool> addFavorite(String categoryId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        return false;
      }

      // Zaten varsa tekrar ekleme
      final existing = await _client
          .from('favorites')
          .select('id')
          .eq('user_id', userId)
          .eq('category_id', categoryId)
          .maybeSingle();

      if (existing != null) {
        return true;
      }

      await _client.from('favorites').insert({
        'user_id': userId,
        'category_id': categoryId,
      });

      debugPrint('✅ Added category $categoryId to favorites (Supabase)');
      return true;
    } catch (e) {
      debugPrint('⚠️ Error adding favorite category to Supabase: $e');
      return false;
    }
  }

  /// Kategoriyi favorilerden çıkar (favorites.category_id)
  Future<bool> removeFavorite(String categoryId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        return false;
      }

      await _client
          .from('favorites')
          .delete()
          .match({'user_id': userId, 'category_id': categoryId});

      debugPrint('✅ Removed category $categoryId from favorites (Supabase)');
      return true;
    } catch (e) {
      debugPrint('⚠️ Error removing favorite category from Supabase: $e');
      return false;
    }
  }

  /// Bu helper artık global “clearAll” için spesifik bir kullanım gerektirmiyor,
  /// istersek sadece kategori favorilerini temizleyebiliriz.
  Future<void> clearAll() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return;

      await _client
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .not('category_id', 'is', null);

      debugPrint('✅ Cleared all favorite categories from Supabase');
    } catch (e) {
      debugPrint('⚠️ Error clearing favorite categories from Supabase: $e');
    }
  }
}
