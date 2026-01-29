/**
 * OSMEA App Config Manager - Tabbed form UI.
 * Admin never sees raw JSON. Each top-level config key = one tab; form builds JSON on save.
 */
(function($) {
    'use strict';
    if (typeof $ !== 'function' || !$.fn || !$.fn.jquery) return;

    /** Legacy tab id -> label (for group titles). */
    function getTabs() {
        return [
            { id: 'app_settings', label: 'App Settings' },
            { id: 'api_configuration', label: 'API' },
            { id: 'woocommerce_configuration', label: 'WooCommerce' },
            { id: 'account_configuration', label: 'Account' },
            { id: 'firebase_configuration', label: 'Firebase' },
            { id: 'ui_configuration', label: 'UI' },
            { id: 'search_view_configuration', label: 'Search View' },
            { id: 'security_configuration', label: 'Security' },
            { id: 'storage_configuration', label: 'Storage' },
            { id: 'notification_configuration', label: 'Notifications' },
            { id: 'feature_flags', label: 'Feature Flags' },
            { id: 'splash_configuration', label: 'Splash' },
            { id: 'localization_configuration', label: 'Localization' },
            { id: 'performance_configuration', label: 'Performance' },
            { id: 'onboarding_configuration', label: 'Onboarding' },
            { id: 'about_configuration', label: 'About' },
            { id: 'contact_us_configuration', label: 'Contact Us' },
            { id: 'faq_configuration', label: 'FAQ' },
            { id: 'loading_configuration', label: 'Loading' },
            { id: 'error_handling_configuration', label: 'Error Handling' },
            { id: 'auth_configuration', label: 'Auth' },
            { id: 'empty_view_configuration', label: 'Empty View' },
            { id: 'home_view', label: 'Home View' },
            { id: 'product_detail_view', label: 'Product Detail' },
            { id: 'product_list_view', label: 'Product List' },
            { id: 'product_card', label: 'Product Card' },
            { id: 'navbar_configuration', label: 'Navbar' },
            { id: 'campaign_view', label: 'Campaign View' },
            { id: 'cart_view_configuration', label: 'Cart View' },
            { id: 'checkout_view_configuration', label: 'Checkout' },
            { id: 'wishlist_view', label: 'Wishlist' },
            { id: 'favorite_categories_view_configuration', label: 'Favorite Categories' },
            { id: 'dialog_popup_configuration', label: 'Dialog & Popup' },
            { id: 'orders_history_view', label: 'Orders History' },
            { id: 'user_profile_view', label: 'User Profile' },
            { id: 'order_detail_view', label: 'Order Detail' }
        ];
    }

    /** Top-level categories (shown in tabbar, fewer tabs). */
    function getCategories() {
        if (typeof osmeaConfig !== 'undefined' && Array.isArray(osmeaConfig.categories) && osmeaConfig.categories.length) {
            return osmeaConfig.categories.map(function(c) {
                return { id: c.id, label: c.label || c.id, tabIds: Array.isArray(c.tabIds) ? c.tabIds : [] };
            });
        }
        return [
            { id: 'general', label: 'General', tabIds: ['app_settings', 'api_configuration', 'woocommerce_configuration'] },
            { id: 'home', label: 'Home', tabIds: ['home_view'] },
            { id: 'theme_account', label: 'Theme & Account', tabIds: ['account_configuration', 'ui_configuration', 'firebase_configuration', 'localization_configuration'] },
            { id: 'infrastructure', label: 'Infrastructure', tabIds: ['security_configuration', 'storage_configuration', 'notification_configuration', 'performance_configuration', 'feature_flags'] },
            { id: 'content', label: 'Content', tabIds: ['splash_configuration', 'onboarding_configuration', 'about_configuration', 'contact_us_configuration', 'faq_configuration', 'loading_configuration', 'error_handling_configuration', 'empty_view_configuration'] },
            { id: 'auth', label: 'Auth', tabIds: ['auth_configuration'] },
            { id: 'views', label: 'Views', tabIds: ['search_view_configuration', 'product_detail_view', 'product_list_view', 'product_card', 'navbar_configuration', 'campaign_view', 'cart_view_configuration', 'checkout_view_configuration', 'wishlist_view', 'favorite_categories_view_configuration', 'dialog_popup_configuration', 'orders_history_view', 'user_profile_view', 'order_detail_view'] }
        ];
    }

    function isImageUrlField(field) {
        if (field.type === 'image') return true;
        var p = (field.path || '').toLowerCase();
        return /logo_url|splash_image_url|imageurl|image_url/.test(p);
    }

    function getFieldDefinitions() {
        var sel = function(opts) { return { type: 'select', options: opts }; };
        var v1v2v3 = [{ value: 'v1', label: 'v1' }, { value: 'v2', label: 'v2' }, { value: 'v3', label: 'v3' }];
        var defs = [
            // app_settings
            { tab: 'app_settings', path: 'app_settings.app_name', type: 'text', label: 'App Name' },
            { tab: 'app_settings', path: 'app_settings.app_version', type: 'text', label: 'App Version' },
            { tab: 'app_settings', path: 'app_settings.build_number', type: 'text', label: 'Build Number' },
            { tab: 'app_settings', path: 'app_settings.environment', type: 'select', label: 'Environment', options: [{ value: 'production', label: 'Production' }, { value: 'staging', label: 'Staging' }, { value: 'development', label: 'Development' }]},
            { tab: 'app_settings', path: 'app_settings.debug_mode', type: 'boolean', label: 'Debug Mode' },
            { tab: 'app_settings', path: 'app_settings.maintenance_mode', type: 'boolean', label: 'Maintenance Mode' },
            // api_configuration
            { tab: 'api_configuration', path: 'api_configuration.base_url', type: 'text', label: 'Base URL' },
            { tab: 'api_configuration', path: 'api_configuration.timeout_seconds', type: 'number', label: 'Timeout (s)' },
            { tab: 'api_configuration', path: 'api_configuration.retry_count', type: 'number', label: 'Retry Count' },
            { tab: 'api_configuration', path: 'api_configuration.enable_logging', type: 'boolean', label: 'Enable Logging' },
            // woocommerce_configuration
            { tab: 'woocommerce_configuration', path: 'woocommerce_configuration.store_url', type: 'text', label: 'Store URL' },
            { tab: 'woocommerce_configuration', path: 'woocommerce_configuration.brand_name', type: 'text', label: 'Brand Name' },
            { tab: 'woocommerce_configuration', path: 'woocommerce_configuration.auth_key', type: 'text', label: 'Auth Key' },
            { tab: 'woocommerce_configuration', path: 'woocommerce_configuration.version', type: 'select', label: 'Version', options: v1v2v3 },
            { tab: 'woocommerce_configuration', path: 'woocommerce_configuration.store_api_version', type: 'select', label: 'Store API Version', options: v1v2v3 },
            { tab: 'woocommerce_configuration', path: 'woocommerce_configuration.admin_api_version', type: 'select', label: 'Admin API Version', options: v1v2v3 },
            { tab: 'woocommerce_configuration', path: 'woocommerce_configuration.wishlist_api_version', type: 'select', label: 'Wishlist API Version', options: v1v2v3 },
            { tab: 'woocommerce_configuration', path: 'woocommerce_configuration.wishlist_namespace', type: 'text', label: 'Wishlist Namespace' },
            { tab: 'woocommerce_configuration', path: 'woocommerce_configuration.verify_ssl', type: 'boolean', label: 'Verify SSL' },
            { tab: 'woocommerce_configuration', path: 'woocommerce_configuration.query_string_auth', type: 'boolean', label: 'Query String Auth' },
            { tab: 'woocommerce_configuration', path: 'woocommerce_configuration.products_per_page', type: 'number', label: 'Products Per Page' },
            { tab: 'woocommerce_configuration', path: 'woocommerce_configuration.enable_reviews', type: 'boolean', label: 'Enable Reviews' },
            { tab: 'woocommerce_configuration', path: 'woocommerce_configuration.enable_coupons', type: 'boolean', label: 'Enable Coupons' },
            { tab: 'woocommerce_configuration', path: 'woocommerce_configuration.enable_guest_checkout', type: 'boolean', label: 'Enable Guest Checkout' },
            // account_configuration
            { tab: 'account_configuration', path: 'account_configuration.style', type: 'select', label: 'Style', options: [{ value: 'space', label: 'Space' }, { value: 'startup', label: 'Startup' }, { value: 'enterprise', label: 'Enterprise' }]},
            { tab: 'account_configuration', path: 'account_configuration.space_style_colors.primary_color', type: 'text', label: 'Primary Color' },
            { tab: 'account_configuration', path: 'account_configuration.space_style_colors.secondary_color', type: 'text', label: 'Secondary Color' },
            { tab: 'account_configuration', path: 'account_configuration.space_style_colors.text_color', type: 'text', label: 'Text Color' },
            { tab: 'account_configuration', path: 'account_configuration.space_style_colors.icon_color', type: 'text', label: 'Icon Color' },
            { tab: 'account_configuration', path: 'account_configuration.space_style_colors.separator_color', type: 'text', label: 'Separator Color' },
            { tab: 'account_configuration', path: 'account_configuration.space_style_colors.background_color', type: 'text', label: 'Background Color' },
            // firebase_configuration
            { tab: 'firebase_configuration', path: 'firebase_configuration.analytics_enabled', type: 'boolean', label: 'Analytics' },
            { tab: 'firebase_configuration', path: 'firebase_configuration.crashlytics_enabled', type: 'boolean', label: 'Crashlytics' },
            { tab: 'firebase_configuration', path: 'firebase_configuration.performance_monitoring_enabled', type: 'boolean', label: 'Performance Monitoring' },
            { tab: 'firebase_configuration', path: 'firebase_configuration.remote_config_enabled', type: 'boolean', label: 'Remote Config' },
            { tab: 'firebase_configuration', path: 'firebase_configuration.remote_config_fetch_timeout', type: 'number', label: 'Remote Config Timeout' },
            { tab: 'firebase_configuration', path: 'firebase_configuration.remote_config_cache_expiration', type: 'number', label: 'Remote Config Cache Expiration' },
            // ui_configuration
            { tab: 'ui_configuration', path: 'ui_configuration.theme_mode', type: 'select', label: 'Theme Mode', options: [{ value: 'light', label: 'Light' }, { value: 'dark', label: 'Dark' }, { value: 'system', label: 'System' }]},
            { tab: 'ui_configuration', path: 'ui_configuration.primary_color', type: 'text', label: 'Primary Color' },
            { tab: 'ui_configuration', path: 'ui_configuration.accent_color', type: 'text', label: 'Accent Color' },
            { tab: 'ui_configuration', path: 'ui_configuration.search_app_bar_color', type: 'text', label: 'Search App Bar Color' },
            { tab: 'ui_configuration', path: 'ui_configuration.font_scale', type: 'number', label: 'Font Scale' },
            { tab: 'ui_configuration', path: 'ui_configuration.enable_haptic_feedback', type: 'boolean', label: 'Haptic Feedback' },
            { tab: 'ui_configuration', path: 'ui_configuration.enable_sound_effects', type: 'boolean', label: 'Sound Effects' },
            // search_view_configuration
            { tab: 'search_view_configuration', path: 'search_view_configuration.search_app_bar_color', type: 'text', label: 'Search App Bar Color' },
            { tab: 'search_view_configuration', path: 'search_view_configuration.search_bar_border_color', type: 'text', label: 'Search Bar Border Color' },
            { tab: 'search_view_configuration', path: 'search_view_configuration.action_icon_color', type: 'text', label: 'Action Icon Color' },
            { tab: 'search_view_configuration', path: 'search_view_configuration.text_color', type: 'text', label: 'Text Color' },
            { tab: 'search_view_configuration', path: 'search_view_configuration.hint_text_color', type: 'text', label: 'Hint Text Color' },
            { tab: 'search_view_configuration', path: 'search_view_configuration.focus_color', type: 'text', label: 'Focus Color' },
            { tab: 'search_view_configuration', path: 'search_view_configuration.error_color', type: 'text', label: 'Error Color' },
            { tab: 'search_view_configuration', path: 'search_view_configuration.search_bar_show_clear_button', type: 'boolean', label: 'Show Clear Button' },
            { tab: 'search_view_configuration', path: 'search_view_configuration.search_bar_show_search_icon', type: 'boolean', label: 'Show Search Icon' },
            { tab: 'search_view_configuration', path: 'search_view_configuration.elevation', type: 'number', label: 'Elevation' },
            { tab: 'search_view_configuration', path: 'search_view_configuration.search_bar_size', type: 'select', label: 'Search Bar Size', options: [{ value: 'small', label: 'Small' }, { value: 'medium', label: 'Medium' }, { value: 'large', label: 'Large' }]},
            { tab: 'search_view_configuration', path: 'search_view_configuration.search_bar_variant', type: 'select', label: 'Search Bar Variant', options: [{ value: 'borderless', label: 'Borderless' }, { value: 'outlined', label: 'Outlined' }, { value: 'filled', label: 'Filled' }]},
            { tab: 'search_view_configuration', path: 'search_view_configuration.search_bar_border_radius', type: 'number', label: 'Search Bar Border Radius' },
            { tab: 'search_view_configuration', path: 'search_view_configuration.title', type: 'text', label: 'Title' },
            { tab: 'search_view_configuration', path: 'search_view_configuration.search_hint', type: 'text', label: 'Search Hint' },
            { tab: 'search_view_configuration', path: 'search_view_configuration.show_barcode_scanner', type: 'boolean', label: 'Show Barcode Scanner' },
            { tab: 'search_view_configuration', path: 'search_view_configuration.show_voice_search', type: 'boolean', label: 'Show Voice Search' },
            { tab: 'search_view_configuration', path: 'search_view_configuration.show_back_button', type: 'boolean', label: 'Show Back Button' },
            { tab: 'search_view_configuration', path: 'search_view_configuration.action_button_spacing', type: 'number', label: 'Action Button Spacing' },
            { tab: 'search_view_configuration', path: 'search_view_configuration.action_button_min_width', type: 'number', label: 'Action Min Width' },
            { tab: 'search_view_configuration', path: 'search_view_configuration.action_button_min_height', type: 'number', label: 'Action Min Height' },
            { tab: 'search_view_configuration', path: 'search_view_configuration.action_button_padding_all', type: 'number', label: 'Action Padding' },
            { tab: 'search_view_configuration', path: 'search_view_configuration.loading.color', type: 'text', label: 'Loading Color' },
            { tab: 'search_view_configuration', path: 'search_view_configuration.loading.stepDuration', type: 'number', label: 'Loading Step Duration' },
            { tab: 'search_view_configuration', path: 'search_view_configuration.loading.showProgress', type: 'boolean', label: 'Loading Show Progress' },
            { tab: 'search_view_configuration', path: 'search_view_configuration.loading.showCancelButton', type: 'boolean', label: 'Loading Show Cancel' },
            // security_configuration
            { tab: 'security_configuration', path: 'security_configuration.enable_ssl_pinning', type: 'boolean', label: 'SSL Pinning' },
            { tab: 'security_configuration', path: 'security_configuration.certificate_validation', type: 'boolean', label: 'Certificate Validation' },
            { tab: 'security_configuration', path: 'security_configuration.biometric_authentication', type: 'boolean', label: 'Biometric Auth' },
            { tab: 'security_configuration', path: 'security_configuration.session_timeout_minutes', type: 'number', label: 'Session Timeout (min)' },
            // storage_configuration
            { tab: 'storage_configuration', path: 'storage_configuration.enable_encryption', type: 'boolean', label: 'Encryption' },
            { tab: 'storage_configuration', path: 'storage_configuration.cache_size_mb', type: 'number', label: 'Cache Size (MB)' },
            { tab: 'storage_configuration', path: 'storage_configuration.auto_cleanup_enabled', type: 'boolean', label: 'Auto Cleanup' },
            { tab: 'storage_configuration', path: 'storage_configuration.backup_enabled', type: 'boolean', label: 'Backup' },
            // notification_configuration
            { tab: 'notification_configuration', path: 'notification_configuration.push_notifications_enabled', type: 'boolean', label: 'Push Notifications' },
            { tab: 'notification_configuration', path: 'notification_configuration.local_notifications_enabled', type: 'boolean', label: 'Local Notifications' },
            { tab: 'notification_configuration', path: 'notification_configuration.notification_sound', type: 'select', label: 'Notification Sound', options: [{ value: 'default', label: 'Default' }, { value: 'none', label: 'None' }, { value: 'custom', label: 'Custom' }]},
            { tab: 'notification_configuration', path: 'notification_configuration.vibration_enabled', type: 'boolean', label: 'Vibration' },
            // feature_flags
            { tab: 'feature_flags', path: 'feature_flags.onboarding_enabled', type: 'boolean', label: 'Onboarding' },
            { tab: 'feature_flags', path: 'feature_flags.dark_mode_available', type: 'boolean', label: 'Dark Mode Available' },
            { tab: 'feature_flags', path: 'feature_flags.offline_mode_enabled', type: 'boolean', label: 'Offline Mode' },
            { tab: 'feature_flags', path: 'feature_flags.beta_features_enabled', type: 'boolean', label: 'Beta Features' },
            { tab: 'feature_flags', path: 'feature_flags.analytics_opt_out_available', type: 'boolean', label: 'Analytics Opt Out' },
            { tab: 'feature_flags', path: 'feature_flags.woocommerce_integration_enabled', type: 'boolean', label: 'WooCommerce Integration' },
            { tab: 'feature_flags', path: 'feature_flags.payment_gateway_enabled', type: 'boolean', label: 'Payment Gateway' },
            { tab: 'feature_flags', path: 'feature_flags.wishlist_enabled', type: 'boolean', label: 'Wishlist' },
            { tab: 'feature_flags', path: 'feature_flags.cart_persistence_enabled', type: 'boolean', label: 'Cart Persistence' },
            // splash_configuration
            { tab: 'splash_configuration', path: 'splash_configuration.enabled', type: 'boolean', label: 'Enabled' },
            { tab: 'splash_configuration', path: 'splash_configuration.style', type: 'select', label: 'Style', options: [{ value: 'startup', label: 'Startup' }, { value: 'space', label: 'Space' }, { value: 'enterprise', label: 'Enterprise' }]},
            { tab: 'splash_configuration', path: 'splash_configuration.duration_milliseconds', type: 'number', label: 'Duration (ms)' },
            { tab: 'splash_configuration', path: 'splash_configuration.min_duration_milliseconds', type: 'number', label: 'Min Duration (ms)' },
            { tab: 'splash_configuration', path: 'splash_configuration.logo_url', type: 'text', label: 'Logo URL' },
            { tab: 'splash_configuration', path: 'splash_configuration.background_color', type: 'text', label: 'Background Color' },
            { tab: 'splash_configuration', path: 'splash_configuration.logo_color', type: 'text', label: 'Logo Color' },
            { tab: 'splash_configuration', path: 'splash_configuration.show_loading_indicator', type: 'boolean', label: 'Show Loading' },
            { tab: 'splash_configuration', path: 'splash_configuration.loading_indicator_color', type: 'text', label: 'Loading Color' },
            { tab: 'splash_configuration', path: 'splash_configuration.show_version_info', type: 'boolean', label: 'Show Version' },
            { tab: 'splash_configuration', path: 'splash_configuration.version_text_color', type: 'text', label: 'Version Text Color' },
            { tab: 'splash_configuration', path: 'splash_configuration.fade_animation_enabled', type: 'boolean', label: 'Fade Animation' },
            { tab: 'splash_configuration', path: 'splash_configuration.animation_duration_milliseconds', type: 'number', label: 'Animation Duration (ms)' },
            { tab: 'splash_configuration', path: 'splash_configuration.enable_logo_animation', type: 'boolean', label: 'Logo Animation' },
            { tab: 'splash_configuration', path: 'splash_configuration.logo_animation_type', type: 'select', label: 'Logo Animation Type', options: [{ value: 'fade_scale', label: 'Fade & Scale' }, { value: 'fade', label: 'Fade' }, { value: 'scale', label: 'Scale' }, { value: 'none', label: 'None' }]},
            { tab: 'splash_configuration', path: 'splash_configuration.show_app_name', type: 'boolean', label: 'Show App Name' },
            { tab: 'splash_configuration', path: 'splash_configuration.app_name_text_color', type: 'text', label: 'App Name Text Color' },
            { tab: 'splash_configuration', path: 'splash_configuration.app_name_font_size', type: 'number', label: 'App Name Font Size' },
            { tab: 'splash_configuration', path: 'splash_configuration.navigation_target', type: 'text', label: 'Navigation Target' },
            { tab: 'splash_configuration', path: 'splash_configuration.fallback_navigation_target', type: 'text', label: 'Fallback Target' },
            { tab: 'splash_configuration', path: 'splash_configuration.check_connectivity', type: 'boolean', label: 'Check Connectivity' },
            { tab: 'splash_configuration', path: 'splash_configuration.preload_critical_data', type: 'boolean', label: 'Preload Critical Data' },
            { tab: 'splash_configuration', path: 'splash_configuration.show_error_on_failure', type: 'boolean', label: 'Show Error on Failure' },
            { tab: 'splash_configuration', path: 'splash_configuration.retry_on_error', type: 'boolean', label: 'Retry on Error' },
            { tab: 'splash_configuration', path: 'splash_configuration.max_retry_attempts', type: 'number', label: 'Max Retry Attempts' },
            { tab: 'splash_configuration', path: 'splash_configuration.enable_dev_mode_tap', type: 'boolean', label: 'Dev Mode Tap' },
            { tab: 'splash_configuration', path: 'splash_configuration.dev_mode_tap_count', type: 'number', label: 'Dev Mode Tap Count' },
            // localization_configuration
            { tab: 'localization_configuration', path: 'localization_configuration.default_language', type: 'text', label: 'Default Language' },
            { tab: 'localization_configuration', path: 'localization_configuration.supported_languages', type: 'text', label: 'Supported Languages (comma-separated)' },
            { tab: 'localization_configuration', path: 'localization_configuration.rtl_support', type: 'boolean', label: 'RTL Support' },
            { tab: 'localization_configuration', path: 'localization_configuration.auto_detect_language', type: 'boolean', label: 'Auto Detect Language' },
            // performance_configuration
            { tab: 'performance_configuration', path: 'performance_configuration.image_cache_size_mb', type: 'number', label: 'Image Cache (MB)' },
            { tab: 'performance_configuration', path: 'performance_configuration.network_cache_size_mb', type: 'number', label: 'Network Cache (MB)' },
            { tab: 'performance_configuration', path: 'performance_configuration.lazy_loading_enabled', type: 'boolean', label: 'Lazy Loading' },
            { tab: 'performance_configuration', path: 'performance_configuration.preload_critical_assets', type: 'boolean', label: 'Preload Critical Assets' },
            // onboarding_configuration
            { tab: 'onboarding_configuration', path: 'onboarding_configuration.style', type: 'select', label: 'Style', options: [{ value: 'space', label: 'Space' }, { value: 'startup', label: 'Startup' }, { value: 'enterprise', label: 'Enterprise' }]},
            { tab: 'onboarding_configuration', path: 'onboarding_configuration.auto_advance_seconds', type: 'number', label: 'Auto Advance (s)' },
            { tab: 'onboarding_configuration', path: 'onboarding_configuration.show_skip_button', type: 'boolean', label: 'Show Skip' },
            { tab: 'onboarding_configuration', path: 'onboarding_configuration.show_page_indicator', type: 'boolean', label: 'Show Page Indicator' },
            { tab: 'onboarding_configuration', path: 'onboarding_configuration.animation_duration', type: 'number', label: 'Animation Duration' },
            { tab: 'onboarding_configuration', path: 'onboarding_configuration.primary_color', type: 'text', label: 'Primary Color' },
            { tab: 'onboarding_configuration', path: 'onboarding_configuration.secondary_color', type: 'text', label: 'Secondary Color' },
            // about_configuration
            { tab: 'about_configuration', path: 'about_configuration.style', type: 'text', label: 'Style' },
            { tab: 'about_configuration', path: 'about_configuration.title', type: 'text', label: 'Title' },
            { tab: 'about_configuration', path: 'about_configuration.description', type: 'text', label: 'Description' },
            { tab: 'about_configuration', path: 'about_configuration.enable_fullscreen_web_view', type: 'boolean', label: 'Fullscreen Web View' },
            { tab: 'about_configuration', path: 'about_configuration.show_version', type: 'boolean', label: 'Show Version' },
            { tab: 'about_configuration', path: 'about_configuration.show_company_info', type: 'boolean', label: 'Show Company Info' },
            { tab: 'about_configuration', path: 'about_configuration.company_name', type: 'text', label: 'Company Name' },
            { tab: 'about_configuration', path: 'about_configuration.copyright', type: 'text', label: 'Copyright' },
            { tab: 'about_configuration', path: 'about_configuration.background_color', type: 'text', label: 'Background Color' },
            { tab: 'about_configuration', path: 'about_configuration.text_color', type: 'text', label: 'Text Color' },
            { tab: 'about_configuration', path: 'about_configuration.primary_color', type: 'text', label: 'Primary Color' },
            { tab: 'about_configuration', path: 'about_configuration.app_bar.backgroundColor', type: 'text', label: 'App Bar BG' },
            { tab: 'about_configuration', path: 'about_configuration.app_bar.foregroundColor', type: 'text', label: 'App Bar FG' },
            { tab: 'about_configuration', path: 'about_configuration.app_bar.titleColor', type: 'text', label: 'App Bar Title' },
            { tab: 'about_configuration', path: 'about_configuration.app_bar.iconColor', type: 'text', label: 'App Bar Icon' },
            { tab: 'about_configuration', path: 'about_configuration.app_bar.elevation', type: 'number', label: 'App Bar Elevation' },
            // contact_us_configuration
            { tab: 'contact_us_configuration', path: 'contact_us_configuration.style', type: 'select', label: 'Style', options: [{ value: 'startup', label: 'Startup' }, { value: 'space', label: 'Space' }, { value: 'enterprise', label: 'Enterprise' }] },
            { tab: 'contact_us_configuration', path: 'contact_us_configuration.title', type: 'text', label: 'Title' },
            { tab: 'contact_us_configuration', path: 'contact_us_configuration.description', type: 'text', label: 'Description' },
            { tab: 'contact_us_configuration', path: 'contact_us_configuration.email', type: 'text', label: 'Email' },
            { tab: 'contact_us_configuration', path: 'contact_us_configuration.phone', type: 'text', label: 'Phone' },
            { tab: 'contact_us_configuration', path: 'contact_us_configuration.address', type: 'text', label: 'Address' },
            { tab: 'contact_us_configuration', path: 'contact_us_configuration.company_name', type: 'text', label: 'Company Name' },
            { tab: 'contact_us_configuration', path: 'contact_us_configuration.show_contact_form', type: 'boolean', label: 'Show Contact Form' },
            { tab: 'contact_us_configuration', path: 'contact_us_configuration.show_contact_info', type: 'boolean', label: 'Show Contact Info' },
            { tab: 'contact_us_configuration', path: 'contact_us_configuration.background_color', type: 'text', label: 'Background Color' },
            { tab: 'contact_us_configuration', path: 'contact_us_configuration.text_color', type: 'text', label: 'Text Color' },
            { tab: 'contact_us_configuration', path: 'contact_us_configuration.primary_color', type: 'text', label: 'Primary Color' },
            // faq_configuration
            { tab: 'faq_configuration', path: 'faq_configuration.style', type: 'text', label: 'Style' },
            { tab: 'faq_configuration', path: 'faq_configuration.title', type: 'text', label: 'Title' },
            { tab: 'faq_configuration', path: 'faq_configuration.description', type: 'text', label: 'Description' },
            { tab: 'faq_configuration', path: 'faq_configuration.allow_multiple_expanded', type: 'boolean', label: 'Allow Multiple Expanded' },
            { tab: 'faq_configuration', path: 'faq_configuration.show_search_bar', type: 'boolean', label: 'Show Search Bar' },
            { tab: 'faq_configuration', path: 'faq_configuration.show_categories', type: 'boolean', label: 'Show Categories' },
            { tab: 'faq_configuration', path: 'faq_configuration.background_color', type: 'text', label: 'Background Color' },
            { tab: 'faq_configuration', path: 'faq_configuration.text_color', type: 'text', label: 'Text Color' },
            { tab: 'faq_configuration', path: 'faq_configuration.primary_color', type: 'text', label: 'Primary Color' },
            // loading_configuration
            { tab: 'loading_configuration', path: 'loading_configuration.style', type: 'text', label: 'Style' },
            { tab: 'loading_configuration', path: 'loading_configuration.type', type: 'text', label: 'Type' },
            { tab: 'loading_configuration', path: 'loading_configuration.duration_milliseconds', type: 'number', label: 'Duration (ms)' },
            { tab: 'loading_configuration', path: 'loading_configuration.step_duration_milliseconds', type: 'number', label: 'Step Duration (ms)' },
            { tab: 'loading_configuration', path: 'loading_configuration.background_color', type: 'text', label: 'Background Color' },
            { tab: 'loading_configuration', path: 'loading_configuration.text_color', type: 'text', label: 'Text Color' },
            { tab: 'loading_configuration', path: 'loading_configuration.progress_color', type: 'text', label: 'Progress Color' },
            { tab: 'loading_configuration', path: 'loading_configuration.animation_type', type: 'text', label: 'Animation Type' },
            { tab: 'loading_configuration', path: 'loading_configuration.show_logo', type: 'boolean', label: 'Show Logo' },
            { tab: 'loading_configuration', path: 'loading_configuration.logo_animation_enabled', type: 'boolean', label: 'Logo Animation' },
            { tab: 'loading_configuration', path: 'loading_configuration.auto_dismiss_enabled', type: 'boolean', label: 'Auto Dismiss' },
            { tab: 'loading_configuration', path: 'loading_configuration.tap_to_dismiss_enabled', type: 'boolean', label: 'Tap to Dismiss' },
            { tab: 'loading_configuration', path: 'loading_configuration.show_progress_indicator', type: 'boolean', label: 'Show Progress' },
            { tab: 'loading_configuration', path: 'loading_configuration.show_percentage', type: 'boolean', label: 'Show Percentage' },
            { tab: 'loading_configuration', path: 'loading_configuration.animation_enabled', type: 'boolean', label: 'Animation' },
            { tab: 'loading_configuration', path: 'loading_configuration.haptic_feedback_enabled', type: 'boolean', label: 'Haptic Feedback' },
            // error_handling_configuration
            { tab: 'error_handling_configuration', path: 'error_handling_configuration.style', type: 'select', label: 'Style', options: [{ value: 'startup', label: 'Startup' }, { value: 'space', label: 'Space' }, { value: 'enterprise', label: 'Enterprise' }] },
            { tab: 'error_handling_configuration', path: 'error_handling_configuration.errorTitle', type: 'text', label: 'Error Title' },
            { tab: 'error_handling_configuration', path: 'error_handling_configuration.animation_duration', type: 'number', label: 'Animation Duration' },
            { tab: 'error_handling_configuration', path: 'error_handling_configuration.primary_color', type: 'text', label: 'Primary Color' },
            { tab: 'error_handling_configuration', path: 'error_handling_configuration.secondary_color', type: 'text', label: 'Secondary Color' },
            { tab: 'error_handling_configuration', path: 'error_handling_configuration.background_color', type: 'text', label: 'Background Color' },
            { tab: 'error_handling_configuration', path: 'error_handling_configuration.text_color', type: 'text', label: 'Text Color' },
            { tab: 'error_handling_configuration', path: 'error_handling_configuration.icon_color', type: 'text', label: 'Icon Color' },
            { tab: 'error_handling_configuration', path: 'error_handling_configuration.icon_border_color', type: 'text', label: 'Icon Border Color' },
            { tab: 'error_handling_configuration', path: 'error_handling_configuration.retry_button_background', type: 'text', label: 'Retry Btn BG' },
            { tab: 'error_handling_configuration', path: 'error_handling_configuration.retry_button_text_color', type: 'text', label: 'Retry Btn Text' },
            { tab: 'error_handling_configuration', path: 'error_handling_configuration.go_back_button_text_color', type: 'text', label: 'Go Back Btn Text' },
            // empty_view_configuration
            { tab: 'empty_view_configuration', path: 'empty_view_configuration.style', type: 'text', label: 'Style' },
            { tab: 'empty_view_configuration', path: 'empty_view_configuration.background_color', type: 'text', label: 'Background Color' },
            { tab: 'empty_view_configuration', path: 'empty_view_configuration.text_color', type: 'text', label: 'Text Color' },
            { tab: 'empty_view_configuration', path: 'empty_view_configuration.animation_duration', type: 'number', label: 'Animation Duration' },
            { tab: 'empty_view_configuration', path: 'empty_view_configuration.primary_color', type: 'text', label: 'Primary Color' },
            { tab: 'empty_view_configuration', path: 'empty_view_configuration.secondary_color', type: 'text', label: 'Secondary Color' },
            { tab: 'empty_view_configuration', path: 'empty_view_configuration.enable_haptic_feedback', type: 'boolean', label: 'Haptic Feedback' },
            { tab: 'empty_view_configuration', path: 'empty_view_configuration.default_empty_message', type: 'text', label: 'Default Empty Message' },
            { tab: 'empty_view_configuration', path: 'empty_view_configuration.show_action_button', type: 'boolean', label: 'Show Action Button' },
            // auth_configuration (scalar fields; use Advanced JSON for full tree)
            { tab: 'auth_configuration', path: 'auth_configuration.ui_style.style', type: 'select', label: 'UI Style', options: [{ value: 'startup', label: 'Startup' }, { value: 'space', label: 'Space' }, { value: 'enterprise', label: 'Enterprise' }]},
            { tab: 'auth_configuration', path: 'auth_configuration.ui_style.primary_color', type: 'text', label: 'UI Primary Color' },
            { tab: 'auth_configuration', path: 'auth_configuration.sign_in.app_name', type: 'text', label: 'Sign-in App Name' },
            { tab: 'auth_configuration', path: 'auth_configuration.sign_in.email_label', type: 'text', label: 'Email Label' },
            { tab: 'auth_configuration', path: 'auth_configuration.sign_in.sign_in_button', type: 'text', label: 'Sign-in Button Text' },
            { tab: 'auth_configuration', path: 'auth_configuration.forgot_password.title', type: 'text', label: 'Forgot Password Title' }
        ].concat(getHomeProductNavbarCartFields());
        defs.forEach(function(f) {
            if (/color/i.test(f.path) || (f.label && /color/i.test(f.label))) f.type = 'color';
            var path = (f.path || '').toLowerCase();
            if (/logo_url|splash_image_url|imageurl|image_url|icon_path|image_path/i.test(path)) {
                f.type = 'text';
                if (!f.placeholder) f.placeholder = 'https://... (HTTPS, JPEG/PNG önerilir)';
            }
        });
        return defs;
    }

    function getHomeProductNavbarCartFields() {
        var a = [];
        var appBarVariantOpts = [{ value: 'standard', label: 'Standard' }, { value: 'compact', label: 'Compact' }, { value: 'extended', label: 'Extended' }];
        var appBarSizeOpts = [{ value: 'standard', label: 'Standard' }, { value: 'compact', label: 'Compact' }, { value: 'extended', label: 'Extended' }];
        var searchStyleOpts = [{ value: 'minimal', label: 'Minimal' }, { value: 'borderless', label: 'Borderless' }, { value: 'outlined', label: 'Outlined' }];
        var searchVariantOpts = [{ value: 'outlined', label: 'Outlined' }, { value: 'borderless', label: 'Borderless' }, { value: 'filled', label: 'Filled' }];
        a.push({ tab: 'home_view', path: 'home_view.app_bar.variant', type: 'select', label: 'app bar variant', options: appBarVariantOpts });
        a.push({ tab: 'home_view', path: 'home_view.app_bar.size', type: 'select', label: 'app bar size', options: appBarSizeOpts });
        a.push({ tab: 'home_view', path: 'home_view.search.style', type: 'select', label: 'search style', options: searchStyleOpts });
        a.push({ tab: 'home_view', path: 'home_view.search.variant', type: 'select', label: 'search variant', options: searchVariantOpts });
        var homePaths = ['home_view.app_bar.title_source','home_view.app_bar.fallback_title','home_view.app_bar.backgroundColor','home_view.app_bar.foregroundColor','home_view.app_bar.titleColor','home_view.app_bar.elevation','home_view.app_bar.titleFontWeight','home_view.component_spacing.top','home_view.component_spacing.bottom','home_view.component_spacing.horizontal','home_view.component_spacing.title_to_content','home_view.search.enabled','home_view.search.order_id','home_view.search.placeholder','home_view.circle_categories.enabled','home_view.circle_categories.order_id','home_view.circle_categories.max_items','home_view.circle_categories.circle_size','home_view.circle_categories.show_names','home_view.circle_categories.image_size','home_view.circle_categories.spacing','home_view.banner.enabled','home_view.banner.order_id','home_view.promotional_bar.enabled','home_view.promotional_bar.order_id','home_view.promotional_bar.border_radius','home_view.promotional_bar.height','home_view.campaign_cards.enabled','home_view.campaign_cards.order_id','home_view.campaign_cards.title','home_view.campaign_cards.card_height','home_view.campaign_cards.card_width','home_view.campaign_cards.border_radius','home_view.deals_of_day.enabled','home_view.deals_of_day.order_id','home_view.deals_of_day.title','home_view.deals_of_day.limit','home_view.collections.enabled','home_view.collections.order_id','home_view.collections.title','home_view.recommended.enabled','home_view.recommended.order_id','home_view.recommended.title','home_view.recommended.limit','home_view.campaign_alert.enabled','home_view.campaign_alert.order_id','home_view.campaign_alert.title','home_view.campaign_alert.message','home_view.campaign_alert.end_time','home_view.campaign_alert.background_color','home_view.campaign_alert.text_color','home_view.campaign_alert.route','home_view.flash_sale.enabled','home_view.flash_sale.order_id','home_view.flash_sale.title','home_view.flash_sale.limit','home_view.flash_sale.end_time','home_view.flash_sale.backgroundColor','home_view.brands.enabled','home_view.brands.order_id','home_view.brands.title','home_view.brands.layout','home_view.campaign_popup_button.enabled','home_view.campaign_popup_button.text','home_view.campaign_popup_button.amount','home_view.campaign_popup_button.backgroundColor','home_view.campaign_popup_button.borderColor','home_view.campaign_popup_button.textColor','home_view.campaign_popup_button.position','home_view.campaign_popup_button.size','home_view.campaign_popup_button.showCloseButton','home_view.campaign_popup_button.route','home_view.bottom_foreground_banner.enabled','home_view.bottom_foreground_banner.imageUrl','home_view.bottom_foreground_banner.title','home_view.bottom_foreground_banner.description','home_view.bottom_foreground_banner.height','home_view.bottom_foreground_banner.border_radius','home_view.bottom_foreground_banner.image_opacity','home_view.bottom_foreground_banner.overlay_color','home_view.bottom_foreground_banner.overlay_opacity','home_view.bottom_foreground_banner.background_color','home_view.bottom_foreground_banner.text_color','home_view.bottom_foreground_banner.arrow_icon_color','home_view.bottom_foreground_banner.tail_height','home_view.bottom_foreground_banner.tail_width','home_view.bottom_foreground_banner.tail_bottom_offset','home_view.bottom_foreground_banner.show_dismiss_button','home_view.bottom_foreground_banner.route','home_view.bottom_foreground_banner.category_id','home_view.bottom_foreground_banner.product_id'];
        homePaths.forEach(function(p) {
            var lab = p.replace('home_view.','').replace(/_/g,' ');
            var isNum = /order_id|limit|size|height|radius|top|bottom|horizontal|spacing|elevation|titleFontWeight|width|opacity|offset|category_id|product_id/i.test(p);
            a.push({ tab: 'home_view', path: p, type: p.indexOf('enabled')>=0||p.indexOf('show_')>=0 ? 'boolean' : (isNum ? 'number' : 'text'), label: lab });
        });
        ['product_detail_view.appBar.backgroundColor','product_detail_view.appBar.titleColor','product_detail_view.appBar.iconColor','product_detail_view.appBar.elevation','product_detail_view.delivery.estimated_label','product_detail_view.delivery.estimated_min_days','product_detail_view.delivery.estimated_max_days','product_detail_view.delivery.cutoff_hour','product_detail_view.delivery.cutoff_minute','product_detail_view.delivery.show_cutoff_time','product_detail_view.delivery.show_cutoff_countdown','product_detail_view.delivery.cutoff_affects_estimate','product_detail_view.name_and_price.enabled','product_detail_view.name_and_price.order_id','product_detail_view.name_and_price.nameColor','product_detail_view.name_and_price.priceColor','product_detail_view.attributes.enabled','product_detail_view.attributes.order_id','product_detail_view.attributes.selectedColor','product_detail_view.attributes.unselectedColor','product_detail_view.description.enabled','product_detail_view.description.order_id','product_detail_view.description.textColor','product_detail_view.reviews.enabled','product_detail_view.reviews.order_id','product_detail_view.images.enabled','product_detail_view.images.order_id','product_detail_view.action_section.buttonBackgroundColor','product_detail_view.action_section.buttonTextColor','product_detail_view.action_section.wishlistIconColor','product_detail_view.action_section.shareIconColor'].forEach(function(p) {
            a.push({ tab: 'product_detail_view', path: p, type: (p.indexOf('enabled')>=0||p.indexOf('show_')>=0||p.indexOf('cutoff_affects')>=0) ? 'boolean' : (p.indexOf('Color')>=0||p.indexOf('Template')>=0||p.indexOf('Format')>=0||p.indexOf('label')>=0 ? 'text' : 'number'), label: p.replace('product_detail_view.','').replace(/_/g,' ') });
        });
        ['product_list_view.app_bar.title','product_list_view.app_bar.backgroundColor','product_list_view.app_bar.foregroundColor','product_list_view.app_bar.titleColor','product_list_view.app_bar.iconColor','product_list_view.grid.columns_tablet','product_list_view.grid.columns_mobile','product_list_view.grid.crossAxisSpacing','product_list_view.grid.mainAxisSpacing','product_list_view.grid.estimatedCardHeight'].forEach(function(p) {
            a.push({ tab: 'product_list_view', path: p, type: p.indexOf('Color')>=0||p.indexOf('title')>=0 ? 'text' : 'number', label: p.replace('product_list_view.','').replace(/_/g,' ') });
        });
        ['product_card.badges.flash_sale.enabled','product_card.badges.flash_sale.auto','product_card.badges.flash_sale.min_discount_percent','product_card.badges.flash_sale.label'].forEach(function(p) {
            a.push({ tab: 'product_card', path: p, type: p.indexOf('enabled')>=0||p.indexOf('auto')>=0 ? 'boolean' : (p.indexOf('percent')>=0 ? 'number' : 'text'), label: p.replace('product_card.','').replace(/_/g,' ') });
        });
        var navbarVariantOpts = [{ value: 'transparent', label: 'Transparent' }, { value: 'filled', label: 'Filled' }];
        var navbarSizeOpts = [{ value: 'small', label: 'Small' }, { value: 'medium', label: 'Medium' }, { value: 'large', label: 'Large' }];
        var navbarPositionOpts = [{ value: 'top', label: 'Top' }, { value: 'bottom', label: 'Bottom' }];
        a.push({ tab: 'navbar_configuration', path: 'navbar_configuration.variant', type: 'select', label: 'variant', options: navbarVariantOpts });
        a.push({ tab: 'navbar_configuration', path: 'navbar_configuration.size', type: 'select', label: 'size', options: navbarSizeOpts });
        a.push({ tab: 'navbar_configuration', path: 'navbar_configuration.position', type: 'select', label: 'position', options: navbarPositionOpts });
        ['navbar_configuration.enabled','navbar_configuration.backgroundColor','navbar_configuration.borderColor','navbar_configuration.elevation','navbar_configuration.selectedIconColor','navbar_configuration.unselectedIconColor','navbar_configuration.selectedTextColor','navbar_configuration.unselectedTextColor','navbar_configuration.showLabels','navbar_configuration.showIcons','navbar_configuration.centerItems'].forEach(function(p) {
            a.push({ tab: 'navbar_configuration', path: p, type: p.indexOf('enabled')>=0||p.indexOf('show')>=0||p.indexOf('center')>=0 ? 'boolean' : 'text', label: p.replace('navbar_configuration.','').replace(/_/g,' ') });
        });
        ['campaign_view.backgroundColor','campaign_view.splash_image_url','campaign_view.splash_title','campaign_view.splash_subtitle','campaign_view.animation.duration_milliseconds','campaign_view.navigation.timer_duration_milliseconds','campaign_view.gradient_overlay.enabled','campaign_view.gradient_overlay.startColor','campaign_view.gradient_overlay.endColor','campaign_view.text_overlay.title.color','campaign_view.text_overlay.subtitle.color'].forEach(function(p) {
            a.push({ tab: 'campaign_view', path: p, type: (p.indexOf('enabled')>=0) ? 'boolean' : (p.indexOf('duration')>=0||p.indexOf('timer')>=0 ? 'number' : 'text'), label: p.replace('campaign_view.','').replace(/_/g,' ') });
        });
        var appBarVariantOptsCart = [{ value: 'standard', label: 'Standard' }, { value: 'compact', label: 'Compact' }, { value: 'extended', label: 'Extended' }];
        var appBarSizeOptsCart = [{ value: 'standard', label: 'Standard' }, { value: 'compact', label: 'Compact' }, { value: 'extended', label: 'Extended' }];
        a.push({ tab: 'cart_view_configuration', path: 'cart_view_configuration.app_bar.variant', type: 'select', label: 'app bar variant', options: appBarVariantOptsCart });
        a.push({ tab: 'cart_view_configuration', path: 'cart_view_configuration.app_bar.size', type: 'select', label: 'app bar size', options: appBarSizeOptsCart });
        a.push({ tab: 'checkout_view_configuration', path: 'checkout_view_configuration.app_bar.variant', type: 'select', label: 'app bar variant', options: appBarVariantOptsCart });
        a.push({ tab: 'checkout_view_configuration', path: 'checkout_view_configuration.app_bar.size', type: 'select', label: 'app bar size', options: appBarSizeOptsCart });
        ['cart_view_configuration.app_bar.title','cart_view_configuration.app_bar.backgroundColor','cart_view_configuration.app_bar.foregroundColor','cart_view_configuration.app_bar.titleColor','cart_view_configuration.app_bar.iconColor','cart_view_configuration.app_bar.elevation','cart_view_configuration.app_bar.show_back_button','cart_view_configuration.app_bar.show_refresh_button','cart_view_configuration.refresh_indicator.color','cart_view_configuration.loading_overlay.loading_color','checkout_view_configuration.app_bar.title','checkout_view_configuration.app_bar.backgroundColor','checkout_view_configuration.app_bar.foregroundColor','checkout_view_configuration.app_bar.titleColor','checkout_view_configuration.app_bar.iconColor','checkout_view_configuration.app_bar.elevation'].forEach(function(p) {
            a.push({ tab: p.indexOf('cart_view')>=0 ? 'cart_view_configuration' : 'checkout_view_configuration', path: p, type: (p.indexOf('show_')>=0) ? 'boolean' : (p.indexOf('Color')>=0||p.indexOf('title')>=0 ? 'text' : 'number'), label: p.replace('cart_view_configuration.','').replace('checkout_view_configuration.','').replace(/_/g,' ') });
        });
        ['wishlist_view.app_bar.title','wishlist_view.app_bar.titleWithCount','wishlist_view.app_bar.backgroundColor','wishlist_view.app_bar.foregroundColor','wishlist_view.app_bar.titleColor','wishlist_view.app_bar.iconColor','wishlist_view.app_bar.elevation','orders_history_view.app_bar.title','orders_history_view.app_bar.backgroundColor','orders_history_view.app_bar.foregroundColor','orders_history_view.app_bar.titleColor','orders_history_view.app_bar.iconColor','user_profile_view.app_bar.title','user_profile_view.app_bar.backgroundColor','user_profile_view.app_bar.foregroundColor','user_profile_view.app_bar.titleColor','user_profile_view.app_bar.iconColor','order_detail_view.app_bar.title','order_detail_view.app_bar.backgroundColor','order_detail_view.app_bar.foregroundColor','order_detail_view.app_bar.titleColor','order_detail_view.app_bar.iconColor'].forEach(function(p) {
            var t = p.split('.')[0];
            a.push({ tab: t, path: p, type: 'text', label: p.replace(t+'.app_bar.','').replace(/_/g,' ') });
        });
        ['favorite_categories_view_configuration.app_bar.title','favorite_categories_view_configuration.app_bar.backgroundColor','favorite_categories_view_configuration.grid.crossAxisCount','favorite_categories_view_configuration.grid.crossAxisSpacing','favorite_categories_view_configuration.grid.mainAxisSpacing','favorite_categories_view_configuration.grid.childAspectRatio','favorite_categories_view_configuration.category_card.borderRadius','dialog_popup_configuration.dialog.backgroundColor','dialog_popup_configuration.dialog.titleColor','dialog_popup_configuration.dialog.subtitleColor','dialog_popup_configuration.dialog.borderRadius','dialog_popup_configuration.dialog.elevation'].forEach(function(p) {
            var t = p.split('.')[0];
            a.push({ tab: t, path: p, type: (p.indexOf('Count')>=0||p.indexOf('Spacing')>=0||p.indexOf('Radius')>=0||p.indexOf('Ratio')>=0||p.indexOf('elevation')>=0) ? 'number' : 'text', label: p.replace(t+'.','').replace(/_/g,' ') });
        });
        return a;
    }

    $(document).ready(function() {
        var $form = $('#osmea-config-form');
        var $tabbar = $('#osmea-config-tabbar');
        var $uiSections = $('#osmea-config-ui-sections');
        var $status = $('#osmea-json-status');
        var $hiddenStore = $('#osmea-config-json-store');
        var staticTabs = getTabs();
        var staticCategories = getCategories();
        var tabLabelById = {};
        staticTabs.forEach(function(t) { tabLabelById[t.id] = t.label; });
        var fieldDefinitions;
        try {
            fieldDefinitions = getFieldDefinitions();
        } catch (e) {
            if (typeof console !== 'undefined') console.error('OSMEA getFieldDefinitions:', e);
            fieldDefinitions = [];
        }
        if (!Array.isArray(fieldDefinitions)) fieldDefinitions = [];

        if (!$form.length || !$tabbar.length || !$uiSections.length) {
            if ($status.length) $status.addClass('invalid').text('Config container not found.').show();
            return;
        }

        /** Categories to show in tabbar: always use full static list so headings never disappear. */
        function getCategoriesForTabbar() {
            return staticCategories;
        }

        var initialConfigSnapshot = null;

        function getConfigObj() {
            var raw = '';
            if ($hiddenStore.length && $hiddenStore.val()) raw = $hiddenStore.val();
            else if (typeof osmeaConfig !== 'undefined' && osmeaConfig.currentConfig) raw = osmeaConfig.currentConfig;
            if (typeof raw !== 'string') raw = (raw && typeof raw === 'object') ? JSON.stringify(raw) : '{}';
            if (!raw || !raw.trim()) raw = '{}';
            try { return JSON.parse(raw); } catch (e) { return {}; }
        }

        function getConfigSnapshot() {
            try { return JSON.stringify(getConfigObj()); } catch (e) { return ''; }
        }

        function isDirty() {
            return initialConfigSnapshot !== null && getConfigSnapshot() !== initialConfigSnapshot;
        }

        function markClean() {
            initialConfigSnapshot = getConfigSnapshot();
        }

        function updateDirtyUI() {
            if (!$status.length) return;
            if (isDirty()) {
                $status.removeClass('valid invalid').addClass('unsaved')
                    .text(typeof osmeaConfig !== 'undefined' && osmeaConfig.strings && osmeaConfig.strings.unsavedChanges ? osmeaConfig.strings.unsavedChanges : 'Unsaved changes.')
                    .show();
            } else {
                $status.removeClass('unsaved');
                if (!$status.hasClass('valid') && !$status.hasClass('invalid')) $status.hide();
            }
        }

        function setConfigObj(obj) {
            $hiddenStore.val(JSON.stringify(obj, null, 2));
            updateDirtyUI();
        }
        function getValueByPath(obj, path) {
            if (!obj || !path) return undefined;
            return path.split('.').reduce(function(acc, key) {
                return (acc && Object.prototype.hasOwnProperty.call(acc, key)) ? acc[key] : undefined;
            }, obj);
        }
        function setValueByPath(obj, path, value) {
            if (!obj || !path) return;
            var keys = path.split('.');
            var current = obj;
            for (var i = 0; i < keys.length; i++) {
                var key = keys[i];
                if (i === keys.length - 1) current[key] = value;
                else {
                    if (!current[key] || typeof current[key] !== 'object') current[key] = {};
                    current = current[key];
                }
            }
        }
        function getFieldId(path) {
            return 'osmea-field-' + path.replace(/\./g, '-').replace(/\[|\]/g, '-');
        }

        function toHex6(val) {
            if (!val || typeof val !== 'string') return '#000000';
            var m = val.match(/^#?([a-fA-F0-9]{6})$/);
            if (m) return '#' + m[1];
            m = val.match(/^#?([a-fA-F0-9]{8})$/);
            if (m) return '#' + m[1].slice(0, 6);
            return val.length >= 6 ? ('#' + String(val).replace(/^#/, '').slice(0, 6)) : '#000000';
        }

        /** Lightweight image lightbox for image URL previews */
        function ensureImageLightbox() {
            if ($('#osmea-image-lightbox').length) return;
            var $lb = $('<div id="osmea-image-lightbox" class="osmea-image-lightbox" role="dialog" aria-modal="true" aria-label="Image preview"/>');
            var $backdrop = $('<div class="osmea-image-lightbox-backdrop" tabindex="-1"></div>');
            var $content = $('<div class="osmea-image-lightbox-content"></div>');
            var $img = $('<img class="osmea-image-lightbox-img" alt="Preview"/>');
            var $close = $('<button type="button" class="osmea-image-lightbox-close" aria-label="Close">&times;</button>');

            $content.append($img).append($close);
            $lb.append($backdrop).append($content);
            $('body').append($lb);

            function closeLb() {
                $lb.removeClass('is-open');
                $img.attr('src', '');
            }

            $backdrop.on('click', closeLb);
            $close.on('click', closeLb);
            $(document).on('keydown.osmeaLightbox', function (e) {
                if (e.key === 'Escape') closeLb();
            });
        }

        function openImageLightbox(url) {
            if (!url || !/^https?:\/\//i.test(url)) return;
            ensureImageLightbox();
            var $lb = $('#osmea-image-lightbox');
            var $img = $lb.find('.osmea-image-lightbox-img');
            $img.attr('src', url);
            $lb.addClass('is-open');
        }

        function renderOneField(configObj, field, $tbody) {
            var currentValue = getValueByPath(configObj, field.path);
            if (field.path === 'localization_configuration.supported_languages' && Array.isArray(currentValue)) {
                currentValue = (currentValue || []).join(', ');
            }
            var fieldId = getFieldId(field.path);
            var $row = $('<tr class="osmea-field-row"/>')
                .attr('data-path', field.path || '')
                .attr('data-tab', field.tab || '');
            var $th = $('<th scope="row"/>').append($('<label/>', { 'for': fieldId, text: field.label }));
            var $td = $('<td/>');
            var $input;
            if (field.type === 'boolean') {
                $input = $('<input type="checkbox" class="osmea-field-boolean"/>').attr('id', fieldId).data('path', field.path);
                $input.prop('checked', Boolean(currentValue));
                $td.append($('<label/>').append($input).append(document.createTextNode(' Yes')));
            } else if (field.type === 'number') {
                $input = $('<input type="number" class="regular-text osmea-field-number" min="0" step="1"/>')
                    .attr('id', fieldId)
                    .data('path', field.path);
                // Sadece sayısal ve 0'dan büyük/büyük eşit değerleri yaz, aksi halde boş bırak
                if (typeof currentValue === 'number' && !isNaN(currentValue) && currentValue >= 0) {
                    $input.val(currentValue);
                } else {
                    $input.val('');
                }
                $td.append($input);
            } else if (field.type === 'select' && Array.isArray(field.options)) {
                $input = $('<select class="osmea-field-select"/>').attr('id', fieldId).data('path', field.path);
                field.options.forEach(function(opt) {
                    $input.append($('<option/>', { value: opt.value, text: opt.label }).prop('selected', currentValue === opt.value));
                });
                $td.append($input);
            } else if (field.type === 'color') {
                var hexVal = (currentValue != null && String(currentValue)) ? toHex6(String(currentValue)) : '#000000';
                var $colorPick = $('<input type="color" class="osmea-field-color-pick"/>').attr('value', hexVal).data('path', field.path);
                var $hexInput = $('<input type="text" class="regular-text osmea-field-color-text"/>').attr('id', fieldId).data('path', field.path).attr('maxlength', 9);
                $hexInput.val(currentValue != null ? String(currentValue) : hexVal);
                $colorPick.on('input change', function() {
                    var h = $(this).val();
                    $hexInput.val(h);
                    var config = getConfigObj();
                    setValueByPath(config, field.path, h);
                    setConfigObj(config);
                });
                $hexInput.on('input change', function() {
                    var h = $(this).val();
                    if (/^#?[a-fA-F0-9]{6}$/.test(h.replace(/^#/, ''))) {
                        $colorPick.val('#' + h.replace(/^#/, '').slice(0, 6));
                    }
                    var config = getConfigObj();
                    setValueByPath(config, field.path, h || $colorPick.val());
                    setConfigObj(config);
                });
                $td.append($('<div class="osmea-color-row"/>').append($colorPick).append($hexInput));
                $row.append($th).append($td);
                $tbody.append($row);
                return;
            } else if ((field.type === 'text' || field.type === 'image') && isImageUrlField(field)) {
                $input = $('<input type="text" class="regular-text osmea-field-text osmea-field-image-url"/>').attr('id', fieldId).data('path', field.path);
                if (field.placeholder) $input.attr('placeholder', field.placeholder);
                $input.val(currentValue === undefined || currentValue === null ? '' : String(currentValue));
                var altText = (typeof osmeaConfig !== 'undefined' && osmeaConfig.strings && osmeaConfig.strings.imagePreviewAlt) ? osmeaConfig.strings.imagePreviewAlt : 'Preview';
                var $preview = $('<div class="osmea-image-preview-wrap osmea-image-preview-clickable" role="button" tabindex="0" title="View full size"/>').append(
                    $('<img class="osmea-image-preview" alt=""/>').attr('alt', altText)
                );
                function updatePreview() {
                    var url = $input.val();
                    var $img = $preview.find('img');
                    if (url && /^https?:\/\//i.test(url)) {
                        $img.attr('src', url).one('error', function() { $img.attr('src', '').addClass('osmea-image-preview-fail'); }).one('load', function() { $img.removeClass('osmea-image-preview-fail'); }).removeClass('osmea-image-preview-fail');
                    } else {
                        $img.attr('src', '').addClass('osmea-image-preview-fail');
                    }
                }
                updatePreview();
                $input.on('change input', function() {
                    var config = getConfigObj();
                    setValueByPath(config, field.path, $(this).val());
                    setConfigObj(config);
                    updatePreview();
                });
                $preview.on('click keydown', function (e) {
                    if (e.type === 'click' || (e.type === 'keydown' && (e.key === 'Enter' || e.key === ' '))) {
                        e.preventDefault();
                        openImageLightbox($input.val());
                    }
                });
                $td.append($('<div class="osmea-image-url-row"/>').append($input).append($preview));
                $row.append($th).append($td);
                $tbody.append($row);
                return;
            } else {
                $input = $('<input type="text" class="regular-text osmea-field-text"/>').attr('id', fieldId).data('path', field.path);
                $input.val(currentValue === undefined || currentValue === null ? '' : String(currentValue));
                $td.append($input);
            }
            $input.on('change input', function() {
                var config = getConfigObj();
                var val;
                if (field.type === 'boolean') {
                    val = $(this).is(':checked');
                } else if (field.type === 'number') {
                    var v = $(this).val();
                    if (v === '') {
                        val = null;
                    } else {
                        var num = Number(v);
                        // Negatif veya NaN ise null'a çek
                        val = (!isNaN(num) && num >= 0) ? num : null;
                        if (val === null) $(this).val('');
                    }
                }
                else if (field.path === 'localization_configuration.supported_languages') {
                    var s = $(this).val();
                    val = s ? s.split(',').map(function(x) { return x.trim(); }).filter(Boolean) : [];
                } else val = $(this).val();
                setValueByPath(config, field.path, val);
                setConfigObj(config);
            });
            $row.append($th).append($td);
            $tbody.append($row);
        }

        function pathToGroupLabel(path) {
            var parts = path.split('.');
            if (parts.length < 2) return '';
            var last = parts[parts.length - 2];
            return last.replace(/_/g, ' ').replace(/\b\w/g, function(c) { return c.toUpperCase(); });
        }

        function buildFormFromConfig() {
            var configObj = getConfigObj();
            var categories = getCategoriesForTabbar();
            $tabbar.empty();
            $uiSections.empty();
            $tabbar.off('click', '.osmea-tab-item');

            categories.forEach(function(cat, idx) {
                var isFirst = idx === 0;
                var $tabBtn = $('<button type="button" class="osmea-tab-item"/>')
                    .attr({ 'data-tab': cat.id, 'role': 'tab', 'aria-selected': isFirst ? 'true' : 'false' })
                    .text(cat.label);
                $tabbar.append($tabBtn);

                var $panel = $('<div class="osmea-tab-panel"/>')
                    .attr({ 'data-tab': cat.id, 'role': 'tabpanel', 'aria-hidden': isFirst ? 'false' : 'true' })
                    .css('display', isFirst ? 'block' : 'none');
                var $tbody = $('<tbody/>');
                var $table = $('<table class="form-table" role="presentation"/>').append($tbody);
                $tbody.append($('<tr class="osmea-panel-title-row"/>').append($('<td colspan="2"/>').append($('<h3 class="osmea-panel-title"/>').text(cat.label))));

                cat.tabIds.forEach(function(tabId) {
                    var tabFields = fieldDefinitions.filter(function(f) { return f.tab === tabId; });
                    if (tabFields.length === 0) return;
                    var tabLabel = tabLabelById[tabId] || tabId.replace(/_/g, ' ');
                    $tbody.append($('<tr class="osmea-tab-section-header-row"/>').append($('<td colspan="2"/>').append($('<div class="osmea-tab-section-header"/>').text(tabLabel))));

                    var lastGroup = null;
                    tabFields.forEach(function(field) {
                        var pathParts = field.path.split('.');
                        var group = pathParts.length >= 2 ? pathParts.slice(0, -1).join('.') : field.path;
                        var showGroupHeader = group !== lastGroup && pathParts.length > 2 && group.indexOf(tabId + '.') === 0;
                        if (showGroupHeader) {
                            lastGroup = group;
                            var label = pathToGroupLabel(field.path);
                            if (label) {
                                $tbody.append($('<tr class="osmea-group-header-row"/>').append($('<td colspan="2"/>').append($('<div class="osmea-group-header"/>').text(label))));
                            }
                        }
                        renderOneField(configObj, field, $tbody);
                    });
                });

                $panel.append($table);
                $uiSections.append($panel);
            });

            $tabbar.on('click', '.osmea-tab-item', function() {
                var id = $(this).data('tab');
                $tabbar.find('.osmea-tab-item').removeClass('active').attr('aria-selected', 'false');
                $(this).addClass('active').attr('aria-selected', 'true');
                $uiSections.find('.osmea-tab-panel').each(function() {
                    var $p = $(this);
                    var on = $p.data('tab') === id;
                    $p.attr('aria-hidden', on ? 'false' : 'true').css('display', on ? 'block' : 'none');
                });
            });
            $tabbar.find('.osmea-tab-item').first().addClass('active');

            markClean();
            updateDirtyUI();
        }

        /** Simple client-side search: filters rows by label or config path. */
        function initSearch() {
            var $input = $('#osmea-config-search');
            if (!$input.length) return;

            $input.on('input', function () {
                var q = $.trim($(this).val().toLowerCase());
                var hasQuery = q.length > 0;

                // Reset all rows when query is empty
                if (!hasQuery) {
                    $('.osmea-field-row').show();
                    $('.osmea-group-header-row').show();
                    $('.osmea-tab-section-header-row').show();
                    return;
                }

                // Filter field rows
                $('.osmea-field-row').each(function () {
                    var $row = $(this);
                    var labelText = $row.find('th label').text().toLowerCase();
                    var path = ($row.data('path') || '').toString().toLowerCase();
                    var match = labelText.indexOf(q) !== -1 || path.indexOf(q) !== -1;
                    $row.toggle(match);
                });

                // Hide group headers with no visible field rows beneath them
                $('.osmea-group-header-row').each(function () {
                    var $header = $(this);
                    var $rows = $header.nextUntil('.osmea-group-header-row, .osmea-tab-section-header-row, .osmea-panel-title-row');
                    var anyVisible = $rows.filter('.osmea-field-row:visible').length > 0;
                    $header.toggle(anyVisible);
                });

                // Hide section headers with no visible field rows beneath them
                $('.osmea-tab-section-header-row').each(function () {
                    var $header = $(this);
                    var $rows = $header.nextUntil('.osmea-tab-section-header-row, .osmea-panel-title-row');
                    var anyVisible = $rows.filter('.osmea-field-row:visible').length > 0;
                    $header.toggle(anyVisible);
                });
            });
        }

        function collectFormIntoConfig() {
            var config = getConfigObj();
            fieldDefinitions.forEach(function(field) {
                var $el = $('#' + getFieldId(field.path));
                if (!$el.length) return;
                var val;
                if (field.type === 'boolean') val = $el.is(':checked');
                else if (field.type === 'number') { var v = $el.val(); val = v === '' ? null : Number(v); }
                else if (field.path === 'localization_configuration.supported_languages') {
                    var s = $el.val();
                    val = s ? s.split(',').map(function(x) { return x.trim(); }).filter(Boolean) : [];
                } else val = $el.val();
                setValueByPath(config, field.path, val);
            });
            return config;
        }

        function applyConfigMetaBeforeSave(config) {
            config.config_meta = config.config_meta || {};
            config.config_meta.last_updated = new Date().toISOString().slice(0, 19).replace('T', ' ');
            return config;
        }

        $form.on('submit', function(e) {
            e.preventDefault();
            var config = collectFormIntoConfig();
            config = applyConfigMetaBeforeSave(config);
            var $submitBtn = $form.find('[type="submit"]');
            var btnOriginalText = $submitBtn.val() || $submitBtn.text();
            var savingText = (typeof osmeaConfig !== 'undefined' && osmeaConfig.strings && osmeaConfig.strings.saving) ? osmeaConfig.strings.saving : 'Saving...';
            var savedText = (typeof osmeaConfig !== 'undefined' && osmeaConfig.strings && osmeaConfig.strings.saved) ? osmeaConfig.strings.saved : 'Settings saved.';
            var errorText = (typeof osmeaConfig !== 'undefined' && osmeaConfig.strings && osmeaConfig.strings.error) ? osmeaConfig.strings.error : 'Error while saving.';

            $status.removeClass('valid invalid unsaved').hide();
            $submitBtn.prop('disabled', true);
            if ($submitBtn.is('input')) $submitBtn.val(savingText); else $submitBtn.text(savingText);

            $.ajax({
                url: typeof osmeaConfig !== 'undefined' ? osmeaConfig.restUrl : '',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(config),
                beforeSend: function(xhr) {
                    if (typeof osmeaConfig !== 'undefined' && osmeaConfig.nonce) xhr.setRequestHeader('X-WP-Nonce', osmeaConfig.nonce);
                },
                success: function(res) {
                    if (res && res.success && res.config) {
                        setConfigObj(res.config);
                        markClean();
                        updateDirtyUI();
                        $status.removeClass('invalid unsaved').addClass('valid').text(res.message || savedText).show();
                        var meta = res.config.config_meta || {};
                        var $metaEl = $('#osmea-config-meta');
                        if ($metaEl.length && (meta.last_updated || meta.plugin_version || meta.configVersion)) {
                            var lastLbl = (typeof osmeaConfig !== 'undefined' && osmeaConfig.strings && osmeaConfig.strings.lastUpdated) || 'Last updated:';
                            var verLbl = (typeof osmeaConfig !== 'undefined' && osmeaConfig.strings && osmeaConfig.strings.pluginVersion) || 'Plugin version:';
                            var cfgVerLbl = (typeof osmeaConfig !== 'undefined' && osmeaConfig.strings && osmeaConfig.strings.configVersion) || 'Config version:';
                            $metaEl.html('<span class="osmea-meta-item">' + lastLbl + ' <strong>' + (meta.last_updated || '—') + '</strong></span><span class="osmea-meta-sep">|</span><span class="osmea-meta-item">' + verLbl + ' <strong>' + (meta.plugin_version || '—') + '</strong></span><span class="osmea-meta-sep">|</span><span class="osmea-meta-item">' + cfgVerLbl + ' <strong>' + (meta.configVersion || '—') + '</strong></span>').show();
                        }
                    } else {
                        $status.removeClass('valid').addClass('invalid').text(res && res.message ? res.message : errorText).show();
                    }
                    $submitBtn.prop('disabled', false);
                    if ($submitBtn.is('input')) $submitBtn.val(btnOriginalText); else $submitBtn.text(btnOriginalText);
                },
                error: function(xhr) {
                    var msg = errorText;
                    if (xhr && xhr.responseJSON && xhr.responseJSON.message) msg = xhr.responseJSON.message;
                    else if (xhr && xhr.responseJSON && xhr.responseJSON.code) msg = (xhr.responseJSON.message || xhr.responseJSON.code) || errorText;
                    $status.removeClass('valid unsaved').addClass('invalid').text(msg).show();
                    $submitBtn.prop('disabled', false);
                    if ($submitBtn.is('input')) $submitBtn.val(btnOriginalText); else $submitBtn.text(btnOriginalText);
                }
            });
        });

        window.addEventListener('beforeunload', function(e) {
            if (isDirty()) {
                e.preventDefault();
                e.returnValue = (typeof osmeaConfig !== 'undefined' && osmeaConfig.strings && osmeaConfig.strings.unsavedChanges) ? osmeaConfig.strings.unsavedChanges : '';
            }
        });

        $('#osmea-reset-config').on('click', function() {
            if (!confirm(typeof osmeaConfig !== 'undefined' ? osmeaConfig.strings.confirmReset : 'Reset to default?')) return;
            var $btn = $(this);
            $btn.prop('disabled', true).text('Resetting...');
            $.ajax({
                url: typeof osmeaConfig !== 'undefined' ? osmeaConfig.resetUrl : '',
                method: 'POST',
                beforeSend: function(xhr) { if (typeof osmeaConfig !== 'undefined') xhr.setRequestHeader('X-WP-Nonce', osmeaConfig.nonce); },
                success: function(res) {
                    if (res.success && res.config) {
                        setConfigObj(res.config);
                        buildFormFromConfig();
                        markClean();
                        updateDirtyUI();
                        $status.removeClass('invalid unsaved').addClass('valid').text('Reset to default.').show();
                        var cfg = typeof res.config === 'string' ? (function(){ try { return JSON.parse(res.config); } catch(e){ return {}; } })() : (res.config || {});
                        var meta = cfg.config_meta || {};
                        var last = meta.last_updated || '—';
                        var ver = meta.plugin_version || '';
                        var cfgVer = meta.configVersion || '—';
                        var $metaEl = $('#osmea-config-meta');
                        if ($metaEl.length && (last || ver || meta.configVersion)) {
                            var lastLbl = (typeof osmeaConfig !== 'undefined' && osmeaConfig.strings && osmeaConfig.strings.lastUpdated) || 'Last updated:';
                            var verLbl = (typeof osmeaConfig !== 'undefined' && osmeaConfig.strings && osmeaConfig.strings.pluginVersion) || 'Plugin version:';
                            var cfgVerLbl = (typeof osmeaConfig !== 'undefined' && osmeaConfig.strings && osmeaConfig.strings.configVersion) || 'Config version:';
                            $metaEl.html('<span class="osmea-meta-item">' + lastLbl + ' <strong>' + (last || '—') + '</strong></span><span class="osmea-meta-sep">|</span><span class="osmea-meta-item">' + verLbl + ' <strong>' + (ver || '—') + '</strong></span><span class="osmea-meta-sep">|</span><span class="osmea-meta-item">' + cfgVerLbl + ' <strong>' + (cfgVer || '—') + '</strong></span>').show();
                        }
                    }
                    $btn.prop('disabled', false).text('Reset to Default');
                },
                error: function() {
                    $btn.prop('disabled', false).text('Reset to Default');
                }
            });
        });

        if ($hiddenStore.length && !$hiddenStore.val().trim() && typeof osmeaConfig !== 'undefined' && osmeaConfig.currentConfig) {
            var cfg = osmeaConfig.currentConfig;
            $hiddenStore.val(typeof cfg === 'string' ? cfg : JSON.stringify(cfg || {}));
        }
        try {
            buildFormFromConfig();
            initSearch();
        } catch (err) {
            if (typeof console !== 'undefined') console.error('OSMEA buildFormFromConfig:', err);
            if ($status.length) $status.addClass('invalid').text('Could not load form. Check console.').show();
            var cats = staticCategories && staticCategories.length ? staticCategories : getCategories();
            cats.forEach(function(cat, idx) {
                $tabbar.append($('<button type="button" class="osmea-tab-item"/>').attr('data-tab', cat.id).text(cat.label));
                var $p = $('<div class="osmea-tab-panel"/>').attr('data-tab', cat.id).css('display', idx === 0 ? 'block' : 'none');
                $p.append($('<p/>').text('Error loading this section.'));
                $uiSections.append($p);
            });
        }
    });

})(jQuery);
