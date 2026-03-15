import 'package:storefront_supabase/app/models/admin_session.dart';

/// Admin sessions (admin_sessions table).
abstract class AdminSessionsService {
  Future<List<AdminSession>> listSessions({int? limit, int? offset, String? adminId});
}
