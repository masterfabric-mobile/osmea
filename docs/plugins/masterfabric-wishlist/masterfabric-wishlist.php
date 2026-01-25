<?php
/*
Plugin Name: Masterfabric Wishlist API
Description: Custom REST API endpoints for Wishlist (Groups + Items).
Version: 1.0.0
Author: Masterfabric
*/

if ( ! defined( 'ABSPATH' ) ) {
    exit;
}

/**
 * Plugin activation -> Create DB Tables
 */
register_activation_hook(__FILE__, 'mfw_wishlist_install');
function mfw_wishlist_install() {
    global $wpdb;
    $charset_collate = $wpdb->get_charset_collate();

    $groups_table = $wpdb->prefix . 'mfw_wishlist_groups';
    $items_table  = $wpdb->prefix . 'mfw_wishlist_items';

    require_once(ABSPATH . 'wp-admin/includes/upgrade.php');

    // Groups Table
    $sql1 = "CREATE TABLE $groups_table (
        id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
        user_id BIGINT UNSIGNED NOT NULL,
        name VARCHAR(255) NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (id),
        KEY user_id (user_id)
    ) $charset_collate;";
    dbDelta($sql1);

    // Products Table
    $sql2 = "CREATE TABLE $items_table (
        id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
        group_id BIGINT UNSIGNED NOT NULL,
        product_id BIGINT UNSIGNED NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (id),
        KEY group_id (group_id)
    ) $charset_collate;";
    dbDelta($sql2);
}

/**
 * Default Group Create
 */
function mfw_get_or_create_default_group($user_id) {
    global $wpdb;
    $groups_table = $wpdb->prefix . 'mfw_wishlist_groups';

    $group_id = $wpdb->get_var(
        $wpdb->prepare("SELECT id FROM $groups_table WHERE user_id = %d AND name = %s LIMIT 1", $user_id, 'Default')
    );

    if (!$group_id) {
        $wpdb->insert($groups_table, [
            'user_id' => $user_id,
            'name'    => 'Default',
        ]);
        $group_id = $wpdb->insert_id;
    }

    return $group_id;
}

/**
 * API Records
 */
add_action('rest_api_init', function () {

    // Products List
    register_rest_route('masterfabric-wishlist/v1', '/items', [
        'methods'  => 'GET',
        'callback' => 'mfw_get_wishlist_items',
        'permission_callback' => function () { return is_user_logged_in(); },
        'args' => [
            'page' => ['default' => 1, 'sanitize_callback' => 'absint'],
            'per_page' => ['default' => 10, 'sanitize_callback' => 'absint'],
            'group_id' => ['sanitize_callback' => 'absint'],
        ],
    ]);

    // Group List
    register_rest_route('masterfabric-wishlist/v1', '/groups', [
        'methods'  => 'GET',
        'callback' => 'mfw_get_groups',
        'permission_callback' => function () { return is_user_logged_in(); },
    ]);
    
    // Group Add
    register_rest_route('masterfabric-wishlist/v1', '/group', [
        'methods'  => 'POST',
        'callback' => 'mfw_add_group',
        'permission_callback' => function () { return is_user_logged_in(); },
    ]);

    // Group Edit
    register_rest_route('masterfabric-wishlist/v1', '/group/(?P<id>\d+)', [
        'methods'  => 'PATCH',
        'callback' => 'mfw_edit_group',
        'permission_callback' => function () { return is_user_logged_in(); },
    ]);

    // Group Delete
    register_rest_route('masterfabric-wishlist/v1', '/group/(?P<id>\d+)', [
        'methods'  => 'DELETE',
        'callback' => 'mfw_delete_group',
        'permission_callback' => function () { return is_user_logged_in(); },
    ]);

    // Product add
    register_rest_route('masterfabric-wishlist/v1', '/item', [
        'methods'  => 'POST',
        'callback' => 'mfw_add_item',
        'permission_callback' => function () { return is_user_logged_in(); },
    ]);

    // Product delete
    register_rest_route('masterfabric-wishlist/v1', '/item/(?P<id>\d+)', [
        'methods'  => 'DELETE',
        'callback' => 'mfw_delete_item',
        'permission_callback' => function () { return is_user_logged_in(); },
    ]);
});

/**
 * ITEMS GET
 */
