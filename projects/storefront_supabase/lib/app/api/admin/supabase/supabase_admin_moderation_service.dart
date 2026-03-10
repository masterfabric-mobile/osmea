import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/api/admin/abstract/admin_moderation_service.dart';
import 'package:storefront_supabase/app/models/product_moderation_entry.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@Injectable(as: AdminModerationService)
class SupabaseAdminModerationService implements AdminModerationService {
  final SupabaseClient _client;

  SupabaseAdminModerationService(this._client);

  @override
  Future<List<ProductModerationEntry>> listModeration({
    int? limit,
    int? offset,
    String? status,
  }) async {
    dynamic q = _client
        .from('product_moderation')
        .select('*, products(name), admin_users(email)');
    if (status != null && status.isNotEmpty) q = q.eq('status', status);
    q = q.order('created_at', ascending: false);
    if (limit != null) q = q.limit(limit);
    if (offset != null) q = q.range(offset, offset + (limit ?? 50) - 1);
    final res = await q;
    return (res as List)
        .map((e) => ProductModerationEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ProductModerationEntry> updateModeration(
    String id,
    Map<String, dynamic> data,
  ) async {
    final payload = Map<String, dynamic>.from(data)
      ..['updated_at'] = DateTime.now().toUtc().toIso8601String();
    final res = await _client
        .from('product_moderation')
        .update(payload)
        .eq('id', id)
        .select('*, products(name), admin_users(email)')
        .single();
    return ProductModerationEntry.fromJson(res);
  }
}
