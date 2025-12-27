# OSMEA App Config Manager

WordPress plugin for managing Flutter mobile app configuration file (`app_config.json`) from WordPress admin panel. The mobile app can fetch configuration via REST API endpoint.

## 📋 Table of Contents

- [Features](#features)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage](#usage)
- [REST API](#rest-api)
- [Flutter Integration](#flutter-integration)
  - [How It Works](#how-it-works)
  - [Flow Diagram](#flow-diagram)
  - [Config Priority](#config-priority)
  - [Code Structure](#code-structure)
  - [Configuration](#configuration)
  - [Debug and Logging](#debug-and-logging)
  - [Error Scenarios](#error-scenarios)
  - [Config Merge Example](#config-merge-example)
- [Advanced Examples](#advanced-examples)
- [Security](#security)
- [Troubleshooting](#troubleshooting)
- [File Structure](#file-structure)
- [Requirements](#requirements)
- [License & Support](#license--support)

## ✨ Features

- ✅ Edit JSON configuration from WordPress admin panel
- ✅ Provide configuration to mobile app via REST API endpoint
- ✅ JSON formatting and validation
- ✅ Import/export configuration
- ✅ Reset to default configuration
- ✅ Real-time JSON validation
- ✅ WordPress config takes priority over local config
- ✅ Automatic config merging (WordPress + Local)
- ✅ Protected from override (WordPress config protection)

## 🚀 Quick Start

### Step 1: Download Plugin

The plugin is located at:
```
docs/plugins/osmea-app-config-manager/
```

**From GitHub:**
1. Navigate to: `https://github.com/masterfabric-mobile/osmea`
2. Go to `docs/plugins/osmea-app-config-manager/` folder
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
2. Connect to your server via FTP/SFTP
3. Upload to `wp-content/plugins/` directory
4. Activate from WordPress Admin > Plugins

**Method 3: Command Line**

```bash
cd /path/to/wordpress/wp-content/plugins/
cp -r /path/to/osmea-app-config-manager ./
chmod -R 755 osmea-app-config-manager/
```

Then activate from WordPress Admin > Plugins

### Step 3: Configure

1. Go to **Settings > OSMEA App Config** in WordPress admin
2. Edit JSON configuration as needed
3. Click **Format JSON** to format properly
4. Click **Save Configuration**

### Step 4: Test REST API

```bash
curl https://your-wordpress-site.com/wp-json/osmea/v1/app-config
```

You should see JSON configuration response.

## 📦 Installation

### Requirements

- WordPress 5.0 or higher
- PHP 7.4 or higher
- JSON extension (usually included by default in PHP)

### Installation Steps

1. **Download Plugin Files**
   - Get the plugin folder from the repository

2. **Install Plugin**
   - Upload via WordPress admin (recommended)
   - Or manually via FTP/SFTP
   - Or via command line

3. **Activate Plugin**
   - Go to **Plugins** page in WordPress admin
   - Find **OSMEA App Config Manager**
   - Click **Activate**

4. **Initial Configuration**
   - Go to **Settings > OSMEA App Config**
   - Default configuration loads automatically
   - Edit configuration as needed
   - Click **Save Configuration**

## 💻 Usage

### Admin Panel

1. Go to **Settings > OSMEA App Config** page in WordPress admin panel
2. Edit JSON configuration in the text area
3. Use **Format JSON** button to format JSON properly
4. Use **Reset to Default** to restore default configuration
5. Use **Export** to download configuration as JSON file
6. Use **Import** to load configuration from JSON file
7. Click **Save Configuration** button

### Feature Details

#### JSON Validation
- Real-time JSON validation as you type
- User notification with error messages
- Valid/invalid status indicator

#### Formatting
- One-click JSON formatting
- Readable and organized JSON output
- Preserves structure and comments

#### Import/Export
- Export as JSON file with timestamp
- Import from JSON file
- Backup and restore support
- Validation before import

## 🔌 REST API

### GET Endpoint (Public)

Fetch configuration from WordPress:

```
GET https://your-wordpress-site.com/wp-json/osmea/v1/app-config
```

**Example:**
```bash
curl https://your-wordpress-site.com/wp-json/osmea/v1/app-config
```

**Response:**
```json
{
  "app_settings": {
    "app_name": "Storefront WooCommerce",
    "app_version": "1.0.0",
    ...
  },
  "woocommerce_configuration": {
    "store_url": "https://your-woocommerce-store.com",
    ...
  },
  ...
}
```

### POST Endpoint (Admin Only)

Update configuration via API (requires admin permissions):

```
POST https://your-wordpress-site.com/wp-json/osmea/v1/app-config
Content-Type: application/json

{
  "app_settings": {
    "app_name": "My App"
  }
}
```

### Testing

**Browser:**
```
https://your-wordpress-site.com/wp-json/osmea/v1/app-config
```

**cURL:**
```bash
# Simple test
curl https://your-wordpress-site.com/wp-json/osmea/v1/app-config

# With JSON formatting (requires jq)
curl https://your-wordpress-site.com/wp-json/osmea/v1/app-config | jq

# Check status code
curl -I https://your-wordpress-site.com/wp-json/osmea/v1/app-config
```

## 📱 Flutter Integration

### Basic Implementation

Your Flutter app automatically loads configuration from WordPress. The integration is already set up in `starter.dart`:

```dart
// In lib/starter.dart
final wordPressService = WordPressConfigService(
  baseUrl: 'https://your-wordpress-site.com', // Update this URL
);

final wordPressConfigIntegration = WordPressConfigIntegration(
  configService: wordPressService,
  assetConfigHelper: assetConfigHelper,
);

// Load and merge WordPress config with local config
final mergedConfig = await wordPressConfigIntegration!.loadAndMergeConfig(
  localConfigPath: 'assets/app_config.json',
  useWordPressAsPrimary: true, // WordPress config overrides local
);
```

### How It Works

When the app starts (`starter.dart`), configuration is loaded in the following order:

1. **Local Config is Loaded** (`assets/app_config.json`)
   - Used as fallback
   - Used if WordPress is not accessible

2. **WordPress Config is Fetched** (`https://your-wordpress-site.com/wp-json/osmea/v1/app-config`)
   - Configuration is retrieved from REST API
   - Local config is used if there's an error

3. **Configs are Merged**
   - WordPress config has **priority** (overrides local)
   - Values in local config that don't exist in WordPress are preserved
   - Nested objects are merged recursively

4. **App Uses the Config**
   - Merged config is used throughout the application

### Flow Diagram

```
App Starting
    ↓
Load Local Config (assets/app_config.json)
    ↓
Fetch WordPress Config (REST API)
    ├─ ✅ Success → Merge (WordPress priority)
    └─ ❌ Error → Use Local Config
    ↓
App Uses Config
```

### Config Priority

- **WordPress Config** (if available) - Highest priority
- **Local Config** (`assets/app_config.json`) - Fallback
- **Core Package Config** - Last resort

WordPress config values override local config values. Values in local config that don't exist in WordPress are preserved.

### Code Structure

The integration consists of three main components:

#### 1. `starter.dart` - Main Integration

```dart
// Create WordPress config service
final wordPressService = WordPressConfigService(
  baseUrl: 'https://your-wordpress-site.com',
);

// Create integration helper
wordPressConfigIntegration = WordPressConfigIntegration(
  configService: wordPressService,
  assetConfigHelper: assetConfigHelper,
);

// Load and merge configs
final mergedConfig = await wordPressConfigIntegration!.loadAndMergeConfig(
  localConfigPath: 'assets/app_config.json',
  useWordPressAsPrimary: true, // WordPress priority
);
```

#### 2. `wordpress_config_service.dart` - REST API Communication

Fetches config from WordPress REST API:
- `fetchAppConfig()` - Single attempt
- `fetchAppConfigWithRetry()` - With retry
- `isAvailable()` - Endpoint check

#### 3. `wordpress_config_integration.dart` - Merge Logic

Merges configs and provides AssetConfigHelper-like API:
- `getString()`, `getBool()`, `getInt()`, `getDouble()`, `getObject()`

### Configuration

#### Changing WordPress URL

In `starter.dart` file:

```dart
final wordPressService = WordPressConfigService(
  baseUrl: 'https://your-wordpress-site.com', // Change this
);
```

#### Changing Priority Order

```dart
await wordPressConfigIntegration!.loadAndMergeConfig(
  localConfigPath: 'assets/app_config.json',
  useWordPressAsPrimary: false, // Local config priority
);
```

### Debug and Logging

When the app starts, you'll see these logs in the console:

```
📡 Attempting to load configuration from WordPress...
📂 Step 1: Loading local config from assets/app_config.json
✅ Local config loaded
📡 Step 2: Fetching config from WordPress...
✅ WordPress config fetched successfully
🔄 Step 3: Merging configurations...
✅ Configuration merged successfully
📊 Config Source: 🌐 WordPress + Local (merged)
```

### Error Scenarios

#### WordPress Not Accessible

```
⚠️ WordPress config fetch failed: [error]
📦 Using local config only
📂 Config Source: 🎯 Project
```

The app continues with local config.

#### Both Fail

```
❌ No configuration could be loaded
⚠️ Default
```

The app runs with default values.

### Config Merge Example

**Local Config:**
```json
{
  "app_settings": {
    "app_name": "Local App",
    "version": "1.0.0"
  },
  "feature_flags": {
    "feature_a": true
  }
}
```

**WordPress Config:**
```json
{
  "app_settings": {
    "app_name": "WordPress App"
  },
  "feature_flags": {
    "feature_b": true
  }
}
```

**Merged Config (WordPress priority):**
```json
{
  "app_settings": {
    "app_name": "WordPress App",  // From WordPress
    "version": "1.0.0"            // From Local (not in WordPress)
  },
  "feature_flags": {
    "feature_a": true,             // From Local
    "feature_b": true              // From WordPress
  }
}
```

### Reading Config Values

```dart
// In starter.dart or other parts of the app
if (wordPressConfigIntegration != null) {
  // Use config from WordPress
  final appName = wordPressConfigIntegration!.getString(
    'app_settings.app_name',
    'Default App',
  );
  
  final storeUrl = wordPressConfigIntegration!.getString(
    'woocommerce_configuration.store_url',
    'https://localhost:8000',
  );
}
```

### Usage in config_di.dart

When reading WooCommerce config in `lib/app/core/config/config_di.dart`, the code automatically uses WordPress merged config if available:

```dart
final AssetConfigHelper configHelper = AssetConfigHelper();

// WordPress config is already set via setConfig() in starter.dart
// So getAllConfig() returns the merged config
final storeUrl = configHelper.getString(
  'woocommerce_configuration.store_url',
  '',
);
```

The `AssetConfigHelper` automatically uses the WordPress merged config that was set in `starter.dart`.

### Summary

- ✅ WordPress config is loaded automatically when app starts
- ✅ Local config is used as fallback if WordPress is unavailable
- ✅ Configs are merged automatically (WordPress priority)
- ✅ WordPress config has priority over local config
- ✅ Graceful fallback on error
- ✅ All config values in `app_config.json` can be managed from WordPress
- ✅ Changes in WordPress admin panel are applied when app restarts

### Using WordPress Config Service Directly

If you need to use the service directly (outside of the automatic integration):

```dart
import 'package:storefront_woo/services/wordpress_config_service.dart';

// Create service instance
final configService = WordPressConfigService(
  baseUrl: 'https://your-wordpress-site.com',
);

// Fetch configuration
try {
  final config = await configService.fetchAppConfig();
  
  final appName = config['app_settings']?['app_name'];
  final storeUrl = config['woocommerce_configuration']?['store_url'];
  
  print('App Name: $appName');
  print('Store URL: $storeUrl');
} catch (e) {
  print('Error: $e');
}
```

### With Retry Logic

```dart
final configService = WordPressConfigService(
  baseUrl: 'https://your-wordpress-site.com',
);

// Fetch with automatic retry
final config = await configService.fetchAppConfigWithRetry(
  maxRetries: 3,
  retryDelay: Duration(seconds: 2),
);
```

### Check Availability

```dart
final configService = WordPressConfigService(
  baseUrl: 'https://your-wordpress-site.com',
);

if (await configService.isAvailable()) {
  final config = await configService.fetchAppConfig();
  // Use config
} else {
  // Use local config
  print('WordPress API not available, using local config');
}
```

## 🎯 Advanced Examples

### Example 1: Update Store URL Dynamically

```dart
final config = await configService.fetchAppConfig();
final storeUrl = config['woocommerce_configuration']?['store_url'] as String?;

if (storeUrl != null) {
  // Update your WooCommerce configuration
  WooNetwork.init(getIt, storeUrl: storeUrl, ...);
}
```

### Example 2: Update UI Colors

```dart
final config = await configService.fetchAppConfig();
final primaryColor = config['ui_configuration']?['primary_color'] as String?;

if (primaryColor != null) {
  // Apply color to your theme
  final color = Color(int.parse(primaryColor.replaceFirst('#', '0xFF')));
}
```

### Example 3: Feature Flags

```dart
final config = await configService.fetchAppConfig();
final featureFlags = config['feature_flags'] as Map<String, dynamic>?;

final wishlistEnabled = featureFlags?['wishlist_enabled'] as bool? ?? true;
final darkModeAvailable = featureFlags?['dark_mode_available'] as bool? ?? false;
```

### Example 4: Error Handling

```dart
try {
  final config = await configService.fetchAppConfig();
  // Use config
} on DioException catch (e) {
  if (e.type == DioExceptionType.connectionTimeout) {
    print('Connection timeout');
  } else if (e.response?.statusCode == 404) {
    print('Endpoint not found - check if plugin is activated');
  } else if (e.response?.statusCode == 500) {
    print('Server error - check WordPress admin');
  }
  // Fallback to local config
} catch (e) {
  print('Unknown error: $e');
  // Fallback to local config
}
```

### Example 5: Config Caching

```dart
class ConfigCache {
  static Map<String, dynamic>? _cachedConfig;
  static DateTime? _cacheTime;
  static const Duration cacheDuration = Duration(minutes: 5);
  
  static Future<Map<String, dynamic>> getConfig() async {
    // Return cached if still valid
    if (_cachedConfig != null && 
        _cacheTime != null && 
        DateTime.now().difference(_cacheTime!) < cacheDuration) {
      return _cachedConfig!;
    }
    
    // Fetch fresh config
    final service = WordPressConfigService(
      baseUrl: 'https://your-wordpress-site.com',
    );
    _cachedConfig = await service.fetchAppConfig();
    _cacheTime = DateTime.now();
    
    return _cachedConfig!;
  }
  
  static void clearCache() {
    _cachedConfig = null;
    _cacheTime = null;
  }
}
```

## 🔒 Security

- **GET endpoint** is public (for mobile app access)
- **POST endpoint** requires admin permissions (`manage_options` capability)
- JSON validation and sanitization on all inputs
- WordPress nonce verification for admin operations
- No sensitive data should be stored in config (use secure storage instead)
- Use HTTPS in production environments

## 🐛 Troubleshooting

### Plugin Cannot Be Activated

**Symptoms:**
- Plugin activation fails
- Error message appears

**Solutions:**
- Check PHP version (needs 7.4+)
- Check WordPress version (needs 5.0+)
- Check file permissions
- Check PHP error logs

### REST API Not Working

**Symptoms:**
- 404 Not Found error
- Endpoint not accessible

**Solutions:**

1. **Check Permalink Structure:**
   - Go to **Settings > Permalinks**
   - Select any structure (not "Plain") and save
   - This activates WordPress REST API

2. **Check .htaccess File:**
   - Ensure `.htaccess` file is writable
   - WordPress needs to update the file

3. **Test REST API:**
   ```bash
   curl https://your-wordpress-site.com/wp-json/
   ```
   This should show WordPress REST API is working.

4. **Verify Plugin is Activated:**
   - Check Plugins page
   - Ensure plugin is active

### Configuration Not Saving

**Symptoms:**
- Changes not persisting
- Save button not working

**Solutions:**
- Check WordPress database connection
- Check write permissions to `wp_options` table
- Increase PHP `max_input_vars` value (for very large JSON files)
- Check PHP error logs
- Check plugin permissions

### Invalid JSON Error

**Symptoms:**
- JSON validation errors
- Cannot save configuration

**Solutions:**
- Use **Format JSON** button to format properly
- Check quotation marks (use double quotes)
- Check for trailing commas
- Validate JSON using online tools
- Check for special characters

### WordPress Config Not Loading in Flutter App

**Symptoms:**
- App uses local config instead of WordPress config
- Network errors in logs

**Solutions:**
- Check WordPress URL in `starter.dart`
- Verify REST API endpoint is accessible
- Check network connectivity
- Review app logs for error messages
- Ensure WordPress config is saved in admin panel

### Common HTTP Errors

**404 Not Found:**
- Plugin not activated
- Permalink structure not set
- Solution: Activate plugin and set permalinks

**500 Internal Server Error:**
- Invalid JSON in WordPress
- Solution: Check WordPress admin panel and validate JSON

**Network Error:**
- No internet connection
- Solution: Implement retry logic and fallback to local config

## 📁 File Structure

```
osmea-app-config-manager/
├── osmea-app-config-manager.php  # Main plugin file
├── default-config.json            # Default configuration template
├── assets/
│   ├── admin.css                  # Admin panel styles
│   └── admin.js                   # Admin panel JavaScript
└── README.md                      # This documentation
```

## 📋 Requirements

- **WordPress:** 5.0 or higher
- **PHP:** 7.4 or higher
- **JSON Extension:** Usually included by default in PHP
- **WordPress REST API:** Must be enabled (default in WordPress 4.7+)

## ✅ Verification Checklist

After installation, verify everything works:

- [ ] Plugin folder downloaded/extracted
- [ ] ZIP file created (if using upload method)
- [ ] Plugin uploaded to WordPress
- [ ] Plugin activated in WordPress
- [ ] Settings page accessible (Settings > OSMEA App Config)
- [ ] Configuration saved successfully
- [ ] REST API endpoint working (test in browser)
- [ ] JSON response is valid
- [ ] Flutter app can fetch config
- [ ] WordPress config overrides local config

## 📝 Best Practices

1. **Always have a fallback** to local `app_config.json`
2. **Cache the config** to reduce API calls
3. **Use retry logic** for network issues
4. **Validate response** before using
5. **Handle errors gracefully** with user-friendly messages
6. **Use HTTPS** in production
7. **Don't store sensitive data** in config
8. **Backup configuration** regularly using Export feature
9. **Test changes** in staging before production
10. **Monitor API calls** for performance

## 📄 License

GPL v2 or later

## 💬 Support

- **GitHub Issues:** https://github.com/masterfabric-mobile/osmea
- **Documentation:** Check this README and inline code comments
- **Troubleshooting:** See Troubleshooting section above

## 📚 Changelog

### 1.0.0
- Initial release
- Admin panel interface
- REST API endpoints (GET/POST)
- JSON validation and formatting
- Import/export features
- WordPress config integration
- Config merge functionality
- Protection from override

---

**Need help?** Check the Troubleshooting section or open an issue on GitHub.
