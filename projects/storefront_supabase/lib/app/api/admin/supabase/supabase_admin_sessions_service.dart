import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/api/admin/abstract/admin_sessions_service.dart';
import 'package:storefront_supabase/app/models/admin_session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@Injectable(as: AdminSessionsService)
class SupabaseAdminSessionsService implements AdminSessionsService {
  final SupabaseClient _client;

  SupabaseAdminSessionsService(this._client);

  @override
  Future<List<AdminSession>> listSessions({
    int? limit,
    int? offset,
    String? adminId,
  }) async {
    dynamic q = _client
        .from('admin_sessions')
        .select('*, admin_users(email)');
    if (adminId != null) q = q.eq('admin_id', adminId);
    q = q.order('created_at', ascending: false);
    if (limit != null) q = q.limit(limit);
    if (offset != null) q = q.range(offset, offset + (limit ?? 50) - 1);
    final res = await q;
    return (res as List)
        .map((e) => AdminSession.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
