import 'package:storefront_supabase/app/models/admin_activity_log_entry.dart';

/// Admin activity log (admin_activity_log table).
abstract class AdminActivityLogService {
  Future<List<AdminActivityLogEntry>> listLogs({int? limit, int? offset, String? adminId, String? targetTable});
}
