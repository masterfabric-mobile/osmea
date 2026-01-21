# OSMEA Users Manager - REST API Documentation

Complete REST API documentation for OSMEA Users Manager plugin.

## Base URL

All endpoints are prefixed with:
```
/wp-json/osmea-users/v1
```

## Authentication

All endpoints require user authentication. Use one of these methods:

1. **JWT Authentication** (Önerilen - Mobil uygulamalar için)
2. **Cookie Authentication** (Browser için - WordPress'e login olmuş kullanıcılar)
3. **Application Password** (WordPress 5.6+ - External applications için)

### JWT Authentication (Önerilen)

WordPress JWT Authentication plugin'i kurulu olmalı. JWT token ile authentication:

**1. JWT Token Alın:**
```bash
curl -X POST \
  'https://your-site.com/wp-json/jwt-auth/v1/token' \
  -H 'Content-Type: application/json' \
  -d '{
    "username": "your_username",
    "password": "your_password"
  }'
```

**Response:**
```json
{
  "token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "user_email": "user@example.com",
  "user_nicename": "username",
  "user_display_name": "Display Name"
}
```

**2. Token'ı Kullanın:**
```
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGc...
```

**JWT Plugin Kurulumu:**
1. WordPress Admin > Plugins > Add New
2. "JWT Authentication for WP REST API" arayın ve kurun
3. `wp-config.php` dosyasına ekleyin:
```php
define('JWT_AUTH_SECRET_KEY', 'your-secret-key-here');
define('JWT_AUTH_CORS_ENABLE', true);
```

### Cookie Authentication

WordPress'e login olduğunuzda cookie otomatik olarak gönderilir. Browser'da çalışır.

### Application Password

WordPress 5.6+ için Application Password kullanılabilir:

**1. Application Password Oluşturun:**
- WordPress Admin > Users > Your Profile
- "Application Passwords" bölümüne gidin
- Yeni password oluşturun

**2. Base64 Encode:**
```bash
echo -n "username:application_password" | base64
```

**3. Kullanın:**
```
Authorization: Basic dXNlcm5hbWU6YXBwbGljYXRpb25fcGFzc3dvcmQ=
```

---

## Endpoints

### 1. User Metadata

#### GET `/metadata`

Get all metadata for the authenticated user.

**Response:**
```json
{
  "user_id": 123,
  "metadata": {
    "preference_language": {
      "value": "en",
      "updated_at": "2024-01-01 12:00:00"
    },
    "marketing_consent": {
      "value": true,
      "updated_at": "2024-01-01 12:00:00"
    }
  },
  "count": 2
}
```

#### POST `/metadata`

Update user metadata. Accepts multiple key-value pairs.

**Request Body:**
```json
{
  "preference_language": "en",
  "marketing_consent": true,
  "custom_field": "value"
}
```

**Response:**
```json
{
  "success": true,
  "updated": ["preference_language", "marketing_consent", "custom_field"],
  "message": "Metadata updated successfully."
}
```

#### DELETE `/metadata/{key}`

Delete specific metadata key.

**Response:**
```json
{
  "success": true,
  "message": "Metadata deleted successfully."
}
```

---

### 2. Orders (WooCommerce)

#### GET `/orders`

Get user orders with pagination and filtering.

**Query Parameters:**
- `page` (int, default: 1) - Page number
- `per_page` (int, default: 10) - Items per page
- `status` (string, optional) - Filter by order status (e.g., "completed", "pending")

**Response:**
```json
{
  "orders": [
    {
      "id": 456,
      "order_number": "12345",
      "status": "completed",
      "date_created": "2024-01-01 12:00:00",
      "total": "99.99",
      "currency": "USD",
      "payment_method": "Credit Card"
    }
  ],
  "pagination": {
    "total": 25,
    "per_page": 10,
    "current_page": 1,
    "total_pages": 3
  }
}
```

#### GET `/orders/{id}`

Get detailed information about a specific order.

**Response:**
```json
{
  "id": 456,
  "order_number": "12345",
  "status": "completed",
  "date_created": "2024-01-01 12:00:00",
  "total": "99.99",
  "currency": "USD",
  "payment_method": "Credit Card",
  "billing": {
    "first_name": "John",
    "last_name": "Doe",
    "company": "",
    "address_1": "123 Main St",
    "address_2": "",
    "city": "New York",
    "state": "NY",
    "postcode": "10001",
    "country": "US",
    "email": "john@example.com",
    "phone": "+1234567890"
  },
  "shipping": {
    "first_name": "John",
    "last_name": "Doe",
    "company": "",
    "address_1": "123 Main St",
    "address_2": "",
    "city": "New York",
    "state": "NY",
    "postcode": "10001",
    "country": "US"
  },
  "line_items": [
    {
      "id": 789,
      "name": "Product Name",
      "quantity": 2,
      "subtotal": "80.00",
      "total": "80.00",
      "product_id": 123,
      "product_image": "https://example.com/image.jpg"
    }
  ],
  "totals": {
    "subtotal": "80.00",
    "shipping": "10.00",
    "tax": "9.99",
    "total": "99.99"
  }
}
```

---

### 3. Contract Signatures

#### GET `/contracts`

Get user contract signatures.

**Query Parameters:**
- `page` (int, default: 1) - Page number
- `per_page` (int, default: 10) - Items per page
- `contract_type` (string, optional) - Filter by contract type

**Response:**
```json
{
  "contracts": [
    {
      "id": 1,
      "contract_type": "terms_and_conditions",
      "contract_title": "Terms and Conditions v1.0",
      "contract_content": "Full contract text...",
      "signature_data": {
        "signature": "base64_encoded_signature",
        "timestamp": "2024-01-01T00:00:00Z"
      },
      "ip_address": "192.168.1.1",
      "signed_at": "2024-01-01 12:00:00"
    }
  ],
  "pagination": {
    "total": 5,
    "per_page": 10,
    "current_page": 1,
    "total_pages": 1
  }
}
```

#### POST `/contracts`

Create a new contract signature.

**Request Body:**
```json
{
  "contract_type": "terms_and_conditions",
  "contract_title": "Terms and Conditions v1.0",
  "contract_content": "Full contract text...",
  "signature_data": {
    "signature": "base64_encoded_signature",
    "timestamp": "2024-01-01T00:00:00Z"
  }
}
```

**Response:**
```json
{
  "success": true,
  "contract_id": 1,
  "message": "Contract signature saved successfully."
}
```

#### GET `/contracts/{id}`

Get detailed information about a specific contract.

**Response:**
```json
{
  "id": 1,
  "contract_type": "terms_and_conditions",
  "contract_title": "Terms and Conditions v1.0",
  "contract_content": "Full contract text...",
  "signature_data": {
    "signature": "base64_encoded_signature",
    "timestamp": "2024-01-01T00:00:00Z"
  },
  "ip_address": "192.168.1.1",
  "user_agent": "Mozilla/5.0...",
  "signed_at": "2024-01-01 12:00:00"
}
```

---

### 4. User Addresses

#### GET `/addresses`

Get user addresses.

**Query Parameters:**
- `type` (string, optional) - Filter by address type ("billing" or "shipping")

**Response:**
```json
{
  "addresses": [
    {
      "id": 1,
      "address_type": "billing",
      "label": "Home",
      "first_name": "John",
      "last_name": "Doe",
      "company": "",
      "address_1": "123 Main St",
      "address_2": "",
      "city": "New York",
      "state": "NY",
      "postcode": "10001",
      "country": "US",
      "email": "john@example.com",
      "phone": "+1234567890",
      "is_default": true,
      "created_at": "2024-01-01 12:00:00",
      "updated_at": "2024-01-01 12:00:00"
    }
  ],
  "count": 1
}
```

#### POST `/addresses`

Create a new address.

**Request Body:**
```json
{
  "address_type": "billing",
  "label": "Home",
  "first_name": "John",
  "last_name": "Doe",
  "company": "",
  "address_1": "123 Main St",
  "address_2": "",
  "city": "New York",
  "state": "NY",
  "postcode": "10001",
  "country": "US",
  "email": "john@example.com",
  "phone": "+1234567890",
  "is_default": true
}
```

**Required Fields:**
- `address_type` - "billing" or "shipping"
- `first_name`
- `last_name`
- `address_1`
- `city`
- `country`

**Response:**
```json
{
  "success": true,
  "address_id": 1,
  "message": "Address created successfully."
}
```

#### PUT `/addresses/{id}`

Update an existing address.

**Request Body:**
```json
{
  "label": "Work",
  "address_1": "456 Business Ave",
  "is_default": true
}
```

**Response:**
```json
{
  "success": true,
  "message": "Address updated successfully."
}
```

#### DELETE `/addresses/{id}`

Delete an address.

**Response:**
```json
{
  "success": true,
  "message": "Address deleted successfully."
}
```

#### POST `/addresses/{id}/set-default`

Set an address as default for its type.

**Response:**
```json
{
  "success": true,
  "message": "Default address set successfully."
}
```

---

### 5. User Preferences

#### GET `/preferences`

Get all user preferences.

**Response:**
```json
{
  "user_id": 123,
  "preferences": {
    "language": {
      "value": "en",
      "updated_at": "2024-01-01 12:00:00"
    },
    "theme": {
      "value": "dark",
      "updated_at": "2024-01-01 12:00:00"
    },
    "notifications": {
      "value": {
        "email": true,
        "sms": false
      },
      "updated_at": "2024-01-01 12:00:00"
    }
  },
  "count": 3
}
```

#### POST `/preferences`

Update user preferences.

**Request Body:**
```json
{
  "language": "en",
  "theme": "dark",
  "notifications": {
    "email": true,
    "sms": false
  }
}
```

**Response:**
```json
{
  "success": true,
  "updated": ["language", "theme", "notifications"],
  "message": "Preferences updated successfully."
}
```

---

### 6. User Activity Logs

#### GET `/activity`

Get user activity logs.

**Query Parameters:**
- `page` (int, default: 1) - Page number
- `per_page` (int, default: 20) - Items per page
- `type` (string, optional) - Filter by activity type

**Response:**
```json
{
  "activities": [
    {
      "id": 1,
      "activity_type": "login",
      "activity_description": "User logged in",
      "ip_address": "192.168.1.1",
      "metadata": {
        "device": "mobile"
      },
      "created_at": "2024-01-01 12:00:00"
    }
  ],
  "pagination": {
    "total": 50,
    "per_page": 20,
    "current_page": 1,
    "total_pages": 3
  }
}
```

#### POST `/activity`

Log a new activity.

**Request Body:**
```json
{
  "activity_type": "page_view",
  "activity_description": "Viewed product page",
  "metadata": {
    "page": "/product/123",
    "device": "mobile"
  }
}
```

**Required Fields:**
- `activity_type`

**Response:**
```json
{
  "success": true,
  "activity_id": 1,
  "message": "Activity logged successfully."
}
```

---

### 7. User Profile

#### GET `/profile`

Get user profile summary.

**Response:**
```json
{
  "user_id": 123,
  "username": "johndoe",
  "email": "john@example.com",
  "display_name": "John Doe",
  "first_name": "John",
  "last_name": "Doe",
  "registered_at": "2023-01-01 00:00:00",
  "statistics": {
    "metadata_count": 5,
    "orders_count": 10,
    "contracts_count": 2
  }
}
```

#### PUT `/profile`

Update user profile information.

**Request Body:**
```json
{
  "email": "newemail@example.com",
  "display_name": "John Smith",
  "first_name": "John",
  "last_name": "Smith",
  "nickname": "Johnny",
  "password": "newpassword123",
  "billing": {
    "first_name": "John",
    "last_name": "Smith",
    "address_1": "123 Main St",
    "city": "New York",
    "country": "US"
  },
  "shipping": {
    "first_name": "John",
    "last_name": "Smith",
    "address_1": "123 Main St",
    "city": "New York",
    "country": "US"
  }
}
```

**Response:**
```json
{
  "success": true,
  "updated": ["email", "display_name", "first_name", "last_name", "billing", "shipping"],
  "message": "Profile updated successfully."
}
```

**Note:** All fields are optional. Only provided fields will be updated.

---

### 8. Statistics

#### GET `/statistics`

Get comprehensive user statistics.

**Response:**
```json
{
  "metadata_count": 5,
  "contracts_count": 2,
  "addresses_count": 3,
  "preferences_count": 4,
  "activity_count": 50,
  "orders_count": 10,
  "orders_total": 999.99,
  "orders_by_status": {
    "completed": 8,
    "pending": 2
  }
}
```

---

### 9. Dashboard

#### GET `/dashboard`

Get all user data in a single request. This is the recommended endpoint for mobile apps and dashboards as it provides all user information in one call, eliminating the need for multiple API requests.

**Query Parameters:**
- `include_orders` (boolean, default: true) - Include recent orders
- `orders_limit` (int, default: 5) - Number of recent orders to include
- `include_activity` (boolean, default: true) - Include recent activities
- `activity_limit` (int, default: 10) - Number of recent activities to include

**Response:**
```json
{
  "profile": {
    "user_id": 123,
    "username": "johndoe",
    "email": "john@example.com",
    "display_name": "John Doe",
    "first_name": "John",
    "last_name": "Doe",
    "nickname": "Johnny",
    "registered_at": "2023-01-01 00:00:00"
  },
  "metadata": {
    "preference_language": {
      "value": "en",
      "updated_at": "2024-01-01 12:00:00"
    }
  },
  "addresses": [
    {
      "id": 1,
      "address_type": "billing",
      "label": "Home",
      "first_name": "John",
      "last_name": "Doe",
      "address_1": "123 Main St",
      "city": "New York",
      "country": "US",
      "is_default": true
    }
  ],
  "preferences": {
    "language": {
      "value": "en",
      "updated_at": "2024-01-01 12:00:00"
    },
    "theme": {
      "value": "dark",
      "updated_at": "2024-01-01 12:00:00"
    }
  },
  "orders": [
    {
      "id": 456,
      "order_number": "12345",
      "status": "completed",
      "date_created": "2024-01-01 12:00:00",
      "total": "99.99",
      "currency": "USD"
    }
  ],
  "activities": [
    {
      "id": 1,
      "activity_type": "login",
      "activity_description": "User logged in",
      "created_at": "2024-01-01 12:00:00"
    }
  ],
  "statistics": {
    "metadata_count": 5,
    "contracts_count": 2,
    "addresses_count": 3,
    "preferences_count": 4,
    "activity_count": 50,
    "orders_count": 10,
    "orders_total": 999.99,
    "orders_by_status": {
      "completed": 8,
      "pending": 2
    }
  }
}
```

**Use Cases:**
- Mobile app dashboard initialization
- Single-page application data loading
- Reducing API calls
- Complete user data snapshot

---

## Error Responses

All endpoints may return error responses in the following format:

```json
{
  "code": "error_code",
  "message": "Error message",
  "data": {
    "status": 400
  }
}
```

### Common Error Codes

- `unauthorized` (401) - User not authenticated
- `invalid_data` (400) - Invalid request data
- `missing_field` (400) - Required field missing
- `not_found` (404) - Resource not found
- `access_denied` (403) - Access denied
- `server_error` (500) - Internal server error

---

## Rate Limiting

Currently, there are no rate limits enforced. However, it's recommended to:
- Cache responses when appropriate
- Use pagination for large datasets
- Avoid making excessive requests in short periods

---

## Examples

### JavaScript (Fetch API)

```javascript
// Get all user data in one request (RECOMMENDED)
const dashboardResponse = await fetch('/wp-json/osmea-users/v1/dashboard?include_orders=true&orders_limit=5', {
  credentials: 'include',
  headers: {
    'Content-Type': 'application/json',
  },
});

const dashboardData = await dashboardResponse.json();
console.log('Profile:', dashboardData.profile);
console.log('Orders:', dashboardData.orders);
console.log('Addresses:', dashboardData.addresses);

// Get user metadata
const response = await fetch('/wp-json/osmea-users/v1/metadata', {
  credentials: 'include',
  headers: {
    'Content-Type': 'application/json',
  },
});

const data = await response.json();
console.log(data);

// Update profile
await fetch('/wp-json/osmea-users/v1/profile', {
  method: 'PUT',
  credentials: 'include',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    first_name: 'John',
    last_name: 'Smith',
    email: 'newemail@example.com',
  }),
});

// Update metadata
await fetch('/wp-json/osmea-users/v1/metadata', {
  method: 'POST',
  credentials: 'include',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    preference_language: 'en',
    marketing_consent: true,
  }),
});
```

### cURL

**JWT Token ile (Önerilen):**
```bash
# Önce JWT token alın
JWT_TOKEN=$(curl -s -X POST \
  'https://example.com/wp-json/jwt-auth/v1/token' \
  -H 'Content-Type: application/json' \
  -d '{"username":"your_username","password":"your_password"}' \
  | grep -o '"token":"[^"]*' | cut -d'"' -f4)

# Get user orders
curl -X GET \
  'https://example.com/wp-json/osmea-users/v1/orders?page=1&per_page=10' \
  -H "Authorization: Bearer $JWT_TOKEN" \
  -H 'Content-Type: application/json'

# Get dashboard (tüm bilgileri tek seferde)
curl -X GET \
  'https://example.com/wp-json/osmea-users/v1/dashboard?include_orders=true&orders_limit=5' \
  -H "Authorization: Bearer $JWT_TOKEN" \
  -H 'Content-Type: application/json'

# Create address
curl -X POST \
  'https://example.com/wp-json/osmea-users/v1/addresses' \
  -H "Authorization: Bearer $JWT_TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{
    "address_type": "billing",
    "first_name": "John",
    "last_name": "Doe",
    "address_1": "123 Main St",
    "city": "New York",
    "country": "US"
  }'

# Update metadata
curl -X POST \
  'https://example.com/wp-json/osmea-users/v1/metadata' \
  -H "Authorization: Bearer $JWT_TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{
    "preference_language": "en",
    "marketing_consent": true
  }'
```

**Application Password ile:**
```bash
# Base64 encode: echo -n "username:application_password" | base64
curl -X GET \
  'https://example.com/wp-json/osmea-users/v1/orders?page=1&per_page=10' \
  -H 'Authorization: Basic dXNlcm5hbWU6YXBwbGljYXRpb25fcGFzc3dvcmQ=' \
  -H 'Content-Type: application/json'
```

### PHP (WordPress)

```php
// Get user metadata
$response = wp_remote_get(
    rest_url('osmea-users/v1/metadata'),
    array(
        'headers' => array(
            'Authorization' => 'Bearer ' . wp_get_session_token(),
        ),
    )
);

$data = json_decode(wp_remote_retrieve_body($response), true);

// Update metadata
wp_remote_post(
    rest_url('osmea-users/v1/metadata'),
    array(
        'headers' => array(
            'Authorization' => 'Bearer ' . wp_get_session_token(),
            'Content-Type' => 'application/json',
        ),
        'body' => json_encode(array(
            'preference_language' => 'en',
            'marketing_consent' => true,
        )),
    )
);
```

---

## Best Practices

1. **Always handle errors** - Check response status codes
2. **Use pagination** - For endpoints that support it
3. **Cache responses** - When appropriate to reduce server load
4. **Validate input** - Before sending requests
5. **Use HTTPS** - Always use secure connections
6. **Store credentials securely** - Never hardcode credentials

---

## Support

For issues or questions:
- GitHub: https://github.com/masterfabric-mobile/osmea
- Create an issue on GitHub
