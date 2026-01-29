<?php
/**
 * Plugin Name: OSMEA App Config Manager
 * Plugin URI: https://github.com/masterfabric-mobile/osmea
 * Description: Manage Flutter mobile app configuration file (app_config.json) from WordPress admin panel. Mobile app can fetch configuration via REST API endpoint.
 * Version: 1.0.5
 * Author: MasterFabric Mobile
 * Author URI: https://github.com/masterfabric-mobile
 * License: GPL v2 or later
 * License URI: https://www.gnu.org/licenses/gpl-2.0.html
 * Text Domain: osmea-app-config
 * Domain Path: /languages
 */

// Exit if accessed directly
if (!defined('ABSPATH')) {
    exit;
}

// Define plugin constants
define('OSMEA_CONFIG_VERSION', '1.0.5');
define('OSMEA_CONFIG_PLUGIN_DIR', plugin_dir_path(__FILE__));
define('OSMEA_CONFIG_PLUGIN_URL', plugin_dir_url(__FILE__));
define('OSMEA_CONFIG_OPTION_NAME', 'osmea_app_config_json');

/**
 * Main plugin class
 */
class OSMEA_App_Config_Manager {
    
    private static $instance = null;
    
    public static function get_instance() {
        if (null === self::$instance) {
            self::$instance = new self();
        }
        return self::$instance;
    }
    
    private function __construct() {
        add_action('admin_menu', array($this, 'add_admin_menu'));
        add_action('admin_init', array($this, 'register_settings'));
        add_action('rest_api_init', array($this, 'register_rest_routes'));
        add_action('admin_enqueue_scripts', array($this, 'enqueue_admin_scripts'));
        add_action('init', array($this, 'load_textdomain'));
        add_action('wp_ajax_osmea_save_config', array($this, 'ajax_save_config'));
        add_action('wp_ajax_osmea_reset_config', array($this, 'ajax_reset_config'));
    }

    /**
     * Load plugin strings per WordPress locale
     */
    public function load_textdomain() {
        load_plugin_textdomain(
            'osmea-app-config',
            false,
            dirname(plugin_basename(__FILE__)) . '/languages'
        );
    }
    
    /**
     * Add admin menu page
     */
    public function add_admin_menu() {
        add_options_page(
            __('OSMEA App Config', 'osmea-app-config'),
            __('OSMEA App Config', 'osmea-app-config'),
            'manage_options',
            'osmea-app-config',
            array($this, 'render_admin_page')
        );
    }
    
    /**
     * Register plugin settings
     */
    public function register_settings() {
        register_setting(
            'osmea_app_config_group',
            OSMEA_CONFIG_OPTION_NAME,
            array(
                'type' => 'string',
                'sanitize_callback' => array($this, 'sanitize_json'),
                'default' => $this->get_default_config()
            )
        );
    }
    
    /**
     * Keys that must be string (app expects String?). Bool stored as "true"/"false".
     * Includes all color/URL keys (backgroundColor, titleColor, iconColor, imageUrl, etc.).
     */
    private static function config_key_must_be_string($key) {
        $str = array(
            'placeholder', 'variant', 'title', 'text', 'message', 'subtitle', 'description',
            'route', 'imageurl', 'amount', 'layout', 'position', 'style', 'curve', 'begin', 'end',
            'name', 'content', 'hint', 'label', 'icon', 'indicatorstyle', 'indicator_style',
            'titlewithcount', 'end_time', 'gradient_start', 'gradient_end', 'id', 'tooltip',
            'fillediconname', 'animationtype', 'animationtrigger', 'authiconname', 'guesticonname',
            'authroute', 'guestroute', 'authtext', 'guesttext', 'height',
        );
        $k = strtolower($key);
        if (in_array($k, $str, true)) {
            return true;
        }
        // *_color, *_url (snake_case) and *color*, *url* (camelCase: backgroundColor, titleColor, imageUrl)
        if (preg_match('/_(color|url)$/i', $k)) {
            return true;
        }
        if (preg_match('/(backgroundcolor|foregroundcolor|titlecolor|textcolor|iconcolor|bordercolor|accentcolor|overlaycolor|shadowcolor|startcolor|endcolor|imageurl|logo_url|splash_image)/i', $k)) {
            return true;
        }
        if (strpos($k, 'color') !== false || preg_match('/url$/i', $k)) {
            return true;
        }
        return false;
    }

    /**
     * Keys that are int or optional int (category_id, product_id, order_id, max_items, circle_size, etc.).
     * App expects int|null. Empty string / "null" → null; numeric string → int.
     */
    private static function config_key_is_optional_int($key) {
        $k = strtolower($key);
        $int_keys = array(
            'category_id', 'product_id', 'order_id', 'limit', 'min_discount_percent',
            'max_items', 'circle_size', 'image_size', 'spacing', 'size',
        );
        if (in_array($k, $int_keys, true)) {
            return true;
        }
        return preg_match('/_(id|count|index|size|spacing|items)$/i', $k) || $k === 'order_id';
    }

