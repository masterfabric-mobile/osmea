import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/api/admin/abstract/admin_store_settings_service.dart';

/// Storefront-level config from admin_settings (default_currency, maintenance_mode, guest_checkout_enabled).
/// Load via [init] at app startup; then use getters for cached values.
@lazySingleton
class StoreConfigService {
  StoreConfigService(this._adminSettings);

  final AdminStoreSettingsService _adminSettings;

  static const String _keyDefaultCurrency = 'default_currency';
  static const String _keyMaintenanceMode = 'maintenance_mode';
  static const String _keyGuestCheckoutEnabled = 'guest_checkout_enabled';

  final Map<String, String> _cache = {};
  bool _initialized = false;

  /// Call once after Supabase and DI are ready (e.g. in launchApp after configureDependencies).
  /// Requires SELECT on admin_settings for the storefront client (e.g. RLS policy allowing anon/authenticated read).
  Future<void> init() async {
    if (_initialized) return;
    try {
      final list = await _adminSettings.listSettings();
      for (final s in list) {
        if (s.value != null) _cache[s.key] = s.value!;
      }
      _initialized = true;
    } catch (_) {
      // Offline or RLS: keep defaults
      _initialized = true;
    }
  }

  /// Default currency code when user has not selected one (from admin_settings).
  String get defaultCurrencyCode => _cache[_keyDefaultCurrency] ?? 'USD';

  /// When true, storefront should show maintenance screen.
  bool get isMaintenanceMode =>
      _cache[_keyMaintenanceMode]?.toLowerCase() == 'true';

  /// When false, checkout requires signed-in user (no guest checkout).
  bool get isGuestCheckoutEnabled =>
      _cache[_keyGuestCheckoutEnabled]?.toLowerCase() != 'false';
}
