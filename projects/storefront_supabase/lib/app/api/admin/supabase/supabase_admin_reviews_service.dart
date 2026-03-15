import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/api/admin/abstract/admin_reviews_service.dart';
import 'package:storefront_supabase/app/models/product_review.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@Injectable(as: AdminReviewsService)
class SupabaseAdminReviewsService implements AdminReviewsService {
  final SupabaseClient _client;

  SupabaseAdminReviewsService(this._client);

  @override
  Future<List<ProductReview>> listReviews({
    int? limit,
    int? offset,
    String? productId,
    bool? isApproved,
  }) async {
    dynamic query = _client.from('product_reviews').select('*, users(full_name)');
    if (productId != null) query = query.eq('product_id', productId);
    if (isApproved != null) query = query.eq('is_approved', isApproved);
    query = query.order('created_at', ascending: false);
    if (limit != null) query = query.limit(limit);
    if (offset != null) query = query.range(offset, offset + (limit ?? 50) - 1);
    final res = await query;
    return (res as List)
        .map((e) => ProductReview.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ProductReview> updateReview(String id, Map<String, dynamic> data) async {
    final payload = Map<String, dynamic>.from(data)..['updated_at'] = DateTime.now().toUtc().toIso8601String();
    final res = await _client
        .from('product_reviews')
        .update(payload)
        .eq('id', id)
        .select('*, users(full_name)')
        .single();
    return ProductReview.fromJson(res);
  }
}
