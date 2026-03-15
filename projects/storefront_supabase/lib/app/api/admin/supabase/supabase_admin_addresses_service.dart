import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/api/admin/abstract/admin_addresses_service.dart';
import 'package:storefront_supabase/app/models/user_address.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@Injectable(as: AdminAddressesService)
class SupabaseAdminAddressesService implements AdminAddressesService {
  final SupabaseClient _client;

  SupabaseAdminAddressesService(this._client);

  @override
  Future<List<UserAddress>> listAddresses({
    int? limit,
    int? offset,
    String? userId,
  }) async {
    dynamic query = _client.from('user_addresses').select();
    if (userId != null) query = query.eq('user_id', userId);
    query = query.order('created_at', ascending: false);
    if (limit != null) query = query.limit(limit);
    if (offset != null) query = query.range(offset, offset + (limit ?? 50) - 1);
    final res = await query;
    return (res as List)
        .map((e) => UserAddress.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
