import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Conditional import for web-only dart:html
// On web: use dart:html, on non-web: use stub
import 'html_stub.dart' if (dart.library.html) 'dart:html' as html;

/// 🍪 Cookie data model with expiration support
class CookieData {
  final String value;
  final DateTime? expiresAt;
  final Duration? maxAge;
  final bool isSession; // Session cookie (expires when browser closes)

  CookieData({
    required this.value,
    this.expiresAt,
    this.maxAge,
    this.isSession = false,
  });

  /// Check if cookie is expired
  bool get isExpired {
    if (isSession) return false; // Session cookies expire on browser close
    if (expiresAt != null) {
      return DateTime.now().isAfter(expiresAt!);
    }
    // If no expiration data, assume it's still valid (browser will handle it)
    return false;
  }

  Map<String, dynamic> toJson() => {
        'value': value,
        'expiresAt': expiresAt?.toIso8601String(),
        'maxAgeSeconds': maxAge?.inSeconds,
        'isSession': isSession,
      };

  factory CookieData.fromJson(Map<String, dynamic> json) => CookieData(
        value: json['value'] as String,
        expiresAt: json['expiresAt'] != null
            ? DateTime.parse(json['expiresAt'] as String)
            : null,
        maxAge: json['maxAgeSeconds'] != null
            ? Duration(seconds: json['maxAgeSeconds'] as int)
            : null,
        isSession: json['isSession'] as bool? ?? false,
      );
}

/// 🍪 Web-compatible cookie manager using SharedPreferences for localStorage
/// Enhanced with WooCommerce cookie support and expiration management
class WebCookieManager extends Interceptor {
  static const String _cookieStorageKey = 'osmea_cookies';
  SharedPreferences? _prefs;

  // WooCommerce standard cookie durations (from documentation)
  static const Map<String, Duration> _wooCommerceCookieDurations = {
    'woocommerce_cart_hash': Duration.zero, // Session
    'woocommerce_items_in_cart': Duration.zero, // Session
    'wp_woocommerce_session_': Duration(days: 2), // 2 days
    'woocommerce_recently_viewed': Duration.zero, // Session
    'woocommerce_snooze_suggestions__': Duration(days: 2), // 2 days
    'woocommerce_dismissed_suggestions__':
        Duration(days: 30), // 1 month (30 days)
    'tk_ai': Duration.zero, // Session
  };

  /// Get WooCommerce cookie duration based on cookie name pattern
  static Duration? _getWooCommerceCookieDuration(String cookieName) {
    // Check for exact matches or patterns
    for (final entry in _wooCommerceCookieDurations.entries) {
      if (cookieName.startsWith(entry.key)) {
        return entry.value;
      }
    }

    // Check for store_notice pattern: store_notice[notice id]
    if (cookieName.startsWith('store_notice')) {
      return Duration.zero; // Session
    }

    return null; // Unknown cookie, use server-provided expiration
  }

  /// 🍪 Initialize SharedPreferences
  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// 🍪 Load cookies from SharedPreferences with expiration data
  Future<Map<String, CookieData>> _loadCookies() async {
    try {
      await _initPrefs();
      final cookieData = _prefs!.getString(_cookieStorageKey);
      if (cookieData != null) {
        final Map<String, dynamic> decoded = json.decode(cookieData);
        final cookies = <String, CookieData>{};

        for (final entry in decoded.entries) {
          try {
            final cookieValue = entry.value;
            if (cookieValue is Map<String, dynamic>) {
              // New format with expiration data
              cookies[entry.key] = CookieData.fromJson(cookieValue);
            } else {
              // Legacy format (just string value) - convert to CookieData
              cookies[entry.key] = CookieData(
                value: cookieValue.toString(),
                isSession: true, // Assume session cookie for legacy data
              );
            }
          } catch (e) {
            debugPrint(
                '⚠️ [WebCookieManager] Error parsing cookie ${entry.key}: $e');
          }
        }

        // Clean expired cookies
        await _cleanExpiredCookies(cookies);

        return cookies;
      }
    } catch (e) {
      debugPrint('❌ [WebCookieManager] Error loading cookies: $e');
    }
    return {};
  }

