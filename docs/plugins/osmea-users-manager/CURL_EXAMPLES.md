# OSMEA Users Manager - cURL Örnekleri

Bu dosya, OSMEA Users Manager plugin API'lerini cURL ile nasıl çağıracağınızı gösterir.

## 🔐 Authentication Yöntemleri

Plugin, WordPress'in standart authentication sistemini kullanır. Üç yöntem desteklenir:

### 1. JWT Authentication (Önerilen - Mobil Uygulamalar için)

WordPress JWT Authentication plugin'i kurulu olmalı. JWT token ile authentication:

```bash
Authorization: Bearer YOUR_JWT_TOKEN
```

### 2. Cookie Authentication (Browser için)

WordPress'e login olduğunuzda cookie otomatik olarak gönderilir.

### 3. Application Password (Basic Auth)

WordPress 5.6+ için Application Password kullanılabilir:

```bash
Authorization: Basic base64(username:application_password)
```

---

## 📋 Base URL

Tüm endpoint'ler şu base URL ile başlar:
```
https://your-site.com/wp-json/osmea-users/v1
```

---

## 🚀 cURL Örnekleri

### 1. Kullanıcı Metadata İşlemleri

#### GET - Kullanıcının Metadata'sını Getir

```bash
curl -X GET \
  'https://your-site.com/wp-json/osmea-users/v1/metadata' \
  -H 'Authorization: Bearer YOUR_JWT_TOKEN' \
  -H 'Content-Type: application/json'
```

**Cookie ile:**
```bash
curl -X GET \
  'https://your-site.com/wp-json/osmea-users/v1/metadata' \
  -H 'Content-Type: application/json' \
  --cookie 'wordpress_logged_in_xxx=YOUR_COOKIE_VALUE'
```

#### POST - Metadata Güncelle

```bash
curl -X POST \
  'https://your-site.com/wp-json/osmea-users/v1/metadata' \
  -H 'Authorization: Bearer YOUR_JWT_TOKEN' \
  -H 'Content-Type: application/json' \
  -d '{
    "preference_language": "en",
    "marketing_consent": true,
    "custom_field": "value"
  }'
```

#### DELETE - Metadata Sil

```bash
curl -X DELETE \
  'https://your-site.com/wp-json/osmea-users/v1/metadata/preference_language' \
  -H 'Authorization: Bearer YOUR_JWT_TOKEN' \
  -H 'Content-Type: application/json'
```

---

### 2. Kullanıcı Dashboard (Tüm Bilgileri Tek Seferde)

#### GET - Dashboard (Önerilen)

```bash
curl -X GET \
  'https://your-site.com/wp-json/osmea-users/v1/dashboard?include_orders=true&orders_limit=5&include_activity=true&activity_limit=10' \
  -H 'Authorization: Bearer YOUR_JWT_TOKEN' \
  -H 'Content-Type: application/json'
```

**Query Parameters:**
- `include_orders` (boolean, default: true) - Siparişleri dahil et
- `orders_limit` (int, default: 5) - Kaç sipariş getirilecek
- `include_activity` (boolean, default: true) - Aktiviteleri dahil et
- `activity_limit` (int, default: 10) - Kaç aktivite getirilecek

---

### 3. Kullanıcı Profili

#### GET - Profil Bilgileri

```bash
curl -X GET \
  'https://your-site.com/wp-json/osmea-users/v1/profile' \
  -H 'Authorization: Bearer YOUR_JWT_TOKEN' \
  -H 'Content-Type: application/json'
```

#### PUT - Profil Güncelle

```bash
curl -X PUT \
  'https://your-site.com/wp-json/osmea-users/v1/profile' \
  -H 'Authorization: Bearer YOUR_JWT_TOKEN' \
  -H 'Content-Type: application/json' \
  -d '{
    "first_name": "John",
    "last_name": "Smith",
    "email": "newemail@example.com",
    "display_name": "John Smith",
    "billing": {
      "first_name": "John",
      "last_name": "Smith",
      "address_1": "123 Main St",
      "city": "New York",
      "country": "US"
    }
  }'
```

