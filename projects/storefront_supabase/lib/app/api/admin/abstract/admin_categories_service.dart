import 'package:storefront_supabase/app/models/category.dart';

/// Admin categories API contract.
abstract class AdminCategoriesService {
  /// List categories (optionally with product count).
  Future<List<Category>> listCategories({int? limit, int? offset});
}