function mfw_get_wishlist_items(WP_REST_Request $request) {
    global $wpdb;
    $user_id = get_current_user_id();

    $page     = max(1, (int) $request->get_param('page'));
    $per_page = max(1, (int) $request->get_param('per_page'));
    $offset   = ($page - 1) * $per_page;

    $groups_table = $wpdb->prefix . 'mfw_wishlist_groups';
    $items_table  = $wpdb->prefix . 'mfw_wishlist_items';

    $group_id = $request->get_param('group_id');
    if (!$group_id) {
        $group_id = mfw_get_or_create_default_group($user_id);
    }

    // Sum
    $total = $wpdb->get_var(
        $wpdb->prepare("SELECT COUNT(*) FROM $items_table WHERE group_id = %d", $group_id)
    );

    // Data
    $results = $wpdb->get_results(
        $wpdb->prepare("SELECT * FROM $items_table WHERE group_id = %d LIMIT %d OFFSET %d", $group_id, $per_page, $offset)
    );

    $items = [];
    foreach ($results as $row) {
        $product = wc_get_product($row->product_id);
        if ($product) {
            $items[] = [
                'id'    => $row->id,
                'product_id' => $product->get_id(),
                'name'  => $product->get_name(),
                'price' => $product->get_price(),
                'link'  => $product->get_permalink(),
                'image' => wp_get_attachment_url($product->get_image_id()),
            ];
        }
    }

    return [
        'items' => $items,
        'pagination' => [
            'total' => (int) $total,
            'per_page' => (int) $per_page,
            'current' => (int) $page,
            'pages' => ceil($total / $per_page),
        ]
    ];
}

/**
 * GROUP LIST
 */
function mfw_get_groups(WP_REST_Request $request) {
    global $wpdb;
    $user_id = get_current_user_id();
    $groups_table = $wpdb->prefix . 'mfw_wishlist_groups';

    $results = $wpdb->get_results(
        $wpdb->prepare("SELECT id, name, created_at FROM $groups_table WHERE user_id = %d ORDER BY id ASC", $user_id)
    );

    return [
        'groups' => $results,
    ];
}

/**
 * GROUP ADD
 */
function mfw_add_group(WP_REST_Request $request) {
    global $wpdb;
    $user_id = get_current_user_id();
    $name = sanitize_text_field($request->get_param('name'));

    if (empty($name)) {
        return new WP_Error('invalid_name', 'Group name is required.', ['status' => 400]);
    }

    $wpdb->insert($wpdb->prefix . 'mfw_wishlist_groups', [
        'user_id' => $user_id,
        'name'    => $name,
    ]);

    return ['success' => true, 'group_id' => $wpdb->insert_id];
}

/**
 * GROUP EDIT
 */
function mfw_edit_group(WP_REST_Request $request) {
    global $wpdb;
    $user_id = get_current_user_id();
    $group_id = (int) $request['id'];
    $name = sanitize_text_field($request->get_param('name'));

    if (empty($name)) {
        return new WP_Error('invalid_name', 'Group name is required.', ['status' => 400]);
    }

    // Default group can not edit
    $default_group = mfw_get_or_create_default_group($user_id);
    if ($group_id === (int)$default_group) {
        return new WP_Error('cannot_edit_default', 'Default group cannot be renamed.', ['status' => 400]);
    }

    $wpdb->update(
        $wpdb->prefix . 'mfw_wishlist_groups',
        ['name' => $name],
        ['id' => $group_id, 'user_id' => $user_id]
    );

    return ['success' => true, 'group_id' => $group_id, 'name' => $name];
}

/**
 * GROUP DELETE
 */
function mfw_delete_group(WP_REST_Request $request) {
    global $wpdb;
    $user_id = get_current_user_id();
    $id = (int) $request['id'];

    // Default group can not delete
    $default_group = mfw_get_or_create_default_group($user_id);
    if ($id === (int)$default_group) {
        return new WP_Error('cannot_delete_default', 'Default group cannot be deleted.', ['status' => 400]);
    }

    $wpdb->delete($wpdb->prefix . 'mfw_wishlist_groups', ['id' => $id, 'user_id' => $user_id]);
    $wpdb->delete($wpdb->prefix . 'mfw_wishlist_items', ['group_id' => $id]);

    return ['success' => true];
}

/**
 * ITEM ADD
 */
function mfw_add_item(WP_REST_Request $request) {
    global $wpdb;
    $user_id = get_current_user_id();
    $product_id = absint($request->get_param('product_id'));
    $group_id   = absint($request->get_param('group_id'));

    if (!$group_id) {
        $group_id = mfw_get_or_create_default_group($user_id);
    }

    // duplicate control
    $exists = $wpdb->get_var($wpdb->prepare(
        "SELECT id FROM {$wpdb->prefix}mfw_wishlist_items WHERE group_id = %d AND product_id = %d LIMIT 1",
        $group_id, $product_id
    ));
    if ($exists) {
        return new WP_Error('duplicate_item', 'Product already in wishlist.', ['status' => 400]);
    }

    $wpdb->insert($wpdb->prefix . 'mfw_wishlist_items', [
        'group_id'   => $group_id,
        'product_id' => $product_id,
    ]);

    return ['success' => true, 'item_id' => $wpdb->insert_id];
}

/**
 * ITEM DELETE
 */
function mfw_delete_item(WP_REST_Request $request) {
    global $wpdb;
    $id = (int) $request['id'];

    $wpdb->delete($wpdb->prefix . 'mfw_wishlist_items', ['id' => $id]);

    return ['success' => true];
}
