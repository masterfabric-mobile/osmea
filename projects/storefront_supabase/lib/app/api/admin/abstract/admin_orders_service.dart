import 'package:storefront_supabase/app/models/order.dart';

/// Admin Orders API contract (adapted from packages/apis admin style).
/// Implementations may use Supabase, WooCommerce, or another backend.
abstract class AdminOrdersService {
  /// List all orders, optionally with user relation and pagination.
  Future<List<Order>> listOrders({
    int? limit,
    int? offset,
    String? status,
    bool includeUser = true,
  });

  /// Get a single order by id.
  Future<Order?> getOrder(String id);

  /// Update order status (or other fields).
  Future<Order> updateOrder(String id, Map<String, dynamic> data);
}
