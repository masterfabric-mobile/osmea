import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/api/admin/abstract/admin_coupons_service.dart';
import 'package:storefront_supabase/app/models/coupon.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@Injectable(as: AdminCouponsService)
class SupabaseAdminCouponsService implements AdminCouponsService {
  final SupabaseClient _client;

  SupabaseAdminCouponsService(this._client);

  @override
  Future<List<Coupon>> listCoupons({int? limit, int? offset}) async {
    var query = _client.from('coupons').select().order('created_at', ascending: false);
    if (limit != null) query = query.limit(limit);
    if (offset != null) query = query.range(offset, offset + (limit ?? 50) - 1);
    final res = await query;
    return (res as List).map((e) => Coupon.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<Coupon?> getCoupon(String id) async {
    final res = await _client.from('coupons').select().eq('id', id).maybeSingle();
    if (res == null) return null;
    return Coupon.fromJson(res);
  }

  @override
  Future<Coupon> createCoupon(Map<String, dynamic> data) async {
    final res = await _client.from('coupons').insert(data).select().single();
    return Coupon.fromJson(res);
  }

  @override
  Future<Coupon> updateCoupon(String id, Map<String, dynamic> data) async {
    final res = await _client.from('coupons').update(data).eq('id', id).select().single();
    return Coupon.fromJson(res);
  }

  @override
  Future<void> deleteCoupon(String id) async {
    await _client.from('coupons').delete().eq('id', id);
  }
}
