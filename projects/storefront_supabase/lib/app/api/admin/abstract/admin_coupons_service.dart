import 'package:storefront_supabase/app/models/coupon.dart';

/// Admin Coupons API contract (adapted from packages/apis admin style).
abstract class AdminCouponsService {
  /// List all coupons.
  Future<List<Coupon>> listCoupons({int? limit, int? offset});

  /// Get a single coupon by id.
  Future<Coupon?> getCoupon(String id);

  /// Create a new coupon.
  Future<Coupon> createCoupon(Map<String, dynamic> data);

  /// Update an existing coupon.
  Future<Coupon> updateCoupon(String id, Map<String, dynamic> data);

  /// Delete a coupon.
  Future<void> deleteCoupon(String id);
}
