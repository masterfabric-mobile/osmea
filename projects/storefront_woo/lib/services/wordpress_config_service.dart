import 'package:apis/dio_config/dio_client/api_dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Service to fetch app configuration from WordPress REST API
class WordPressConfigService {
  final String baseUrl;
  final Duration timeout;
  final Dio? dio;
  
  WordPressConfigService({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 30),
    this.dio,
  });
  
  /// Get Dio instance using ApiDioClient helper
  /// Uses wooPublicDio() for public WordPress REST API endpoints
  Dio get _dio {
    if (dio != null) return dio!;
    
    // Use ApiDioClient helper for public WordPress endpoints
    // wooPublicDio() is appropriate for public REST API calls without authentication
    final publicDio = ApiDioClient.wooPublicDio();
    
    // Override timeout if custom timeout is provided
    if (timeout != const Duration(seconds: 60)) {
      publicDio.options.connectTimeout = timeout;
      publicDio.options.receiveTimeout = timeout;
      publicDio.options.sendTimeout = timeout;
    }
    
    return publicDio;
  }
  
  /// Fetch app configuration from WordPress REST API
  /// 
  /// Returns the full app_config.json structure
  /// Throws exception on error
  Future<Map<String, dynamic>> fetchAppConfig() async {
    try {
      final url = '$baseUrl/wp-json/osmea/v1/app-config';
      
      debugPrint('📡 Fetching config from: $url');
      
      final response = await _dio.get<Map<String, dynamic>>(
        url,
        options: Options(
          responseType: ResponseType.json,
        ),
      );
      
      if (response.statusCode == 200 && response.data != null) {
        debugPrint('✅ Config fetched successfully');
        return response.data!;
      } else {
        throw Exception(
          'Failed to load config: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      debugPrint('❌ Dio error fetching config: ${e.message}');
      if (e.response != null) {
        throw Exception(
          'Failed to load config: ${e.response?.statusCode} - ${e.response?.data}',
        );
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      debugPrint('❌ Error fetching config: $e');
      rethrow;
    }
  }
  
  /// Fetch config with retry logic
  /// 
  /// [maxRetries] - Maximum number of retry attempts
  /// [retryDelay] - Delay between retries
  Future<Map<String, dynamic>> fetchAppConfigWithRetry({
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 2),
  }) async {
    int attempts = 0;
    Exception? lastException;
    
    while (attempts < maxRetries) {
      try {
        return await fetchAppConfig();
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        attempts++;
        
        if (attempts >= maxRetries) {
          debugPrint('❌ Failed after $maxRetries attempts');
          break;
        }
        
        debugPrint('⚠️ Retry attempt $attempts/$maxRetries after ${retryDelay.inSeconds}s');
        await Future.delayed(retryDelay);
      }
    }
    
    throw lastException ?? Exception('Failed to fetch config after $maxRetries attempts');
  }
  
  /// Check if WordPress endpoint is available
  Future<bool> isAvailable() async {
    try {
      final url = '$baseUrl/wp-json/osmea/v1/app-config';
      final response = await _dio.head(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

