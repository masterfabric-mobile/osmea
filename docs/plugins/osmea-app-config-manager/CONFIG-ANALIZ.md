# OSMEA App Config Manager – Analiz ve Checklist

Bu dosya plugin konfigürasyonu için detaylı checklist ve analiz yapısını içerir. Fazlar tamamlandıkça durum güncellenir.

---

## BÖLÜM 1: DETAYLI CHECKLİST

### A. JSON default ve yükleme

| # | Madde | Durum | Not |
|---|--------|--------|-----|
| A1 | Plugin aktivasyonunda `default-config.json` tek kaynak olarak option'a yazılsın | ✅ Var | Activation hook ile yapılıyor |
| A2 | Admin sayfası açılırken stored config yoksa tamamen default-config.json gelsin | ✅ Var | `get_stored_config()` fallback ile |
| A3 | Admin sayfasında eksik üst seviye section'lar default'tan doldurulsun | ✅ Var | PHP'de merge (697–701) |
| A4 | Admin sayfasında nested eksik key'ler (örn. home_view içi) default'tan merge edilsin | ✅ Faz 1 | Admin script localize'da deep merge eklendi |
| A5 | Save sırasında gelen partial payload mevcut config ile deep merge edilsin | ✅ Var | PHP save/merge mevcut |
| A6 | REST/API response'ta eksik section'lar default'tan tamamlansın | ✅ Var | PHP'de yapılıyor |

### B. Version / API version alanları (dropdown)

| # | Alan (path) | Beklenen tip | Seçenekler | Durum |
|---|-------------|--------------|-----------|--------|
| B1 | woocommerce_configuration.version | select | v1, v2, v3 | ✅ |
| B2 | woocommerce_configuration.store_api_version | select | v1, v2, v3 | ✅ |
| B3 | woocommerce_configuration.admin_api_version | select | v1, v2, v3 | ✅ |
| B4 | woocommerce_configuration.wishlist_api_version | select | v1, v2, v3 | ✅ |

### C. Style alanları (startup / space / enterprise) – dropdown

| # | Alan (path) | Beklenen tip | Seçenekler | Durum |
|---|-------------|--------------|-----------|--------|
| C1 | account_configuration.style | select | space, startup, enterprise | ✅ |
| C2 | splash_configuration.style | select | startup, space, enterprise | ✅ |
| C3 | onboarding_configuration.style | select | aynı | ✅ |
| C4 | about_configuration.style | select | aynı | ✅ |
| C5 | contact_us_configuration.style | select | aynı | ✅ Faz 2 |
| C6 | faq_configuration.style | select | aynı | ✅ |
| C7 | loading_configuration.style | select | aynı | ✅ |
| C8 | error_handling_configuration.style | select | aynı | ✅ Faz 2 |
| C9 | empty_view_configuration.style | select | aynı | ✅ |
| C10 | auth_configuration.ui_style.style | select | aynı | ✅ |

### D. Home view – app_bar / search (dropdown)

| # | Alan (path) | Beklenen tip | Önerilen seçenekler | Durum |
|---|-------------|--------------|---------------------|--------|
| D1 | home_view.app_bar.variant | select | standard, compact, extended | ✅ Faz 3 |
| D2 | home_view.app_bar.size | select | standard, compact, extended | ✅ Faz 3 |
| D3 | home_view.search.style | select | minimal, borderless, outlined | ✅ Faz 3 |
| D4 | home_view.search.variant | select | outlined, borderless, filled | ✅ Faz 3 |

### E. Navbar – dropdown

| # | Alan (path) | Beklenen tip | Önerilen seçenekler | Durum |
|---|-------------|--------------|---------------------|--------|
| E1 | navbar_configuration.variant | select | transparent, filled | ✅ Faz 4 |
| E2 | navbar_configuration.size | select | small, medium, large | ✅ Faz 4 |
| E3 | navbar_configuration.position | select | top, bottom | ✅ Faz 4 |

### F. Cart / Checkout app_bar (dropdown – opsiyonel)

| # | Alan (path) | Beklenen tip | Önerilen seçenekler | Durum |
|---|-------------|--------------|---------------------|--------|
| F1 | cart_view_configuration.app_bar.variant | select | standard, compact, extended | ✅ Faz 5 |
| F2 | cart_view_configuration.app_bar.size | select | aynı | ✅ Faz 5 |
| F3 | checkout_view_configuration.app_bar.variant | select | aynı | ✅ Faz 5 |
| F4 | checkout_view_configuration.app_bar.size | select | aynı | ✅ Faz 5 |

### G. Diğer select alanları (kontrol)

| # | Alan | Seçenekler | Durum |
|---|------|------------|--------|
| G1 | app_settings.environment | production, staging, development | ✅ |
| G2 | ui_configuration.theme_mode | light, dark, system | ✅ |
| G3 | search_view_configuration.search_bar_size | small, medium, large | ✅ |
| G4 | search_view_configuration.search_bar_variant | borderless, outlined, filled | ✅ |
| G5 | notification_configuration.notification_sound | default, none, custom | ✅ |
| G6 | splash_configuration.logo_animation_type | fade_scale, fade, scale, none | ✅ |

### H. İmaj / URL alanları ve kurallar

