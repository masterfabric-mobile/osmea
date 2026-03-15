import 'package:storefront_supabase/app/models/admin_staff_user.dart';

/// Admin staff users (admin_users table).
abstract class AdminStaffService {
  Future<List<AdminStaffUser>> listStaff({int? limit, int? offset});

  Future<AdminStaffUser> setActive(String id, bool isActive);
}
