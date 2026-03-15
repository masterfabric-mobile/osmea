import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/api/admin/abstract/admin_staff_service.dart';
import 'package:storefront_supabase/app/models/admin_staff_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@Injectable(as: AdminStaffService)
class SupabaseAdminStaffService implements AdminStaffService {
  final SupabaseClient _client;

  SupabaseAdminStaffService(this._client);

  @override
  Future<List<AdminStaffUser>> listStaff({int? limit, int? offset}) async {
    dynamic q = _client.from('admin_users').select().order('created_at', ascending: false);
    if (limit != null) q = q.limit(limit);
    if (offset != null) q = q.range(offset, offset + (limit ?? 50) - 1);
    final res = await q;
    return (res as List)
        .map((e) => AdminStaffUser.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<AdminStaffUser> setActive(String id, bool isActive) async {
    final res = await _client
        .from('admin_users')
        .update({
          'is_active': isActive,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', id)
        .select()
        .single();
    return AdminStaffUser.fromJson(res);
  }
}