  /// 🍪 Save cookies to SharedPreferences with expiration data
  Future<void> _saveCookies(Map<String, CookieData> cookies) async {
    try {
      await _initPrefs();

      // Clean expired cookies before saving
      await _cleanExpiredCookies(cookies);

      final cookieMap =
          cookies.map((key, value) => MapEntry(key, value.toJson()));
      await _prefs!.setString(_cookieStorageKey, json.encode(cookieMap));

      debugPrint('✅ [WebCookieManager] Saved ${cookies.length} cookie(s)');
    } catch (e) {
      debugPrint('❌ [WebCookieManager] Error saving cookies: $e');
    }
  }

  /// 🗑️ Clean expired cookies from the map
  Future<void> _cleanExpiredCookies(Map<String, CookieData> cookies) async {
    final expiredCookies = <String>[];

    for (final entry in cookies.entries) {
      if (entry.value.isExpired) {
        expiredCookies.add(entry.key);
        debugPrint('🗑️ [WebCookieManager] Cookie expired: ${entry.key}');
      }
    }

    if (expiredCookies.isNotEmpty) {
      for (final key in expiredCookies) {
        cookies.remove(key);
      }
      debugPrint(
          '🗑️ [WebCookieManager] Removed ${expiredCookies.length} expired cookie(s)');
    }
  }

  /// 🍪 Parse Set-Cookie header and extract cookies with expiration data
  ///
  /// Note: Each Set-Cookie header is a single cookie, not comma-separated.
  /// Multiple Set-Cookie headers come as separate items in the headers list.
  ///
  /// Format: name=value; Expires=date; Max-Age=seconds; Path=/; Domain=.example.com
  Map<String, CookieData> _parseSetCookieHeader(String setCookieHeader) {
    final Map<String, CookieData> cookies = {};

    if (setCookieHeader.isEmpty) {
      debugPrint('⚠️ [WebCookieManager] Empty Set-Cookie header');
      return cookies;
    }

    debugPrint(
        '🍪 [WebCookieManager] Parsing Set-Cookie header: $setCookieHeader');

    // Set-Cookie format: name=value; attribute1=value1; attribute2=value2
    final cookieParts = setCookieHeader.split(';');
    if (cookieParts.isEmpty) {
      debugPrint('❌ [WebCookieManager] No cookie parts found in header');
      return cookies;
    }

    // First part is always name=value
    final firstPart = cookieParts[0].trim();
    if (!firstPart.contains('=')) {
      debugPrint(
          '❌ [WebCookieManager] No = found in cookie header: $firstPart');
      return cookies;
    }

    final name = firstPart.substring(0, firstPart.indexOf('=')).trim();
    final value = firstPart.substring(firstPart.indexOf('=') + 1).trim();

    if (name.isEmpty) {
      debugPrint('❌ [WebCookieManager] Cookie name is empty');
      return cookies;
    }

    debugPrint(
        '🍪 [WebCookieManager] Extracted - name: $name, value length: ${value.length}');

    // Parse attributes
    DateTime? expiresAt;
    Duration? maxAge;
    bool isSession = false;

    for (int i = 1; i < cookieParts.length; i++) {
      final part = cookieParts[i].trim().toLowerCase();

      if (part.startsWith('expires=')) {
        try {
          final expiresStr = cookieParts[i].substring(8).trim();
          // Parse HTTP date format (e.g., "Wed, 21 Oct 2015 07:28:00 GMT")
          expiresAt = _parseHttpDate(expiresStr);
          if (expiresAt != null) {
            debugPrint(
                '📅 [WebCookieManager] Cookie $name expires at: $expiresAt');
          }
        } catch (e) {
          debugPrint('⚠️ [WebCookieManager] Error parsing Expires date: $e');
        }
      } else if (part.startsWith('max-age=')) {
        try {
          final maxAgeStr = cookieParts[i].substring(8).trim();
          final maxAgeSeconds = int.parse(maxAgeStr);
          if (maxAgeSeconds > 0) {
            maxAge = Duration(seconds: maxAgeSeconds);
            // Calculate expiration from now + maxAge
            expiresAt = DateTime.now().add(maxAge);
            debugPrint(
                '⏱️ [WebCookieManager] Cookie $name max-age: ${maxAgeSeconds}s, expires at: $expiresAt');
          } else if (maxAgeSeconds == 0) {
            // Max-Age=0 means delete cookie
            debugPrint(
                '🗑️ [WebCookieManager] Cookie $name has Max-Age=0, will be deleted');
            return cookies; // Don't add this cookie
          }
        } catch (e) {
          debugPrint('⚠️ [WebCookieManager] Error parsing Max-Age: $e');
        }
      } else if (part == 'httponly' || part == 'secure') {
        // These are flags, no values
        continue;
      }
    }

    // If no Expires or Max-Age, it's a session cookie
    if (expiresAt == null && maxAge == null) {
      isSession = true;
      debugPrint('📝 [WebCookieManager] Cookie $name is a session cookie');
    }

    // Check WooCommerce cookie duration if not set by server
    if (!isSession && expiresAt == null && maxAge == null) {
      final wooDuration = _getWooCommerceCookieDuration(name);
      if (wooDuration != null) {
        if (wooDuration == Duration.zero) {
          isSession = true;
          debugPrint(
              '📝 [WebCookieManager] Cookie $name is a WooCommerce session cookie');
        } else {
          expiresAt = DateTime.now().add(wooDuration);
          maxAge = wooDuration;
          debugPrint(
              '⏱️ [WebCookieManager] Cookie $name using WooCommerce duration: $wooDuration');
        }
      }
    }

    final cookieData = CookieData(
      value: value.isEmpty ? '' : value,
      expiresAt: expiresAt,
      maxAge: maxAge,
      isSession: isSession,
    );

    cookies[name] = cookieData;
    debugPrint(
        '✅ [WebCookieManager] Parsed cookie: $name=${value.length > 50 ? value.substring(0, 50) + "..." : value} (session: $isSession, expires: $expiresAt)');

    return cookies;
  }

