import 'package:storefront_supabase/app/models/product_review.dart';

/// Admin product reviews API contract.
abstract class AdminReviewsService {
  /// List reviews (optionally filter by product or approved status).
  Future<List<ProductReview>> listReviews({
    int? limit,
    int? offset,
    String? productId,
    bool? isApproved,
  });

  /// Update review (e.g. approve/reject).
  Future<ProductReview> updateReview(String id, Map<String, dynamic> data);
}
