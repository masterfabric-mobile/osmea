import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/views/view_cart/models/module/states.dart';

/// Kullanıcı bazlı sepet önbelleği: hangi ürünlerin sepette olduğu (giriş yapmış veya anon).
/// Sepet yüklendiğinde / sepete eklenip çıkarıldığında güncellenir.
@lazySingleton
class CartCache {
  final Map<String, Set<String>> _cache = {};

  static String _key(String productId, String? variantId) =>
      variantId == null ? productId : '${productId}_$variantId';

  /// Bu kullanıcının sepetteki ürün listesini cache'e yazar (sepet yüklendiğinde çağrılır).
  void setCartForUser(String userId, List<CartItem> items) {
    _cache[userId] = {
      for (final item in items) _key(item.product.id, item.variantId),
    };
  }

  /// Tek ürün sepete eklendi/çıkarıldığında güncelle (home/detail/favorites'dan eklerken).
  void setInCart(String userId, String productId, String? variantId, bool inCart) {
    final set = _cache.putIfAbsent(userId, () => {});
    final k = _key(productId, variantId);
    if (inCart) {
      set.add(k);
    } else {
      set.remove(k);
    }
  }

  /// Ürün bu kullanıcının cache'inde sepette mi?
  bool isInCart(String? userId, String productId, [String? variantId]) {
    if (userId == null) return false;
    return _cache[userId]?.contains(_key(productId, variantId)) ?? false;
  }
}
