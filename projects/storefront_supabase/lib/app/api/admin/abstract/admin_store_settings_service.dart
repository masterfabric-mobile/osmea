import 'package:storefront_supabase/app/models/admin_setting.dart';

/// Admin store settings (key-value from admin_settings table).
/// Use for app-level config: maintenance_mode, order_auto_confirm, etc.
abstract class AdminStoreSettingsService {
  /// List all settings.
  Future<List<AdminSetting>> listSettings();

  /// Get one setting by key.
  Future<AdminSetting?> getSetting(String key);

  /// Create or update setting by key.
  Future<AdminSetting> setSetting(String key, String value);
}
