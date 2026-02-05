class ProductVariant {
  final String id;
  final String productId;
  final String name; // e.g., "Size", "Color"
  final String value; // e.g., "M", "Red"
  final double priceModifier;
  final int stockQuantity;

  ProductVariant({
    required this.id,
    required this.productId,
    required this.name,
    required this.value,
    this.priceModifier = 0.0,
    this.stockQuantity = 0,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      name: json['variant_name'] as String,
      value: json['variant_value'] as String,
      priceModifier: (json['price_modifier'] as num?)?.toDouble() ?? 0.0,
      stockQuantity: json['stock_quantity'] as int? ?? 0,
    );
  }
}
