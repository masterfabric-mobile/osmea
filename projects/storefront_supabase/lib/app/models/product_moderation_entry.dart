class ProductModerationEntry {
  final String id;
  final String? productId;
  final String? productName;
  final String status;
  final String? adminId;
  final String? adminEmail;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModerationEntry({
    required this.id,
    this.productId,
    this.productName,
    required this.status,
    this.adminId,
    this.adminEmail,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModerationEntry.fromJson(Map<String, dynamic> json) {
    final product = json['products'];
    final admin = json['admin_users'];
    return ProductModerationEntry(
      id: json['id'] as String,
      productId: json['product_id'] as String?,
      productName: product is Map<String, dynamic> ? product['name'] as String? : null,
      status: json['status'] as String? ?? 'pending',
      adminId: json['admin_id'] as String?,
      adminEmail: admin is Map<String, dynamic> ? admin['email'] as String? : null,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
