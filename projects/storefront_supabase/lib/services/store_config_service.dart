/// Storefront-level config (mirrors storefront_woo lib/services layout).
/// Use for default currency, maintenance flag, etc. when not using admin_settings.
class StoreConfigService {
  StoreConfigService();

  /// Default currency code when user has not selected one (e.g. from admin_settings.default_currency).
  String get defaultCurrencyCode => 'USD';
}
