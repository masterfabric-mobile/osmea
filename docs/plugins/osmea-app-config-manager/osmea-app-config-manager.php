<?php
/**
 * Plugin Name: OSMEA App Config Manager
 * Plugin URI: https://github.com/masterfabric-mobile/osmea
 * Description: Manage Flutter mobile app configuration file (app_config.json) from WordPress admin panel. Mobile app can fetch configuration via REST API endpoint.
 * Version: 1.0.3
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
define('OSMEA_CONFIG_VERSION', '1.0.3');
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
     * Sanitize JSON input
     */
    public function sanitize_json($input) {
        if (empty($input)) {
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
        
        return rest_ensure_response($decoded);
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
        
        $json_string = wp_json_encode($json_body, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
        $sanitized = $this->sanitize_json($json_string);
        
        $updated = update_option(OSMEA_CONFIG_OPTION_NAME, $sanitized);
        
        if ($updated) {
            return rest_ensure_response(array(
                'success' => true,
                'message' => __('Configuration updated successfully.', 'osmea-app-config')
            ));
        } else {
            return new WP_Error(
                'update_failed',
                __('Configuration could not be updated.', 'osmea-app-config'),
                array('status' => 500)
            );
        }
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
        
        $formatted = wp_json_encode($decoded, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
        $updated = update_option(OSMEA_CONFIG_OPTION_NAME, $formatted);
        
        return rest_ensure_response(array(
            'success' => true,
            'message' => __('Configuration reset to default successfully.', 'osmea-app-config'),
            'config' => $decoded
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
        
        wp_enqueue_script(
            'osmea-config-admin',
            OSMEA_CONFIG_PLUGIN_URL . 'assets/admin.js',
            array('jquery'),
            OSMEA_CONFIG_VERSION,
            true
        );
        
        wp_localize_script('osmea-config-admin', 'osmeaConfig', array(
            'ajaxUrl' => admin_url('admin-ajax.php'),
            'restUrl' => rest_url('osmea/v1/app-config'),
            'resetUrl' => rest_url('osmea/v1/app-config/reset'),
            'nonce' => wp_create_nonce('wp_rest'),
            'strings' => array(
                'saving' => __('Saving...', 'osmea-app-config'),
                'saved' => __('Saved!', 'osmea-app-config'),
                'error' => __('An error occurred.', 'osmea-app-config'),
                'invalidJson' => __('Invalid JSON format.', 'osmea-app-config'),
                'confirmReset' => __('Are you sure you want to reset to default configuration?', 'osmea-app-config'),
                'resetting' => __('Resetting...', 'osmea-app-config'),
                'resetSuccess' => __('Configuration reset to default successfully!', 'osmea-app-config')
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
            
            <div class="osmea-config-header">
                <p class="description">
                    <?php _e('Manage your Flutter mobile app configuration file from here. Changes are provided to the mobile app via REST API.', 'osmea-app-config'); ?>
                </p>
                <div class="osmea-config-actions">
                    <button type="button" id="osmea-format-json" class="button">
                        <?php _e('Format JSON', 'osmea-app-config'); ?>
                    </button>
                    <button type="button" id="osmea-reset-config" class="button">
                        <?php _e('Reset to Default', 'osmea-app-config'); ?>
                    </button>
                    <button type="button" id="osmea-export-config" class="button">
                        <?php _e('Export', 'osmea-app-config'); ?>
                    </button>
                    <button type="button" id="osmea-import-config" class="button">
                        <?php _e('Import', 'osmea-app-config'); ?>
                    </button>
                    <input type="file" id="osmea-import-file" accept=".json" style="display: none;">
                </div>
            </div>
            
            <form method="post" action="options.php" id="osmea-config-form">
                <?php
                settings_fields('osmea_app_config_group');
                do_settings_sections('osmea_app_config_group');
                ?>
                
                <table class="form-table" role="presentation">
                    <tbody>
                        <tr>
                            <th scope="row">
                                <label for="<?php echo esc_attr(OSMEA_CONFIG_OPTION_NAME); ?>">
                                    <?php _e('App Config JSON', 'osmea-app-config'); ?>
                                </label>
                            </th>
                            <td>
                                <textarea 
                                    id="<?php echo esc_attr(OSMEA_CONFIG_OPTION_NAME); ?>"
                                    name="<?php echo esc_attr(OSMEA_CONFIG_OPTION_NAME); ?>"
                                    rows="30"
                                    class="large-text code osmea-json-editor"
                                    spellcheck="false"
                                ><?php echo esc_textarea($config); ?></textarea>
                                <p class="description">
                                    <?php _e('Configuration file in JSON format. Changes are accessible via REST API after saving.', 'osmea-app-config'); ?>
                                </p>
                                <div class="osmea-json-status" id="osmea-json-status"></div>
                            </td>
                        </tr>
                    </tbody>
                </table>
                
                <div class="osmea-config-info">
                    <h3><?php _e('REST API Endpoint', 'osmea-app-config'); ?></h3>
                    <p>
                        <code><?php echo esc_url(rest_url('osmea/v1/app-config')); ?></code>
                    </p>
                    <p class="description">
                        <?php _e('Your mobile app can fetch the configuration using this endpoint.', 'osmea-app-config'); ?>
                    </p>
                </div>
                
                <?php submit_button(__('Save Configuration', 'osmea-app-config')); ?>
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
            $formatted = wp_json_encode($decoded, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
            update_option(OSMEA_CONFIG_OPTION_NAME, $formatted);
        }
    }
});

