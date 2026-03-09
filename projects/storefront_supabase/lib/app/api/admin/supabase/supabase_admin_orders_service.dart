import 'package:injectable/injectable.dart' hide Order;
import 'package:storefront_supabase/app/api/admin/abstract/admin_orders_service.dart';
import 'package:storefront_supabase/app/models/order.dart' as models;
import 'package:supabase_flutter/supabase_flutter.dart';

@Injectable(as: AdminOrdersService)
class SupabaseAdminOrdersService implements AdminOrdersService {
  final SupabaseClient _client;

  SupabaseAdminOrdersService(this._client);

  @override
  Future<List<models.Order>> listOrders({
    int? limit,
    int? offset,
    String? status,
    bool includeUser = true,
  }) async {
    dynamic q = _client.from('orders').select(includeUser ? '*, users(*)' : '*');
    if (status != null && status.isNotEmpty) {
      q = q.eq('status', status);
    }
    q = q.order('created_at', ascending: false);
    if (limit != null) q = q.limit(limit);
    if (offset != null) q = q.range(offset, offset + (limit ?? 10) - 1);
    final res = await q as List;
    return res.map((e) => models.Order.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<models.Order?> getOrder(String id) async {
    final res = await _client
        .from('orders')
        .select('*, users(*)')
        .eq('id', id)
        .maybeSingle();
    if (res == null) return null;
    return models.Order.fromJson(res);
  }

  @override
  Future<models.Order> updateOrder(String id, Map<String, dynamic> data) async {
    final res = await _client
        .from('orders')
        .update(data)
        .eq('id', id)
        .select('*, users(*)')
        .single();
    return models.Order.fromJson(res);
  }
}
