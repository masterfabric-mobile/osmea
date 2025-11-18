import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 🍪 Web-compatible cookie manager using SharedPreferences for localStorage
/// Enhanced with WooCommerce cookie support and expiration management
class WebCookieManager extends Interceptor {
  static const String _cookieStorageKey = 'osmea_cookies';
  SharedPreferences? _prefs;

  /// 🍪 Initialize SharedPreferences
  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// 🍪 Load cookies from SharedPreferences with expiration data
  Future<Map<String, String>> _loadCookies() async {
    try {
      await _initPrefs();
      final cookieData = _prefs!.getString(_cookieStorageKey);
      if (cookieData != null) {
        final Map<String, dynamic> decoded = json.decode(cookieData);
        return decoded.map((key, value) => MapEntry(key, value.toString()));
      }
    } catch (e) {
      debugPrint('❌ [WebCookieManager] Error loading cookies: $e');
    }
    return {};
  }

  /// 🍪 Save cookies to SharedPreferences with expiration data
  Future<void> _saveCookies(Map<String, String> cookies) async {
    try {
      await _initPrefs();
      await _prefs!.setString(_cookieStorageKey, json.encode(cookies));
    } catch (e) {
      debugPrint('❌ [WebCookieManager] Error saving cookies: $e');
    }
  }

  /// 🍪 Parse Set-Cookie header and extract cookies
  Map<String, String> _parseSetCookieHeader(String setCookieHeader) {
    final Map<String, String> cookies = {};
    final cookiePairs = setCookieHeader.split(',');

    for (final pair in cookiePairs) {
      final trimmedPair = pair.trim();
      final cookieParts = trimmedPair.split(';');
      if (cookieParts.isNotEmpty) {
        final nameValue = cookieParts[0].split('=');
        if (nameValue.length == 2) {
          cookies[nameValue[0].trim()] = nameValue[1].trim();
        }
      }
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
      final cookies = await _loadCookies();
      // Load existing cookies from storage (already filters expired)
      if (cookies.isNotEmpty) {
        final cookieHeader = _buildCookieHeader(cookies);
        options.headers['Cookie'] = cookieHeader;
        debugPrint('🍪 Added cookies to request: $cookieHeader');
      }
    } catch (e) {
      debugPrint('❌ [WebCookieManager] Error adding cookies to request: $e');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    try {
      final setCookieHeaders = response.headers['set-cookie'];
      if (setCookieHeaders != null && setCookieHeaders.isNotEmpty) {
        debugPrint(
            '🍪 [WebCookieManager] Found ${setCookieHeaders.length} Set-Cookie header(s) (accessible!)');
        debugPrint(
            '🍪 [WebCookieManager] Set-Cookie values: $setCookieHeaders');

        final existingCookies = await _loadCookies();
        // Parse and merge new cookies
        for (final setCookieHeader in setCookieHeaders) {
          final newCookies = _parseSetCookieHeader(setCookieHeader);
          existingCookies.addAll(newCookies);
        }

        // Save updated cookies
        await _saveCookies(existingCookies);
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

  /// 📋 Get all stored cookies (returns simple map for backward compatibility)
  /// On web, this also reads cookies from document.cookie (non-HttpOnly cookies)
  Future<Map<String, String>> getAllCookies() async {
    return await _loadCookies();
  }

  /// 🔍 Check if a specific cookie exists and is not expired
  Future<bool> hasCookie(String name) async {
    final cookies = await _loadCookies();
    return cookies.containsKey(name);
  }

  /// 🍪 Get a specific cookie value (returns null if expired)
  Future<String?> getCookie(String name) async {
    final cookies = await _loadCookies();
    return cookies[name];
  }
}
