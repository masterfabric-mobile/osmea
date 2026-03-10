import 'package:storefront_supabase/app/models/product_moderation_entry.dart';

/// Product moderation (product_moderation table).
abstract class AdminModerationService {
  Future<List<ProductModerationEntry>> listModeration({int? limit, int? offset, String? status});

  Future<ProductModerationEntry> updateModeration(String id, Map<String, dynamic> data);
}
