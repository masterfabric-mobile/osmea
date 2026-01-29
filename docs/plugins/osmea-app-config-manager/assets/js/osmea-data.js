/**
 * OSMEA App Config Manager – Data layer
 * Tabs, categories, field definitions. No DOM/jQuery.
 */
(function () {
    'use strict';
    var N = window.OSMEA_Config = window.OSMEA_Config || {};

    function getTabs() {
        return [
            { id: 'app_settings', label: 'App Settings' },
            { id: 'api_configuration', label: 'API' },
            { id: 'woocommerce_configuration', label: 'WooCommerce' },
            { id: 'splash_configuration', label: 'Splash' },
            { id: 'onboarding_configuration', label: 'Onboarding' },
            { id: 'auth_configuration', label: 'Auth' },
            { id: 'home_view', label: 'Home View' },
            { id: 'search_view_configuration', label: 'Search View' },
            { id: 'product_list_view', label: 'Product List' },
            { id: 'product_detail_view', label: 'Product Detail' },
            { id: 'product_card', label: 'Product Card' },
            { id: 'cart_view_configuration', label: 'Cart View' },
            { id: 'checkout_view_configuration', label: 'Checkout' },
            { id: 'wishlist_view', label: 'Wishlist' },
            { id: 'favorite_categories_view_configuration', label: 'Favorite Categories' },
            { id: 'campaign_view', label: 'Campaign View' },
            { id: 'orders_history_view', label: 'Orders History' },
            { id: 'order_detail_view', label: 'Order Detail' },
            { id: 'user_profile_view', label: 'User Profile' },
            { id: 'account_configuration', label: 'Account' },
            { id: 'about_configuration', label: 'About' },
            { id: 'contact_us_configuration', label: 'Contact Us' },
            { id: 'faq_configuration', label: 'FAQ' },
            { id: 'empty_view_configuration', label: 'Empty View' },
            { id: 'loading_configuration', label: 'Loading' },
            { id: 'error_handling_configuration', label: 'Error Handling' },
            { id: 'navbar_configuration', label: 'Navbar' },
            { id: 'ui_configuration', label: 'UI' },
            { id: 'dialog_popup_configuration', label: 'Dialog & Popup' },
            { id: 'firebase_configuration', label: 'Firebase' },
            { id: 'security_configuration', label: 'Security' },
            { id: 'storage_configuration', label: 'Storage' },
            { id: 'notification_configuration', label: 'Notifications' },
            { id: 'performance_configuration', label: 'Performance' },
            { id: 'feature_flags', label: 'Feature Flags' },
            { id: 'localization_configuration', label: 'Localization' }
        ];
    }

    function getCategories() {
        if (typeof osmeaConfig !== 'undefined' && Array.isArray(osmeaConfig.categories) && osmeaConfig.categories.length) {
            return osmeaConfig.categories.map(function (c) {
                return { id: c.id, label: c.label || c.id, tabIds: Array.isArray(c.tabIds) ? c.tabIds : [] };
            });
        }
        return [
            { id: 'general', label: 'General', tabIds: ['app_settings', 'api_configuration', 'woocommerce_configuration'] },
            { id: 'launch', label: 'Launch & Auth', tabIds: ['splash_configuration', 'onboarding_configuration', 'auth_configuration'] },
            { id: 'home', label: 'Home View', tabIds: ['home_view'] },
            { id: 'search', label: 'Search View', tabIds: ['search_view_configuration'] },
            { id: 'product', label: 'Product (List / Detail / Card)', tabIds: ['product_list_view', 'product_detail_view', 'product_card'] },
            { id: 'cart_checkout', label: 'Cart & Checkout', tabIds: ['cart_view_configuration', 'checkout_view_configuration'] },
            { id: 'wishlist_favorites', label: 'Wishlist & Favorites', tabIds: ['wishlist_view', 'favorite_categories_view_configuration'] },
            { id: 'campaign', label: 'Campaign View', tabIds: ['campaign_view'] },
            { id: 'orders', label: 'Orders', tabIds: ['orders_history_view', 'order_detail_view'] },
            { id: 'profile_account', label: 'Profile & Account', tabIds: ['user_profile_view', 'account_configuration'] },
            { id: 'content', label: 'Content (About / FAQ / Empty / Loading)', tabIds: ['about_configuration', 'contact_us_configuration', 'faq_configuration', 'empty_view_configuration', 'loading_configuration', 'error_handling_configuration'] },
            { id: 'nav_ui', label: 'Nav & UI', tabIds: ['navbar_configuration', 'ui_configuration', 'dialog_popup_configuration'] },
            { id: 'infrastructure', label: 'Infrastructure', tabIds: ['firebase_configuration', 'security_configuration', 'storage_configuration', 'notification_configuration', 'performance_configuration', 'feature_flags', 'localization_configuration'] }
        ];
    }

    function isImageUrlField(field) {
        if (field.type === 'image') return true;
        var p = (field.path || '').toLowerCase();
        return /logo_url|splash_image_url|imageurl|image_url/.test(p);
    }

    N.getTabs = getTabs;
    N.getCategories = getCategories;
    N.isImageUrlField = isImageUrlField;
    N.getFieldDefinitions = getFieldDefinitions;
    N.getHomeProductNavbarCartFields = getHomeProductNavbarCartFields;

    function getFieldDefinitions() {
        var v1v2v3 = [{ value: 'v1', label: 'v1' }, { value: 'v2', label: 'v2' }, { value: 'v3', label: 'v3' }];
        var defs = getBaseFieldDefinitions(v1v2v3).concat(getHomeProductNavbarCartFields());
        defs.forEach(function (f) {
            var path = (f.path || '').toLowerCase();
            // Colors: force color picker UI
            if (/color/i.test(f.path) || (f.label && /color/i.test(f.label))) {
                f.type = 'color';
                return;
            }
            // Image / URL fields must always be text (not number),
            // so default URLs and previews work correctly.
            if (/logo_url|splash_image_url|imageurl|image_url|icon_path|image_path/i.test(path)) {
                f.type = 'text';
                if (!f.placeholder) {
                    f.placeholder = 'https://... (HTTPS, JPEG/PNG önerilir)';
                }
            }
        });
        return defs;
    }

    function getBaseFieldDefinitions(v1v2v3) {
        var sel = function (opts) { return { type: 'select', options: opts }; };
        return [
            { tab: 'app_settings', path: 'app_settings.app_name', type: 'text', label: 'App Name' },
            { tab: 'app_settings', path: 'app_settings.app_version', type: 'text', label: 'App Version' },
            { tab: 'app_settings', path: 'app_settings.build_number', type: 'text', label: 'Build Number' },
            { tab: 'app_settings', path: 'app_settings.environment', type: 'select', label: 'Environment', options: [{ value: 'production', label: 'Production' }, { value: 'staging', label: 'Staging' }, { value: 'development', label: 'Development' }] },
            { tab: 'app_settings', path: 'app_settings.debug_mode', type: 'boolean', label: 'Debug Mode' },
            { tab: 'app_settings', path: 'app_settings.maintenance_mode', type: 'boolean', label: 'Maintenance Mode' },
            { tab: 'app_settings', path: 'app_settings.wordpress_config_check_interval_seconds', type: 'number', label: 'WordPress config check interval (sec)' },
            { tab: 'api_configuration', path: 'api_configuration.base_url', type: 'text', label: 'Base URL' },
            { tab: 'api_configuration', path: 'api_configuration.timeout_seconds', type: 'number', label: 'Timeout (s)' },
            { tab: 'api_configuration', path: 'api_configuration.retry_count', type: 'number', label: 'Retry Count' },
            { tab: 'api_configuration', path: 'api_configuration.enable_logging', type: 'boolean', label: 'Enable Logging' },
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
            { tab: 'woocommerce_configuration', path: 'woocommerce_configuration.enable_guest_checkout', type: 'boolean', label: 'Enable Guest Checkout' }
        ].concat(
            getAccountAndFirebaseDefs(v1v2v3),
            getUiAndSearchDefs(v1v2v3),
            getSecurityToFeatureFlagsDefs(v1v2v3),
            getSplashToAuthDefs(v1v2v3)
        );
    }

    function getAccountAndFirebaseDefs(v1v2v3) {
        return [
            { tab: 'account_configuration', path: 'account_configuration.style', type: 'select', label: 'Style', options: [{ value: 'space', label: 'Space' }, { value: 'startup', label: 'Startup' }, { value: 'enterprise', label: 'Enterprise' }] },
            { tab: 'account_configuration', path: 'account_configuration.space_style_colors.primary_color', type: 'text', label: 'Primary Color' },
            { tab: 'account_configuration', path: 'account_configuration.space_style_colors.secondary_color', type: 'text', label: 'Secondary Color' },
            { tab: 'account_configuration', path: 'account_configuration.space_style_colors.text_color', type: 'text', label: 'Text Color' },
            { tab: 'account_configuration', path: 'account_configuration.space_style_colors.icon_color', type: 'text', label: 'Icon Color' },
            { tab: 'account_configuration', path: 'account_configuration.space_style_colors.separator_color', type: 'text', label: 'Separator Color' },
            { tab: 'account_configuration', path: 'account_configuration.space_style_colors.background_color', type: 'text', label: 'Background Color' },
            { tab: 'firebase_configuration', path: 'firebase_configuration.analytics_enabled', type: 'boolean', label: 'Analytics' },
            { tab: 'firebase_configuration', path: 'firebase_configuration.crashlytics_enabled', type: 'boolean', label: 'Crashlytics' },
            { tab: 'firebase_configuration', path: 'firebase_configuration.performance_monitoring_enabled', type: 'boolean', label: 'Performance Monitoring' },
            { tab: 'firebase_configuration', path: 'firebase_configuration.remote_config_enabled', type: 'boolean', label: 'Remote Config' },
            { tab: 'firebase_configuration', path: 'firebase_configuration.remote_config_fetch_timeout', type: 'number', label: 'Remote Config Timeout' },
            { tab: 'firebase_configuration', path: 'firebase_configuration.remote_config_cache_expiration', type: 'number', label: 'Remote Config Cache Expiration' }
        ];
    }

    function getUiAndSearchDefs(v1v2v3) {
        return [
            { tab: 'ui_configuration', path: 'ui_configuration.theme_mode', type: 'select', label: 'Theme Mode', options: [{ value: 'light', label: 'Light' }, { value: 'dark', label: 'Dark' }, { value: 'system', label: 'System' }] },
            { tab: 'ui_configuration', path: 'ui_configuration.primary_color', type: 'text', label: 'Primary Color' },
            { tab: 'ui_configuration', path: 'ui_configuration.accent_color', type: 'text', label: 'Accent Color' },
            { tab: 'ui_configuration', path: 'ui_configuration.search_app_bar_color', type: 'text', label: 'Search App Bar Color' },
            { tab: 'ui_configuration', path: 'ui_configuration.font_scale', type: 'number', label: 'Font Scale' },
            { tab: 'ui_configuration', path: 'ui_configuration.enable_haptic_feedback', type: 'boolean', label: 'Haptic Feedback' },
            { tab: 'ui_configuration', path: 'ui_configuration.enable_sound_effects', type: 'boolean', label: 'Sound Effects' }
        ].concat(getSearchViewDefs());
    }

    function getSearchViewDefs() {
        var opts = { size: [{ value: 'small', label: 'Small' }, { value: 'medium', label: 'Medium' }, { value: 'large', label: 'Large' }], variant: [{ value: 'borderless', label: 'Borderless' }, { value: 'outlined', label: 'Outlined' }, { value: 'filled', label: 'Filled' }] };
        return [
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
            { tab: 'search_view_configuration', path: 'search_view_configuration.search_bar_size', type: 'select', label: 'Search Bar Size', options: opts.size },
            { tab: 'search_view_configuration', path: 'search_view_configuration.search_bar_variant', type: 'select', label: 'Search Bar Variant', options: opts.variant },
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
            { tab: 'search_view_configuration', path: 'search_view_configuration.loading.showCancelButton', type: 'boolean', label: 'Loading Show Cancel' }
        ];
    }

    function getSecurityToFeatureFlagsDefs() {
        return [
            { tab: 'security_configuration', path: 'security_configuration.enable_ssl_pinning', type: 'boolean', label: 'SSL Pinning' },
            { tab: 'security_configuration', path: 'security_configuration.certificate_validation', type: 'boolean', label: 'Certificate Validation' },
            { tab: 'security_configuration', path: 'security_configuration.biometric_authentication', type: 'boolean', label: 'Biometric Auth' },
            { tab: 'security_configuration', path: 'security_configuration.session_timeout_minutes', type: 'number', label: 'Session Timeout (min)' },
            { tab: 'storage_configuration', path: 'storage_configuration.enable_encryption', type: 'boolean', label: 'Encryption' },
            { tab: 'storage_configuration', path: 'storage_configuration.cache_size_mb', type: 'number', label: 'Cache Size (MB)' },
            { tab: 'storage_configuration', path: 'storage_configuration.auto_cleanup_enabled', type: 'boolean', label: 'Auto Cleanup' },
            { tab: 'storage_configuration', path: 'storage_configuration.backup_enabled', type: 'boolean', label: 'Backup' },
            { tab: 'notification_configuration', path: 'notification_configuration.push_notifications_enabled', type: 'boolean', label: 'Push Notifications' },
            { tab: 'notification_configuration', path: 'notification_configuration.local_notifications_enabled', type: 'boolean', label: 'Local Notifications' },
            { tab: 'notification_configuration', path: 'notification_configuration.notification_sound', type: 'select', label: 'Notification Sound', options: [{ value: 'default', label: 'Default' }, { value: 'none', label: 'None' }, { value: 'custom', label: 'Custom' }] },
            { tab: 'notification_configuration', path: 'notification_configuration.vibration_enabled', type: 'boolean', label: 'Vibration' },
            { tab: 'feature_flags', path: 'feature_flags.onboarding_enabled', type: 'boolean', label: 'Onboarding' },
            { tab: 'feature_flags', path: 'feature_flags.dark_mode_available', type: 'boolean', label: 'Dark Mode Available' },
            { tab: 'feature_flags', path: 'feature_flags.offline_mode_enabled', type: 'boolean', label: 'Offline Mode' },
            { tab: 'feature_flags', path: 'feature_flags.beta_features_enabled', type: 'boolean', label: 'Beta Features' },
            { tab: 'feature_flags', path: 'feature_flags.analytics_opt_out_available', type: 'boolean', label: 'Analytics Opt Out' },
            { tab: 'feature_flags', path: 'feature_flags.woocommerce_integration_enabled', type: 'boolean', label: 'WooCommerce Integration' },
            { tab: 'feature_flags', path: 'feature_flags.payment_gateway_enabled', type: 'boolean', label: 'Payment Gateway' },
            { tab: 'feature_flags', path: 'feature_flags.wishlist_enabled', type: 'boolean', label: 'Wishlist' },
            { tab: 'feature_flags', path: 'feature_flags.cart_persistence_enabled', type: 'boolean', label: 'Cart Persistence' }
        ];
    }

    function getSplashToAuthDefs() {
        var styleOpts = [{ value: 'startup', label: 'Startup' }, { value: 'space', label: 'Space' }, { value: 'enterprise', label: 'Enterprise' }];
        var logoAnimOpts = [{ value: 'fade_scale', label: 'Fade & Scale' }, { value: 'fade', label: 'Fade' }, { value: 'scale', label: 'Scale' }, { value: 'none', label: 'None' }];
        return [
            { tab: 'splash_configuration', path: 'splash_configuration.enabled', type: 'boolean', label: 'Enabled' },
            { tab: 'splash_configuration', path: 'splash_configuration.style', type: 'select', label: 'Style', options: styleOpts },
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
            { tab: 'splash_configuration', path: 'splash_configuration.logo_animation_type', type: 'select', label: 'Logo Animation Type', options: logoAnimOpts },
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
            { tab: 'localization_configuration', path: 'localization_configuration.default_language', type: 'text', label: 'Default Language' },
            { tab: 'localization_configuration', path: 'localization_configuration.supported_languages', type: 'text', label: 'Supported Languages (comma-separated)' },
            { tab: 'localization_configuration', path: 'localization_configuration.rtl_support', type: 'boolean', label: 'RTL Support' },
            { tab: 'localization_configuration', path: 'localization_configuration.auto_detect_language', type: 'boolean', label: 'Auto Detect Language' },
            { tab: 'performance_configuration', path: 'performance_configuration.image_cache_size_mb', type: 'number', label: 'Image Cache (MB)' },
            { tab: 'performance_configuration', path: 'performance_configuration.network_cache_size_mb', type: 'number', label: 'Network Cache (MB)' },
            { tab: 'performance_configuration', path: 'performance_configuration.lazy_loading_enabled', type: 'boolean', label: 'Lazy Loading' },
            { tab: 'performance_configuration', path: 'performance_configuration.preload_critical_assets', type: 'boolean', label: 'Preload Critical Assets' }
        ].concat(
            getOnboardingAboutContactFaqDefs(styleOpts),
            getLoadingErrorEmptyAuthDefs(styleOpts)
        );
    }

    function getOnboardingAboutContactFaqDefs(styleOpts) {
        return [
            { tab: 'onboarding_configuration', path: 'onboarding_configuration.style', type: 'select', label: 'Style', options: styleOpts },
            { tab: 'onboarding_configuration', path: 'onboarding_configuration.auto_advance_seconds', type: 'number', label: 'Auto Advance (s)' },
            { tab: 'onboarding_configuration', path: 'onboarding_configuration.show_skip_button', type: 'boolean', label: 'Show Skip' },
            { tab: 'onboarding_configuration', path: 'onboarding_configuration.show_page_indicator', type: 'boolean', label: 'Show Page Indicator' },
            { tab: 'onboarding_configuration', path: 'onboarding_configuration.animation_duration', type: 'number', label: 'Animation Duration' },
            { tab: 'onboarding_configuration', path: 'onboarding_configuration.primary_color', type: 'text', label: 'Primary Color' },
            { tab: 'onboarding_configuration', path: 'onboarding_configuration.secondary_color', type: 'text', label: 'Secondary Color' },
            // About/Contact/FAQ style alanlarını da dropdown yap
            { tab: 'about_configuration', path: 'about_configuration.style', type: 'select', label: 'Style', options: styleOpts },
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
            { tab: 'contact_us_configuration', path: 'contact_us_configuration.style', type: 'select', label: 'Style', options: styleOpts },
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
            { tab: 'faq_configuration', path: 'faq_configuration.style', type: 'select', label: 'Style', options: styleOpts },
            { tab: 'faq_configuration', path: 'faq_configuration.title', type: 'text', label: 'Title' },
            { tab: 'faq_configuration', path: 'faq_configuration.description', type: 'text', label: 'Description' },
            { tab: 'faq_configuration', path: 'faq_configuration.allow_multiple_expanded', type: 'boolean', label: 'Allow Multiple Expanded' },
            { tab: 'faq_configuration', path: 'faq_configuration.show_search_bar', type: 'boolean', label: 'Show Search Bar' },
            { tab: 'faq_configuration', path: 'faq_configuration.show_categories', type: 'boolean', label: 'Show Categories' },
            { tab: 'faq_configuration', path: 'faq_configuration.background_color', type: 'text', label: 'Background Color' },
            { tab: 'faq_configuration', path: 'faq_configuration.text_color', type: 'text', label: 'Text Color' },
            { tab: 'faq_configuration', path: 'faq_configuration.primary_color', type: 'text', label: 'Primary Color' }
        ];
    }

    function getLoadingErrorEmptyAuthDefs(styleOpts) {
        return [
            // Loading / Error / Empty view style alanları da dropdown
            { tab: 'loading_configuration', path: 'loading_configuration.style', type: 'select', label: 'Style', options: styleOpts },
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
            { tab: 'error_handling_configuration', path: 'error_handling_configuration.style', type: 'select', label: 'Style', options: styleOpts },
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
            { tab: 'empty_view_configuration', path: 'empty_view_configuration.style', type: 'select', label: 'Style', options: styleOpts },
            { tab: 'empty_view_configuration', path: 'empty_view_configuration.background_color', type: 'text', label: 'Background Color' },
            { tab: 'empty_view_configuration', path: 'empty_view_configuration.text_color', type: 'text', label: 'Text Color' },
            { tab: 'empty_view_configuration', path: 'empty_view_configuration.animation_duration', type: 'number', label: 'Animation Duration' },
            { tab: 'empty_view_configuration', path: 'empty_view_configuration.primary_color', type: 'text', label: 'Primary Color' },
            { tab: 'empty_view_configuration', path: 'empty_view_configuration.secondary_color', type: 'text', label: 'Secondary Color' },
            { tab: 'empty_view_configuration', path: 'empty_view_configuration.enable_haptic_feedback', type: 'boolean', label: 'Haptic Feedback' },
            { tab: 'empty_view_configuration', path: 'empty_view_configuration.default_empty_message', type: 'text', label: 'Default Empty Message' },
            { tab: 'empty_view_configuration', path: 'empty_view_configuration.show_action_button', type: 'boolean', label: 'Show Action Button' },
            { tab: 'auth_configuration', path: 'auth_configuration.ui_style.style', type: 'select', label: 'UI Style', options: styleOpts },
            { tab: 'auth_configuration', path: 'auth_configuration.ui_style.primary_color', type: 'text', label: 'UI Primary Color' },
            { tab: 'auth_configuration', path: 'auth_configuration.sign_in.app_name', type: 'text', label: 'Sign-in App Name' },
            { tab: 'auth_configuration', path: 'auth_configuration.sign_in.email_label', type: 'text', label: 'Email Label' },
            { tab: 'auth_configuration', path: 'auth_configuration.sign_in.sign_in_button', type: 'text', label: 'Sign-in Button Text' },
            { tab: 'auth_configuration', path: 'auth_configuration.forgot_password.title', type: 'text', label: 'Forgot Password Title' }
        ];
    }

    function inferFieldType(path) {
        var p = path.toLowerCase();
        if (p.indexOf('enabled') >= 0 || p.indexOf('show_') >= 0 || p.indexOf('showborder') >= 0 || p.indexOf('showclose') >= 0 || p.indexOf('cutoff_affects') >= 0) return 'boolean';
        if (p.indexOf('order_id') >= 0 || p.indexOf('limit') >= 0 || p.indexOf('size') >= 0 || p.indexOf('height') >= 0 || p.indexOf('radius') >= 0 || p.indexOf('top') >= 0 || p.indexOf('bottom') >= 0 || p.indexOf('horizontal') >= 0 || p.indexOf('spacing') >= 0 || p.indexOf('elevation') >= 0 || p.indexOf('titlefontweight') >= 0 || p.indexOf('opacity') >= 0 || p.indexOf('offset') >= 0 || (p.indexOf('width') >= 0 && p.indexOf('borderwidth') < 0) || p.indexOf('borderwidth') >= 0) return 'number';
        return 'text';
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
        var homePaths = [
            'home_view.app_bar.title_source', 'home_view.app_bar.fallback_title', 'home_view.app_bar.backgroundColor', 'home_view.app_bar.foregroundColor', 'home_view.app_bar.titleColor', 'home_view.app_bar.elevation', 'home_view.app_bar.titleFontWeight',
            'home_view.component_spacing.top', 'home_view.component_spacing.bottom', 'home_view.component_spacing.horizontal', 'home_view.component_spacing.title_to_content',
            'home_view.search.enabled', 'home_view.search.order_id', 'home_view.search.placeholder',
            'home_view.circle_categories.enabled', 'home_view.circle_categories.order_id', 'home_view.circle_categories.max_items', 'home_view.circle_categories.circle_size', 'home_view.circle_categories.show_names', 'home_view.circle_categories.image_size', 'home_view.circle_categories.spacing',
            'home_view.banner.enabled', 'home_view.banner.order_id', 'home_view.banner.padding.top', 'home_view.banner.padding.bottom',
            'home_view.promotional_bar.enabled', 'home_view.promotional_bar.order_id', 'home_view.promotional_bar.border_radius', 'home_view.promotional_bar.height',
            'home_view.campaign_cards.enabled', 'home_view.campaign_cards.order_id', 'home_view.campaign_cards.title', 'home_view.campaign_cards.card_height', 'home_view.campaign_cards.card_width', 'home_view.campaign_cards.border_radius', 'home_view.campaign_cards.padding.top', 'home_view.campaign_cards.padding.bottom', 'home_view.campaign_cards.padding.horizontal',
            'home_view.deals_of_day.enabled', 'home_view.deals_of_day.order_id', 'home_view.deals_of_day.title', 'home_view.deals_of_day.limit', 'home_view.deals_of_day.padding.top', 'home_view.deals_of_day.padding.bottom', 'home_view.deals_of_day.padding.horizontal',
            'home_view.collections.enabled', 'home_view.collections.order_id', 'home_view.collections.title', 'home_view.collections.padding.top', 'home_view.collections.padding.bottom', 'home_view.collections.padding.horizontal',
            'home_view.recommended.enabled', 'home_view.recommended.order_id', 'home_view.recommended.title', 'home_view.recommended.limit', 'home_view.recommended.padding.top', 'home_view.recommended.padding.bottom', 'home_view.recommended.padding.horizontal', 'home_view.recommended.titleColor', 'home_view.recommended.seeAllColor', 'home_view.recommended.card.backgroundColor', 'home_view.recommended.card.imageBackgroundColor', 'home_view.recommended.card.borderRadius', 'home_view.recommended.card.showBorder', 'home_view.recommended.card.borderColor', 'home_view.recommended.card.borderWidth', 'home_view.recommended.discountBadge.backgroundColor', 'home_view.recommended.discountBadge.textColor', 'home_view.recommended.discountBadge.borderRadius', 'home_view.recommended.wishlistButton.backgroundColor', 'home_view.recommended.wishlistButton.borderColor', 'home_view.recommended.wishlistButton.borderWidth', 'home_view.recommended.wishlistButton.iconColor', 'home_view.recommended.wishlistButton.iconColorSelected', 'home_view.recommended.wishlistButton.borderRadius', 'home_view.recommended.price.salePriceColor', 'home_view.recommended.price.regularPriceColor', 'home_view.recommended.price.strikethroughPriceColor', 'home_view.recommended.productName.color', 'home_view.recommended.description.color',
            'home_view.campaign_alert.enabled', 'home_view.campaign_alert.order_id', 'home_view.campaign_alert.title', 'home_view.campaign_alert.message', 'home_view.campaign_alert.end_time', 'home_view.campaign_alert.background_color', 'home_view.campaign_alert.text_color', 'home_view.campaign_alert.route', 'home_view.campaign_alert.category_id', 'home_view.campaign_alert.product_id', 'home_view.campaign_alert.padding.top', 'home_view.campaign_alert.padding.bottom', 'home_view.campaign_alert.padding.horizontal',
            'home_view.flash_sale.enabled', 'home_view.flash_sale.order_id', 'home_view.flash_sale.title', 'home_view.flash_sale.limit', 'home_view.flash_sale.end_time', 'home_view.flash_sale.backgroundColor', 'home_view.flash_sale.padding.top', 'home_view.flash_sale.padding.bottom', 'home_view.flash_sale.padding.horizontal',
            'home_view.brands.enabled', 'home_view.brands.order_id', 'home_view.brands.title', 'home_view.brands.layout', 'home_view.brands.padding.top', 'home_view.brands.padding.bottom', 'home_view.brands.padding.horizontal',
            'home_view.campaign_popup_button.enabled', 'home_view.campaign_popup_button.text', 'home_view.campaign_popup_button.amount', 'home_view.campaign_popup_button.imageUrl', 'home_view.campaign_popup_button.backgroundColor', 'home_view.campaign_popup_button.borderColor', 'home_view.campaign_popup_button.textColor', 'home_view.campaign_popup_button.position', 'home_view.campaign_popup_button.size', 'home_view.campaign_popup_button.showCloseButton', 'home_view.campaign_popup_button.route', 'home_view.campaign_popup_button.category_id', 'home_view.campaign_popup_button.product_id',
            'home_view.bottom_foreground_banner.enabled', 'home_view.bottom_foreground_banner.imageUrl', 'home_view.bottom_foreground_banner.title', 'home_view.bottom_foreground_banner.description', 'home_view.bottom_foreground_banner.height', 'home_view.bottom_foreground_banner.border_radius', 'home_view.bottom_foreground_banner.image_opacity', 'home_view.bottom_foreground_banner.overlay_color', 'home_view.bottom_foreground_banner.overlay_opacity', 'home_view.bottom_foreground_banner.background_color', 'home_view.bottom_foreground_banner.text_color', 'home_view.bottom_foreground_banner.arrow_icon_color', 'home_view.bottom_foreground_banner.tail_height', 'home_view.bottom_foreground_banner.tail_width', 'home_view.bottom_foreground_banner.tail_bottom_offset', 'home_view.bottom_foreground_banner.show_dismiss_button', 'home_view.bottom_foreground_banner.route', 'home_view.bottom_foreground_banner.category_id', 'home_view.bottom_foreground_banner.product_id'
        ];
        homePaths.forEach(function (p) {
            var lab = p.replace('home_view.', '').replace(/_/g, ' ');
            a.push({ tab: 'home_view', path: p, type: inferFieldType(p), label: lab });
        });
        var pdPaths = [
            'product_detail_view.appBar.backgroundColor', 'product_detail_view.appBar.titleColor', 'product_detail_view.appBar.iconColor', 'product_detail_view.appBar.elevation',
            'product_detail_view.delivery.estimated_label', 'product_detail_view.delivery.estimated_min_days', 'product_detail_view.delivery.estimated_max_days', 'product_detail_view.delivery.estimated_display', 'product_detail_view.delivery.date_format', 'product_detail_view.delivery.cutoff_title', 'product_detail_view.delivery.cutoff_hour', 'product_detail_view.delivery.cutoff_minute', 'product_detail_view.delivery.show_cutoff_time', 'product_detail_view.delivery.show_cutoff_countdown', 'product_detail_view.delivery.cutoff_affects_estimate',
            'product_detail_view.name_and_price.enabled', 'product_detail_view.name_and_price.order_id', 'product_detail_view.name_and_price.nameColor', 'product_detail_view.name_and_price.priceColor', 'product_detail_view.name_and_price.padding.horizontal', 'product_detail_view.name_and_price.padding.vertical',
            'product_detail_view.attributes.enabled', 'product_detail_view.attributes.order_id', 'product_detail_view.attributes.selectedColor', 'product_detail_view.attributes.unselectedColor', 'product_detail_view.attributes.highlightedColor', 'product_detail_view.attributes.borderColor', 'product_detail_view.attributes.backgroundColor',
            'product_detail_view.description.enabled', 'product_detail_view.description.order_id', 'product_detail_view.description.textColor', 'product_detail_view.description.backgroundColor', 'product_detail_view.description.borderColor',
            'product_detail_view.reviews.enabled', 'product_detail_view.reviews.order_id', 'product_detail_view.reviews.starColor', 'product_detail_view.reviews.textColor', 'product_detail_view.reviews.nameColor', 'product_detail_view.reviews.dateColor', 'product_detail_view.reviews.verifiedBadgeColor', 'product_detail_view.reviews.verifiedBadgeTextColor', 'product_detail_view.reviews.backgroundColor', 'product_detail_view.reviews.borderColor',
            'product_detail_view.images.enabled', 'product_detail_view.images.order_id', 'product_detail_view.images.indicatorColor', 'product_detail_view.images.wishlistIconColor',
            'product_detail_view.action_section.wishlistIconColor', 'product_detail_view.action_section.wishlistUnselectedColor', 'product_detail_view.action_section.shareIconColor', 'product_detail_view.action_section.buttonBackgroundColor', 'product_detail_view.action_section.buttonTextColor', 'product_detail_view.action_section.buttonBorderColor', 'product_detail_view.action_section.buttonBorderWidth', 'product_detail_view.action_section.buttonBorderRadius'
        ];
        pdPaths.forEach(function (p) {
            a.push({ tab: 'product_detail_view', path: p, type: inferFieldType(p), label: p.replace('product_detail_view.', '').replace(/_/g, ' ') });
        });
        var plPaths = [
            'product_list_view.app_bar.title', 'product_list_view.app_bar.backgroundColor', 'product_list_view.app_bar.foregroundColor', 'product_list_view.app_bar.titleColor', 'product_list_view.app_bar.iconColor',
            'product_list_view.component_spacing.top', 'product_list_view.component_spacing.bottom', 'product_list_view.component_spacing.horizontal', 'product_list_view.component_spacing.vertical', 'product_list_view.component_spacing.action_buttons_spacing', 'product_list_view.component_spacing.filter_chips_spacing', 'product_list_view.component_spacing.grid_spacing', 'product_list_view.component_spacing.grid_padding',
            'product_list_view.grid.columns_tablet', 'product_list_view.grid.columns_mobile', 'product_list_view.grid.crossAxisSpacing', 'product_list_view.grid.mainAxisSpacing', 'product_list_view.grid.estimatedCardHeight',
            'product_list_view.action_buttons.backgroundColor', 'product_list_view.action_buttons.borderColor', 'product_list_view.action_buttons.textColor', 'product_list_view.action_buttons.iconColor', 'product_list_view.action_buttons.borderRadius', 'product_list_view.action_buttons.borderWidth', 'product_list_view.action_buttons.badgeColor', 'product_list_view.action_buttons.badgeBorderColor'
        ];
        plPaths.forEach(function (p) {
            a.push({ tab: 'product_list_view', path: p, type: inferFieldType(p), label: p.replace('product_list_view.', '').replace(/_/g, ' ') });
        });
        ['product_card.badges.flash_sale.enabled','product_card.badges.flash_sale.auto','product_card.badges.flash_sale.min_discount_percent','product_card.badges.flash_sale.label'].forEach(function (p) {
            a.push({ tab: 'product_card', path: p, type: p.indexOf('enabled') >= 0 || p.indexOf('auto') >= 0 ? 'boolean' : (p.indexOf('percent') >= 0 ? 'number' : 'text'), label: p.replace('product_card.', '').replace(/_/g, ' ') });
        });
        var navbarVariantOpts = [{ value: 'transparent', label: 'Transparent' }, { value: 'filled', label: 'Filled' }];
        var navbarSizeOpts = [{ value: 'small', label: 'Small' }, { value: 'medium', label: 'Medium' }, { value: 'large', label: 'Large' }];
        var navbarPositionOpts = [{ value: 'top', label: 'Top' }, { value: 'bottom', label: 'Bottom' }];
        a.push({ tab: 'navbar_configuration', path: 'navbar_configuration.variant', type: 'select', label: 'variant', options: navbarVariantOpts });
        a.push({ tab: 'navbar_configuration', path: 'navbar_configuration.size', type: 'select', label: 'size', options: navbarSizeOpts });
        a.push({ tab: 'navbar_configuration', path: 'navbar_configuration.position', type: 'select', label: 'position', options: navbarPositionOpts });
        ['navbar_configuration.enabled','navbar_configuration.backgroundColor','navbar_configuration.borderColor','navbar_configuration.elevation','navbar_configuration.selectedIconColor','navbar_configuration.unselectedIconColor','navbar_configuration.selectedTextColor','navbar_configuration.unselectedTextColor','navbar_configuration.showLabels','navbar_configuration.showIcons','navbar_configuration.centerItems'].forEach(function (p) {
            a.push({ tab: 'navbar_configuration', path: p, type: p.indexOf('enabled') >= 0 || p.indexOf('show') >= 0 || p.indexOf('center') >= 0 ? 'boolean' : 'text', label: p.replace('navbar_configuration.', '').replace(/_/g, ' ') });
        });
        ['campaign_view.backgroundColor','campaign_view.splash_image_url','campaign_view.splash_title','campaign_view.splash_subtitle','campaign_view.animation.duration_milliseconds','campaign_view.navigation.timer_duration_milliseconds','campaign_view.gradient_overlay.enabled','campaign_view.gradient_overlay.startColor','campaign_view.gradient_overlay.endColor','campaign_view.text_overlay.title.color','campaign_view.text_overlay.subtitle.color'].forEach(function (p) {
            a.push({ tab: 'campaign_view', path: p, type: (p.indexOf('enabled') >= 0) ? 'boolean' : (p.indexOf('duration') >= 0 || p.indexOf('timer') >= 0 ? 'number' : 'text'), label: p.replace('campaign_view.', '').replace(/_/g, ' ') });
        });
        var appBarVariantOpts = [{ value: 'standard', label: 'Standard' }, { value: 'compact', label: 'Compact' }, { value: 'extended', label: 'Extended' }];
        var appBarSizeOpts = [{ value: 'standard', label: 'Standard' }, { value: 'compact', label: 'Compact' }, { value: 'extended', label: 'Extended' }];
        a.push({ tab: 'cart_view_configuration', path: 'cart_view_configuration.app_bar.variant', type: 'select', label: 'app bar variant', options: appBarVariantOpts });
        a.push({ tab: 'cart_view_configuration', path: 'cart_view_configuration.app_bar.size', type: 'select', label: 'app bar size', options: appBarSizeOpts });
        a.push({ tab: 'checkout_view_configuration', path: 'checkout_view_configuration.app_bar.variant', type: 'select', label: 'app bar variant', options: appBarVariantOpts });
        a.push({ tab: 'checkout_view_configuration', path: 'checkout_view_configuration.app_bar.size', type: 'select', label: 'app bar size', options: appBarSizeOpts });
        ['cart_view_configuration.app_bar.title','cart_view_configuration.app_bar.backgroundColor','cart_view_configuration.app_bar.foregroundColor','cart_view_configuration.app_bar.titleColor','cart_view_configuration.app_bar.iconColor','cart_view_configuration.app_bar.elevation','cart_view_configuration.app_bar.show_back_button','cart_view_configuration.app_bar.show_refresh_button','cart_view_configuration.refresh_indicator.color','cart_view_configuration.loading_overlay.loading_color','checkout_view_configuration.app_bar.title','checkout_view_configuration.app_bar.backgroundColor','checkout_view_configuration.app_bar.foregroundColor','checkout_view_configuration.app_bar.titleColor','checkout_view_configuration.app_bar.iconColor','checkout_view_configuration.app_bar.elevation'].forEach(function (p) {
            a.push({ tab: p.indexOf('cart_view') >= 0 ? 'cart_view_configuration' : 'checkout_view_configuration', path: p, type: (p.indexOf('show_') >= 0) ? 'boolean' : (p.indexOf('Color') >= 0 || p.indexOf('title') >= 0 ? 'text' : 'number'), label: p.replace('cart_view_configuration.', '').replace('checkout_view_configuration.', '').replace(/_/g, ' ') });
        });
        ['wishlist_view.app_bar.title','wishlist_view.app_bar.titleWithCount','wishlist_view.app_bar.backgroundColor','wishlist_view.app_bar.foregroundColor','wishlist_view.app_bar.titleColor','wishlist_view.app_bar.iconColor','wishlist_view.app_bar.elevation','orders_history_view.app_bar.title','orders_history_view.app_bar.backgroundColor','orders_history_view.app_bar.foregroundColor','orders_history_view.app_bar.titleColor','orders_history_view.app_bar.iconColor','user_profile_view.app_bar.title','user_profile_view.app_bar.backgroundColor','user_profile_view.app_bar.foregroundColor','user_profile_view.app_bar.titleColor','user_profile_view.app_bar.iconColor','order_detail_view.app_bar.title','order_detail_view.app_bar.backgroundColor','order_detail_view.app_bar.foregroundColor','order_detail_view.app_bar.titleColor','order_detail_view.app_bar.iconColor'].forEach(function (p) {
            var t = p.split('.')[0];
            a.push({ tab: t, path: p, type: 'text', label: p.replace(t + '.app_bar.', '').replace(/_/g, ' ') });
        });
        ['favorite_categories_view_configuration.app_bar.title','favorite_categories_view_configuration.app_bar.backgroundColor','favorite_categories_view_configuration.grid.crossAxisCount','favorite_categories_view_configuration.grid.crossAxisSpacing','favorite_categories_view_configuration.grid.mainAxisSpacing','favorite_categories_view_configuration.grid.childAspectRatio','favorite_categories_view_configuration.category_card.borderRadius','dialog_popup_configuration.dialog.backgroundColor','dialog_popup_configuration.dialog.titleColor','dialog_popup_configuration.dialog.subtitleColor','dialog_popup_configuration.dialog.borderRadius','dialog_popup_configuration.dialog.elevation'].forEach(function (p) {
            var t = p.split('.')[0];
            a.push({ tab: t, path: p, type: (p.indexOf('Count') >= 0 || p.indexOf('Spacing') >= 0 || p.indexOf('Radius') >= 0 || p.indexOf('Ratio') >= 0 || p.indexOf('elevation') >= 0) ? 'number' : 'text', label: p.replace(t + '.', '').replace(/_/g, ' ') });
        });
        return a;
    }
})();