---

### 4. Siparişler (WooCommerce)

#### GET - Siparişleri Listele

```bash
curl -X GET \
  'https://your-site.com/wp-json/osmea-users/v1/orders?page=1&per_page=10&status=completed' \
  -H 'Authorization: Bearer YOUR_JWT_TOKEN' \
  -H 'Content-Type: application/json'
```

**Query Parameters:**
- `page` (int, default: 1) - Sayfa numarası
- `per_page` (int, default: 10) - Sayfa başına kayıt
- `status` (string, optional) - Sipariş durumu (completed, pending, processing, vb.)

#### GET - Tek Sipariş Detayı

```bash
curl -X GET \
  'https://your-site.com/wp-json/osmea-users/v1/orders/123' \
  -H 'Authorization: Bearer YOUR_JWT_TOKEN' \
  -H 'Content-Type: application/json'
```

---

### 5. Sözleşme İmzaları

#### GET - Sözleşmeleri Listele

```bash
curl -X GET \
  'https://your-site.com/wp-json/osmea-users/v1/contracts?page=1&per_page=10&contract_type=terms_and_conditions' \
  -H 'Authorization: Bearer YOUR_JWT_TOKEN' \
  -H 'Content-Type: application/json'
```

#### POST - Yeni Sözleşme İmzası Oluştur

```bash
curl -X POST \
  'https://your-site.com/wp-json/osmea-users/v1/contracts' \
  -H 'Authorization: Bearer YOUR_JWT_TOKEN' \
  -H 'Content-Type: application/json' \
  -d '{
    "contract_type": "terms_and_conditions",
    "contract_title": "Terms and Conditions v1.0",
    "contract_content": "Full contract text...",
    "signature_data": {
      "signature": "base64_encoded_signature",
      "timestamp": "2024-01-01T00:00:00Z"
    }
  }'
```

---

### 6. Adresler

#### GET - Adresleri Listele

```bash
curl -X GET \
  'https://your-site.com/wp-json/osmea-users/v1/addresses?type=billing' \
  -H 'Authorization: Bearer YOUR_JWT_TOKEN' \
  -H 'Content-Type: application/json'
```

#### POST - Yeni Adres Oluştur

```bash
curl -X POST \
  'https://your-site.com/wp-json/osmea-users/v1/addresses' \
  -H 'Authorization: Bearer YOUR_JWT_TOKEN' \
  -H 'Content-Type: application/json' \
  -d '{
    "address_type": "billing",
    "label": "Home",
    "first_name": "John",
    "last_name": "Doe",
    "address_1": "123 Main St",
    "city": "New York",
    "state": "NY",
    "postcode": "10001",
    "country": "US",
    "email": "john@example.com",
    "phone": "+1234567890",
    "is_default": true
  }'
```

#### PUT - Adres Güncelle

```bash
curl -X PUT \
  'https://your-site.com/wp-json/osmea-users/v1/addresses/1' \
  -H 'Authorization: Bearer YOUR_JWT_TOKEN' \
  -H 'Content-Type: application/json' \
  -d '{
    "label": "Work",
    "address_1": "456 Business Ave",
    "is_default": true
  }'
```

#### DELETE - Adres Sil

```bash
curl -X DELETE \
  'https://your-site.com/wp-json/osmea-users/v1/addresses/1' \
  -H 'Authorization: Bearer YOUR_JWT_TOKEN' \
  -H 'Content-Type: application/json'
```

#### POST - Varsayılan Adres Belirle

```bash
curl -X POST \
  'https://your-site.com/wp-json/osmea-users/v1/addresses/1/set-default' \
  -H 'Authorization: Bearer YOUR_JWT_TOKEN' \
  -H 'Content-Type: application/json'
```

---

### 7. Tercihler

#### GET - Tercihleri Getir

