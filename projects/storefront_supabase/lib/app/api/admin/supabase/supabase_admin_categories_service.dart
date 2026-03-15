import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/api/admin/abstract/admin_categories_service.dart';
import 'package:storefront_supabase/app/models/category.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@Injectable(as: AdminCategoriesService)
class SupabaseAdminCategoriesService implements AdminCategoriesService {
  final SupabaseClient _client;

  SupabaseAdminCategoriesService(this._client);

  @override
  Future<List<Category>> listCategories({int? limit, int? offset}) async {
    var query = _client
        .from('categories')
        .select()
        .order('sort_order', ascending: true)
        .order('name', ascending: true);
    if (limit != null) query = query.limit(limit);
    if (offset != null) query = query.range(offset, offset + (limit ?? 50) - 1);
    final res = await query;
    return (res as List)
        .map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