  /// 📅 Parse HTTP date format (RFC 7231)
  /// Examples: "Wed, 21 Oct 2015 07:28:00 GMT", "Mon, 01 Jan 2024 00:00:00 GMT"
  DateTime? _parseHttpDate(String dateStr) {
    try {
      // Try standard DateTime.parse (handles most HTTP date formats)
      return DateTime.parse(dateStr);
    } catch (e) {
      debugPrint('⚠️ [WebCookieManager] Could not parse date: $dateStr');
      return null;
    }
  }

  /// 🍪 Build Cookie header from stored cookies (filtering expired ones)
  String _buildCookieHeader(Map<String, CookieData> cookies) {
    // Filter out expired cookies
    final validCookies = cookies.entries
        .where((entry) => !entry.value.isExpired)
        .map((entry) => '${entry.key}=${entry.value.value}')
        .toList();

    if (validCookies.isEmpty) return '';

    return validCookies.join('; ');
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      // Load existing cookies from storage (already filters expired)
      var cookies = await _loadCookies();

      // On web, also read cookies from browser (for non-HttpOnly cookies)
      // Note: HttpOnly cookies are automatically sent by browser
      if (kIsWeb) {
        final browserCookies = _readBrowserCookies();
        // Merge browser cookies (convert to CookieData)
        for (final entry in browserCookies.entries) {
          // Browser cookies take precedence, but check if we already have expiration data
          if (!cookies.containsKey(entry.key) ||
              cookies[entry.key]?.isExpired == true) {
            // For browser cookies, we can't know expiration, so assume session cookie
            cookies[entry.key] = CookieData(
              value: entry.value,
              isSession: true,
            );
          } else {
            // Update value but keep expiration data
            final existing = cookies[entry.key]!;
            cookies[entry.key] = CookieData(
              value: entry.value,
              expiresAt: existing.expiresAt,
              maxAge: existing.maxAge,
              isSession: existing.isSession,
            );
          }
        }

        if (browserCookies.isNotEmpty) {
          debugPrint(
              '🍪 [WebCookieManager] Found ${browserCookies.length} cookie(s) in browser');
        }
      }

      // Clean expired cookies before building header
      await _cleanExpiredCookies(cookies);

      // Add cookies to request headers if any exist
      if (cookies.isNotEmpty) {
        final cookieHeader = _buildCookieHeader(cookies);
        if (cookieHeader.isNotEmpty) {
          options.headers['Cookie'] = cookieHeader;
          final validCount =
              cookies.entries.where((e) => !e.value.isExpired).length;
          debugPrint(
              '🍪 [WebCookieManager] Added $validCount valid cookie(s) to request (${cookies.length} total)');
          debugPrint(
              '🍪 [WebCookieManager] Cookie header: ${cookieHeader.length > 100 ? cookieHeader.substring(0, 100) + "..." : cookieHeader}');
        } else {
          debugPrint(
              '🍪 [WebCookieManager] All cookies expired, not adding to request');
        }
      } else {
        debugPrint(
            '🍪 [WebCookieManager] No cookies to add (browser will send HttpOnly cookies automatically)');
      }
    } catch (e) {
      debugPrint('❌ [WebCookieManager] Error adding cookies to request: $e');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    try {
      debugPrint(
          '🍪 [WebCookieManager] Processing response for: ${response.requestOptions.path}');
      debugPrint(
          '🍪 [WebCookieManager] All response headers: ${response.headers.map.keys.toList()}');

      // ⚠️ IMPORTANT: On web platform, Set-Cookie headers are NOT accessible via JavaScript
      // due to browser security policies (even with withCredentials=true)
      // Browser automatically processes Set-Cookie headers and stores cookies
      // We can only read non-HttpOnly cookies from document.cookie after a delay

      // Try different case variations for Set-Cookie header (may work in some cases)
      final setCookieHeaders = response.headers['set-cookie'] ??
          response.headers['Set-Cookie'] ??
          response.headers['SET-COOKIE'];

      // Check if Set-Cookie headers are accessible
      if (setCookieHeaders != null && setCookieHeaders.isNotEmpty) {
        debugPrint(
            '🍪 [WebCookieManager] Found ${setCookieHeaders.length} Set-Cookie header(s) (accessible!)');
        debugPrint(
            '🍪 [WebCookieManager] Set-Cookie values: $setCookieHeaders');

        final existingCookies = await _loadCookies();
        debugPrint(
            '🍪 [WebCookieManager] Existing cookies before: ${existingCookies.keys.toList()}');

        // Parse and merge new cookies
        for (final setCookieHeader in setCookieHeaders) {
          debugPrint(
              '🍪 [WebCookieManager] Parsing Set-Cookie: $setCookieHeader');
          final newCookies = _parseSetCookieHeader(setCookieHeader);
          debugPrint(
              '🍪 [WebCookieManager] Parsed cookies: ${newCookies.keys.toList()}');

          // Merge new cookies (new cookies override existing ones)
          for (final entry in newCookies.entries) {
            existingCookies[entry.key] = entry.value;
            debugPrint(
                '✅ [WebCookieManager] Updated cookie: ${entry.key} (session: ${entry.value.isSession}, expires: ${entry.value.expiresAt})');
          }
        }

        // Clean expired cookies before saving
        await _cleanExpiredCookies(existingCookies);

        // Save updated cookies
        await _saveCookies(existingCookies);
        debugPrint(
            '🍪 [WebCookieManager] Saved new cookies: ${existingCookies.keys.join(', ')}');
        debugPrint(
            '🍪 [WebCookieManager] Total cookies after save: ${existingCookies.length}');
      } else {
        debugPrint(
            '⚠️ [WebCookieManager] Set-Cookie headers not accessible in response (normal on web)');

        // On web, browser automatically processes Set-Cookie headers
        // Wait a bit for browser to process cookies, then read from document.cookie
        if (kIsWeb) {
          debugPrint(
              '🍪 [WebCookieManager] Browser will automatically process Set-Cookie headers...');
          debugPrint(
              '🍪 [WebCookieManager] Waiting for browser to process cookies, then reading from document.cookie...');

          // Wait for browser to process Set-Cookie headers
          // Try multiple times with increasing delays to catch cookies as they're processed
          _readCookiesWithRetry(response.requestOptions.path);
        }
      }
    } catch (e) {
      debugPrint('❌ [WebCookieManager] Error processing response cookies: $e');
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    try {
      // Check for Set-Cookie headers in error response
      if (err.response != null) {
        final setCookieHeaders = err.response!.headers['set-cookie'];
        if (setCookieHeaders != null && setCookieHeaders.isNotEmpty) {
          final existingCookies = await _loadCookies();

          // Parse and merge new cookies
          for (final setCookieHeader in setCookieHeaders) {
            final newCookies = _parseSetCookieHeader(setCookieHeader);
            // Merge new cookies (new cookies override existing ones)
            for (final entry in newCookies.entries) {
              existingCookies[entry.key] = entry.value;
            }
          }

          // Clean expired cookies before saving
          await _cleanExpiredCookies(existingCookies);

          // Save updated cookies
          await _saveCookies(existingCookies);
          debugPrint(
              '🍪 Saved error response cookies: ${existingCookies.keys.join(', ')}');
        }
      }
    } catch (e) {
      debugPrint('Error processing error response cookies: $e');
    }

    handler.next(err);
  }

  /// 🗑️ Clear all stored cookies
  Future<void> clearCookies() async {
    try {
      await _initPrefs();
      await _prefs!.remove(_cookieStorageKey);
      debugPrint('🍪 All cookies cleared');
    } catch (e) {
      debugPrint('Error clearing cookies: $e');
    }
  }

  /// 📋 Get all stored cookies (returns simple map for backward compatibility)
  /// On web, this also reads cookies from document.cookie (non-HttpOnly cookies)
  Future<Map<String, String>> getAllCookies() async {
    final cookies = await _loadCookies();

    // Convert CookieData to simple string map (filter expired)
    final simpleCookies = <String, String>{};
    for (final entry in cookies.entries) {
      if (!entry.value.isExpired) {
        simpleCookies[entry.key] = entry.value.value;
      }
    }

    // On web, also try to read from document.cookie
    if (kIsWeb) {
      final browserCookies = _readBrowserCookies();
      // Merge browser cookies (browser cookies take precedence as they are more current)
      simpleCookies.addAll(browserCookies);
      debugPrint(
          '🍪 [WebCookieManager] getAllCookies() - Storage: ${cookies.length}, Browser: ${browserCookies.length}, Merged: ${simpleCookies.length}');
      return simpleCookies;
    }

    debugPrint(
        '🍪 [WebCookieManager] getAllCookies() - returning ${simpleCookies.length} cookies: ${simpleCookies.keys.toList()}');
    return simpleCookies;
  }

  /// 🔍 Check if a specific cookie exists and is not expired
  Future<bool> hasCookie(String name) async {
    final cookies = await _loadCookies();
    final cookie = cookies[name];
    return cookie != null && !cookie.isExpired;
  }

  /// 🍪 Get a specific cookie value (returns null if expired)
  Future<String?> getCookie(String name) async {
    final cookies = await _loadCookies();
    final cookie = cookies[name];
    if (cookie != null && !cookie.isExpired) {
      return cookie.value;
    }
    return null;
  }

  /// 🍪 Get a specific cookie with full data (including expiration)
  Future<CookieData?> getCookieData(String name) async {
    final cookies = await _loadCookies();
    final cookie = cookies[name];
    if (cookie != null && !cookie.isExpired) {
      return cookie;
    }
    return null;
  }

  /// 🌐 Read cookies from browser with retry mechanism
  /// Tries multiple times with increasing delays to catch cookies as browser processes them
  void _readCookiesWithRetry(String path) async {
    const delays = [100, 300, 500, 1000]; // Try at 100ms, 300ms, 500ms, 1000ms
    int maxCookiesFound = 0;

    for (final delayMs in delays) {
      await Future.delayed(Duration(milliseconds: delayMs));

      try {
        final browserCookies = _readBrowserCookies();
        debugPrint(
            '🍪 [WebCookieManager] Browser cookies at ${delayMs}ms: ${browserCookies.keys.toList()} (${browserCookies.length} cookies)');

        if (browserCookies.length > maxCookiesFound) {
          maxCookiesFound = browserCookies.length;

          // Merge with existing cookies
          final existingCookies = await _loadCookies();
          final beforeCount = existingCookies.length;

          // Convert browser cookies to CookieData (assume session cookies)
          for (final entry in browserCookies.entries) {
            // Keep existing expiration data if available, otherwise assume session
            final existing = existingCookies[entry.key];
            existingCookies[entry.key] = CookieData(
              value: entry.value,
              expiresAt: existing?.expiresAt,
              maxAge: existing?.maxAge,
              isSession: existing?.isSession ?? true,
            );
          }

          // Clean expired cookies before saving
          await _cleanExpiredCookies(existingCookies);

          await _saveCookies(existingCookies);

          final newCount = existingCookies.length - beforeCount;
          if (newCount > 0) {
            debugPrint(
                '✅ [WebCookieManager] Saved $newCount new cookie(s) from browser at ${delayMs}ms (non-HttpOnly only)');
            debugPrint(
                '🍪 [WebCookieManager] Total cookies: ${existingCookies.length}');
            debugPrint(
                '🍪 [WebCookieManager] Cookies: ${existingCookies.keys.join(", ")}');
          }
        }

        // If we found cookies and they haven't changed, we can stop retrying
        if (browserCookies.length > 0 &&
            browserCookies.length == maxCookiesFound &&
            delayMs >= 300) {
          debugPrint(
              '✅ [WebCookieManager] Cookie reading stabilized at ${delayMs}ms');
          break;
        }
      } catch (e) {
        debugPrint(
            '❌ [WebCookieManager] Error reading browser cookies at ${delayMs}ms: $e');
      }
    }

    // Final check
    final finalCookies = _readBrowserCookies();
    if (finalCookies.isEmpty && maxCookiesFound == 0) {
      debugPrint(
          '⚠️ [WebCookieManager] No cookies found in document.cookie after all retries');
      debugPrint('💡 [WebCookieManager] Possible reasons:');
      debugPrint(
          '   1. Cookies are HttpOnly (browser handles automatically, not accessible via JavaScript)');
      debugPrint(
          '   2. Cookies need more time or are set by a different domain/path');
      debugPrint('   3. CORS/SameSite policy preventing cookie storage');
      debugPrint('   4. Server not sending Set-Cookie headers');
      debugPrint(
          '   NOTE: HttpOnly cookies are still sent automatically by browser on next request!');
      debugPrint(
          '   NOTE: Check Network tab in DevTools to see if Set-Cookie headers are present');
    }
  }

  /// 🌐 Read cookies directly from browser's document.cookie
  /// This only works for non-HttpOnly cookies on web platform
  Map<String, String> _readBrowserCookies() {
    final Map<String, String> cookies = {};

    if (!kIsWeb) {
      return cookies;
    }

    try {
      // Read from document.cookie (format: "name1=value1; name2=value2; ...")
      final cookieString = html.document.cookie ?? '';
      debugPrint('🍪 [WebCookieManager] document.cookie: $cookieString');

      if (cookieString.isEmpty) {
        debugPrint('⚠️ [WebCookieManager] document.cookie is empty');
        return cookies;
      }

      // Parse cookies
      final cookiePairs = cookieString.split('; ');
      for (final pair in cookiePairs) {
        final parts = pair.split('=');
        if (parts.length >= 2) {
          final name = parts[0].trim();
          // Handle values that might contain '=' characters
          final value = pair.substring(pair.indexOf('=') + 1).trim();
          if (name.isNotEmpty) {
            cookies[name] = value;
            debugPrint(
                '🍪 [WebCookieManager] Found browser cookie: $name=${value.length > 50 ? value.substring(0, 50) + "..." : value}');
          }
        }
      }

      debugPrint(
          '🍪 [WebCookieManager] Total browser cookies: ${cookies.length}');
    } catch (e) {
      debugPrint('❌ [WebCookieManager] Error reading document.cookie: $e');
    }

    return cookies;
  }
}