    /**
     * Keys that must stay bool (app expects bool). Only these may be output as JSON boolean.
     * Any other key that is bool will be converted to "true"/"false" to avoid "bool is not a subtype of String?" in the app.
     */
    private static function config_key_is_bool($key) {
        $k = strtolower($key);
        if (in_array($k, array('enabled', 'show_names', 'show_dismiss_button', 'show_close_button', 'show_see_all', 'showlabels', 'showicons', 'centeritems'), true)) {
            return true;
        }
        return preg_match('/^show_/i', $k);
    }

    /**
     * Ensure config scalar types so the app can use config directly (no per-widget helpers).
     * - String keys: bool → "true"/"false".
     * - Optional int keys: "" / "null" → null; numeric string → int.
     * - Bool keys: "true"/"1" → true, "false"/"0"/"" → false.
     * - Any remaining bool that is not in config_key_is_bool → "true"/"false" (prevents "bool is not a subtype of String?" in Flutter).
     */
    private function ensure_config_types(&$arr) {
        if (!is_array($arr)) {
            return;
        }
        foreach ($arr as $key => &$v) {
            if (is_array($v)) {
                $this->ensure_config_types($v);
                continue;
            }
            $mustString = self::config_key_must_be_string($key);
            $optionalInt = self::config_key_is_optional_int($key);
            $mustBool = self::config_key_is_bool($key);

            if ($mustString && is_bool($v)) {
                $v = $v ? 'true' : 'false';
            }
            if ($optionalInt && is_string($v)) {
                $s = trim($v);
                if ($s === '' || strtolower($s) === 'null') {
                    $v = null;
                } elseif (is_numeric($s)) {
                    $v = (int) $s;
                }
            }
            if (!$mustString && !$optionalInt && is_string($v)) {
                $s = strtolower(trim($v));
                if ($s === 'true' || $s === '1') {
                    $v = true;
                } elseif ($s === 'false' || $s === '0' || $s === '') {
                    $v = false;
                }
            }
            // Flutter expects String? for most keys; only explicit bool keys may stay bool.
            if (is_bool($v) && !$mustBool) {
                $v = $v ? 'true' : 'false';
            }
        }
        unset($v);
    }

    /**
     * Increment config version in semver style: 1.0.0 -> 1.0.1, 1.0.1 -> 1.0.2.
     * If $current is empty or not X.Y.Z, returns "1.0.0".
     */
    private static function next_config_version($current) {
        $current = is_string($current) ? trim($current) : '';
        if ($current === '' || !preg_match('/^(\d+)\.(\d+)\.(\d+)$/', $current, $m)) {
            return '1.0.0';
        }
        return $m[1] . '.' . $m[2] . '.' . ((int) $m[3] + 1);
    }

