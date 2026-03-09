import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/api/admin/abstract/admin_products_service.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@Injectable(as: AdminProductsService)
class SupabaseAdminProductsService implements AdminProductsService {
  final SupabaseClient _client;

  SupabaseAdminProductsService(this._client);

  @override
  Future<List<Product>> listProducts({
    String? search,
    String? categoryId,
    int? limit,
    int? offset,
    String? orderBy,
    bool ascending = true,
  }) async {
    dynamic query = _client
        .from('products')
        .select('*, product_images(*), brand(name)');
    if (search != null && search.isNotEmpty) {
      query = query.ilike('name', '%$search%');
    }
    if (categoryId != null && categoryId.isNotEmpty) {
      query = query.eq('category_id', categoryId);
    }
    query = query.order(orderBy ?? 'created_at', ascending: ascending);
    if (limit != null) query = query.limit(limit);
    if (offset != null) query = query.range(offset, offset + (limit ?? 20) - 1);
    final res = await query as List;
    return res.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<Product?> getProduct(String id) async {
    final res = await _client
        .from('products')
        .select('*, product_images(*), product_variants(*), brand(name)')
        .eq('id', id)
        .maybeSingle();
    if (res == null) return null;
    return Product.fromJson(res);
  }

  @override
  Future<Product> createProduct(Map<String, dynamic> data) async {
    final res = await _client
        .from('products')
        .insert(data)
        .select('*, product_images(*), brand(name)')
        .single();
    return Product.fromJson(res);
  }

  @override
  Future<Product> updateProduct(String id, Map<String, dynamic> data) async {
    final res = await _client
        .from('products')
        .update(data)
        .eq('id', id)
        .select('*, product_images(*), brand(name)')
        .single();
    return Product.fromJson(res);
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _client.from('products').delete().eq('id', id);
  }
}
