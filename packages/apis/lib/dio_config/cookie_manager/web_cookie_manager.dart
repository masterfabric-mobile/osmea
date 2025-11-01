import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Conditional import for web-only dart:html
// On web: use dart:html, on non-web: use stub
import 'html_stub.dart' if (dart.library.html) 'dart:html' as html;

/// 🍪 Web-compatible cookie manager using SharedPreferences for localStorage
class WebCookieManager extends Interceptor {
  static const String _cookieStorageKey = 'osmea_cookies';
  SharedPreferences? _prefs;

  /// 🍪 Initialize SharedPreferences
  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// 🍪 Load cookies from SharedPreferences
  Future<Map<String, String>> _loadCookies() async {
    try {
      await _initPrefs();
      final cookieData = _prefs!.getString(_cookieStorageKey);
      if (cookieData != null) {
        final Map<String, dynamic> decoded = json.decode(cookieData);
        return decoded.map((key, value) => MapEntry(key, value.toString()));
      }
    } catch (e) {
      debugPrint('Error loading cookies: $e');
    }
    return {};
  }

  /// 🍪 Save cookies to SharedPreferences
  Future<void> _saveCookies(Map<String, String> cookies) async {
    try {
      await _initPrefs();
      await _prefs!.setString(_cookieStorageKey, json.encode(cookies));
    } catch (e) {
      debugPrint('Error saving cookies: $e');
    }
  }

  /// 🍪 Parse Set-Cookie header and extract cookies
  ///
  /// Note: Each Set-Cookie header is a single cookie, not comma-separated.
  /// Multiple Set-Cookie headers come as separate items in the headers list.
  Map<String, String> _parseSetCookieHeader(String setCookieHeader) {
    final Map<String, String> cookies = {};

    if (setCookieHeader.isEmpty) {
      debugPrint('⚠️ [WebCookieManager] Empty Set-Cookie header');
      return cookies;
    }

    debugPrint(
        '🍪 [WebCookieManager] Parsing Set-Cookie header: $setCookieHeader');

    // Set-Cookie format: name=value; attribute1=value1; attribute2=value2
    // We only need the name=value part (the first part before semicolon)
    final cookieParts = setCookieHeader.split(';');
    if (cookieParts.isNotEmpty) {
      final firstPart = cookieParts[0].trim();
      debugPrint('🍪 [WebCookieManager] First part (name=value): $firstPart');

      if (firstPart.contains('=')) {
        final name = firstPart.substring(0, firstPart.indexOf('=')).trim();
        final value = firstPart.substring(firstPart.indexOf('=') + 1).trim();

        debugPrint(
            '🍪 [WebCookieManager] Extracted - name: $name, value length: ${value.length}');

        if (name.isNotEmpty) {
          if (value.isNotEmpty) {
            cookies[name] = value;
            debugPrint(
                '✅ [WebCookieManager] Parsed cookie: $name=${value.length > 50 ? value.substring(0, 50) + "..." : value}');
          } else {
            debugPrint('⚠️ [WebCookieManager] Cookie $name has empty value');
            cookies[name] = ''; // Still save empty cookies
          }
        } else {
          debugPrint('❌ [WebCookieManager] Cookie name is empty');
        }
      } else {
        debugPrint(
            '❌ [WebCookieManager] No = found in cookie header: $firstPart');
      }
    } else {
      debugPrint('❌ [WebCookieManager] No cookie parts found in header');
    }

    return cookies;
  }