| # | Madde | Durum | Not |
|---|--------|--------|-----|
| H1 | imageUrl, image_url, logo_url, icon_path, image_path, splash_image_url → type: text | ✅ | osmea-data.js'te zorlanıyor |
| H2 | Bu alanlarda önizleme + lightbox | ✅ | admin/form tarafında var |
| H3 | Image URL alanlarına placeholder/hint (HTTPS, önerilen boyut) | ✅ Faz 5 | osmea-data.js + form |
| H4 | Cursor rules'da config imaj URL kuralları | ✅ Faz 5 | rules/osmea-app-config-images.cursorrules |

### I. Default version uyumu (app / storefront_woo)

| # | Madde | Durum |
|---|--------|--------|
| I1 | default-config.json ile storefront_woo/assets/app_config.json version değerleri uyumlu | ✅ |
| I2 | WordPress'ten version gelmezse fallback v1 | ✅ starter/wordpress_config |

---

## BÖLÜM 2: ANALİZ YAPISI (Öncelik ve Aksiyon)

### 2.1 Öncelik matrisi

| Öncelik | Kategori | Aksiyon | Dosya / Yer | Durum |
|---------|----------|--------|-------------|--------|
| P1 | Admin'de nested default merge | Eksik nested key'ler için default-config ile deep merge (admin script localize) | osmea-app-config-manager.php | ✅ Faz 1 |
| P2 | contact_us + error_handling style | type: 'select', options: startup, space, enterprise | osmea-data.js, admin.js | ✅ Faz 2 |
| P3 | home_view app_bar | variant + size için explicit select tanımı | osmea-data.js | ✅ Faz 3 |
| P4 | home_view search | style + variant için explicit select tanımı | osmea-data.js | ✅ Faz 3 |
| P5 | navbar_configuration | variant, size, position → select + options | osmea-data.js | ✅ Faz 4 |
| P6 | Cart/Checkout app_bar | variant, size path'leri ekle + select | osmea-data.js | ✅ Faz 5 |
| P7 | Image placeholder/hint | İmaj URL field'lara placeholder veya hint metni | osmea-data.js, osmea-form.js, admin.js | ✅ Faz 5 |
| P8 | Cursor rules – imaj | rules/ altında config imaj URL kuralları | osmea-app-config-images.cursorrules | ✅ Faz 5 |

### 2.2 Dosya bazlı analiz

| Dosya | Yapılacaklar | Durum |
|-------|----------------|--------|
| **osmea-app-config-manager.php** | Admin sayfasına gönderilen config hazırlanırken (690–704) tüm nested section'lar için default ile deep merge. | ✅ Faz 1 |
| **assets/js/osmea-data.js** | contact_us + error_handling style → select. home_view app_bar/search select. navbar variant/size/position → select. | Faz 2–4 ✅ |
| **assets/js/osmea-admin.js** (admin.js) | osmea-data.js ile aynı field set kullanıyorsa aynı select değişiklikleri senkron. | Faz 2 (style) ✅ |
| **default-config.json** | Sadece referans; değerler dropdown seçenekleriyle uyumlu tutulacak. | Referans |
| **rules/** | Config imaj URL kuralları (opsiyonel). | Opsiyonel |

### 2.3 Dropdown seçenekleri referansı

- **style (view'lar):** `startup`, `space`, `enterprise`
- **app_bar variant:** `standard`, `compact`, `extended`
- **app_bar size:** `standard`, `compact`, `extended` veya `small`, `medium`, `large`
- **search style:** `minimal` (+ default-config ile uyumlu)
- **search variant:** `outlined`, `borderless`, `filled`
- **navbar variant:** `transparent`, `filled`
- **navbar size:** `small`, `medium`, `large`
- **navbar position:** `top`, `bottom`

---

## BÖLÜM 3: FAZ DURUMU

| Faz | İçerik | Durum |
|-----|--------|--------|
| **Faz 1** | Admin'de nested default merge (P1) | ✅ Tamamlandı |
| **Faz 2** | contact_us + error_handling style → select (P2) | ✅ Tamamlandı |
| **Faz 3** | home_view app_bar + search select'ler (P3, P4) | ✅ Tamamlandı |
| **Faz 4** | navbar variant/size/position → select (P5) | ✅ Tamamlandı |
| **Faz 5** | Cart/Checkout app_bar dropdown, imaj placeholder, Cursor rules, kategori/view yapısı (storefront_woo uyumlu) | ✅ Tamamlandı |

---

## BÖLÜM 4: İLERLEME ADIMLARI

1. **Faz 1** – Default: Admin'de nested default merge (P1). ✅
2. **Faz 2** – Dropdown (style): contact_us + error_handling style → select (P2). ✅
3. **Faz 3** – Dropdown (home): home_view app_bar + search select'ler (P3, P4). ✅
4. **Faz 4** – Dropdown (navbar): navbar variant/size/position → select (P5). ✅
5. **Faz 5** – Cart/Checkout app_bar dropdown, imaj placeholder, Cursor rules, kategori/view yapısı (storefront_woo). ✅

---

*Son güncelleme: Faz 5 uygulandı – Kategoriler storefront_woo view yapısına göre düzenlendi (Launch & Auth, Home View, Search, Product, Cart & Checkout, Wishlist & Favorites, Campaign, Orders, Profile & Account, Content, Nav & UI, Infrastructure). Tab sırası app akışına göre güncellendi. Cart/Checkout app_bar variant & size dropdown eklendi. İmaj URL alanlarına placeholder (HTTPS, JPEG/PNG önerilir) eklendi. rules/osmea-app-config-images.cursorrules eklendi.*
