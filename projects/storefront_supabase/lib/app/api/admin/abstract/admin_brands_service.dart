import 'package:storefront_supabase/app/models/brand.dart';

/// Admin brands API contract.
abstract class AdminBrandsService {
  /// List all brands.
  Future<List<Brand>> listBrands({int? limit, int? offset});
}
