<?php
/**
 * Plugin Name: OSMEA Users Manager
 * Plugin URI: https://github.com/masterfabric-mobile/osmea
 * Description: Comprehensive user management plugin for storing user metadata, orders, and contract signatures. Compatible with MasterFabric theme. WooCommerce integration available (WooCommerce 5.0+ recommended).
 * Version: 1.0.0
 * Author: MasterFabric Mobile
 * Author URI: https://github.com/masterfabric-mobile
 * License: GPL v2 or later
 * License URI: https://www.gnu.org/licenses/gpl-2.0.html
 * Text Domain: osmea-users-manager
 * Domain Path: /languages
 * Requires at least: 5.8
 * Requires PHP: 7.4
 */

// Exit if accessed directly
if (!defined('ABSPATH')) {
    exit;
}

// Define plugin constants
define('OSMEA_USERS_MANAGER_VERSION', '1.0.0');
define('OSMEA_USERS_MANAGER_PLUGIN_DIR', plugin_dir_path(__FILE__));
define('OSMEA_USERS_MANAGER_PLUGIN_URL', plugin_dir_url(__FILE__));
define('OSMEA_USERS_MANAGER_DB_VERSION', '1.0');

/**
 * Main plugin class
 */
class OSMEA_Users_Manager {
    
    private static $instance = null;
    
    public static function get_instance() {
        if (null === self::$instance) {
            self::$instance = new self();
        }
        return self::$instance;
    }
    
    private function __construct() {
        // Activation/Deactivation hooks
        register_activation_hook(__FILE__, array($this, 'activate'));
        register_deactivation_hook(__FILE__, array($this, 'deactivate'));
        
        // Add admin menu - must be registered early
        add_action('admin_menu', array($this, 'add_admin_menu'));
        
        // Enqueue admin assets
        add_action('admin_enqueue_scripts', array($this, 'enqueue_admin_assets'));
        
        // Register REST API routes - register early to ensure routes are available
        add_action('rest_api_init', array($this, 'register_rest_routes'), 10);
        
        // Initialize plugin
        add_action('plugins_loaded', array($this, 'init'));
    }
    
    /**
     * Initialize plugin
     */
    public function init() {
        // Check database version and update if needed
        $this->check_database_version();
        
        // WooCommerce integration hooks
        if (class_exists('WooCommerce')) {
            add_action('woocommerce_order_status_changed', array($this, 'sync_order_to_user'), 10, 3);
        }
    }
    
    /**
     * Plugin activation - create database tables
     */
    public function activate() {
        $this->create_database_tables();
        add_option('osmea_users_manager_db_version', OSMEA_USERS_MANAGER_DB_VERSION);
    }
    
    /**
     * Plugin deactivation
     */
    public function deactivate() {
        // Cleanup if needed
    }
    
    /**
     * Check and update database version
     */
    private function check_database_version() {
        $installed_version = get_option('osmea_users_manager_db_version');
        if ($installed_version !== OSMEA_USERS_MANAGER_DB_VERSION) {
            $this->create_database_tables();
            update_option('osmea_users_manager_db_version', OSMEA_USERS_MANAGER_DB_VERSION);
        }
    }
    
    /**
     * Create database tables
     */
    private function create_database_tables() {
        global $wpdb;
        $charset_collate = $wpdb->get_charset_collate();
        
        require_once(ABSPATH . 'wp-admin/includes/upgrade.php');
        
        // User metadata table
        $metadata_table = $wpdb->prefix . 'osmea_user_metadata';
        $sql_metadata = "CREATE TABLE $metadata_table (
            id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
            user_id BIGINT UNSIGNED NOT NULL,
            meta_key VARCHAR(255) NOT NULL,
            meta_value LONGTEXT,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY user_id (user_id),
            KEY meta_key (meta_key),
            UNIQUE KEY user_meta_key (user_id, meta_key)
        ) $charset_collate;";
        dbDelta($sql_metadata);
        
