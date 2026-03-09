import 'package:storefront_supabase/app/models/app_user.dart';

/// Admin Users API contract (adapted from packages/apis admin style).
abstract class AdminUsersService {
  /// List all users with optional pagination.
  Future<List<AppUser>> listUsers({int? limit, int? offset});

  /// Get a single user by id.
  Future<AppUser?> getUser(String id);
}
