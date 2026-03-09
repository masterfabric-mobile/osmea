import 'package:storefront_supabase/app/models/product.dart';

/// Admin Products API contract (adapted from packages/apis admin style).
abstract class AdminProductsService {
  /// List products with optional search, filters and pagination.
  Future<List<Product>> listProducts({
    String? search,
    String? categoryId,
    int? limit,
    int? offset,
    String? orderBy,
    bool ascending = true,
  });

  /// Get a single product by id.
  Future<Product?> getProduct(String id);

  /// Create a new product.
  Future<Product> createProduct(Map<String, dynamic> data);

  /// Update an existing product.
  Future<Product> updateProduct(String id, Map<String, dynamic> data);

  /// Delete a product.
  Future<void> deleteProduct(String id);
}
