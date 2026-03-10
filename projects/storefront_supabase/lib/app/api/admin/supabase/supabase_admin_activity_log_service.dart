import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/api/admin/abstract/admin_activity_log_service.dart';
import 'package:storefront_supabase/app/models/admin_activity_log_entry.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@Injectable(as: AdminActivityLogService)
class SupabaseAdminActivityLogService implements AdminActivityLogService {
  final SupabaseClient _client;

  SupabaseAdminActivityLogService(this._client);

  @override
  Future<List<AdminActivityLogEntry>> listLogs({
    int? limit,
    int? offset,
    String? adminId,
    String? targetTable,
  }) async {
    dynamic q = _client
        .from('admin_activity_log')
        .select('*, admin_users(email)');
    if (adminId != null) q = q.eq('admin_id', adminId);
    if (targetTable != null) q = q.eq('target_table', targetTable);
    q = q.order('created_at', ascending: false);
    if (limit != null) q = q.limit(limit);
    if (offset != null) q = q.range(offset, offset + (limit ?? 50) - 1);
    final res = await q;
    return (res as List)
        .map((e) => AdminActivityLogEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
