import 'package:storefront_supabase/app/models/app_user.dart';
import 'package:storefront_supabase/app/models/coupon.dart'; // Import the Coupon model

class Order {
  final String id;
  final String orderNumber;
  final String status;
  final double total;
  final DateTime createdAt;
  final String? userId;
  final AppUser? user;
  final String? couponId; // New field
  final double? discountAmount; // New field
  final Coupon? coupon; // New field

  Order({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.total,
    required this.createdAt,
    this.userId,
    this.user,
    this.couponId, // Initialize new field
    this.discountAmount, // Initialize new field
    this.coupon, // Initialize new field
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      orderNumber: json['order_number'] as String,
      status: json['status'] as String,
      total: (json['total'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      userId: json['user_id'] as String?,
      user: json['users'] != null
          ? AppUser.fromJson(json['users'] as Map<String, dynamic>)
          : null,
      couponId: json['coupon_id'] as String?, // Parse new field
      discountAmount: (json['discount_amount'] as num?)?.toDouble(), // Parse new field
      coupon: json['coupons'] != null
          ? Coupon.fromJson(json['coupons'] as Map<String, dynamic>)
          : null,
    );
  }
}
