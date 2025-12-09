import 'package:storefront_supabase/app/models/product.dart';

class CartItem {
  final String id; // This is the id from the 'cart' table
  final int quantity;
  final Product product;

  CartItem({
    required this.id,
    required this.quantity,
    required this.product,
  });

  // A factory constructor to create a CartItem from a JSON map
  // This is useful when fetching data from Supabase that joins 'cart' and 'products'
  factory CartItem.fromJson(Map<String, dynamic> json) {
    if (json['products'] == null) {
      throw ArgumentError('CartItem.fromJson: "products" field cannot be null.');
    }
    return CartItem(
      id: json['id'] as String,
      quantity: json['quantity'] as int,
      product: Product.fromJson(json['products'] as Map<String, dynamic>),
    );
  }
}