  /// 🍪 Build Cookie header from stored cookies
  String _buildCookieHeader(Map<String, String> cookies) {
    return cookies.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join('; ');
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      // Load existing cookies
      final cookies = await _loadCookies();

      // Add cookies to request headers if any exist
      if (cookies.isNotEmpty) {
        final cookieHeader = _buildCookieHeader(cookies);
        options.headers['Cookie'] = cookieHeader;
        debugPrint('🍪 Added cookies to request: $cookieHeader');
      }
    } catch (e) {
      debugPrint('Error adding cookies to request: $e');
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

      // Try different case variations for Set-Cookie header
      final setCookieHeaders = response.headers['set-cookie'] ??
          response.headers['Set-Cookie'] ??
          response.headers['SET-COOKIE'];

      // Also check headers.map directly for any Set-Cookie variations
      if (setCookieHeaders == null || setCookieHeaders.isEmpty) {
        debugPrint(
            '🍪 [WebCookieManager] No Set-Cookie header found, checking all headers...');
        for (final key in response.headers.map.keys) {
          if (key.toLowerCase().contains('cookie')) {
            debugPrint(
                '🍪 [WebCookieManager] Found cookie-related header: $key = ${response.headers[key]}');
            final cookieHeaders = response.headers[key];
            if (cookieHeaders != null && cookieHeaders.isNotEmpty) {
              debugPrint(
                  '🍪 [WebCookieManager] Cookie header values: $cookieHeaders');
            }
          }
        }
      }

      if (setCookieHeaders != null && setCookieHeaders.isNotEmpty) {
        debugPrint(
            '🍪 [WebCookieManager] Found ${setCookieHeaders.length} Set-Cookie header(s)');
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
          existingCookies.addAll(newCookies);
        }

        // Save updated cookies
        await _saveCookies(existingCookies);
        debugPrint(
            '🍪 [WebCookieManager] Saved new cookies: ${existingCookies.keys.join(', ')}');
        debugPrint(
            '🍪 [WebCookieManager] Total cookies after save: ${existingCookies.length}');
      } else {
        debugPrint(
            '⚠️ [WebCookieManager] No Set-Cookie headers found in response');

        // ⚠️ On web, JavaScript cannot read Set-Cookie headers (browser security)
        // Try reading cookies directly from browser's document.cookie instead
        if (kIsWeb) {
          debugPrint(
              '🍪 [WebCookieManager] Attempting to read cookies from document.cookie...');
          final browserCookies = _readBrowserCookies();
          if (browserCookies.isNotEmpty) {
            await _saveCookies(browserCookies);
            debugPrint(
                '🍪 [WebCookieManager] Saved ${browserCookies.length} cookies from browser');
          } else {
            debugPrint(
                '⚠️ [WebCookieManager] No cookies found in document.cookie either');
            debugPrint('💡 [WebCookieManager] This may be due to:');
            debugPrint(
                '   1. Cookies are HttpOnly (not accessible to JavaScript)');
            debugPrint(
                '   2. CORS policy blocking cookies (need Access-Control-Allow-Credentials)');
            debugPrint('   3. SameSite policy preventing cookie storage');
            debugPrint('   4. Server not sending cookies for this endpoint');
          }
        }
      }
    } catch (e) {
      debugPrint('Error processing response cookies: $e');
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
            existingCookies.addAll(newCookies);
          }

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

  /// 📋 Get all stored cookies
  /// On web, this also reads cookies from document.cookie (non-HttpOnly cookies)
  Future<Map<String, String>> getAllCookies() async {
    final cookies = await _loadCookies();

    // On web, also try to read from document.cookie
    if (kIsWeb) {
      final browserCookies = _readBrowserCookies();
      // Merge browser cookies (browser cookies take precedence as they are more current)
      final mergedCookies = Map<String, String>.from(cookies);
      mergedCookies.addAll(browserCookies);
      debugPrint(
          '🍪 [WebCookieManager] getAllCookies() - Storage: ${cookies.length}, Browser: ${browserCookies.length}, Merged: ${mergedCookies.length}');
      return mergedCookies;
    }

    debugPrint(
        '🍪 [WebCookieManager] getAllCookies() - returning ${cookies.length} cookies: ${cookies.keys.toList()}');
    return cookies;
  }

  /// 🔍 Check if a specific cookie exists
  Future<bool> hasCookie(String name) async {
    final cookies = await _loadCookies();
    return cookies.containsKey(name);
  }

  /// 🍪 Get a specific cookie value
  Future<String?> getCookie(String name) async {
    final cookies = await _loadCookies();
    return cookies[name];
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
