import 'package:storefront_supabase/app/models/app_user.dart';

class Order {
  final String id;
  final String orderNumber;
  final String status;
  final double total;
  final DateTime createdAt;
  final String? userId;
  final AppUser? user;

  Order({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.total,
    required this.createdAt,
    this.userId,
    this.user,
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
    );
  }
}