    /**
     * Sanitize JSON input
     */
    public function sanitize_json($input) {
        if (empty($input)) {
            // Ensure default config also contains meta information
            return $this->get_default_config();
        }
        
        // Decode to validate JSON
        $decoded = json_decode($input, true);
        if (json_last_error() !== JSON_ERROR_NONE) {
            add_settings_error(
                OSMEA_CONFIG_OPTION_NAME,
                'invalid_json',
                __('Invalid JSON format. Please fix it.', 'osmea-app-config'),
                'error'
            );
            return get_option(OSMEA_CONFIG_OPTION_NAME, $this->get_default_config());
        }

        if (!is_array($decoded)) {
            $decoded = array();
        }

        // Merge with default: never drop keys.
        // If client sends partial config (e.g. only Home tab), keep full structure,
        // including nested sections such as home_view.bottom_foreground_banner.imageUrl / route.
        $default_file = OSMEA_CONFIG_PLUGIN_DIR . 'default-config.json';
        if (file_exists($default_file)) {
            $default_raw = file_get_contents($default_file);
            $default_decoded = $default_raw ? json_decode($default_raw, true) : null;
            if (is_array($default_decoded)) {
                foreach (array_keys($default_decoded) as $top_key) {
                    if ($top_key === 'config_meta') {
                        continue;
                    }
                    // If whole top-level section is missing, copy it from default.
                    if (!array_key_exists($top_key, $decoded)) {
                        $decoded[ $top_key ] = $default_decoded[ $top_key ];
                        continue;
                    }
                    // For home_view, also deep-merge nested structure so missing
                    // children like bottom_foreground_banner are preserved.
                    if ($top_key === 'home_view'
                        && is_array($decoded['home_view'])
                        && is_array($default_decoded['home_view'])
                        && method_exists($this, 'deep_merge_config')
                    ) {
                        $decoded['home_view'] = $this->deep_merge_config(
                            $default_decoded['home_view'],
                            $decoded['home_view']
                        );
                    }
                }
            }
        }

        // Enforce types so app receives string/bool as expected (no "as String?" cast errors)
        $this->ensure_config_types($decoded);

        // On every save: set config_meta and bump configVersion from stored (1.0.0 -> 1.0.1 -> 1.0.2 …)
        if (!isset($decoded['config_meta']) || !is_array($decoded['config_meta'])) {
            $decoded['config_meta'] = array();
        }
        $stored = get_option(OSMEA_CONFIG_OPTION_NAME, '');
        $stored_decoded = $stored ? json_decode($stored, true) : null;
        $prev_version = (is_array($stored_decoded) && isset($stored_decoded['config_meta']['configVersion']))
            ? $stored_decoded['config_meta']['configVersion']
            : '';
        // Server-side, authoritative meta:
        // - last_updated: human‑readable timestamp
        // - configVersion: semantic version (1.0.0 → 1.0.1 → …) that changes on every save
        // - config_revision: unix timestamp (string) – unique per save
        // - plugin_version: mirrors configVersion for the mobile app (Storefront) – used to detect config changes
        $decoded['config_meta']['last_updated']    = current_time('mysql');
        $decoded['config_meta']['config_revision'] = (string) time();
        $decoded['config_meta']['configVersion']   = self::next_config_version($prev_version);
        $decoded['config_meta']['plugin_version']  = $decoded['config_meta']['configVersion'];

        // Re-encode with pretty print
        return wp_json_encode($decoded, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
    }
    
    /**
     * Get default configuration from file or return empty structure
     */
    private function get_default_config() {
        $default_file = OSMEA_CONFIG_PLUGIN_DIR . 'default-config.json';
        if (file_exists($default_file)) {
            $content = file_get_contents($default_file);
            $decoded = json_decode($content, true);
            if ($decoded) {
                $this->ensure_config_types($decoded);
                // Ensure meta information is present on defaults as well
                if (!isset($decoded['config_meta']) || !is_array($decoded['config_meta'])) {
                    $decoded['config_meta'] = array();
                }
                // Default config meta: first version of config (1.0.0)
                $decoded['config_meta']['last_updated']    = current_time('mysql');
                $decoded['config_meta']['config_revision'] = (string) time();
                $decoded['config_meta']['configVersion']   = '1.0.0';
                $decoded['config_meta']['plugin_version']  = $decoded['config_meta']['configVersion'];

                return wp_json_encode($decoded, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
            }
        }
        
        // Return minimal structure if file doesn't exist
        return wp_json_encode(array(
            'app_settings' => array(),
            'api_configuration' => array(),
            'woocommerce_configuration' => array()
        ), JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
    }
    
    /**
     * Get stored config for admin (used by JS form). Admin never sees raw JSON.
     */
    public function get_stored_config() {
        return get_option(OSMEA_CONFIG_OPTION_NAME, $this->get_default_config());
    }
    
    /**
     * Register REST API routes
     */
    public function register_rest_routes() {
        register_rest_route('osmea/v1', '/app-config', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_app_config_api'),
            'permission_callback' => array($this, 'api_permission_check'),
        ));
        
        register_rest_route('osmea/v1', '/app-config', array(
            'methods' => 'POST',
            'callback' => array($this, 'update_app_config_api'),
            'permission_callback' => array($this, 'api_permission_check'),
        ));
        
        register_rest_route('osmea/v1', '/app-config/reset', array(
            'methods' => 'POST',
            'callback' => array($this, 'reset_app_config_api'),
            'permission_callback' => function() {
                return current_user_can('manage_options');
            },
        ));
        
        register_rest_route('osmea/v1', '/app-config/debug', array(
            'methods' => 'GET',
            'callback' => array($this, 'debug_config_api'),
            'permission_callback' => function() {
                return current_user_can('manage_options');
            },
        ));
    }
    
    /**
     * Check API permissions
     */
    public function api_permission_check() {
        // Allow public access for GET requests (for mobile app)
        // POST requires admin permissions
        if ($_SERVER['REQUEST_METHOD'] === 'GET') {
            return true;
        }
        
        // POST requires admin permissions
        return current_user_can('manage_options');
    }
    
    /**
     * GET endpoint for app config
     */
    public function get_app_config_api($request) {
        $config = get_option(OSMEA_CONFIG_OPTION_NAME, $this->get_default_config());
        $decoded = json_decode($config, true);
        
        if (!$decoded) {
            return new WP_Error(
                'invalid_config',
                __('Configuration file is invalid.', 'osmea-app-config'),
                array('status' => 500)
            );
        }

        // Expose config_meta.plugin_version (config revision) — do not overwrite with constant
        // so the app receives the last-save timestamp and can detect config changes.
        if (!isset($decoded['config_meta']) || !is_array($decoded['config_meta'])) {
            $decoded['config_meta'] = array();
        }
        if (!isset($decoded['config_meta']['last_updated']) || $decoded['config_meta']['last_updated'] === '') {
            $decoded['config_meta']['last_updated'] = current_time('mysql');
        }
        if (!isset($decoded['config_meta']['config_revision']) || $decoded['config_meta']['config_revision'] === '') {
            $decoded['config_meta']['config_revision'] = (string) time();
        }
        if (!isset($decoded['config_meta']['configVersion']) || $decoded['config_meta']['configVersion'] === '') {
            $decoded['config_meta']['configVersion'] = '1.0.0';
        }
        if (!isset($decoded['config_meta']['plugin_version']) || $decoded['config_meta']['plugin_version'] === '') {
            // Mobile app tracks this field for "config changed" behaviour, so keep it in sync with configVersion.
            $decoded['config_meta']['plugin_version'] = $decoded['config_meta']['configVersion'];
        }

        $this->ensure_config_types($decoded);
        return rest_ensure_response($decoded);
    }

    /**
     * Deep-merge override into base (override wins). Preserves keys in base that are missing in override.
     * Used so partial saves (e.g. only Home tab) do not wipe other sections (e.g. bottom_foreground_banner URL).
     */
    private function deep_merge_config( $base, $override ) {
        if ( ! is_array( $base ) ) {
            return is_array( $override ) ? $override : $base;
        }
        if ( ! is_array( $override ) ) {
            return $base;
        }
        $merged = $base;
        foreach ( $override as $key => $value ) {
            if ( is_array( $value ) && isset( $merged[ $key ] ) && is_array( $merged[ $key ] ) ) {
                $merged[ $key ] = $this->deep_merge_config( $merged[ $key ], $value );
            } else {
                $merged[ $key ] = $value;
            }
        }
        return $merged;
    }

    /**
     * POST endpoint for app config
     */
    public function update_app_config_api($request) {
        $json_body = $request->get_json_params();
        
        if (empty($json_body)) {
            return new WP_Error(
                'empty_body',
                __('Submitted data is empty.', 'osmea-app-config'),
                array('status' => 400)
            );
        }

        // Merge with existing stored config so partial payloads do not wipe keys (e.g. bottom_foreground_banner.imageUrl, route)
        $existing_raw = get_option(OSMEA_CONFIG_OPTION_NAME, '');
        $existing = ( $existing_raw && is_string( $existing_raw ) ) ? json_decode( $existing_raw, true ) : null;
        if ( is_array( $existing ) ) {
            $json_body = $this->deep_merge_config( $existing, $json_body );
        }
        
        $json_string = wp_json_encode($json_body, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
        $sanitized = $this->sanitize_json($json_string);
        update_option(OSMEA_CONFIG_OPTION_NAME, $sanitized);

        $saved = json_decode($sanitized, true);
        return rest_ensure_response(array(
            'success' => true,
            'message' => __('Configuration saved successfully.', 'osmea-app-config'),
            'config'  => is_array($saved) ? $saved : $json_body
        ));
    }
    
    /**
     * Reset config to default (from file)
     */
    public function reset_app_config_api($request) {
        $default_file = OSMEA_CONFIG_PLUGIN_DIR . 'default-config.json';
        
        if (!file_exists($default_file)) {
            return new WP_Error(
                'file_not_found',
                __('Default configuration file not found.', 'osmea-app-config'),
                array('status' => 404)
            );
        }
        
        $content = file_get_contents($default_file);
        $decoded = json_decode($content, true);
        
        if (!$decoded) {
            return new WP_Error(
                'invalid_default',
                __('Default configuration file is invalid.', 'osmea-app-config'),
                array('status' => 500)
            );
        }

        $this->ensure_config_types($decoded);

        // Ensure meta so app can detect change after reset
        if (!isset($decoded['config_meta']) || !is_array($decoded['config_meta'])) {
            $decoded['config_meta'] = array();
        }
        $decoded['config_meta']['last_updated']    = current_time('mysql');
        $decoded['config_meta']['config_revision'] = (string) time();
        $decoded['config_meta']['configVersion']   = '1.0.0';
        $decoded['config_meta']['plugin_version']  = $decoded['config_meta']['configVersion'];

        $formatted = wp_json_encode($decoded, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
        update_option(OSMEA_CONFIG_OPTION_NAME, $formatted);
        
        return rest_ensure_response(array(
            'success' => true,
            'message' => __('Configuration reset to default successfully.', 'osmea-app-config'),
            'config' => $decoded
        ));
    }
    
    /**
     * Admin-ajax: save config (JSON body). Same logic as update_app_config_api.
     */
    public function ajax_save_config() {
        if (!current_user_can('manage_options')) {
            wp_send_json(array('success' => false, 'message' => __('Permission denied.', 'osmea-app-config')));
        }
        $raw = file_get_contents('php://input');
        $payload = $raw ? json_decode($raw, true) : null;
        $body = null;
        $nonce_ok = false;
        if (is_array($payload)) {
            if (!empty($payload['nonce']) && wp_verify_nonce($payload['nonce'], 'osmea_save_config')) {
                $nonce_ok = true;
            }
            if (!empty($payload['config']) && is_array($payload['config'])) {
                $body = $payload['config'];
            }
        }
        if (!$nonce_ok) {
            wp_send_json(array('success' => false, 'message' => __('Security check failed. Refresh the page and try again.', 'osmea-app-config')));
        }
        if (empty($body) || !is_array($body)) {
            if (!empty($_POST['config']) && is_string($_POST['config'])) {
                $body = json_decode(wp_unslash($_POST['config']), true);
            }
        }
        if (empty($body) || !is_array($body)) {
            wp_send_json(array('success' => false, 'message' => __('Submitted data is empty or invalid.', 'osmea-app-config')));
        }
        // Merge with existing stored config so partial payloads do not wipe keys (e.g. bottom_foreground_banner.imageUrl, route)
        $existing_raw = get_option(OSMEA_CONFIG_OPTION_NAME, '');
        $existing = ( $existing_raw && is_string( $existing_raw ) ) ? json_decode( $existing_raw, true ) : null;
        if ( is_array( $existing ) ) {
            $body = $this->deep_merge_config( $existing, $body );
        }
        $json_string = wp_json_encode($body, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
        $sanitized = $this->sanitize_json($json_string);
        update_option(OSMEA_CONFIG_OPTION_NAME, $sanitized);
        $saved = json_decode($sanitized, true);
        wp_send_json(array(
            'success' => true,
            'message' => __('Configuration saved successfully.', 'osmea-app-config'),
            'config'  => is_array($saved) ? $saved : $body
        ));
    }

    /**
     * Admin-ajax: reset config to default file. Same logic as reset_app_config_api.
     */
    public function ajax_reset_config() {
        if (!current_user_can('manage_options')) {
            wp_send_json(array('success' => false, 'message' => __('Permission denied.', 'osmea-app-config')));
        }
        $nonce_ok = false;
        if (!empty($_REQUEST['nonce']) && wp_verify_nonce(sanitize_text_field(wp_unslash($_REQUEST['nonce'])), 'osmea_reset_config')) {
            $nonce_ok = true;
        }
        $raw = file_get_contents('php://input');
        if (!$nonce_ok && $raw) {
            $payload = json_decode($raw, true);
            if (is_array($payload) && !empty($payload['nonce']) && wp_verify_nonce($payload['nonce'], 'osmea_reset_config')) {
                $nonce_ok = true;
            }
        }
        if (!$nonce_ok) {
            wp_send_json(array('success' => false, 'message' => __('Security check failed. Refresh the page and try again.', 'osmea-app-config')));
        }
        $default_file = OSMEA_CONFIG_PLUGIN_DIR . 'default-config.json';
        if (!file_exists($default_file)) {
            wp_send_json(array('success' => false, 'message' => __('Default configuration file not found.', 'osmea-app-config')));
        }
        $content = file_get_contents($default_file);
        $decoded = json_decode($content, true);
        if (!$decoded) {
            wp_send_json(array('success' => false, 'message' => __('Default configuration file is invalid.', 'osmea-app-config')));
        }

        $this->ensure_config_types($decoded);

        if (!isset($decoded['config_meta']) || !is_array($decoded['config_meta'])) {
            $decoded['config_meta'] = array();
        }
        $decoded['config_meta']['last_updated']    = current_time('mysql');
        $decoded['config_meta']['plugin_version']  = $decoded['config_meta']['last_updated'];
        $decoded['config_meta']['config_revision'] = (string) time();
        $decoded['config_meta']['configVersion']   = '1.0.0';
        $formatted = wp_json_encode($decoded, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
        update_option(OSMEA_CONFIG_OPTION_NAME, $formatted);
        wp_send_json(array(
            'success' => true,
            'message' => __('Configuration reset to default successfully.', 'osmea-app-config'),
            'config'  => $decoded
        ));
    }

    /**
     * Debug endpoint to check config state
     */
    public function debug_config_api($request) {
        $db_config = get_option(OSMEA_CONFIG_OPTION_NAME, '');
        $db_decoded = json_decode($db_config, true);
        
        $default_file = OSMEA_CONFIG_PLUGIN_DIR . 'default-config.json';
        $default_exists = file_exists($default_file);
        $default_decoded = null;
        
        if ($default_exists) {
            $default_content = file_get_contents($default_file);
            $default_decoded = json_decode($default_content, true);
        }
        
        return rest_ensure_response(array(
            'database' => array(
                'raw_length' => strlen($db_config),
                'keys_count' => $db_decoded ? count($db_decoded) : 0,
                'keys' => $db_decoded ? array_keys($db_decoded) : [],
            ),
            'default_file' => array(
                'exists' => $default_exists,
                'path' => $default_file,
                'keys_count' => $default_decoded ? count($default_decoded) : 0,
                'keys' => $default_decoded ? array_keys($default_decoded) : [],
            ),
            'version' => OSMEA_CONFIG_VERSION,
        ));
    }
    
    /**
     * Enqueue admin scripts and styles
     */
    public function enqueue_admin_scripts($hook) {
        if ($hook !== 'settings_page_osmea-app-config') {
            return;
        }
        
        // Use filemtime to bust cache
        $css_version = file_exists(OSMEA_CONFIG_PLUGIN_DIR . 'assets/admin.css') 
            ? filemtime(OSMEA_CONFIG_PLUGIN_DIR . 'assets/admin.css') 
            : OSMEA_CONFIG_VERSION;
        
        wp_enqueue_style(
            'osmea-config-admin',
            OSMEA_CONFIG_PLUGIN_URL . 'assets/admin.css',
            array(),
            $css_version
        );
        
        $js_base = OSMEA_CONFIG_PLUGIN_DIR . 'assets/js/';
        $js_version = OSMEA_CONFIG_VERSION;
        if (file_exists($js_base . 'osmea-admin.js')) {
            $js_version = (string) filemtime($js_base . 'osmea-admin.js');
        }
        wp_enqueue_script(
            'osmea-config-data',
            OSMEA_CONFIG_PLUGIN_URL . 'assets/js/osmea-data.js',
            array(),
            $js_version,
            true
        );
        wp_enqueue_script(
            'osmea-config-form',
            OSMEA_CONFIG_PLUGIN_URL . 'assets/js/osmea-form.js',
            array('jquery', 'osmea-config-data'),
            $js_version,
            true
        );
        wp_enqueue_script(
            'osmea-config-admin',
            OSMEA_CONFIG_PLUGIN_URL . 'assets/js/osmea-admin.js',
            array('jquery', 'osmea-config-form'),
            $js_version,
            true
        );

        $config = $this->get_stored_config();
        $config_decoded = json_decode($config, true);
        // Merge with default so admin always has all top-level keys and nested keys from default-config (tabbar/headings and nested blocks like home_view.bottom_foreground_banner never disappear)
        $default_file = OSMEA_CONFIG_PLUGIN_DIR . 'default-config.json';
        if (is_array($config_decoded) && file_exists($default_file)) {
            $default_decoded = json_decode(file_get_contents($default_file), true);
            if (is_array($default_decoded)) {
                foreach (array_keys($default_decoded) as $top_key) {
                    if ($top_key === 'config_meta') {
                        continue;
                    }
                    if (!isset($config_decoded[$top_key])) {
                        $config_decoded[$top_key] = $default_decoded[$top_key];
                    } elseif (is_array($default_decoded[$top_key]) && is_array($config_decoded[$top_key]) && method_exists($this, 'deep_merge_config')) {
                        // Faz 1: Nested default merge – fill missing nested keys from default (e.g. home_view.bottom_foreground_banner, onboarding pages, etc.)
                        $config_decoded[$top_key] = $this->deep_merge_config($default_decoded[$top_key], $config_decoded[$top_key]);
                    }
                }
                $config = wp_json_encode($config_decoded, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
            }
        }
        $meta = isset($config_decoded['config_meta']) && is_array($config_decoded['config_meta']) ? $config_decoded['config_meta'] : array();
        $last_updated = isset($meta['last_updated']) ? $meta['last_updated'] : '';
        $plugin_version = isset($meta['plugin_version']) ? $meta['plugin_version'] : OSMEA_CONFIG_VERSION;
        $config_version = isset($meta['configVersion']) && $meta['configVersion'] !== '' ? $meta['configVersion'] : '1.0.0';

        $tab_labels = array(
            'app_settings' => __('App Settings', 'osmea-app-config'),
            'api_configuration' => __('API', 'osmea-app-config'),
            'woocommerce_configuration' => __('WooCommerce', 'osmea-app-config'),
            'account_configuration' => __('Account', 'osmea-app-config'),
            'firebase_configuration' => __('Firebase', 'osmea-app-config'),
            'ui_configuration' => __('UI', 'osmea-app-config'),
            'search_view_configuration' => __('Search View', 'osmea-app-config'),
            'security_configuration' => __('Security', 'osmea-app-config'),
            'storage_configuration' => __('Storage', 'osmea-app-config'),
            'notification_configuration' => __('Notifications', 'osmea-app-config'),
            'feature_flags' => __('Feature Flags', 'osmea-app-config'),
            'splash_configuration' => __('Splash', 'osmea-app-config'),
            'localization_configuration' => __('Localization', 'osmea-app-config'),
            'performance_configuration' => __('Performance', 'osmea-app-config'),
            'onboarding_configuration' => __('Onboarding', 'osmea-app-config'),
            'about_configuration' => __('About', 'osmea-app-config'),
            'contact_us_configuration' => __('Contact Us', 'osmea-app-config'),
            'faq_configuration' => __('FAQ', 'osmea-app-config'),
            'loading_configuration' => __('Loading', 'osmea-app-config'),
            'error_handling_configuration' => __('Error Handling', 'osmea-app-config'),
            'auth_configuration' => __('Auth', 'osmea-app-config'),
            'empty_view_configuration' => __('Empty View', 'osmea-app-config'),
            'home_view' => __('Home View', 'osmea-app-config'),
            'product_detail_view' => __('Product Detail', 'osmea-app-config'),
            'product_list_view' => __('Product List', 'osmea-app-config'),
            'product_card' => __('Product Card', 'osmea-app-config'),
            'navbar_configuration' => __('Navbar', 'osmea-app-config'),
            'campaign_view' => __('Campaign View', 'osmea-app-config'),
            'cart_view_configuration' => __('Cart View', 'osmea-app-config'),
            'checkout_view_configuration' => __('Checkout', 'osmea-app-config'),
            'wishlist_view' => __('Wishlist', 'osmea-app-config'),
            'favorite_categories_view_configuration' => __('Favorite Categories', 'osmea-app-config'),
            'dialog_popup_configuration' => __('Dialog & Popup', 'osmea-app-config'),
            'orders_history_view' => __('Orders History', 'osmea-app-config'),
            'user_profile_view' => __('User Profile', 'osmea-app-config'),
            'order_detail_view' => __('Order Detail', 'osmea-app-config'),
        );
        wp_localize_script('osmea-config-data', 'osmeaConfig', array(
            'ajaxUrl' => admin_url('admin-ajax.php'),
            'restUrl' => rest_url('osmea/v1/app-config'),
            'resetUrl' => rest_url('osmea/v1/app-config/reset'),
            'nonce' => wp_create_nonce('wp_rest'),
            'saveNonce' => wp_create_nonce('osmea_save_config'),
            'resetNonce' => wp_create_nonce('osmea_reset_config'),
            'locale' => get_locale(),
            'currentConfig' => $config,
            'configMeta' => array(
                'last_updated' => $last_updated,
                'plugin_version' => $plugin_version,
                'configVersion' => $config_version,
            ),
            'tabLabels' => $tab_labels,
            'categories' => array(
                array('id' => 'general', 'label' => __('General', 'osmea-app-config'), 'tabIds' => array('app_settings', 'api_configuration', 'woocommerce_configuration')),
                array('id' => 'launch', 'label' => __('Launch & Auth', 'osmea-app-config'), 'tabIds' => array('splash_configuration', 'onboarding_configuration', 'auth_configuration')),
                array('id' => 'home', 'label' => __('Home View', 'osmea-app-config'), 'tabIds' => array('home_view')),
                array('id' => 'search', 'label' => __('Search View', 'osmea-app-config'), 'tabIds' => array('search_view_configuration')),
                array('id' => 'product', 'label' => __('Product (List / Detail / Card)', 'osmea-app-config'), 'tabIds' => array('product_list_view', 'product_detail_view', 'product_card')),
                array('id' => 'cart_checkout', 'label' => __('Cart & Checkout', 'osmea-app-config'), 'tabIds' => array('cart_view_configuration', 'checkout_view_configuration')),
                array('id' => 'wishlist_favorites', 'label' => __('Wishlist & Favorites', 'osmea-app-config'), 'tabIds' => array('wishlist_view', 'favorite_categories_view_configuration')),
                array('id' => 'campaign', 'label' => __('Campaign View', 'osmea-app-config'), 'tabIds' => array('campaign_view')),
                array('id' => 'orders', 'label' => __('Orders', 'osmea-app-config'), 'tabIds' => array('orders_history_view', 'order_detail_view')),
                array('id' => 'profile_account', 'label' => __('Profile & Account', 'osmea-app-config'), 'tabIds' => array('user_profile_view', 'account_configuration')),
                array('id' => 'content', 'label' => __('Content (About / FAQ / Empty / Loading)', 'osmea-app-config'), 'tabIds' => array('about_configuration', 'contact_us_configuration', 'faq_configuration', 'empty_view_configuration', 'loading_configuration', 'error_handling_configuration')),
                array('id' => 'nav_ui', 'label' => __('Nav & UI', 'osmea-app-config'), 'tabIds' => array('navbar_configuration', 'ui_configuration', 'dialog_popup_configuration')),
                array('id' => 'infrastructure', 'label' => __('Infrastructure', 'osmea-app-config'), 'tabIds' => array('firebase_configuration', 'security_configuration', 'storage_configuration', 'notification_configuration', 'performance_configuration', 'feature_flags', 'localization_configuration')),
            ),
            'strings' => array(
                'saving' => __('Saving...', 'osmea-app-config'),
                'saved' => __('Settings saved.', 'osmea-app-config'),
                'error' => __('Error while saving.', 'osmea-app-config'),
                'invalidJson' => __('Invalid JSON. Please check.', 'osmea-app-config'),
                'confirmReset' => __('Are you sure you want to reset to default configuration?', 'osmea-app-config'),
                'resetting' => __('Resetting...', 'osmea-app-config'),
                'resetSuccess' => __('Reset to default.', 'osmea-app-config'),
                'unsavedChanges' => __('You have unsaved changes. Do you want to leave anyway?', 'osmea-app-config'),
                'lastUpdated' => __('Last updated:', 'osmea-app-config'),
                'pluginVersion' => __('Plugin version:', 'osmea-app-config'),
                'configVersion' => __('Config version:', 'osmea-app-config'),
                'imagePreviewAlt' => __('Preview', 'osmea-app-config'),
            )
        ));
    }
    
    /**
     * Render admin page
     */
    public function render_admin_page() {
        if (!current_user_can('manage_options')) {
            wp_die(__('You do not have permission to access this page.', 'osmea-app-config'));
        }
        
        $config = get_option(OSMEA_CONFIG_OPTION_NAME, $this->get_default_config());
        ?>
        <div class="wrap osmea-config-wrap">
            <h1><?php echo esc_html(get_admin_page_title()); ?></h1>
            <?php settings_errors(); ?>

            <form id="osmea-config-form" class="osmea-config-form" method="post" action="#" autocomplete="off" novalidate>
                <?php settings_fields('osmea_app_config_group'); ?>
                <?php do_settings_sections('osmea_app_config_group'); ?>
                <textarea id="osmea-config-json-store" name="<?php echo esc_attr(OSMEA_CONFIG_OPTION_NAME); ?>" class="osmea-config-json-hidden" rows="1" aria-hidden="true"><?php echo esc_textarea($config); ?></textarea>

                <div class="osmea-config-layout">
                    <div class="osmea-config-main">
                        <div id="osmea-config-ui" class="osmea-config-ui osmea-config-ui-inner">
                            <div class="osmea-config-search-wrap">
                                <label for="osmea-config-search" class="osmea-config-search-label">
                                    <?php esc_html_e('Search settings', 'osmea-app-config'); ?>
                                </label>
                                <input
                                    type="search"
                                    id="osmea-config-search"
                                    class="osmea-config-search-input"
                                    placeholder="<?php echo esc_attr__('Search by label or path (e.g. bottom_foreground_banner, imageUrl)...', 'osmea-app-config'); ?>"
                                    autocomplete="off"
                                />
                            </div>
                            <div class="osmea-config-tabbar-wrap">
                                <div id="osmea-config-tabbar" class="osmea-config-tabbar" role="tablist"></div>
                            </div>
                            <div id="osmea-config-ui-sections" class="osmea-config-ui-sections"></div>
                        </div>
                        <div class="osmea-json-status" id="osmea-json-status" aria-live="polite" role="status"></div>
                    </div>
                    <div class="osmea-config-footer">
                        <h2 class="osmea-config-title"><?php _e('Configuration', 'osmea-app-config'); ?></h2>
                        <p class="osmea-config-meta" id="osmea-config-meta" aria-live="polite"></p>
                        <div class="osmea-config-actions">
                            <?php submit_button(__('Save Configuration', 'osmea-app-config'), 'primary', 'osmea-save-config', false); ?>
                            <button type="button" id="osmea-reset-config" class="button"><?php _e('Reset to Default', 'osmea-app-config'); ?></button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
        <?php
    }
}

// Initialize plugin
function osmea_app_config_manager_init() {
    return OSMEA_App_Config_Manager::get_instance();
}

// Start the plugin
add_action('plugins_loaded', 'osmea_app_config_manager_init');

// Activation hook
register_activation_hook(__FILE__, function() {
    // ALWAYS load default config on activation (even if exists)
    // This ensures the latest default-config.json is loaded
    $default_file = OSMEA_CONFIG_PLUGIN_DIR . 'default-config.json';
    if (file_exists($default_file)) {
        $content = file_get_contents($default_file);
        // Validate and format JSON
        $decoded = json_decode($content, true);
        if ($decoded) {
            // Ensure default config also includes meta with current plugin version
            if (!isset($decoded['config_meta']) || !is_array($decoded['config_meta'])) {
                $decoded['config_meta'] = array();
            }
            $decoded['config_meta']['last_updated']    = current_time('mysql');
            $decoded['config_meta']['config_revision'] = (string) time();
            $decoded['config_meta']['configVersion']   = '1.0.0';
            $decoded['config_meta']['plugin_version']  = $decoded['config_meta']['configVersion'];

            $formatted = wp_json_encode($decoded, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
            update_option(OSMEA_CONFIG_OPTION_NAME, $formatted);
        }
    }
});

