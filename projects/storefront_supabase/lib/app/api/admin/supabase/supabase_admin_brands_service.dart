import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/api/admin/abstract/admin_brands_service.dart';
import 'package:storefront_supabase/app/models/brand.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@Injectable(as: AdminBrandsService)
class SupabaseAdminBrandsService implements AdminBrandsService {
  final SupabaseClient _client;

  SupabaseAdminBrandsService(this._client);

  @override
  Future<List<Brand>> listBrands({int? limit, int? offset}) async {
    var query = _client.from('brand').select().order('name', ascending: true);
    if (limit != null) query = query.limit(limit);
    if (offset != null) query = query.range(offset, offset + (limit ?? 50) - 1);
    final res = await query;
    return (res as List)
        .map((e) => Brand.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
