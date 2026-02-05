# OSMEA Users Manager - Erişim Rehberi

## 📍 Menü Konumu

Plugin menüsü **WordPress Admin > Kullanıcılar (Users) > OSMEA Users Manager** altında görünür.

### Adım Adım Erişim

1. **WordPress Admin Paneline giriş yapın**
   - URL: `https://your-site.com/wp-admin`

2. **Sol menüden "Kullanıcılar" (Users) sekmesine tıklayın**
   - Menüde "Kullanıcılar" yazısını bulun
   - Alt menüler açılacak

3. **"OSMEA Users Manager" seçeneğine tıklayın**
   - "Kullanıcılar" altında "OSMEA Users Manager" görünecek

### Doğrudan URL

Eğer menüde görünmüyorsa, doğrudan şu URL'yi kullanabilirsiniz:

```
https://your-site.com/wp-admin/users.php?page=osmea-users-manager
```

## 🔍 Menü Görünmüyorsa

### 1. Yetki Kontrolü

Menüyü görmek için **Administrator** yetkisine sahip olmanız gerekir. Plugin `manage_options` yetkisi gerektirir.

**Kontrol:**
- WordPress Admin > Kullanıcılar > Profiliniz
- Rolünüzün "Administrator" olduğundan emin olun

### 2. Plugin Aktif mi?

**Kontrol:**
- WordPress Admin > Eklentiler (Plugins)
- "OSMEA Users Manager" eklentisinin **Aktif** olduğundan emin olun
- Eğer aktif değilse, "Etkinleştir" butonuna tıklayın

### 3. Sayfayı Yenileyin

Bazen menü cache'lenmiş olabilir:
- Tarayıcınızda **Ctrl+F5** (Windows) veya **Cmd+Shift+R** (Mac) ile hard refresh yapın
- Veya tarayıcı cache'ini temizleyin

### 4. Menü Görünürlüğü

Eğer hala görünmüyorsa, WordPress'in menü sistemini kontrol edin:

**Debug için:**
```php
// wp-config.php'ye ekleyin (geçici olarak)
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
```

Sonra `wp-content/debug.log` dosyasını kontrol edin.

## 🎯 Alternatif Erişim Yöntemleri

### Yöntem 1: Doğrudan URL

Tarayıcınızın adres çubuğuna şunu yazın:
```
https://your-site.com/wp-admin/users.php?page=osmea-users-manager
```

### Yöntem 2: Admin Bar'dan

WordPress Admin Bar'da (üstteki siyah çubuk):
- "Kullanıcılar" (Users) menüsüne tıklayın
- "OSMEA Users Manager" seçeneğini bulun

### Yöntem 3: Arama ile

WordPress Admin'de:
- Üstteki arama kutusuna "OSMEA" yazın
- Menü önerilerinde görünecektir

## 📊 Menüde Ne Göreceksiniz?

Menüye tıkladığınızda şunları göreceksiniz:

1. **İstatistikler**
   - User Metadata sayısı
   - Contract Signatures sayısı
   - Kullanıcı sayıları

2. **REST API Endpoints Listesi**
   - Tüm endpoint'lerin listesi
   - Kullanım açıklamaları

3. **Doğrudan URL**
   - Sayfanın doğrudan erişim URL'si

## 🔧 Sorun Giderme

### Menü hiç görünmüyor

1. **Plugin dosyasını kontrol edin:**
   - `wp-content/plugins/osmea-users-manager/osmea-users-manager.php` dosyasının var olduğundan emin olun

2. **PHP hatalarını kontrol edin:**
   - WordPress Admin > Araçlar > Site Sağlığı
   - Hataları kontrol edin

3. **Diğer plugin'lerle çakışma:**
   - Tüm plugin'leri geçici olarak devre dışı bırakın
   - Sadece OSMEA Users Manager'ı aktif edin
   - Menü görünüyor mu kontrol edin

### Yetki hatası alıyorsunuz

```
You do not have permission to access this page.
```

**Çözüm:**
- Kullanıcı rolünüzü Administrator yapın
- Veya `manage_options` yetkisini ekleyin

### Sayfa boş görünüyor

1. **PHP hatalarını kontrol edin:**
   - `wp-content/debug.log` dosyasını kontrol edin

2. **Veritabanı tablolarını kontrol edin:**
   - phpMyAdmin veya benzeri bir araçla
   - `wp_osmea_user_metadata` tablosunun var olduğundan emin olun

## 💡 İpuçları

1. **Bookmark ekleyin:** Sayfayı sık kullanılanlarınıza ekleyin
2. **Kısayol:** Doğrudan URL'yi bookmark olarak kaydedin
3. **Menü sırası:** WordPress menü sıralamasını değiştirmek isterseniz, plugin kodunda `add_users_page` fonksiyonuna priority ekleyebilirsiniz

## 📝 Menü Yapısı

```
WordPress Admin
└── Kullanıcılar (Users)
    ├── Tüm Kullanıcılar (All Users)
    ├── Yeni Ekle (Add New)
    ├── Profiliniz (Your Profile)
    └── OSMEA Users Manager ← BURADA
```

## 🚀 Hızlı Erişim

En hızlı yöntem: Tarayıcınızın adres çubuğuna şunu yazın:

```
wp-admin/users.php?page=osmea-users-manager
```

Site URL'nizin başına ekleyin (örn: `https://your-site.com/wp-admin/users.php?page=osmea-users-manager`)