        // Contract signatures table
        $contracts_table = $wpdb->prefix . 'osmea_contract_signatures';
        $sql_contracts = "CREATE TABLE $contracts_table (
            id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
            user_id BIGINT UNSIGNED NOT NULL,
            contract_type VARCHAR(100) NOT NULL,
            contract_title VARCHAR(255) NOT NULL,
            contract_content LONGTEXT,
            signature_data LONGTEXT,
            ip_address VARCHAR(45),
            user_agent TEXT,
            signed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY user_id (user_id),
            KEY contract_type (contract_type),
            KEY signed_at (signed_at)
        ) $charset_collate;";
        dbDelta($sql_contracts);
        
        // User addresses table
        $addresses_table = $wpdb->prefix . 'osmea_user_addresses';
        $sql_addresses = "CREATE TABLE $addresses_table (
            id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
            user_id BIGINT UNSIGNED NOT NULL,
            address_type VARCHAR(20) NOT NULL DEFAULT 'billing',
            label VARCHAR(100),
            first_name VARCHAR(100),
            last_name VARCHAR(100),
            company VARCHAR(100),
            address_1 VARCHAR(255),
            address_2 VARCHAR(255),
            city VARCHAR(100),
            state VARCHAR(100),
            postcode VARCHAR(20),
            country VARCHAR(2),
            email VARCHAR(100),
            phone VARCHAR(20),
            is_default TINYINT(1) DEFAULT 0,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY user_id (user_id),
            KEY address_type (address_type),
            KEY is_default (is_default)
        ) $charset_collate;";
        dbDelta($sql_addresses);
        
        // User activity logs table
        $activity_table = $wpdb->prefix . 'osmea_user_activity';
        $sql_activity = "CREATE TABLE $activity_table (
            id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
            user_id BIGINT UNSIGNED NOT NULL,
            activity_type VARCHAR(50) NOT NULL,
            activity_description TEXT,
            ip_address VARCHAR(45),
            user_agent TEXT,
            metadata LONGTEXT,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY user_id (user_id),
            KEY activity_type (activity_type),
            KEY created_at (created_at)
        ) $charset_collate;";
        dbDelta($sql_activity);
        
        // User preferences table
        $preferences_table = $wpdb->prefix . 'osmea_user_preferences';
        $sql_preferences = "CREATE TABLE $preferences_table (
            id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
            user_id BIGINT UNSIGNED NOT NULL,
            preference_key VARCHAR(100) NOT NULL,
            preference_value LONGTEXT,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY user_id (user_id),
            KEY preference_key (preference_key),
            UNIQUE KEY user_preference_key (user_id, preference_key)
        ) $charset_collate;";
        dbDelta($sql_preferences);
    }
    
    /**
     * Register REST API routes
     */
    public function register_rest_routes() {
        // Debug: Log route registration (remove in production)
        if (defined('WP_DEBUG') && WP_DEBUG) {
            error_log('OSMEA Users Manager: Registering REST API routes');
        }
        // User metadata endpoints
        register_rest_route('osmea-users/v1', '/metadata', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_user_metadata'),
            'permission_callback' => array($this, 'check_user_permission'),
        ));
        
        register_rest_route('osmea-users/v1', '/metadata', array(
            'methods' => 'POST',
            'callback' => array($this, 'update_user_metadata'),
            'permission_callback' => array($this, 'check_user_permission'),
        ));
        
        register_rest_route('osmea-users/v1', '/metadata/(?P<key>[a-zA-Z0-9_-]+)', array(
            'methods' => 'DELETE',
            'callback' => array($this, 'delete_user_metadata'),
            'permission_callback' => array($this, 'check_user_permission'),
        ));
        
        // Orders endpoints
        register_rest_route('osmea-users/v1', '/orders', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_user_orders'),
            'permission_callback' => array($this, 'check_user_permission'),
            'args' => array(
                'page' => array(
                    'default' => 1,
                    'sanitize_callback' => 'absint',
                ),
                'per_page' => array(
                    'default' => 10,
                    'sanitize_callback' => 'absint',
                ),
                'status' => array(
                    'sanitize_callback' => 'sanitize_text_field',
                ),
            ),
        ));
        
        register_rest_route('osmea-users/v1', '/orders/(?P<id>\d+)', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_user_order'),
            'permission_callback' => array($this, 'check_user_permission'),
        ));
        
        // Contract signatures endpoints
        register_rest_route('osmea-users/v1', '/contracts', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_user_contracts'),
            'permission_callback' => array($this, 'check_user_permission'),
            'args' => array(
                'page' => array(
                    'default' => 1,
                    'sanitize_callback' => 'absint',
                ),
                'per_page' => array(
                    'default' => 10,
                    'sanitize_callback' => 'absint',
                ),
                'contract_type' => array(
                    'sanitize_callback' => 'sanitize_text_field',
                ),
            ),
        ));
        
        register_rest_route('osmea-users/v1', '/contracts', array(
            'methods' => 'POST',
            'callback' => array($this, 'create_contract_signature'),
            'permission_callback' => array($this, 'check_user_permission'),
        ));
        
        register_rest_route('osmea-users/v1', '/contracts/(?P<id>\d+)', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_user_contract'),
            'permission_callback' => array($this, 'check_user_permission'),
        ));
        
        // User profile summary endpoint
        register_rest_route('osmea-users/v1', '/profile', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_user_profile'),
            'permission_callback' => array($this, 'check_user_permission'),
        ));
        
        // User addresses endpoints
        register_rest_route('osmea-users/v1', '/addresses', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_user_addresses'),
            'permission_callback' => array($this, 'check_user_permission'),
            'args' => array(
                'type' => array(
                    'sanitize_callback' => 'sanitize_text_field',
                ),
            ),
        ));
        
        register_rest_route('osmea-users/v1', '/addresses', array(
            'methods' => 'POST',
            'callback' => array($this, 'create_user_address'),
            'permission_callback' => array($this, 'check_user_permission'),
        ));
        
        register_rest_route('osmea-users/v1', '/addresses/(?P<id>\d+)', array(
            'methods' => 'PUT',
            'callback' => array($this, 'update_user_address'),
            'permission_callback' => array($this, 'check_user_permission'),
        ));
        
        register_rest_route('osmea-users/v1', '/addresses/(?P<id>\d+)', array(
            'methods' => 'DELETE',
            'callback' => array($this, 'delete_user_address'),
            'permission_callback' => array($this, 'check_user_permission'),
        ));
        
        register_rest_route('osmea-users/v1', '/addresses/(?P<id>\d+)/set-default', array(
            'methods' => 'POST',
            'callback' => array($this, 'set_default_address'),
            'permission_callback' => array($this, 'check_user_permission'),
        ));
        
        // User preferences endpoints
        register_rest_route('osmea-users/v1', '/preferences', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_user_preferences'),
            'permission_callback' => array($this, 'check_user_permission'),
        ));
        
        register_rest_route('osmea-users/v1', '/preferences', array(
            'methods' => 'POST',
            'callback' => array($this, 'update_user_preferences'),
            'permission_callback' => array($this, 'check_user_permission'),
        ));
        
        // User activity logs endpoints
        register_rest_route('osmea-users/v1', '/activity', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_user_activity'),
            'permission_callback' => array($this, 'check_user_permission'),
            'args' => array(
                'page' => array(
                    'default' => 1,
                    'sanitize_callback' => 'absint',
                ),
                'per_page' => array(
                    'default' => 20,
                    'sanitize_callback' => 'absint',
                ),
                'type' => array(
                    'sanitize_callback' => 'sanitize_text_field',
                ),
            ),
        ));
        
        register_rest_route('osmea-users/v1', '/activity', array(
            'methods' => 'POST',
            'callback' => array($this, 'log_user_activity'),
            'permission_callback' => array($this, 'check_user_permission'),
        ));
        
        // Statistics endpoint
        register_rest_route('osmea-users/v1', '/statistics', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_user_statistics'),
            'permission_callback' => array($this, 'check_user_permission'),
        ));
        
        // Dashboard endpoint - Get all user data in one request
        register_rest_route('osmea-users/v1', '/dashboard', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_user_dashboard'),
            'permission_callback' => array($this, 'check_user_permission'),
            'args' => array(
                'include_orders' => array(
                    'default' => true,
                    'sanitize_callback' => 'rest_sanitize_boolean',
                ),
                'orders_limit' => array(
                    'default' => 5,
                    'sanitize_callback' => 'absint',
                ),
                'include_activity' => array(
                    'default' => true,
                    'sanitize_callback' => 'rest_sanitize_boolean',
                ),
                'activity_limit' => array(
                    'default' => 10,
                    'sanitize_callback' => 'absint',
                ),
            ),
        ));
        
        // Update user profile endpoint
        register_rest_route('osmea-users/v1', '/profile', array(
            'methods' => 'PUT',
            'callback' => array($this, 'update_user_profile'),
            'permission_callback' => array($this, 'check_user_permission'),
        ));
        
        // Admin endpoints - Access all WordPress users
        register_rest_route('osmea-users/v1', '/admin/users', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_all_users'),
            'permission_callback' => array($this, 'check_admin_permission'),
            'args' => array(
                'page' => array(
                    'default' => 1,
                    'sanitize_callback' => 'absint',
                ),
                'per_page' => array(
                    'default' => 20,
                    'sanitize_callback' => 'absint',
                ),
                'search' => array(
                    'sanitize_callback' => 'sanitize_text_field',
                ),
                'role' => array(
                    'sanitize_callback' => 'sanitize_text_field',
                ),
            ),
        ));
        
        register_rest_route('osmea-users/v1', '/admin/users/(?P<id>\d+)', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_user_by_id'),
            'permission_callback' => array($this, 'check_admin_permission'),
        ));
        
        register_rest_route('osmea-users/v1', '/admin/users/(?P<id>\d+)/metadata', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_user_metadata_admin'),
            'permission_callback' => array($this, 'check_admin_permission'),
        ));
        
        register_rest_route('osmea-users/v1', '/admin/users/(?P<id>\d+)/metadata', array(
            'methods' => 'POST',
            'callback' => array($this, 'update_user_metadata_admin'),
            'permission_callback' => array($this, 'check_admin_permission'),
        ));
        
        register_rest_route('osmea-users/v1', '/admin/users/(?P<id>\d+)/metadata/(?P<key>[a-zA-Z0-9_-]+)', array(
            'methods' => 'DELETE',
            'callback' => array($this, 'delete_user_metadata_admin'),
            'permission_callback' => array($this, 'check_admin_permission'),
        ));
        
        register_rest_route('osmea-users/v1', '/admin/users/(?P<id>\d+)/dashboard', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_user_dashboard_admin'),
            'permission_callback' => array($this, 'check_admin_permission'),
            'args' => array(
                'include_orders' => array(
                    'default' => true,
                    'sanitize_callback' => 'rest_sanitize_boolean',
                ),
                'orders_limit' => array(
                    'default' => 5,
                    'sanitize_callback' => 'absint',
                ),
                'include_activity' => array(
                    'default' => true,
                    'sanitize_callback' => 'rest_sanitize_boolean',
                ),
                'activity_limit' => array(
                    'default' => 10,
                    'sanitize_callback' => 'absint',
                ),
            ),
        ));
    }
    
    /**
     * Check user permission for REST API
     * Supports both cookie-based and JWT authentication
     */
    public function check_user_permission() {
        // Check if user is logged in via cookie (browser)
        if (is_user_logged_in()) {
            return true;
        }
        
        // Check if user is authenticated via JWT token
        // JWT authentication sets the user via wp_set_current_user()
        $user_id = get_current_user_id();
        if ($user_id > 0) {
            return true;
        }
        
        return false;
    }
    
    /**
     * Check admin permission for REST API
     */
    public function check_admin_permission() {
        return current_user_can('manage_options');
    }
    
    /**
     * Get current user ID
     */
    private function get_current_user_id() {
        return get_current_user_id();
    }
    
    /**
     * Get user metadata
     */
    public function get_user_metadata($request) {
        $user_id = $this->get_current_user_id();
        if (!$user_id) {
            return new WP_Error('unauthorized', __('User not authenticated.', 'osmea-users-manager'), array('status' => 401));
        }
        
        global $wpdb;
        $metadata_table = $wpdb->prefix . 'osmea_user_metadata';
        
        $results = $wpdb->get_results($wpdb->prepare(
            "SELECT meta_key, meta_value, updated_at FROM $metadata_table WHERE user_id = %d ORDER BY updated_at DESC",
            $user_id
        ), ARRAY_A);
        
        $metadata = array();
        foreach ($results as $row) {
            $metadata[$row['meta_key']] = array(
                'value' => maybe_unserialize($row['meta_value']),
                'updated_at' => $row['updated_at'],
            );
        }
        
        return rest_ensure_response(array(
            'user_id' => $user_id,
            'metadata' => $metadata,
            'count' => count($metadata),
        ));
    }
    
    /**
     * Update user metadata
     */
    public function update_user_metadata($request) {
        $user_id = $this->get_current_user_id();
        if (!$user_id) {
            return new WP_Error('unauthorized', __('User not authenticated.', 'osmea-users-manager'), array('status' => 401));
        }
        
        $params = $request->get_json_params();
        if (empty($params) || !is_array($params)) {
            return new WP_Error('invalid_data', __('Invalid data provided.', 'osmea-users-manager'), array('status' => 400));
        }
        
        global $wpdb;
        $metadata_table = $wpdb->prefix . 'osmea_user_metadata';
        
        $updated = array();
        $errors = array();
        
        foreach ($params as $key => $value) {
            // Validate key
            if (!preg_match('/^[a-zA-Z0-9_-]+$/', $key)) {
                $errors[] = sprintf(__('Invalid meta key: %s', 'osmea-users-manager'), $key);
                continue;
            }
            
            // Serialize value if needed
            $meta_value = maybe_serialize($value);
            
            // Insert or update
            $result = $wpdb->replace(
                $metadata_table,
                array(
                    'user_id' => $user_id,
                    'meta_key' => sanitize_text_field($key),
                    'meta_value' => $meta_value,
                ),
                array('%d', '%s', '%s')
            );
            
            if ($result !== false) {
                $updated[] = $key;
            } else {
                $errors[] = sprintf(__('Failed to update meta key: %s', 'osmea-users-manager'), $key);
            }
        }
        
        if (!empty($errors)) {
            return new WP_Error('update_partial', __('Some metadata could not be updated.', 'osmea-users-manager'), array(
                'status' => 207,
                'updated' => $updated,
                'errors' => $errors,
            ));
        }
        
        return rest_ensure_response(array(
            'success' => true,
            'updated' => $updated,
            'message' => __('Metadata updated successfully.', 'osmea-users-manager'),
        ));
    }
    
    /**
     * Delete user metadata
     */
    public function delete_user_metadata($request) {
        $user_id = $this->get_current_user_id();
        if (!$user_id) {
            return new WP_Error('unauthorized', __('User not authenticated.', 'osmea-users-manager'), array('status' => 401));
        }
        
        $key = $request->get_param('key');
        if (empty($key)) {
            return new WP_Error('invalid_key', __('Meta key is required.', 'osmea-users-manager'), array('status' => 400));
        }
        
        global $wpdb;
        $metadata_table = $wpdb->prefix . 'osmea_user_metadata';
        
        $deleted = $wpdb->delete(
            $metadata_table,
            array(
                'user_id' => $user_id,
                'meta_key' => sanitize_text_field($key),
            ),
            array('%d', '%s')
        );
        
        if ($deleted === false) {
            return new WP_Error('delete_failed', __('Failed to delete metadata.', 'osmea-users-manager'), array('status' => 500));
        }
        
        return rest_ensure_response(array(
            'success' => true,
            'message' => __('Metadata deleted successfully.', 'osmea-users-manager'),
        ));
    }
    
    /**
     * Get user orders (WooCommerce integration)
     */
    public function get_user_orders($request) {
        $user_id = $this->get_current_user_id();
        if (!$user_id) {
            return new WP_Error('unauthorized', __('User not authenticated.', 'osmea-users-manager'), array('status' => 401));
        }
        
        if (!class_exists('WooCommerce')) {
            return new WP_Error('woocommerce_not_active', __('WooCommerce is not active.', 'osmea-users-manager'), array('status' => 400));
        }
        
        $page = $request->get_param('page');
        $per_page = $request->get_param('per_page');
        $status = $request->get_param('status');
        
        $args = array(
            'customer_id' => $user_id,
            'limit' => $per_page,
            'paged' => $page,
            'orderby' => 'date',
            'order' => 'DESC',
        );
        
        if (!empty($status)) {
            $args['status'] = $status;
        }
        
        $orders = wc_get_orders($args);
        $total_orders = wc_get_orders(array(
            'customer_id' => $user_id,
            'limit' => -1,
            'status' => !empty($status) ? $status : 'any',
            'return' => 'ids',
        ));
        
        $orders_data = array();
        foreach ($orders as $order) {
            $orders_data[] = $this->format_order_data($order);
        }
        
        return rest_ensure_response(array(
            'orders' => $orders_data,
            'pagination' => array(
                'total' => count($total_orders),
                'per_page' => $per_page,
                'current_page' => $page,
                'total_pages' => ceil(count($total_orders) / $per_page),
            ),
        ));
    }
    
    /**
     * Get single user order
     */
    public function get_user_order($request) {
        $user_id = $this->get_current_user_id();
        if (!$user_id) {
            return new WP_Error('unauthorized', __('User not authenticated.', 'osmea-users-manager'), array('status' => 401));
        }
        
        if (!class_exists('WooCommerce')) {
            return new WP_Error('woocommerce_not_active', __('WooCommerce is not active.', 'osmea-users-manager'), array('status' => 400));
        }
        
        $order_id = $request->get_param('id');
        $order = wc_get_order($order_id);
        
        if (!$order || $order->get_customer_id() != $user_id) {
            return new WP_Error('order_not_found', __('Order not found or access denied.', 'osmea-users-manager'), array('status' => 404));
        }
        
        return rest_ensure_response($this->format_order_data($order, true));
    }
    
    /**
     * Format order data for API response
     */
    private function format_order_data($order, $detailed = false) {
        $data = array(
            'id' => $order->get_id(),
            'order_number' => $order->get_order_number(),
            'status' => $order->get_status(),
            'date_created' => $order->get_date_created()->date('Y-m-d H:i:s'),
            'total' => $order->get_total(),
            'currency' => $order->get_currency(),
            'payment_method' => $order->get_payment_method_title(),
        );
        
        // Include line items - first 3 for list view, all for detailed view
        $data['line_items'] = array();
        $items = $order->get_items();
        $item_count = 0;
        $max_items = $detailed ? PHP_INT_MAX : 3; // Limit to 3 for list, all for detailed
        
        // Debug: Log items count
        if (defined('WP_DEBUG') && WP_DEBUG) {
            error_log('OSMEA format_order_data: Order #' . $order->get_order_number() . ' - Items count: ' . count($items));
        }
        
        foreach ($items as $item_id => $item) {
            if ($item_count >= $max_items) break;
            $product = $item->get_product();
            $product_image = '';
            if ($product) {
                $image_id = $product->get_image_id();
                if ($image_id) {
                    $product_image = wp_get_attachment_image_url($image_id, 'thumbnail');
                    // Fallback to medium size if thumbnail not available
                    if (!$product_image) {
                        $product_image = wp_get_attachment_image_url($image_id, 'medium');
                    }
                    // Fallback to full size if medium not available
                    if (!$product_image) {
                        $product_image = wp_get_attachment_image_url($image_id, 'full');
                    }
                }
            }
            
            $data['line_items'][] = array(
                'id' => $item_id,
                'name' => $item->get_name(),
                'quantity' => $item->get_quantity(),
                'subtotal' => $item->get_subtotal(),
                'total' => $item->get_total(),
                'product_id' => $item->get_product_id(),
                'product_image' => $product_image ? $product_image : '',
            );
            $item_count++;
        }
        
        if ($detailed) {
            $data['billing'] = array(
                'first_name' => $order->get_billing_first_name(),
                'last_name' => $order->get_billing_last_name(),
                'company' => $order->get_billing_company(),
                'address_1' => $order->get_billing_address_1(),
                'address_2' => $order->get_billing_address_2(),
                'city' => $order->get_billing_city(),
                'state' => $order->get_billing_state(),
                'postcode' => $order->get_billing_postcode(),
                'country' => $order->get_billing_country(),
                'email' => $order->get_billing_email(),
                'phone' => $order->get_billing_phone(),
            );
            
            $data['shipping'] = array(
                'first_name' => $order->get_shipping_first_name(),
                'last_name' => $order->get_shipping_last_name(),
                'company' => $order->get_shipping_company(),
                'address_1' => $order->get_shipping_address_1(),
                'address_2' => $order->get_shipping_address_2(),
                'city' => $order->get_shipping_city(),
                'state' => $order->get_shipping_state(),
                'postcode' => $order->get_shipping_postcode(),
                'country' => $order->get_shipping_country(),
            );
            
            $data['totals'] = array(
                'subtotal' => $order->get_subtotal(),
                'shipping' => $order->get_shipping_total(),
                'tax' => $order->get_total_tax(),
                'total' => $order->get_total(),
            );
        }
        
        return $data;
    }
    
    /**
     * Get user contracts
     */
    public function get_user_contracts($request) {
        $user_id = $this->get_current_user_id();
        if (!$user_id) {
            return new WP_Error('unauthorized', __('User not authenticated.', 'osmea-users-manager'), array('status' => 401));
        }
        
        global $wpdb;
        $contracts_table = $wpdb->prefix . 'osmea_contract_signatures';
        
        $page = $request->get_param('page');
        $per_page = $request->get_param('per_page');
        $contract_type = $request->get_param('contract_type');
        $offset = ($page - 1) * $per_page;
        
        $where = $wpdb->prepare('user_id = %d', $user_id);
        if (!empty($contract_type)) {
            $where .= $wpdb->prepare(' AND contract_type = %s', $contract_type);
        }
        
        // Get total count
        $total = $wpdb->get_var("SELECT COUNT(*) FROM $contracts_table WHERE $where");
        
        // Get contracts
        $results = $wpdb->get_results($wpdb->prepare(
            "SELECT * FROM $contracts_table WHERE $where ORDER BY signed_at DESC LIMIT %d OFFSET %d",
            $per_page,
            $offset
        ), ARRAY_A);
        
        $contracts = array();
        foreach ($results as $row) {
            $contracts[] = array(
                'id' => (int) $row['id'],
                'contract_type' => $row['contract_type'],
                'contract_title' => $row['contract_title'],
                'contract_content' => $row['contract_content'],
                'signature_data' => maybe_unserialize($row['signature_data']),
                'ip_address' => $row['ip_address'],
                'signed_at' => $row['signed_at'],
            );
        }
        
        return rest_ensure_response(array(
            'contracts' => $contracts,
            'pagination' => array(
                'total' => (int) $total,
                'per_page' => $per_page,
                'current_page' => $page,
                'total_pages' => ceil($total / $per_page),
            ),
        ));
    }
    
    /**
     * Get single user contract
     */
    public function get_user_contract($request) {
        $user_id = $this->get_current_user_id();
        if (!$user_id) {
            return new WP_Error('unauthorized', __('User not authenticated.', 'osmea-users-manager'), array('status' => 401));
        }
        
        $contract_id = $request->get_param('id');
        
        global $wpdb;
        $contracts_table = $wpdb->prefix . 'osmea_contract_signatures';
        
        $contract = $wpdb->get_row($wpdb->prepare(
            "SELECT * FROM $contracts_table WHERE id = %d AND user_id = %d",
            $contract_id,
            $user_id
        ), ARRAY_A);
        
        if (!$contract) {
            return new WP_Error('contract_not_found', __('Contract not found or access denied.', 'osmea-users-manager'), array('status' => 404));
        }
        
        return rest_ensure_response(array(
            'id' => (int) $contract['id'],
            'contract_type' => $contract['contract_type'],
            'contract_title' => $contract['contract_title'],
            'contract_content' => $contract['contract_content'],
            'signature_data' => maybe_unserialize($contract['signature_data']),
            'ip_address' => $contract['ip_address'],
            'user_agent' => $contract['user_agent'],
            'signed_at' => $contract['signed_at'],
        ));
    }
    
    /**
     * Create contract signature
     */
    public function create_contract_signature($request) {
        $user_id = $this->get_current_user_id();
        if (!$user_id) {
            return new WP_Error('unauthorized', __('User not authenticated.', 'osmea-users-manager'), array('status' => 401));
        }
        
        $params = $request->get_json_params();
        
        $required_fields = array('contract_type', 'contract_title', 'signature_data');
        foreach ($required_fields as $field) {
            if (empty($params[$field])) {
                return new WP_Error('missing_field', sprintf(__('Field %s is required.', 'osmea-users-manager'), $field), array('status' => 400));
            }
        }
        
        global $wpdb;
        $contracts_table = $wpdb->prefix . 'osmea_contract_signatures';
        
        $insert_data = array(
            'user_id' => $user_id,
            'contract_type' => sanitize_text_field($params['contract_type']),
            'contract_title' => sanitize_text_field($params['contract_title']),
            'contract_content' => isset($params['contract_content']) ? wp_kses_post($params['contract_content']) : '',
            'signature_data' => maybe_serialize($params['signature_data']),
            'ip_address' => $this->get_client_ip(),
            'user_agent' => isset($_SERVER['HTTP_USER_AGENT']) ? sanitize_text_field($_SERVER['HTTP_USER_AGENT']) : '',
        );
        
        $result = $wpdb->insert(
            $contracts_table,
            $insert_data,
            array('%d', '%s', '%s', '%s', '%s', '%s', '%s')
        );
        
        if ($result === false) {
            return new WP_Error('insert_failed', __('Failed to save contract signature.', 'osmea-users-manager'), array('status' => 500));
        }
        
        return rest_ensure_response(array(
            'success' => true,
            'contract_id' => $wpdb->insert_id,
            'message' => __('Contract signature saved successfully.', 'osmea-users-manager'),
        ));
    }
    
    /**
     * Get user addresses
     */
    public function get_user_addresses($request) {
        $user_id = $this->get_current_user_id();
        if (!$user_id) {
            return new WP_Error('unauthorized', __('User not authenticated.', 'osmea-users-manager'), array('status' => 401));
        }
        
        global $wpdb;
        $addresses_table = $wpdb->prefix . 'osmea_user_addresses';
        
        $type = $request->get_param('type');
        $where = $wpdb->prepare('user_id = %d', $user_id);
        if (!empty($type)) {
            $where .= $wpdb->prepare(' AND address_type = %s', $type);
        }
        
        $results = $wpdb->get_results("SELECT * FROM $addresses_table WHERE $where ORDER BY is_default DESC, created_at DESC", ARRAY_A);
        
        $addresses = array();
        foreach ($results as $row) {
            $addresses[] = array(
                'id' => (int) $row['id'],
                'address_type' => $row['address_type'],
                'label' => $row['label'],
                'first_name' => $row['first_name'],
                'last_name' => $row['last_name'],
                'company' => $row['company'],
                'address_1' => $row['address_1'],
                'address_2' => $row['address_2'],
                'city' => $row['city'],
                'state' => $row['state'],
                'postcode' => $row['postcode'],
                'country' => $row['country'],
                'email' => $row['email'],
                'phone' => $row['phone'],
                'is_default' => (bool) $row['is_default'],
                'created_at' => $row['created_at'],
                'updated_at' => $row['updated_at'],
            );
        }
        
        return rest_ensure_response(array(
            'addresses' => $addresses,
            'count' => count($addresses),
        ));
    }
    
    /**
     * Create user address
     */
    public function create_user_address($request) {
        $user_id = $this->get_current_user_id();
        if (!$user_id) {
            return new WP_Error('unauthorized', __('User not authenticated.', 'osmea-users-manager'), array('status' => 401));
        }
        
        $params = $request->get_json_params();
        $required = array('address_type', 'first_name', 'last_name', 'address_1', 'city', 'country');
        foreach ($required as $field) {
            if (empty($params[$field])) {
                return new WP_Error('missing_field', sprintf(__('Field %s is required.', 'osmea-users-manager'), $field), array('status' => 400));
            }
        }
        
        global $wpdb;
        $addresses_table = $wpdb->prefix . 'osmea_user_addresses';
        
        $insert_data = array(
            'user_id' => $user_id,
            'address_type' => sanitize_text_field($params['address_type']),
            'label' => isset($params['label']) ? sanitize_text_field($params['label']) : null,
            'first_name' => sanitize_text_field($params['first_name']),
            'last_name' => sanitize_text_field($params['last_name']),
            'company' => isset($params['company']) ? sanitize_text_field($params['company']) : null,
            'address_1' => sanitize_text_field($params['address_1']),
            'address_2' => isset($params['address_2']) ? sanitize_text_field($params['address_2']) : null,
            'city' => sanitize_text_field($params['city']),
            'state' => isset($params['state']) ? sanitize_text_field($params['state']) : null,
            'postcode' => isset($params['postcode']) ? sanitize_text_field($params['postcode']) : null,
            'country' => sanitize_text_field($params['country']),
            'email' => isset($params['email']) ? sanitize_email($params['email']) : null,
            'phone' => isset($params['phone']) ? sanitize_text_field($params['phone']) : null,
            'is_default' => isset($params['is_default']) ? (int) $params['is_default'] : 0,
        );
        
        // If setting as default, unset other defaults of same type
        if ($insert_data['is_default']) {
            $wpdb->update(
                $addresses_table,
                array('is_default' => 0),
                array('user_id' => $user_id, 'address_type' => $insert_data['address_type']),
                array('%d'),
                array('%d', '%s')
            );
        }
        
        $result = $wpdb->insert($addresses_table, $insert_data, array('%d', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%d'));
        
        if ($result === false) {
            return new WP_Error('insert_failed', __('Failed to create address.', 'osmea-users-manager'), array('status' => 500));
        }
        
        return rest_ensure_response(array(
            'success' => true,
            'address_id' => $wpdb->insert_id,
            'message' => __('Address created successfully.', 'osmea-users-manager'),
        ));
    }
    
    /**
     * Update user address
     */
    public function update_user_address($request) {
        $user_id = $this->get_current_user_id();
        if (!$user_id) {
            return new WP_Error('unauthorized', __('User not authenticated.', 'osmea-users-manager'), array('status' => 401));
        }
        
        $address_id = $request->get_param('id');
        $params = $request->get_json_params();
        
        global $wpdb;
        $addresses_table = $wpdb->prefix . 'osmea_user_addresses';
        
        // Verify ownership
        $address = $wpdb->get_row($wpdb->prepare(
            "SELECT * FROM $addresses_table WHERE id = %d AND user_id = %d",
            $address_id,
            $user_id
        ));
        
        if (!$address) {
            return new WP_Error('address_not_found', __('Address not found or access denied.', 'osmea-users-manager'), array('status' => 404));
        }
        
        $update_data = array();
        $allowed_fields = array('label', 'first_name', 'last_name', 'company', 'address_1', 'address_2', 'city', 'state', 'postcode', 'country', 'email', 'phone', 'is_default');
        
        foreach ($allowed_fields as $field) {
            if (isset($params[$field])) {
                if ($field === 'email') {
                    $update_data[$field] = sanitize_email($params[$field]);
                } elseif ($field === 'is_default') {
                    $update_data[$field] = (int) $params[$field];
                } else {
                    $update_data[$field] = sanitize_text_field($params[$field]);
                }
            }
        }
        
        if (empty($update_data)) {
            return new WP_Error('no_data', __('No data provided for update.', 'osmea-users-manager'), array('status' => 400));
        }
        
        // If setting as default, unset other defaults
        if (isset($update_data['is_default']) && $update_data['is_default']) {
            $wpdb->update(
                $addresses_table,
                array('is_default' => 0),
                array('user_id' => $user_id, 'address_type' => $address->address_type, 'id' => array('!=', $address_id)),
                array('%d'),
                array('%d', '%s')
            );
        }
        
        $result = $wpdb->update(
            $addresses_table,
            $update_data,
            array('id' => $address_id, 'user_id' => $user_id),
            null,
            array('%d', '%d')
        );
        
        if ($result === false) {
            return new WP_Error('update_failed', __('Failed to update address.', 'osmea-users-manager'), array('status' => 500));
        }
        
        return rest_ensure_response(array(
            'success' => true,
            'message' => __('Address updated successfully.', 'osmea-users-manager'),
        ));
    }
    
    /**
     * Delete user address
     */
    public function delete_user_address($request) {
        $user_id = $this->get_current_user_id();
        if (!$user_id) {
            return new WP_Error('unauthorized', __('User not authenticated.', 'osmea-users-manager'), array('status' => 401));
        }
        
        $address_id = $request->get_param('id');
        
        global $wpdb;
        $addresses_table = $wpdb->prefix . 'osmea_user_addresses';
        
        $deleted = $wpdb->delete(
            $addresses_table,
            array('id' => $address_id, 'user_id' => $user_id),
            array('%d', '%d')
        );
        
        if ($deleted === false) {
            return new WP_Error('delete_failed', __('Failed to delete address.', 'osmea-users-manager'), array('status' => 500));
        }
        
        return rest_ensure_response(array(
            'success' => true,
            'message' => __('Address deleted successfully.', 'osmea-users-manager'),
        ));
    }
    
    /**
     * Set default address
     */
    public function set_default_address($request) {
        $user_id = $this->get_current_user_id();
        if (!$user_id) {
            return new WP_Error('unauthorized', __('User not authenticated.', 'osmea-users-manager'), array('status' => 401));
        }
        
        $address_id = $request->get_param('id');
        
        global $wpdb;
        $addresses_table = $wpdb->prefix . 'osmea_user_addresses';
        
        // Get address to find type
        $address = $wpdb->get_row($wpdb->prepare(
            "SELECT address_type FROM $addresses_table WHERE id = %d AND user_id = %d",
            $address_id,
            $user_id
        ));
        
        if (!$address) {
            return new WP_Error('address_not_found', __('Address not found or access denied.', 'osmea-users-manager'), array('status' => 404));
        }
        
        // Unset other defaults of same type
        $wpdb->update(
            $addresses_table,
            array('is_default' => 0),
            array('user_id' => $user_id, 'address_type' => $address->address_type),
            array('%d'),
            array('%d', '%s')
        );
        
        // Set this as default
        $result = $wpdb->update(
            $addresses_table,
            array('is_default' => 1),
            array('id' => $address_id, 'user_id' => $user_id),
            array('%d'),
            array('%d', '%d')
        );
        
        if ($result === false) {
            return new WP_Error('update_failed', __('Failed to set default address.', 'osmea-users-manager'), array('status' => 500));
        }
        
        return rest_ensure_response(array(
            'success' => true,
            'message' => __('Default address set successfully.', 'osmea-users-manager'),
        ));
    }
    
    /**
     * Get user preferences
     */
    public function get_user_preferences($request) {
        $user_id = $this->get_current_user_id();
        if (!$user_id) {
            return new WP_Error('unauthorized', __('User not authenticated.', 'osmea-users-manager'), array('status' => 401));
        }
        
        global $wpdb;
        $preferences_table = $wpdb->prefix . 'osmea_user_preferences';
        
        $results = $wpdb->get_results($wpdb->prepare(
            "SELECT preference_key, preference_value, updated_at FROM $preferences_table WHERE user_id = %d ORDER BY updated_at DESC",
            $user_id
        ), ARRAY_A);
        
        $preferences = array();
        foreach ($results as $row) {
            $preferences[$row['preference_key']] = array(
                'value' => maybe_unserialize($row['preference_value']),
                'updated_at' => $row['updated_at'],
            );
        }
        
        return rest_ensure_response(array(
            'user_id' => $user_id,
            'preferences' => $preferences,
            'count' => count($preferences),
        ));
    }
    
    /**
     * Update user preferences
     */
    public function update_user_preferences($request) {
        $user_id = $this->get_current_user_id();
        if (!$user_id) {
            return new WP_Error('unauthorized', __('User not authenticated.', 'osmea-users-manager'), array('status' => 401));
        }
        
        $params = $request->get_json_params();
        if (empty($params) || !is_array($params)) {
            return new WP_Error('invalid_data', __('Invalid data provided.', 'osmea-users-manager'), array('status' => 400));
        }
        
        global $wpdb;
        $preferences_table = $wpdb->prefix . 'osmea_user_preferences';
        
        $updated = array();
        foreach ($params as $key => $value) {
            if (!preg_match('/^[a-zA-Z0-9_-]+$/', $key)) {
                continue;
            }
            
            $preference_value = maybe_serialize($value);
            
            $result = $wpdb->replace(
                $preferences_table,
                array(
                    'user_id' => $user_id,
                    'preference_key' => sanitize_text_field($key),
                    'preference_value' => $preference_value,
                ),
                array('%d', '%s', '%s')
            );
            
            if ($result !== false) {
                $updated[] = $key;
            }
        }
        
        return rest_ensure_response(array(
            'success' => true,
            'updated' => $updated,
            'message' => __('Preferences updated successfully.', 'osmea-users-manager'),
        ));
    }
    
    /**
     * Get user activity logs
     */
    public function get_user_activity($request) {
        $user_id = $this->get_current_user_id();
        if (!$user_id) {
            return new WP_Error('unauthorized', __('User not authenticated.', 'osmea-users-manager'), array('status' => 401));
        }
        
        global $wpdb;
        $activity_table = $wpdb->prefix . 'osmea_user_activity';
        
        $page = $request->get_param('page');
        $per_page = $request->get_param('per_page');
        $type = $request->get_param('type');
        $offset = ($page - 1) * $per_page;
        
        $where = $wpdb->prepare('user_id = %d', $user_id);
        if (!empty($type)) {
            $where .= $wpdb->prepare(' AND activity_type = %s', $type);
        }
        
        $total = $wpdb->get_var("SELECT COUNT(*) FROM $activity_table WHERE $where");
        
        $results = $wpdb->get_results($wpdb->prepare(
            "SELECT * FROM $activity_table WHERE $where ORDER BY created_at DESC LIMIT %d OFFSET %d",
            $per_page,
            $offset
        ), ARRAY_A);
        
        $activities = array();
        foreach ($results as $row) {
            $activities[] = array(
                'id' => (int) $row['id'],
                'activity_type' => $row['activity_type'],
                'activity_description' => $row['activity_description'],
                'ip_address' => $row['ip_address'],
                'metadata' => maybe_unserialize($row['metadata']),
                'created_at' => $row['created_at'],
            );
        }
        
        return rest_ensure_response(array(
            'activities' => $activities,
            'pagination' => array(
                'total' => (int) $total,
                'per_page' => $per_page,
                'current_page' => $page,
                'total_pages' => ceil($total / $per_page),
            ),
        ));
    }
    
    /**
     * Log user activity
     */
    public function log_user_activity($request) {
        $user_id = $this->get_current_user_id();
        if (!$user_id) {
            return new WP_Error('unauthorized', __('User not authenticated.', 'osmea-users-manager'), array('status' => 401));
        }
        
        $params = $request->get_json_params();
        if (empty($params['activity_type'])) {
            return new WP_Error('missing_type', __('Activity type is required.', 'osmea-users-manager'), array('status' => 400));
        }
        
        global $wpdb;
        $activity_table = $wpdb->prefix . 'osmea_user_activity';
        
        $insert_data = array(
            'user_id' => $user_id,
            'activity_type' => sanitize_text_field($params['activity_type']),
            'activity_description' => isset($params['activity_description']) ? sanitize_text_field($params['activity_description']) : null,
            'ip_address' => $this->get_client_ip(),
            'user_agent' => isset($_SERVER['HTTP_USER_AGENT']) ? sanitize_text_field($_SERVER['HTTP_USER_AGENT']) : null,
            'metadata' => isset($params['metadata']) ? maybe_serialize($params['metadata']) : null,
        );
        
        $result = $wpdb->insert($activity_table, $insert_data, array('%d', '%s', '%s', '%s', '%s', '%s'));
        
        if ($result === false) {
            return new WP_Error('insert_failed', __('Failed to log activity.', 'osmea-users-manager'), array('status' => 500));
        }
        
        return rest_ensure_response(array(
            'success' => true,
            'activity_id' => $wpdb->insert_id,
            'message' => __('Activity logged successfully.', 'osmea-users-manager'),
        ));
    }
    
    /**
     * Get user statistics
     */
    public function get_user_statistics($request) {
        $user_id = $this->get_current_user_id();
        if (!$user_id) {
            return new WP_Error('unauthorized', __('User not authenticated.', 'osmea-users-manager'), array('status' => 401));
        }
        
        $stats = $this->get_user_statistics_internal($user_id);
        return rest_ensure_response($stats);
    }
    
    /**
     * Get user dashboard - All user data in one request
     */
    public function get_user_dashboard($request) {
        $user_id = $this->get_current_user_id();
        if (!$user_id) {
            return new WP_Error('unauthorized', __('User not authenticated.', 'osmea-users-manager'), array('status' => 401));
        }
        
        $user = get_userdata($user_id);
        if (!$user) {
            return new WP_Error('user_not_found', __('User not found.', 'osmea-users-manager'), array('status' => 404));
        }
        
        $include_orders = $request->get_param('include_orders');
        $orders_limit = $request->get_param('orders_limit');
        $include_activity = $request->get_param('include_activity');
        $activity_limit = $request->get_param('activity_limit');
        
        global $wpdb;
        
        // Get profile information
        $profile = array(
            'user_id' => $user_id,
            'username' => $user->user_login,
            'email' => $user->user_email,
            'display_name' => $user->display_name,
            'first_name' => get_user_meta($user_id, 'first_name', true),
            'last_name' => get_user_meta($user_id, 'last_name', true),
            'nickname' => get_user_meta($user_id, 'nickname', true),
            'registered_at' => $user->user_registered,
        );
        
        // Get metadata
        $metadata_table = $wpdb->prefix . 'osmea_user_metadata';
        $metadata_results = $wpdb->get_results($wpdb->prepare(
            "SELECT meta_key, meta_value, updated_at FROM $metadata_table WHERE user_id = %d ORDER BY updated_at DESC",
            $user_id
        ), ARRAY_A);
        
        $metadata = array();
        foreach ($metadata_results as $row) {
            $metadata[$row['meta_key']] = array(
                'value' => maybe_unserialize($row['meta_value']),
                'updated_at' => $row['updated_at'],
            );
        }
        
        // Get addresses
        $addresses_table = $wpdb->prefix . 'osmea_user_addresses';
        $addresses_results = $wpdb->get_results($wpdb->prepare(
            "SELECT * FROM $addresses_table WHERE user_id = %d ORDER BY is_default DESC, created_at DESC",
            $user_id
        ), ARRAY_A);
        
        $addresses = array();
        foreach ($addresses_results as $row) {
            $addresses[] = array(
                'id' => (int) $row['id'],
                'address_type' => $row['address_type'],
                'label' => $row['label'],
                'first_name' => $row['first_name'],
                'last_name' => $row['last_name'],
                'company' => $row['company'],
                'address_1' => $row['address_1'],
                'address_2' => $row['address_2'],
                'city' => $row['city'],
                'state' => $row['state'],
                'postcode' => $row['postcode'],
                'country' => $row['country'],
                'email' => $row['email'],
                'phone' => $row['phone'],
                'is_default' => (bool) $row['is_default'],
                'created_at' => $row['created_at'],
                'updated_at' => $row['updated_at'],
            );
        }
        
        // Get preferences
        $preferences_table = $wpdb->prefix . 'osmea_user_preferences';
        $preferences_results = $wpdb->get_results($wpdb->prepare(
            "SELECT preference_key, preference_value, updated_at FROM $preferences_table WHERE user_id = %d ORDER BY updated_at DESC",
            $user_id
        ), ARRAY_A);
        
        $preferences = array();
        foreach ($preferences_results as $row) {
            $preferences[$row['preference_key']] = array(
                'value' => maybe_unserialize($row['preference_value']),
                'updated_at' => $row['updated_at'],
            );
        }
        
        // Get recent orders (if WooCommerce is active and requested)
        $orders = array();
        if ($include_orders && class_exists('WooCommerce')) {
            $wc_orders = wc_get_orders(array(
                'customer_id' => $user_id,
                'limit' => $orders_limit,
                'orderby' => 'date',
                'order' => 'DESC',
            ));
            
            foreach ($wc_orders as $order) {
                $orders[] = $this->format_order_data($order, false);
            }
        }
        
        // Get recent activity (if requested)
        $activities = array();
        if ($include_activity) {
            $activity_table = $wpdb->prefix . 'osmea_user_activity';
            $activity_results = $wpdb->get_results($wpdb->prepare(
                "SELECT * FROM $activity_table WHERE user_id = %d ORDER BY created_at DESC LIMIT %d",
                $user_id,
                $activity_limit
            ), ARRAY_A);
            
            foreach ($activity_results as $row) {
                $activities[] = array(
                    'id' => (int) $row['id'],
                    'activity_type' => $row['activity_type'],
                    'activity_description' => $row['activity_description'],
                    'ip_address' => $row['ip_address'],
                    'metadata' => maybe_unserialize($row['metadata']),
                    'created_at' => $row['created_at'],
                );
            }
        }
        
        // Get statistics
        $stats = $this->get_user_statistics_internal($user_id);
        
        return rest_ensure_response(array(
            'profile' => $profile,
            'metadata' => $metadata,
            'addresses' => $addresses,
            'preferences' => $preferences,
            'orders' => $orders,
            'activities' => $activities,
            'statistics' => $stats,
        ));
    }
    
    /**
     * Get user statistics (internal method)
     */
    private function get_user_statistics_internal($user_id) {
        global $wpdb;
        
        $metadata_table = $wpdb->prefix . 'osmea_user_metadata';
        $contracts_table = $wpdb->prefix . 'osmea_contract_signatures';
        $addresses_table = $wpdb->prefix . 'osmea_user_addresses';
        $preferences_table = $wpdb->prefix . 'osmea_user_preferences';
        $activity_table = $wpdb->prefix . 'osmea_user_activity';
        
        $stats = array(
            'metadata_count' => (int) $wpdb->get_var($wpdb->prepare("SELECT COUNT(*) FROM $metadata_table WHERE user_id = %d", $user_id)),
            'contracts_count' => (int) $wpdb->get_var($wpdb->prepare("SELECT COUNT(*) FROM $contracts_table WHERE user_id = %d", $user_id)),
            'addresses_count' => (int) $wpdb->get_var($wpdb->prepare("SELECT COUNT(*) FROM $addresses_table WHERE user_id = %d", $user_id)),
            'preferences_count' => (int) $wpdb->get_var($wpdb->prepare("SELECT COUNT(*) FROM $preferences_table WHERE user_id = %d", $user_id)),
            'activity_count' => (int) $wpdb->get_var($wpdb->prepare("SELECT COUNT(*) FROM $activity_table WHERE user_id = %d", $user_id)),
        );
        
        // WooCommerce stats
        if (class_exists('WooCommerce')) {
            $wc_orders = wc_get_orders(array(
                'customer_id' => $user_id,
                'limit' => -1,
                'return' => 'ids',
            ));
            
            $stats['orders_count'] = count($wc_orders);
            $stats['orders_total'] = 0;
            $stats['orders_by_status'] = array();
            
            foreach ($wc_orders as $order_id) {
                $order = wc_get_order($order_id);
                if ($order) {
                    $stats['orders_total'] += $order->get_total();
                    $status = $order->get_status();
                    if (!isset($stats['orders_by_status'][$status])) {
                        $stats['orders_by_status'][$status] = 0;
                    }
                    $stats['orders_by_status'][$status]++;
                }
            }
        }
        
        return $stats;
    }
    
    /**
     * Update user profile
     */
    public function update_user_profile($request) {
        $user_id = $this->get_current_user_id();
        if (!$user_id) {
            return new WP_Error('unauthorized', __('User not authenticated.', 'osmea-users-manager'), array('status' => 401));
        }
        
        $user = get_userdata($user_id);
        if (!$user) {
            return new WP_Error('user_not_found', __('User not found.', 'osmea-users-manager'), array('status' => 404));
        }
        
        $params = $request->get_json_params();
        if (empty($params) || !is_array($params)) {
            return new WP_Error('invalid_data', __('Invalid data provided.', 'osmea-users-manager'), array('status' => 400));
        }
        
        $updated = array();
        $errors = array();
        
        // Update WordPress user fields
        $user_data = array('ID' => $user_id);
        
        if (isset($params['email'])) {
            $email = sanitize_email($params['email']);
            if (is_email($email) && email_exists($email) != $user_id) {
                $errors[] = __('Email already in use.', 'osmea-users-manager');
            } else {
                $user_data['user_email'] = $email;
                $updated[] = 'email';
            }
        }
        
        if (isset($params['display_name'])) {
            $user_data['display_name'] = sanitize_text_field($params['display_name']);
            $updated[] = 'display_name';
        }
        
        if (isset($params['first_name'])) {
            update_user_meta($user_id, 'first_name', sanitize_text_field($params['first_name']));
            $updated[] = 'first_name';
        }
        
        if (isset($params['last_name'])) {
            update_user_meta($user_id, 'last_name', sanitize_text_field($params['last_name']));
            $updated[] = 'last_name';
        }
        
        if (isset($params['nickname'])) {
            update_user_meta($user_id, 'nickname', sanitize_text_field($params['nickname']));
            $updated[] = 'nickname';
        }
        
        // Update password if provided
        if (isset($params['password']) && !empty($params['password'])) {
            $user_data['user_pass'] = $params['password'];
            $updated[] = 'password';
        }
        
        // Update user if there are changes
        if (count($user_data) > 1) {
            $result = wp_update_user($user_data);
            if (is_wp_error($result)) {
                $errors[] = $result->get_error_message();
            }
        }
        
        // Update WooCommerce customer data if WooCommerce is active
        if (class_exists('WooCommerce') && (isset($params['billing']) || isset($params['shipping']))) {
            $customer = new WC_Customer($user_id);
            
            if (isset($params['billing']) && is_array($params['billing'])) {
                $billing = $params['billing'];
                if (isset($billing['first_name'])) $customer->set_billing_first_name($billing['first_name']);
                if (isset($billing['last_name'])) $customer->set_billing_last_name($billing['last_name']);
                if (isset($billing['company'])) $customer->set_billing_company($billing['company']);
                if (isset($billing['address_1'])) $customer->set_billing_address_1($billing['address_1']);
                if (isset($billing['address_2'])) $customer->set_billing_address_2($billing['address_2']);
                if (isset($billing['city'])) $customer->set_billing_city($billing['city']);
                if (isset($billing['state'])) $customer->set_billing_state($billing['state']);
                if (isset($billing['postcode'])) $customer->set_billing_postcode($billing['postcode']);
                if (isset($billing['country'])) $customer->set_billing_country($billing['country']);
                if (isset($billing['email'])) $customer->set_billing_email($billing['email']);
                if (isset($billing['phone'])) $customer->set_billing_phone($billing['phone']);
                $updated[] = 'billing';
            }
            
            if (isset($params['shipping']) && is_array($params['shipping'])) {
                $shipping = $params['shipping'];
                if (isset($shipping['first_name'])) $customer->set_shipping_first_name($shipping['first_name']);
                if (isset($shipping['last_name'])) $customer->set_shipping_last_name($shipping['last_name']);
                if (isset($shipping['company'])) $customer->set_shipping_company($shipping['company']);
                if (isset($shipping['address_1'])) $customer->set_shipping_address_1($shipping['address_1']);
                if (isset($shipping['address_2'])) $customer->set_shipping_address_2($shipping['address_2']);
                if (isset($shipping['city'])) $customer->set_shipping_city($shipping['city']);
                if (isset($shipping['state'])) $customer->set_shipping_state($shipping['state']);
                if (isset($shipping['postcode'])) $customer->set_shipping_postcode($shipping['postcode']);
                if (isset($shipping['country'])) $customer->set_shipping_country($shipping['country']);
                $updated[] = 'shipping';
            }
            
            $customer->save();
        }
        
        if (!empty($errors)) {
            return new WP_Error('update_partial', __('Some fields could not be updated.', 'osmea-users-manager'), array(
                'status' => 207,
                'updated' => $updated,
                'errors' => $errors,
            ));
        }
        
        return rest_ensure_response(array(
            'success' => true,
            'updated' => $updated,
            'message' => __('Profile updated successfully.', 'osmea-users-manager'),
        ));
    }
    
    /**
     * Get user profile summary
     */
    public function get_user_profile($request) {
        $user_id = $this->get_current_user_id();
        if (!$user_id) {
            return new WP_Error('unauthorized', __('User not authenticated.', 'osmea-users-manager'), array('status' => 401));
        }
        
        $user = get_userdata($user_id);
        if (!$user) {
            return new WP_Error('user_not_found', __('User not found.', 'osmea-users-manager'), array('status' => 404));
        }
        
        global $wpdb;
        
        // Get metadata count
        $metadata_table = $wpdb->prefix . 'osmea_user_metadata';
        $metadata_count = $wpdb->get_var($wpdb->prepare(
            "SELECT COUNT(*) FROM $metadata_table WHERE user_id = %d",
            $user_id
        ));
        
        // Get orders count (if WooCommerce is active)
        $orders_count = 0;
        if (class_exists('WooCommerce')) {
            $orders = wc_get_orders(array(
                'customer_id' => $user_id,
                'limit' => -1,
                'return' => 'ids',
            ));
            $orders_count = count($orders);
        }
        
        // Get contracts count
        $contracts_table = $wpdb->prefix . 'osmea_contract_signatures';
        $contracts_count = $wpdb->get_var($wpdb->prepare(
            "SELECT COUNT(*) FROM $contracts_table WHERE user_id = %d",
            $user_id
        ));
        
        return rest_ensure_response(array(
            'user_id' => $user_id,
            'username' => $user->user_login,
            'email' => $user->user_email,
            'display_name' => $user->display_name,
            'first_name' => get_user_meta($user_id, 'first_name', true),
            'last_name' => get_user_meta($user_id, 'last_name', true),
            'registered_at' => $user->user_registered,
            'statistics' => array(
                'metadata_count' => (int) $metadata_count,
                'orders_count' => $orders_count,
                'contracts_count' => (int) $contracts_count,
            ),
        ));
    }
    
    /**
     * Sync order to user (WooCommerce hook)
     */
    public function sync_order_to_user($order_id, $old_status, $new_status) {
        // This can be used to sync order data to user metadata if needed
        // Currently, orders are fetched directly from WooCommerce
    }
    
    /**
     * Get client IP address
     */
    private function get_client_ip() {
        $ip_keys = array('HTTP_CLIENT_IP', 'HTTP_X_FORWARDED_FOR', 'REMOTE_ADDR');
        foreach ($ip_keys as $key) {
            if (array_key_exists($key, $_SERVER) === true) {
                foreach (explode(',', $_SERVER[$key]) as $ip) {
                    $ip = trim($ip);
                    if (filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE) !== false) {
                        return $ip;
                    }
                }
            }
        }
        return isset($_SERVER['REMOTE_ADDR']) ? $_SERVER['REMOTE_ADDR'] : '';
    }
    
    /**
     * Add admin menu under Settings
     */
    public function add_admin_menu() {
        add_options_page(
            __('OSMEA Users Manager', 'osmea-users-manager'),
            __('OSMEA Users Manager', 'osmea-users-manager'),
            'manage_options',
            'osmea-users-manager',
            array($this, 'render_admin_page')
        );
    }
    
    /**
     * Enqueue admin assets
     */
    public function enqueue_admin_assets($hook) {
        if ($hook !== 'settings_page_osmea-users-manager') {
            return;
        }
        
        wp_enqueue_style(
            'osmea-users-manager-admin',
            OSMEA_USERS_MANAGER_PLUGIN_URL . 'assets/admin.css',
            array(),
            OSMEA_USERS_MANAGER_VERSION
        );
    }
    
    /**
     * Render admin page
     */
    public function render_admin_page() {
        if (!current_user_can('manage_options')) {
            wp_die(__('You do not have permission to access this page.', 'osmea-users-manager'));
        }
        
        global $wpdb;
        
        // Get WordPress user statistics
        $total_wp_users = count_users();
        $total_wp_users_count = $total_wp_users['total_users'];
        
        // Get plugin statistics
        $metadata_table = $wpdb->prefix . 'osmea_user_metadata';
        $contracts_table = $wpdb->prefix . 'osmea_contract_signatures';
        $addresses_table = $wpdb->prefix . 'osmea_user_addresses';
        $preferences_table = $wpdb->prefix . 'osmea_user_preferences';
        $activity_table = $wpdb->prefix . 'osmea_user_activity';
        
        $total_metadata = $wpdb->get_var("SELECT COUNT(*) FROM $metadata_table");
        $total_contracts = $wpdb->get_var("SELECT COUNT(*) FROM $contracts_table");
        $total_addresses = $wpdb->get_var("SELECT COUNT(*) FROM $addresses_table");
        $total_preferences = $wpdb->get_var("SELECT COUNT(*) FROM $preferences_table");
        $total_activities = $wpdb->get_var("SELECT COUNT(*) FROM $activity_table");
        
        $unique_users_metadata = $wpdb->get_var("SELECT COUNT(DISTINCT user_id) FROM $metadata_table");
        $unique_users_contracts = $wpdb->get_var("SELECT COUNT(DISTINCT user_id) FROM $contracts_table");
        $unique_users_addresses = $wpdb->get_var("SELECT COUNT(DISTINCT user_id) FROM $addresses_table");
        $unique_users_preferences = $wpdb->get_var("SELECT COUNT(DISTINCT user_id) FROM $preferences_table");
        
        // Get WooCommerce orders count if available
        $total_orders = 0;
        if (class_exists('WooCommerce')) {
            $orders_count = $wpdb->get_var("SELECT COUNT(*) FROM {$wpdb->prefix}posts WHERE post_type = 'shop_order' AND post_status != 'trash'");
            $total_orders = (int) $orders_count;
        }
        
        ?>
        <div class="wrap osmea-users-manager-wrap">
            <h1><?php echo esc_html(get_admin_page_title()); ?></h1>
            
            <div class="notice notice-info">
                <p>
                    <strong><?php _e('Direct URL:', 'osmea-users-manager'); ?></strong>
                    <code><?php echo esc_url(admin_url('options-general.php?page=osmea-users-manager')); ?></code>
                </p>
            </div>
            
            <div class="osmea-users-stats">
                <div class="stat-box">
                    <h3><?php _e('WordPress Users', 'osmea-users-manager'); ?></h3>
                    <p class="stat-number"><?php echo esc_html($total_wp_users_count); ?></p>
                    <p class="stat-label"><?php _e('Total registered users', 'osmea-users-manager'); ?></p>
                </div>
                
                <div class="stat-box">
                    <h3><?php _e('User Metadata', 'osmea-users-manager'); ?></h3>
                    <p class="stat-number"><?php echo esc_html($total_metadata); ?></p>
                    <p class="stat-label"><?php printf(__('Across %d users', 'osmea-users-manager'), $unique_users_metadata); ?></p>
                </div>
                
                <div class="stat-box">
                    <h3><?php _e('Contract Signatures', 'osmea-users-manager'); ?></h3>
                    <p class="stat-number"><?php echo esc_html($total_contracts); ?></p>
                    <p class="stat-label"><?php printf(__('From %d users', 'osmea-users-manager'), $unique_users_contracts); ?></p>
                </div>
                
                <div class="stat-box">
                    <h3><?php _e('User Addresses', 'osmea-users-manager'); ?></h3>
                    <p class="stat-number"><?php echo esc_html($total_addresses); ?></p>
                    <p class="stat-label"><?php printf(__('From %d users', 'osmea-users-manager'), $unique_users_addresses); ?></p>
                </div>
                
                <?php if ($total_orders > 0) { ?>
                <div class="stat-box">
                    <h3><?php _e('WooCommerce Orders', 'osmea-users-manager'); ?></h3>
                    <p class="stat-number"><?php echo esc_html($total_orders); ?></p>
                    <p class="stat-label"><?php _e('Total orders', 'osmea-users-manager'); ?></p>
                </div>
                <?php } ?>
            </div>
            
            <div class="osmea-users-info">
                <h2><?php _e('REST API Endpoints', 'osmea-users-manager'); ?></h2>
                <p class="description"><?php _e('The plugin provides the following REST API endpoints for authenticated users:', 'osmea-users-manager'); ?></p>
                
                <h3><?php _e('User Metadata', 'osmea-users-manager'); ?></h3>
                <ul>
                    <li><code>GET /wp-json/osmea-users/v1/metadata</code> - Get all user metadata</li>
                    <li><code>POST /wp-json/osmea-users/v1/metadata</code> - Update user metadata</li>
                    <li><code>DELETE /wp-json/osmea-users/v1/metadata/{key}</code> - Delete specific metadata</li>
                </ul>
                
                <h3><?php _e('Orders', 'osmea-users-manager'); ?></h3>
                <ul>
                    <li><code>GET /wp-json/osmea-users/v1/orders</code> - Get user orders (requires WooCommerce)</li>
                    <li><code>GET /wp-json/osmea-users/v1/orders/{id}</code> - Get single order details</li>
                </ul>
                
                <h3><?php _e('Contract Signatures', 'osmea-users-manager'); ?></h3>
                <ul>
                    <li><code>GET /wp-json/osmea-users/v1/contracts</code> - Get user contract signatures</li>
                    <li><code>POST /wp-json/osmea-users/v1/contracts</code> - Create new contract signature</li>
                    <li><code>GET /wp-json/osmea-users/v1/contracts/{id}</code> - Get single contract details</li>
                </ul>
                
                <h3><?php _e('User Profile', 'osmea-users-manager'); ?></h3>
                <ul>
                    <li><code>GET /wp-json/osmea-users/v1/profile</code> - Get user profile summary</li>
                    <li><code>PUT /wp-json/osmea-users/v1/profile</code> - Update user profile</li>
                </ul>
                
                <h3><?php _e('Dashboard', 'osmea-users-manager'); ?></h3>
                <ul>
                    <li><code>GET /wp-json/osmea-users/v1/dashboard</code> - Get all user data in one request (profile, metadata, addresses, preferences, orders, activities, statistics)</li>
                </ul>
                
                <h3><?php _e('User Addresses', 'osmea-users-manager'); ?></h3>
                <ul>
                    <li><code>GET /wp-json/osmea-users/v1/addresses</code> - Get user addresses</li>
                    <li><code>POST /wp-json/osmea-users/v1/addresses</code> - Create new address</li>
                    <li><code>PUT /wp-json/osmea-users/v1/addresses/{id}</code> - Update address</li>
                    <li><code>DELETE /wp-json/osmea-users/v1/addresses/{id}</code> - Delete address</li>
                    <li><code>POST /wp-json/osmea-users/v1/addresses/{id}/set-default</code> - Set default address</li>
                </ul>
                
                <h3><?php _e('User Preferences', 'osmea-users-manager'); ?></h3>
                <ul>
                    <li><code>GET /wp-json/osmea-users/v1/preferences</code> - Get user preferences</li>
                    <li><code>POST /wp-json/osmea-users/v1/preferences</code> - Update user preferences</li>
                </ul>
                
                <h3><?php _e('User Activity', 'osmea-users-manager'); ?></h3>
                <ul>
                    <li><code>GET /wp-json/osmea-users/v1/activity</code> - Get user activity logs</li>
                    <li><code>POST /wp-json/osmea-users/v1/activity</code> - Log user activity</li>
                </ul>
                
                <h3><?php _e('Statistics', 'osmea-users-manager'); ?></h3>
                <ul>
                    <li><code>GET /wp-json/osmea-users/v1/statistics</code> - Get user statistics</li>
                </ul>
                
                <h3><?php _e('Admin Endpoints (Manage All Users)', 'osmea-users-manager'); ?></h3>
                <ul>
                    <li><code>GET /wp-json/osmea-users/v1/admin/users</code> - Get all WordPress users (paginated, searchable)</li>
                    <li><code>GET /wp-json/osmea-users/v1/admin/users/{id}</code> - Get specific user details</li>
                    <li><code>GET /wp-json/osmea-users/v1/admin/users/{id}/metadata</code> - Get user metadata (admin)</li>
                    <li><code>POST /wp-json/osmea-users/v1/admin/users/{id}/metadata</code> - Update user metadata (admin)</li>
                    <li><code>DELETE /wp-json/osmea-users/v1/admin/users/{id}/metadata/{key}</code> - Delete user metadata (admin)</li>
                    <li><code>GET /wp-json/osmea-users/v1/admin/users/{id}/dashboard</code> - Get complete user dashboard (admin)</li>
                </ul>
            </div>
        </div>
        <?php
    }
    
    /**
     * Get all WordPress users (Admin only)
     */
    public function get_all_users($request) {
        $page = $request->get_param('page');
        $per_page = $request->get_param('per_page');
        $search = $request->get_param('search');
        $role = $request->get_param('role');
        
        $args = array(
            'number' => $per_page,
            'offset' => ($page - 1) * $per_page,
            'orderby' => 'registered',
            'order' => 'DESC',
        );
        
        if (!empty($search)) {
            $args['search'] = '*' . esc_attr($search) . '*';
            $args['search_columns'] = array('user_login', 'user_email', 'display_name', 'user_nicename');
        }
        
        if (!empty($role)) {
            $args['role'] = $role;
        }
        
        $user_query = new WP_User_Query($args);
        $users = $user_query->get_results();
        
        // Get total count
        $total_args = $args;
        $total_args['number'] = -1;
        $total_query = new WP_User_Query($total_args);
        $total_users = $total_query->get_total();
        
        $users_data = array();
        foreach ($users as $user) {
            global $wpdb;
            $metadata_table = $wpdb->prefix . 'osmea_user_metadata';
            $metadata_count = $wpdb->get_var($wpdb->prepare(
                "SELECT COUNT(*) FROM $metadata_table WHERE user_id = %d",
                $user->ID
            ));
            
            $users_data[] = array(
                'id' => $user->ID,
                'username' => $user->user_login,
                'email' => $user->user_email,
                'display_name' => $user->display_name,
                'first_name' => get_user_meta($user->ID, 'first_name', true),
                'last_name' => get_user_meta($user->ID, 'last_name', true),
                'roles' => $user->roles,
                'registered_at' => $user->user_registered,
                'metadata_count' => (int) $metadata_count,
            );
        }
        
        return rest_ensure_response(array(
            'users' => $users_data,
            'pagination' => array(
                'total' => (int) $total_users,
                'per_page' => $per_page,
                'current_page' => $page,
                'total_pages' => ceil($total_users / $per_page),
            ),
        ));
    }
    
    /**
     * Get user by ID (Admin only)
     */
    public function get_user_by_id($request) {
        $user_id = (int) $request->get_param('id');
        $user = get_userdata($user_id);
        
        if (!$user) {
            return new WP_Error('user_not_found', __('User not found.', 'osmea-users-manager'), array('status' => 404));
        }
        
        global $wpdb;
        $metadata_table = $wpdb->prefix . 'osmea_user_metadata';
        $metadata_count = $wpdb->get_var($wpdb->prepare(
            "SELECT COUNT(*) FROM $metadata_table WHERE user_id = %d",
            $user_id
        ));
        
        return rest_ensure_response(array(
            'id' => $user_id,
            'username' => $user->user_login,
            'email' => $user->user_email,
            'display_name' => $user->display_name,
            'first_name' => get_user_meta($user_id, 'first_name', true),
            'last_name' => get_user_meta($user_id, 'last_name', true),
            'nickname' => get_user_meta($user_id, 'nickname', true),
            'roles' => $user->roles,
            'registered_at' => $user->user_registered,
            'metadata_count' => (int) $metadata_count,
        ));
    }
    
    /**
     * Get user metadata (Admin - for any user)
     */
    public function get_user_metadata_admin($request) {
        $user_id = (int) $request->get_param('id');
        
        if (!get_userdata($user_id)) {
            return new WP_Error('user_not_found', __('User not found.', 'osmea-users-manager'), array('status' => 404));
        }
        
        global $wpdb;
        $metadata_table = $wpdb->prefix . 'osmea_user_metadata';
        
        $results = $wpdb->get_results($wpdb->prepare(
            "SELECT meta_key, meta_value, updated_at FROM $metadata_table WHERE user_id = %d ORDER BY updated_at DESC",
            $user_id
        ), ARRAY_A);
        
        $metadata = array();
        foreach ($results as $row) {
            $metadata[$row['meta_key']] = array(
                'value' => maybe_unserialize($row['meta_value']),
                'updated_at' => $row['updated_at'],
            );
        }
        
        return rest_ensure_response(array(
            'user_id' => $user_id,
            'metadata' => $metadata,
            'count' => count($metadata),
        ));
    }
    
    /**
     * Update user metadata (Admin - for any user)
     */
    public function update_user_metadata_admin($request) {
        $user_id = (int) $request->get_param('id');
        
        if (!get_userdata($user_id)) {
            return new WP_Error('user_not_found', __('User not found.', 'osmea-users-manager'), array('status' => 404));
        }
        
        $params = $request->get_json_params();
        if (empty($params) || !is_array($params)) {
            return new WP_Error('invalid_data', __('Invalid data provided.', 'osmea-users-manager'), array('status' => 400));
        }
        
        global $wpdb;
        $metadata_table = $wpdb->prefix . 'osmea_user_metadata';
        
        $updated = array();
        $errors = array();
        
        foreach ($params as $key => $value) {
            if (!preg_match('/^[a-zA-Z0-9_-]+$/', $key)) {
                $errors[] = sprintf(__('Invalid meta key: %s', 'osmea-users-manager'), $key);
                continue;
            }
            
            $meta_value = maybe_serialize($value);
            
            $result = $wpdb->replace(
                $metadata_table,
                array(
                    'user_id' => $user_id,
                    'meta_key' => sanitize_text_field($key),
                    'meta_value' => $meta_value,
                ),
                array('%d', '%s', '%s')
            );
            
            if ($result !== false) {
                $updated[] = $key;
            } else {
                $errors[] = sprintf(__('Failed to update meta key: %s', 'osmea-users-manager'), $key);
            }
        }
        
        if (!empty($errors)) {
            return new WP_Error('update_partial', __('Some metadata could not be updated.', 'osmea-users-manager'), array(
                'status' => 207,
                'updated' => $updated,
                'errors' => $errors,
            ));
        }
        
        return rest_ensure_response(array(
            'success' => true,
            'updated' => $updated,
            'message' => __('Metadata updated successfully.', 'osmea-users-manager'),
        ));
    }
    
    /**
     * Delete user metadata (Admin - for any user)
     */
    public function delete_user_metadata_admin($request) {
        $user_id = (int) $request->get_param('id');
        $key = $request->get_param('key');
        
        if (!get_userdata($user_id)) {
            return new WP_Error('user_not_found', __('User not found.', 'osmea-users-manager'), array('status' => 404));
        }
        
        if (empty($key)) {
            return new WP_Error('invalid_key', __('Meta key is required.', 'osmea-users-manager'), array('status' => 400));
        }
        
        global $wpdb;
        $metadata_table = $wpdb->prefix . 'osmea_user_metadata';
        
        $deleted = $wpdb->delete(
            $metadata_table,
            array(
                'user_id' => $user_id,
                'meta_key' => sanitize_text_field($key),
            ),
            array('%d', '%s')
        );
        
        if ($deleted === false) {
            return new WP_Error('delete_failed', __('Failed to delete metadata.', 'osmea-users-manager'), array('status' => 500));
        }
        
        return rest_ensure_response(array(
            'success' => true,
            'message' => __('Metadata deleted successfully.', 'osmea-users-manager'),
        ));
    }
    
    /**
     * Get user dashboard (Admin - for any user)
     */
    public function get_user_dashboard_admin($request) {
        $user_id = (int) $request->get_param('id');
        $user = get_userdata($user_id);
        
        if (!$user) {
            return new WP_Error('user_not_found', __('User not found.', 'osmea-users-manager'), array('status' => 404));
        }
        
        $include_orders = $request->get_param('include_orders');
        $orders_limit = $request->get_param('orders_limit');
        $include_activity = $request->get_param('include_activity');
        $activity_limit = $request->get_param('activity_limit');
        
        global $wpdb;
        
        // Get profile information
        $profile = array(
            'user_id' => $user_id,
            'username' => $user->user_login,
            'email' => $user->user_email,
            'display_name' => $user->display_name,
            'first_name' => get_user_meta($user_id, 'first_name', true),
            'last_name' => get_user_meta($user_id, 'last_name', true),
            'nickname' => get_user_meta($user_id, 'nickname', true),
            'roles' => $user->roles,
            'registered_at' => $user->user_registered,
        );
        
        // Get metadata
        $metadata_table = $wpdb->prefix . 'osmea_user_metadata';
        $metadata_results = $wpdb->get_results($wpdb->prepare(
            "SELECT meta_key, meta_value, updated_at FROM $metadata_table WHERE user_id = %d ORDER BY updated_at DESC",
            $user_id
        ), ARRAY_A);
        
        $metadata = array();
        foreach ($metadata_results as $row) {
            $metadata[$row['meta_key']] = array(
                'value' => maybe_unserialize($row['meta_value']),
                'updated_at' => $row['updated_at'],
            );
        }
        
        // Get addresses
        $addresses_table = $wpdb->prefix . 'osmea_user_addresses';
        $addresses_results = $wpdb->get_results($wpdb->prepare(
            "SELECT * FROM $addresses_table WHERE user_id = %d ORDER BY is_default DESC, created_at DESC",
            $user_id
        ), ARRAY_A);
        
        $addresses = array();
        foreach ($addresses_results as $row) {
            $addresses[] = array(
                'id' => (int) $row['id'],
                'address_type' => $row['address_type'],
                'label' => $row['label'],
                'first_name' => $row['first_name'],
                'last_name' => $row['last_name'],
                'company' => $row['company'],
                'address_1' => $row['address_1'],
                'address_2' => $row['address_2'],
                'city' => $row['city'],
                'state' => $row['state'],
                'postcode' => $row['postcode'],
                'country' => $row['country'],
                'email' => $row['email'],
                'phone' => $row['phone'],
                'is_default' => (bool) $row['is_default'],
                'created_at' => $row['created_at'],
                'updated_at' => $row['updated_at'],
            );
        }
        
        // Get preferences
        $preferences_table = $wpdb->prefix . 'osmea_user_preferences';
        $preferences_results = $wpdb->get_results($wpdb->prepare(
            "SELECT preference_key, preference_value, updated_at FROM $preferences_table WHERE user_id = %d ORDER BY updated_at DESC",
            $user_id
        ), ARRAY_A);
        
        $preferences = array();
        foreach ($preferences_results as $row) {
            $preferences[$row['preference_key']] = array(
                'value' => maybe_unserialize($row['preference_value']),
                'updated_at' => $row['updated_at'],
            );
        }
        
        // Get contracts
        $contracts_table = $wpdb->prefix . 'osmea_contract_signatures';
        $contracts_results = $wpdb->get_results($wpdb->prepare(
            "SELECT * FROM $contracts_table WHERE user_id = %d ORDER BY signed_at DESC",
            $user_id
        ), ARRAY_A);
        
        $contracts = array();
        foreach ($contracts_results as $row) {
            $contracts[] = array(
                'id' => (int) $row['id'],
                'contract_type' => $row['contract_type'],
                'contract_title' => $row['contract_title'],
                'signed_at' => $row['signed_at'],
            );
        }
        
        // Get recent orders (if WooCommerce is active and requested)
        $orders = array();
        if ($include_orders && class_exists('WooCommerce')) {
            $wc_orders = wc_get_orders(array(
                'customer_id' => $user_id,
                'limit' => $orders_limit,
                'orderby' => 'date',
                'order' => 'DESC',
            ));
            
            foreach ($wc_orders as $order) {
                $orders[] = $this->format_order_data($order, false);
            }
        }
        
        // Get recent activity (if requested)
        $activities = array();
        if ($include_activity) {
            $activity_table = $wpdb->prefix . 'osmea_user_activity';
            $activity_results = $wpdb->get_results($wpdb->prepare(
                "SELECT * FROM $activity_table WHERE user_id = %d ORDER BY created_at DESC LIMIT %d",
                $user_id,
                $activity_limit
            ), ARRAY_A);
            
            foreach ($activity_results as $row) {
                $activities[] = array(
                    'id' => (int) $row['id'],
                    'activity_type' => $row['activity_type'],
                    'activity_description' => $row['activity_description'],
                    'ip_address' => $row['ip_address'],
                    'metadata' => maybe_unserialize($row['metadata']),
                    'created_at' => $row['created_at'],
                );
            }
        }
        
        // Get statistics
        $stats = $this->get_user_statistics_internal($user_id);
        
        return rest_ensure_response(array(
            'profile' => $profile,
            'metadata' => $metadata,
            'addresses' => $addresses,
            'preferences' => $preferences,
            'contracts' => $contracts,
            'orders' => $orders,
            'activities' => $activities,
            'statistics' => $stats,
        ));
    }
}

// Initialize plugin
function osmea_users_manager_init() {
    return OSMEA_Users_Manager::get_instance();
}

// Start the plugin
add_action('plugins_loaded', 'osmea_users_manager_init');