```bash
curl -X GET \
  'https://your-site.com/wp-json/osmea-users/v1/preferences' \
  -H 'Authorization: Bearer YOUR_JWT_TOKEN' \
  -H 'Content-Type: application/json'
```

#### POST - Tercihleri Güncelle

```bash
curl -X POST \
  'https://your-site.com/wp-json/osmea-users/v1/preferences' \
  -H 'Authorization: Bearer YOUR_JWT_TOKEN' \
  -H 'Content-Type: application/json' \
  -d '{
    "language": "en",
    "theme": "dark",
    "notifications": {
      "email": true,
      "sms": false
    }
  }'
```

---

### 8. Aktivite Logları

#### GET - Aktivite Loglarını Getir

```bash
curl -X GET \
  'https://your-site.com/wp-json/osmea-users/v1/activity?page=1&per_page=20&type=login' \
  -H 'Authorization: Bearer YOUR_JWT_TOKEN' \
  -H 'Content-Type: application/json'
```

#### POST - Yeni Aktivite Kaydet

```bash
curl -X POST \
  'https://your-site.com/wp-json/osmea-users/v1/activity' \
  -H 'Authorization: Bearer YOUR_JWT_TOKEN' \
  -H 'Content-Type: application/json' \
  -d '{
    "activity_type": "page_view",
    "activity_description": "Viewed product page",
    "metadata": {
      "page": "/product/123",
      "device": "mobile"
    }
  }'
```

---

### 9. İstatistikler

#### GET - Kullanıcı İstatistikleri

```bash
curl -X GET \
  'https://your-site.com/wp-json/osmea-users/v1/statistics' \
  -H 'Authorization: Bearer YOUR_JWT_TOKEN' \
  -H 'Content-Type: application/json'
```

---

## 🔑 Admin Endpoint'leri (Yönetici Yetkisi Gerekli)

Admin endpoint'leri için `manage_options` yetkisi gerekir. JWT token'ınız admin yetkisine sahip olmalı.

### GET - Tüm Kullanıcıları Listele

```bash
curl -X GET \
  'https://your-site.com/wp-json/osmea-users/v1/admin/users?page=1&per_page=20&search=john&role=customer' \
  -H 'Authorization: Bearer ADMIN_JWT_TOKEN' \
  -H 'Content-Type: application/json'
```

**Query Parameters:**
- `page` (int, default: 1) - Sayfa numarası
- `per_page` (int, default: 20) - Sayfa başına kayıt
- `search` (string, optional) - Kullanıcı adı, email veya display name ile arama
- `role` (string, optional) - Kullanıcı rolü ile filtrele (customer, administrator, vb.)

### GET - Kullanıcıyı ID ile Getir

```bash
curl -X GET \
  'https://your-site.com/wp-json/osmea-users/v1/admin/users/123' \
  -H 'Authorization: Bearer ADMIN_JWT_TOKEN' \
  -H 'Content-Type: application/json'
```

### GET - Kullanıcının Metadata'sını Getir (Admin)

```bash
curl -X GET \
  'https://your-site.com/wp-json/osmea-users/v1/admin/users/123/metadata' \
  -H 'Authorization: Bearer ADMIN_JWT_TOKEN' \
  -H 'Content-Type: application/json'
```

### POST - Kullanıcının Metadata'sını Güncelle (Admin)

```bash
curl -X POST \
  'https://your-site.com/wp-json/osmea-users/v1/admin/users/123/metadata' \
  -H 'Authorization: Bearer ADMIN_JWT_TOKEN' \
  -H 'Content-Type: application/json' \
  -d '{
    "custom_field": "admin_updated_value",
    "admin_note": "Updated by admin"
  }'
```

### DELETE - Kullanıcının Metadata'sını Sil (Admin)

```bash
curl -X DELETE \
  'https://your-site.com/wp-json/osmea-users/v1/admin/users/123/metadata/custom_field' \
  -H 'Authorization: Bearer ADMIN_JWT_TOKEN' \
  -H 'Content-Type: application/json'
```

### GET - Kullanıcının Dashboard'unu Getir (Admin)

