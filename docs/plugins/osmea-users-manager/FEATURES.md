# OSMEA Users Manager - Features Overview

Complete list of features and capabilities.

## 🎯 Core Features

### 1. User Metadata Management
Store and manage custom user metadata with key-value pairs.

**Use Cases:**
- User preferences (language, theme, etc.)
- Custom user fields
- Application-specific data
- Integration data

**API Endpoints:**
- `GET /metadata` - Get all metadata
- `POST /metadata` - Update metadata
- `DELETE /metadata/{key}` - Delete specific metadata

---

### 2. Order Management (WooCommerce)
Comprehensive order listing and details for authenticated users.

**Features:**
- List all user orders with pagination
- Filter by order status
- Detailed order information
- Line items, billing, shipping addresses
- Order totals and payment information

**API Endpoints:**
- `GET /orders` - List orders
- `GET /orders/{id}` - Get order details

**Requirements:**
- WooCommerce plugin must be installed and active

---

### 3. Contract Signature Tracking
Track and manage contract signatures with full audit trail.

**Features:**
- Multiple contract types
- Signature data storage
- IP address and user agent logging
- Contract content storage
- Timestamp tracking

**API Endpoints:**
- `GET /contracts` - List contracts
- `POST /contracts` - Create signature
- `GET /contracts/{id}` - Get contract details

**Use Cases:**
- Terms and conditions acceptance
- Privacy policy consent
- Service agreements
- Legal document signatures

---

### 4. User Address Management
Manage multiple billing and shipping addresses per user.

**Features:**
- Multiple addresses per user
- Billing and shipping address types
- Default address support
- Address labels (Home, Work, etc.)
- Full address fields (name, company, address, city, state, postcode, country, email, phone)

**API Endpoints:**
- `GET /addresses` - List addresses
- `POST /addresses` - Create address
- `PUT /addresses/{id}` - Update address
- `DELETE /addresses/{id}` - Delete address
- `POST /addresses/{id}/set-default` - Set default address

**Use Cases:**
- Multiple shipping addresses
- Billing address management
- Address book functionality
- Checkout address selection

---

### 5. User Preferences
Store and manage user preferences and settings.

**Features:**
- Key-value preference storage
- Support for complex data types (arrays, objects)
- Automatic serialization
- Update tracking

**API Endpoints:**
- `GET /preferences` - Get all preferences
- `POST /preferences` - Update preferences

**Use Cases:**
- Language preferences
- Theme settings
- Notification preferences
- Display preferences
- Application settings

---

### 6. Activity Logging
Track user activities with detailed logging.

**Features:**
- Activity type classification
- IP address tracking
- User agent logging
- Custom metadata support
- Pagination support

**API Endpoints:**
- `GET /activity` - Get activity logs
- `POST /activity` - Log new activity

**Use Cases:**
- Security auditing
- User behavior tracking
- Analytics
- Debugging
- Compliance logging

---

### 7. User Statistics
Comprehensive statistics and analytics for users.

**Features:**
- Metadata count
- Orders count and totals
- Contracts count
- Addresses count
- Preferences count
- Activity count
- Orders by status breakdown

**API Endpoints:**
- `GET /statistics` - Get all statistics

**Use Cases:**
- Dashboard widgets
- Analytics
- Reporting
- User insights

---

### 8. User Profile
Get user profile summary with statistics.

**Features:**
- Basic user information
- Registration date
- Quick statistics overview

**API Endpoints:**
- `GET /profile` - Get profile summary

---

## 🗄️ Database Structure

### Tables Created

1. **`wp_osmea_user_metadata`** - User metadata storage
2. **`wp_osmea_contract_signatures`** - Contract signatures
3. **`wp_osmea_user_addresses`** - User addresses
4. **`wp_osmea_user_activity`** - Activity logs
5. **`wp_osmea_user_preferences`** - User preferences

All tables use WordPress database prefix and follow WordPress coding standards.

---

## 🔒 Security Features

- **Authentication Required** - All endpoints require user authentication
- **User Isolation** - Users can only access their own data
- **Input Sanitization** - All inputs are sanitized
- **SQL Injection Protection** - Uses WordPress prepared statements
- **XSS Protection** - All outputs are escaped
- **IP Logging** - Contract signatures and activities include IP addresses
- **User Agent Tracking** - For audit and security purposes

---

## 🎨 MasterFabric Theme Compatibility

- **No Conflicts** - Does not interfere with theme functionality
- **Standard WordPress Hooks** - Uses standard WordPress hooks
- **Database Prefix** - Uses WordPress database prefix
- **REST API** - Uses standard WordPress REST API
- **No Theme Dependencies** - Works independently

---

## 📊 Admin Dashboard

WordPress admin panel includes:

- **Statistics Overview** - Quick stats for metadata and contracts
- **API Documentation** - Complete endpoint list
- **User Counts** - Number of users using each feature

**Location:** Settings > OSMEA Users

---

## 🔌 Integration Examples

### WooCommerce Integration

The plugin automatically integrates with WooCommerce:
- Orders are fetched directly from WooCommerce
- No duplicate data storage
- Real-time order information
- Full order details available

### Custom Integration

```php
// Log user activity
wp_remote_post(
    rest_url('osmea-users/v1/activity'),
    array(
        'headers' => array(
            'Authorization' => 'Bearer ' . wp_get_session_token(),
            'Content-Type' => 'application/json',
        ),
        'body' => json_encode(array(
            'activity_type' => 'custom_action',
            'activity_description' => 'User performed custom action',
            'metadata' => array(
                'custom_field' => 'value',
            ),
        )),
    )
);
```

---

## 📈 Performance Considerations

- **Efficient Queries** - Uses indexed database columns
- **Pagination** - All list endpoints support pagination
- **Caching Ready** - Responses can be cached
- **Minimal Overhead** - Lightweight database structure

---

## 🚀 Future Enhancements

Potential future features:
- File uploads for user documents
- User groups and tags
- Advanced analytics
- Export functionality
- Webhook support
- Real-time notifications

---

## 📝 Notes

- All timestamps are in MySQL DATETIME format
- All monetary values use WooCommerce currency settings
- IP addresses are stored in IPv4/IPv6 compatible format
- Metadata and preferences support serialized data

---

For complete API documentation, see [API.md](API.md)
