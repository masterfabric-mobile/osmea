import 'dart:convert';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Misafir (guest) sepet modeli – storefront_woo'daki WooCartToken yapısına benzer.
/// Giriş yapılmadan sepete eklenen ürünler burada tutulur; kullanıcı giriş yaptığında
/// CartViewModel bu veriyi Supabase'e merge edip temizler.
class GuestCart {
  final List<GuestCartEntry> items;
  final DateTime issuedAt;
  final DateTime? lastUpdated;

  const GuestCart({
    this.items = const [],
    required this.issuedAt,
    this.lastUpdated,
  });

  Map<String, dynamic> toJson() => {
        'items': items.map((e) => e.toJson()).toList(),
        'issuedAt': issuedAt.toIso8601String(),
        'lastUpdated': lastUpdated?.toIso8601String(),
      };

  factory GuestCart.fromJson(Map<String, dynamic> json) {
    final list = json['items'] as List<dynamic>?;
    return GuestCart(
      items: list != null
          ? list
              .map((e) => GuestCartEntry.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
      issuedAt: json['issuedAt'] != null
          ? DateTime.parse(json['issuedAt'] as String)
          : DateTime.now(),
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
    );
  }

  GuestCart copyWith({
    List<GuestCartEntry>? items,
    DateTime? issuedAt,
    DateTime? lastUpdated,
  }) {
    return GuestCart(
      items: items ?? this.items,
      issuedAt: issuedAt ?? this.issuedAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class GuestCartEntry {
  final String productId;
  final int quantity;
  final String? variantId;

  GuestCartEntry({
    required this.productId,
    required this.quantity,
    this.variantId,
  });

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'quantity': quantity,
        if (variantId != null) 'variant_id': variantId,
      };

  static GuestCartEntry fromJson(Map<String, dynamic> json) {
    return GuestCartEntry(
      productId: json['product_id'] as String,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      variantId: json['variant_id'] as String?,
    );
  }
}

/// Misafir sepet depolama – storefront_woo'daki WooCartTokenStorage mantığı.
/// Core LocalStorageHelper kullanır; load/save/clear akışı Woo ile uyumlu.
@lazySingleton
class GuestCartStorage {
  static const String _storageKey = 'supabase_guest_cart';

  final LocalStorageHelper _storage = LocalStorageHelper();

  static GuestCart? _cachedCart;
  static DateTime? _lastCacheUpdate;
  static const Duration _cacheValidityDuration = Duration(minutes: 1);

  void _clearCache() {
    _cachedCart = null;
    _lastCacheUpdate = null;
  }

  /// WooCartTokenStorage.loadCartToken() benzeri: misafir sepetini yükle (kısa süreli cache ile).
  Future<GuestCart?> loadGuestCart() async {
    try {
      if (_cachedCart != null && _lastCacheUpdate != null) {
        final cacheAge = DateTime.now().difference(_lastCacheUpdate!);
        if (cacheAge < _cacheValidityDuration) return _cachedCart;
      }

      await _storage.init();
      final jsonString = await _storage.getItem(_storageKey);
      if (jsonString == null || jsonString.toString().isEmpty) return null;

      final json = jsonDecode(jsonString.toString()) as Map<String, dynamic>?;
      if (json == null) return null;

      final cart = GuestCart.fromJson(json);
      _cachedCart = cart;
      _lastCacheUpdate = DateTime.now();
      return cart;
    } catch (e) {
      debugPrint('❌ GuestCartStorage loadGuestCart: $e');
      return null;
    }
  }

  /// WooCartTokenStorage.saveCartToken() benzeri: misafir sepetini kaydet.
  Future<void> saveGuestCart(GuestCart cart) async {
    try {
      await _storage.init();
      await _storage.setItem(_storageKey, jsonEncode(cart.toJson()));
      _cachedCart = cart;
      _lastCacheUpdate = DateTime.now();
    } catch (e) {
      debugPrint('❌ GuestCartStorage saveGuestCart: $e');
      rethrow;
    }
  }

  /// WooCartTokenStorage.clearCartToken() benzeri: misafir sepetini temizle.
  Future<void> clearGuestCart() async {
    try {
      await _storage.init();
      await _storage.removeItem(_storageKey);
      _clearCache();
    } catch (e) {
      debugPrint('❌ GuestCartStorage clearGuestCart: $e');
      rethrow;
    }
  }

  /// Mevcut CartViewModel API uyumluluğu: öğe listesini döndür.
  Future<List<GuestCartEntry>> getItems() async {
    final cart = await loadGuestCart();
    return cart?.items ?? [];
  }

  /// Sepete tek öğe ekle veya miktarı güncelle (aynı product_id + variant_id varsa).
  Future<void> add(String productId, {int quantity = 1, String? variantId}) async {
    final cart = await loadGuestCart() ?? GuestCart(issuedAt: DateTime.now());
    final list = List<GuestCartEntry>.from(cart.items);
    final idx = list.indexWhere(
        (e) => e.productId == productId && e.variantId == variantId);
    if (idx >= 0) {
      list[idx] = GuestCartEntry(
        productId: productId,
        quantity: list[idx].quantity + quantity,
        variantId: variantId,
      );
    } else {
      list.add(GuestCartEntry(
        productId: productId,
        quantity: quantity,
        variantId: variantId,
      ));
    }
    await saveGuestCart(cart.copyWith(
      items: list,
      lastUpdated: DateTime.now(),
    ));
  }

  /// Belirtilen indeksteki öğeyi kaldır.
  Future<void> removeAt(int index) async {
    final cart = await loadGuestCart();
    if (cart == null || index < 0 || index >= cart.items.length) return;
    final list = List<GuestCartEntry>.from(cart.items)..removeAt(index);
    if (list.isEmpty) {
      await clearGuestCart();
    } else {
      await saveGuestCart(cart.copyWith(
        items: list,
        lastUpdated: DateTime.now(),
      ));
    }
  }

  /// Belirtilen indeksteki öğenin miktarını güncelle; 0 ve altında ise öğeyi sil.
  Future<void> updateQuantityAt(int index, int quantity) async {
    final cart = await loadGuestCart();
    if (cart == null || index < 0 || index >= cart.items.length) return;
    final list = List<GuestCartEntry>.from(cart.items);
    if (quantity <= 0) {
      list.removeAt(index);
    } else {
      final e = list[index];
      list[index] = GuestCartEntry(
        productId: e.productId,
        quantity: quantity,
        variantId: e.variantId,
      );
    }
    if (list.isEmpty) {
      await clearGuestCart();
    } else {
      await saveGuestCart(cart.copyWith(
        items: list,
        lastUpdated: DateTime.now(),
      ));
    }
  }

  /// Tüm listeyi verilen öğelerle değiştir (merge sonrası temizlik vb. için).
  Future<void> setItems(List<GuestCartEntry> items) async {
    if (items.isEmpty) {
      await clearGuestCart();
      return;
    }
    final cart = await loadGuestCart() ?? GuestCart(issuedAt: DateTime.now());
    await saveGuestCart(cart.copyWith(
      items: items,
      lastUpdated: DateTime.now(),
    ));
  }

  /// Eski API uyumluluğu: clear() -> clearGuestCart().
  Future<void> clear() => clearGuestCart();

  /// Misafir sepetinde en az bir öğe var mı?
  Future<bool> get hasItems async => (await getItems()).isNotEmpty;
}
