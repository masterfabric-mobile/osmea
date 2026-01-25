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
  
  /// Get Dio instance for WordPress config fetch
  /// Creates a simple Dio instance without cookie jar to avoid file system issues
  Dio get _dio {
    if (dio != null) return dio!;
    
    // Create a simple Dio instance without cookie jar for WordPress config fetch
    // This avoids file system errors when cookie jar tries to create .cookies directory
    final simpleDio = Dio()
      ..options = BaseOptions(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        connectTimeout: timeout,
        receiveTimeout: timeout,
        sendTimeout: timeout,
        responseType: ResponseType.json,
      );
    
    debugPrint('📡 WordPress config Dio client configured (no cookies)');
    return simpleDio;
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
      debugPrint('❌ Dio error fetching config:');
      debugPrint('  - Type: ${e.type}');
      debugPrint('  - Message: ${e.message ?? 'null'}');
      debugPrint('  - Error: ${e.error}');
      debugPrint('  - Response status: ${e.response?.statusCode}');
      debugPrint('  - Response data: ${e.response?.data}');
      debugPrint('  - Request path: ${e.requestOptions.path}');
      
      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;
        throw Exception(
          'Failed to load config: HTTP $statusCode - $responseData',
        );
      }
      
      // Provide more detailed error message
      String errorMsg = 'Network error';
      if (e.type == DioExceptionType.connectionTimeout) {
        errorMsg = 'Connection timeout - server did not respond in time';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMsg = 'Receive timeout - server took too long to respond';
      } else if (e.type == DioExceptionType.sendTimeout) {
        errorMsg = 'Send timeout - request took too long to send';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMsg = 'Connection error - could not connect to server';
      } else if (e.message != null && e.message!.isNotEmpty) {
        errorMsg = e.message!;
      } else if (e.error != null) {
        errorMsg = 'Error: ${e.error}';
      }
      
      throw Exception('Network error: $errorMsg');
    } catch (e, stackTrace) {
      debugPrint('❌ Error fetching config: $e');
      debugPrint('❌ Stack trace: $stackTrace');
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

