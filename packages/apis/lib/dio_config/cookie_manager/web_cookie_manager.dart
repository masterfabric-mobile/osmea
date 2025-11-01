import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    
    // Set-Cookie format: name=value; attribute1=value1; attribute2=value2
    // We only need the name=value part (the first part before semicolon)
    final cookieParts = setCookieHeader.split(';');
    if (cookieParts.isNotEmpty) {
      final nameValue = cookieParts[0].trim().split('=');
      if (nameValue.length >= 2) {
        // Handle case where value might contain '=' characters
        final name = nameValue[0].trim();
        final value = cookieParts[0]
            .substring(cookieParts[0].indexOf('=') + 1)
            .trim();
        if (name.isNotEmpty && value.isNotEmpty) {
          cookies[name] = value;
          debugPrint('🍪 Parsed cookie: $name=${value.length > 50 ? value.substring(0, 50) + "..." : value}');
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
      // Check for Set-Cookie headers in response
      final setCookieHeaders = response.headers['set-cookie'];
      if (setCookieHeaders != null && setCookieHeaders.isNotEmpty) {
        final existingCookies = await _loadCookies();

        // Parse and merge new cookies
        for (final setCookieHeader in setCookieHeaders) {
          final newCookies = _parseSetCookieHeader(setCookieHeader);
          existingCookies.addAll(newCookies);
        }

        // Save updated cookies
        await _saveCookies(existingCookies);
        debugPrint('🍪 Saved new cookies: ${existingCookies.keys.join(', ')}');
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
  Future<Map<String, String>> getAllCookies() async {
    return await _loadCookies();
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
}