```bash
curl -X GET \
  'https://your-site.com/wp-json/osmea-users/v1/admin/users/123/dashboard?include_orders=true&orders_limit=5' \
  -H 'Authorization: Bearer ADMIN_JWT_TOKEN' \
  -H 'Content-Type: application/json'
```

---

## 🔐 JWT Token Nasıl Alınır?

### WordPress JWT Authentication Plugin ile

1. **JWT Authentication Plugin'i kurun:**
   - WordPress Admin > Plugins > Add New
   - "JWT Authentication for WP REST API" arayın ve kurun

2. **wp-config.php'ye ekleyin:**
   ```php
   define('JWT_AUTH_SECRET_KEY', 'your-secret-key-here');
   define('JWT_AUTH_CORS_ENABLE', true);
   ```

3. **JWT Token Alın:**
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

4. **Token'ı kullanın:**
   ```bash
   curl -X GET \
     'https://your-site.com/wp-json/osmea-users/v1/metadata' \
     -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGc...' \
     -H 'Content-Type: application/json'
   ```

---

## 📝 Application Password ile (WordPress 5.6+)

1. **Application Password Oluşturun:**
   - WordPress Admin > Users > Your Profile
   - "Application Passwords" bölümüne gidin
   - Yeni password oluşturun

2. **Base64 encode edin:**
   ```bash
   echo -n "username:application_password" | base64
   ```

3. **Kullanın:**
   ```bash
   curl -X GET \
     'https://your-site.com/wp-json/osmea-users/v1/metadata' \
     -H 'Authorization: Basic dXNlcm5hbWU6YXBwbGljYXRpb25fcGFzc3dvcmQ=' \
     -H 'Content-Type: application/json'
   ```

---

## ⚠️ Hata Yönetimi

### 401 Unauthorized
```json
{
  "code": "unauthorized",
  "message": "User not authenticated.",
  "data": {
    "status": 401
  }
}
```

**Çözüm:** JWT token'ınızı kontrol edin veya yeniden login olun.

### 403 Forbidden (Admin endpoint'leri için)
```json
{
  "code": "forbidden",
  "message": "You do not have permission to access this endpoint.",
  "data": {
    "status": 403
  }
}
```

**Çözüm:** Admin yetkisine sahip bir kullanıcı ile login olun.

### 404 Not Found
```json
{
  "code": "user_not_found",
  "message": "User not found.",
  "data": {
    "status": 404
  }
}
```

**Çözüm:** Kullanıcı ID'sini kontrol edin.

---

## 💡 İpuçları

1. **JWT Token'ı güvenli saklayın** - Token'lar hassas bilgidir
2. **HTTPS kullanın** - Production'da mutlaka HTTPS kullanın
3. **Token süresi** - JWT token'ların bir süresi vardır, yenileme mekanizması ekleyin
4. **Rate limiting** - Çok fazla istek göndermekten kaçının
5. **Error handling** - Tüm hataları yakalayıp uygun şekilde handle edin

---

## 🔄 Token Yenileme

JWT token'ların süresi dolduğunda yenileme yapmanız gerekebilir:

```bash
curl -X POST \
  'https://your-site.com/wp-json/jwt-auth/v1/token/validate' \
  -H 'Authorization: Bearer YOUR_JWT_TOKEN' \
  -H 'Content-Type: application/json'
```

Eğer token geçersizse, yeni token alın:
```bash
curl -X POST \
  'https://your-site.com/wp-json/jwt-auth/v1/token' \
  -H 'Content-Type: application/json' \
  -d '{
    "username": "your_username",
    "password": "your_password"
  }'
```

---

## 📚 Daha Fazla Bilgi

- [WordPress REST API Authentication](https://developer.wordpress.org/rest-api/using-the-rest-api/authentication/)
- [JWT Authentication Plugin](https://wordpress.org/plugins/jwt-authentication-for-wp-rest-api/)
- [Application Passwords](https://make.wordpress.org/core/2020/11/05/application-passwords-integration-guide/)
