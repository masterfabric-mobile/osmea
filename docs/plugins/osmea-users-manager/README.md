# OSMEA Users Manager

WordPress plugin for comprehensive user management, including user metadata storage, order listing, and contract signature tracking. Fully compatible with MasterFabric theme.

## 📋 Table of Contents

- [Features](#features)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage](#usage)
- [REST API](#rest-api)
- [Database Structure](#database-structure)
- [WooCommerce Integration](#woocommerce-integration)
- [MasterFabric Theme Compatibility](#masterfabric-theme-compatibility)
- [Security](#security)
- [Troubleshooting](#troubleshooting)
- [File Structure](#file-structure)
- [Requirements](#requirements)
- [License & Support](#license--support)

## ✨ Features

- ✅ **User Metadata Management** - Store and retrieve custom user metadata
- ✅ **Order Listing** - List and view user orders (WooCommerce integration)
- ✅ **Contract Signatures** - Track and manage contract signatures with IP and user agent logging
- ✅ **User Addresses** - Manage billing and shipping addresses with default address support
- ✅ **User Preferences** - Store and manage user preferences (language, theme, notifications, etc.)
- ✅ **Activity Logging** - Track user activities with IP and metadata
- ✅ **Statistics** - Comprehensive user statistics and analytics
- ✅ **REST API** - Full REST API for all features
- ✅ **MasterFabric Compatible** - Designed to work seamlessly with MasterFabric theme
- ✅ **Secure** - All endpoints require user authentication
- ✅ **Admin Dashboard** - Statistics and API documentation in WordPress admin

## 🚀 Quick Start

### Step 1: Download Plugin

The plugin is located at:
```
docs/plugins/osmea-users-manager/
```

**From GitHub:**
1. Navigate to: `https://github.com/masterfabric-mobile/osmea`
2. Go to `docs/plugins/osmea-users-manager/` folder
3. Download the entire folder

### Step 2: Install in WordPress

**Method 1: Upload via WordPress Admin (Recommended)**

1. Create ZIP file from the plugin folder
2. Login to WordPress Admin Panel
3. Go to **Plugins > Add New > Upload Plugin**
4. Select the ZIP file and upload
5. Click **Activate Plugin**

**Method 2: Manual Installation via FTP/SFTP**

1. Extract the plugin folder
2. Upload `osmea-users-manager` folder to `/wp-content/plugins/` directory
3. Activate the plugin through the **Plugins** menu in WordPress

### Step 3: Verify Installation

1. Go to **Settings > OSMEA Users** in WordPress admin
2. Check that statistics are displayed
3. Verify REST API endpoints are available

## 📖 Usage

### User Metadata

Store custom metadata for users:

```javascript
// Store metadata
POST /wp-json/osmea-users/v1/metadata
{
  "preference_language": "en",
  "marketing_consent": true,
  "custom_field": "value"
}

// Retrieve metadata
GET /wp-json/osmea-users/v1/metadata

// Delete specific metadata
DELETE /wp-json/osmea-users/v1/metadata/preference_language
```

### Orders (WooCommerce)

List and view user orders:

```javascript
// Get all orders
GET /wp-json/osmea-users/v1/orders?page=1&per_page=10&status=completed

// Get single order
GET /wp-json/osmea-users/v1/orders/123
```

### Contract Signatures

Track contract signatures:

```javascript
// Create signature
POST /wp-json/osmea-users/v1/contracts
{
  "contract_type": "terms_and_conditions",
  "contract_title": "Terms and Conditions v1.0",
  "contract_content": "Full contract text...",
  "signature_data": {
    "signature": "base64_encoded_signature",
    "timestamp": "2024-01-01T00:00:00Z"
  }
}

// Get all contracts
GET /wp-json/osmea-users/v1/contracts?page=1&per_page=10

// Get single contract
GET /wp-json/osmea-users/v1/contracts/456
```

### User Profile

Get user profile summary:

```javascript
GET /wp-json/osmea-users/v1/profile
```

Update user profile:

```javascript
PUT /wp-json/osmea-users/v1/profile
{
  "first_name": "John",
  "last_name": "Smith",
  "email": "newemail@example.com",
  "billing": {
    "first_name": "John",
    "address_1": "123 Main St",
    "city": "New York",
    "country": "US"
  }
}
```

### Dashboard (All-in-One) - RECOMMENDED

Get all user data in a single request. Perfect for mobile apps and dashboards:

```javascript
// Get everything in one call
GET /wp-json/osmea-users/v1/dashboard?include_orders=true&orders_limit=5

// Response includes:
// - profile (user info)
// - metadata (all metadata)
// - addresses (all addresses)
// - preferences (all preferences)
// - orders (recent orders)
// - activities (recent activities)
// - statistics (all stats)
```

This endpoint eliminates the need for multiple API calls and is optimized for mobile applications.

## 🔌 REST API

**📖 For complete API documentation, see [API.md](API.md)**

### Authentication

All endpoints require user authentication. Use one of these methods:

1. **Cookie Authentication** (for logged-in users in browser)
2. **Application Password** (for external applications)
3. **OAuth 2.0** (if configured)

### Endpoints

#### User Metadata

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/wp-json/osmea-users/v1/metadata` | Get all user metadata |
| POST | `/wp-json/osmea-users/v1/metadata` | Update user metadata |
| DELETE | `/wp-json/osmea-users/v1/metadata/{key}` | Delete specific metadata |

#### Orders

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/wp-json/osmea-users/v1/orders` | Get user orders |
| GET | `/wp-json/osmea-users/v1/orders/{id}` | Get single order |

**Query Parameters:**
- `page` - Page number (default: 1)
- `per_page` - Items per page (default: 10)
- `status` - Order status filter (optional)

#### Contract Signatures

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/wp-json/osmea-users/v1/contracts` | Get user contracts |
| POST | `/wp-json/osmea-users/v1/contracts` | Create contract signature |
| GET | `/wp-json/osmea-users/v1/contracts/{id}` | Get single contract |

**Query Parameters:**
- `page` - Page number (default: 1)
- `per_page` - Items per page (default: 10)
- `contract_type` - Filter by contract type (optional)

#### User Profile

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/wp-json/osmea-users/v1/profile` | Get user profile summary |
| PUT | `/wp-json/osmea-users/v1/profile` | Update user profile (email, name, billing, shipping) |

#### Dashboard (All-in-One)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/wp-json/osmea-users/v1/dashboard` | Get all user data in one request (profile, metadata, addresses, preferences, orders, activities, statistics) |

**Query Parameters:**
- `include_orders` (boolean, default: true) - Include recent orders
- `orders_limit` (int, default: 5) - Number of recent orders
- `include_activity` (boolean, default: true) - Include recent activities
- `activity_limit` (int, default: 10) - Number of recent activities

#### User Addresses

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/wp-json/osmea-users/v1/addresses` | Get user addresses |
| POST | `/wp-json/osmea-users/v1/addresses` | Create new address |
| PUT | `/wp-json/osmea-users/v1/addresses/{id}` | Update address |
| DELETE | `/wp-json/osmea-users/v1/addresses/{id}` | Delete address |
| POST | `/wp-json/osmea-users/v1/addresses/{id}/set-default` | Set default address |

**Query Parameters:**
- `type` - Filter by address type ("billing" or "shipping")

#### User Preferences

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/wp-json/osmea-users/v1/preferences` | Get user preferences |
| POST | `/wp-json/osmea-users/v1/preferences` | Update user preferences |

#### User Activity Logs

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/wp-json/osmea-users/v1/activity` | Get user activity logs |
| POST | `/wp-json/osmea-users/v1/activity` | Log user activity |

**Query Parameters:**
- `page` - Page number (default: 1)
- `per_page` - Items per page (default: 20)
- `type` - Filter by activity type (optional)

#### Statistics

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/wp-json/osmea-users/v1/statistics` | Get comprehensive user statistics |

## 🗄️ Database Structure

### User Metadata Table

Stores custom user metadata:

- `id` - Primary key
- `user_id` - WordPress user ID
- `meta_key` - Metadata key (unique per user)
- `meta_value` - Metadata value (serialized if needed)
- `created_at` - Creation timestamp
- `updated_at` - Last update timestamp

### Contract Signatures Table

Stores contract signatures:

- `id` - Primary key
- `user_id` - WordPress user ID
- `contract_type` - Type of contract (e.g., "terms_and_conditions")
- `contract_title` - Contract title/version
- `contract_content` - Full contract text
- `signature_data` - Signature data (serialized)
- `ip_address` - IP address at signing
- `user_agent` - User agent at signing
- `signed_at` - Signature timestamp
- `created_at` - Record creation timestamp

### User Addresses Table

Stores user billing and shipping addresses:

- `id` - Primary key
- `user_id` - WordPress user ID
- `address_type` - Type of address ("billing" or "shipping")
- `label` - Address label (e.g., "Home", "Work")
- `first_name`, `last_name` - Name fields
- `company` - Company name
- `address_1`, `address_2` - Address lines
- `city`, `state`, `postcode`, `country` - Location fields
- `email`, `phone` - Contact fields
- `is_default` - Whether this is the default address for its type
- `created_at`, `updated_at` - Timestamps

### User Activity Table

Stores user activity logs:

- `id` - Primary key
- `user_id` - WordPress user ID
- `activity_type` - Type of activity (e.g., "login", "page_view")
- `activity_description` - Description of the activity
- `ip_address` - IP address
- `user_agent` - User agent string
- `metadata` - Additional metadata (serialized)
- `created_at` - Activity timestamp

### User Preferences Table

Stores user preferences:

- `id` - Primary key
- `user_id` - WordPress user ID
- `preference_key` - Preference key (unique per user)
- `preference_value` - Preference value (serialized if needed)
- `created_at`, `updated_at` - Timestamps

## 🛒 WooCommerce Integration

The plugin automatically integrates with WooCommerce if installed:

- **Order Listing** - Users can view their orders via REST API
- **Order Details** - Full order information including line items, billing, shipping
- **Order Status Filtering** - Filter orders by status
- **Automatic Sync** - Orders are automatically available via API

### Requirements

- WooCommerce 5.0 or higher
- User must be logged in
- User must be the customer of the order

## 🎨 MasterFabric Theme Compatibility

This plugin is designed to work seamlessly with the MasterFabric theme:

- **No Conflicts** - Does not interfere with theme functionality
- **REST API** - Uses standard WordPress REST API (compatible with theme)
- **Database Tables** - Uses WordPress database prefix (theme-safe)
- **Hooks** - Uses standard WordPress hooks (no theme-specific dependencies)

### Integration Example

```php
// In your theme or custom plugin
add_action('wp_ajax_osmea_get_user_data', function() {
    $user_id = get_current_user_id();
    
    // Get metadata via REST API
    $response = wp_remote_get(
        rest_url('osmea-users/v1/metadata'),
        array(
            'headers' => array(
                'Authorization' => 'Bearer ' . wp_get_session_token(),
            ),
        )
    );
    
    // Process response...
});
```

## 🔒 Security

- **Authentication Required** - All endpoints require user authentication
- **User Isolation** - Users can only access their own data
- **Input Sanitization** - All inputs are sanitized
- **SQL Injection Protection** - Uses WordPress prepared statements
- **XSS Protection** - Outputs are escaped
- **IP Logging** - Contract signatures include IP address for audit

## 🐛 Troubleshooting

### Plugin Not Activating

1. Check PHP version (requires 7.4+)
2. Check WordPress version (requires 5.8+)
3. Check for plugin conflicts
4. Review error logs

### REST API Not Working

1. Verify permalink structure (Settings > Permalinks)
2. Check user authentication
3. Verify REST API is enabled
4. Check for plugin conflicts

### Orders Not Showing

1. Verify WooCommerce is installed and active
2. Check user is logged in
3. Verify user has orders
4. Check order status filter

### Database Tables Not Created

1. Check database permissions
2. Review activation errors
3. Manually run activation hook
4. Check database prefix

## 📁 File Structure

```
osmea-users-manager/
├── osmea-users-manager.php    # Main plugin file
├── assets/
│   └── admin.css              # Admin styles
├── README.md                  # This file
└── API.md                     # Complete REST API documentation
```

## 📋 Requirements

- **WordPress**: 5.8 or higher
- **PHP**: 7.4 or higher
- **MySQL**: 5.6 or higher
- **WooCommerce**: 5.0 or higher (optional, for order features)

## 📝 License & Support

- **License**: GPL v2 or later
- **Author**: MasterFabric Mobile
- **GitHub**: https://github.com/masterfabric-mobile/osmea
- **Support**: Create an issue on GitHub

## 🔄 Changelog

### Version 1.0.0
- Initial release
- User metadata management
- Order listing (WooCommerce integration)
- Contract signature tracking
- User address management (billing/shipping)
- User preferences management
- User activity logging
- Comprehensive statistics
- REST API endpoints
- Admin dashboard
- MasterFabric theme compatibility
- Complete API documentation
