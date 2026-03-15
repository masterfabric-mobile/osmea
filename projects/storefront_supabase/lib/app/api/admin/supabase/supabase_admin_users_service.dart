import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/api/admin/abstract/admin_users_service.dart';
import 'package:storefront_supabase/app/models/app_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@Injectable(as: AdminUsersService)
class SupabaseAdminUsersService implements AdminUsersService {
  final SupabaseClient _client;

  SupabaseAdminUsersService(this._client);

  @override
  Future<List<AppUser>> listUsers({int? limit, int? offset}) async {
    var query = _client.from('users').select().order('created_at', ascending: false);
    if (limit != null) query = query.limit(limit);
    if (offset != null) query = query.range(offset, offset + (limit ?? 20) - 1);
    final res = await query;
    return (res as List).map((e) => AppUser.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<AppUser?> getUser(String id) async {
    final res = await _client.from('users').select().eq('id', id).maybeSingle();
    if (res == null) return null;
    return AppUser.fromJson(res);
  }
}
