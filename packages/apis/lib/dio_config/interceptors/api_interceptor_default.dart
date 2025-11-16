import 'package:apis/apis.dart';
import 'package:apis/dio_config/dio_logger/abstract/api_base_logger.dart';
import 'package:apis/utils/api_error_utils.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

/// 🌐 Default API Interceptor for Dio
/// Handles logging, request/response modification, and error mapping.
/// Open-source friendly! Contribute and improve! 🚀
class ApiInterceptorDefault extends Interceptor {
  final _dioLogger = GetIt.I.get<ApiBaseLogger>();
  final String shopifyAccessToken;
  ApiInterceptorDefault({required this.shopifyAccessToken});
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 🐞 Log error details for debugging
    _dioLogger.printErrorLogs(err);
    // 404 is handled in onResponse, nothing to do here
    super.onError(err, handler);
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // 🌐 Pre-request hook for network checks or analytics
    await ApiNetwork.onRequestInterceptor();
    // 🛡️ Always use the latest access token from ApiNetwork
    final token = ApiNetwork.shopifyAccessToken.isNotEmpty
        ? ApiNetwork.shopifyAccessToken
        : shopifyAccessToken;
    if (token.isEmpty) {
      // ⚠️ Warn if access token is missing
      _dioLogger.printErrorLogs(
          "X-Shopify-Access-Token is missing! Set it before making requests. 🔑"
              as DioException);
    }
    // 📝 Set common headers for all requests
    options.headers.addAll(<String, dynamic>{
      "Accept": "application/json",
      "Content-type": "application/json",
      "X-Shopify-Access-Token": token,
    });
    // 📋 Log outgoing request
    _dioLogger.printOnRequestLogs(options);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 📥 Log incoming response
    _dioLogger.printOnResponseLogs(response);
    // 🛑 Map common HTTP errors to DioException with friendly messages
    // Uses ApiErrorUtils for centralized error message mapping
    final statusCode = response.statusCode;
    final errorMessage = ApiErrorUtils.getErrorMessageForStatusCode(statusCode);
    if (errorMessage != null) {
      return handler.reject(DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: errorMessage,
      ));
    }
    super.onResponse(response, handler);
  }
}

/// Interceptor that adds Basic Auth and JSON headers for WooCommerce
class WooInterceptor extends Interceptor {
  final _dioLogger = GetIt.I.get<ApiBaseLogger>();
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      // 🌐 Pre-request hook for network checks or analytics
      await ApiNetwork.onRequestInterceptor();
      // 🔑 Add Basic Auth for WooCommerce only if credentials are provided
      final authHeader = WooNetwork.basicAuthHeader();
      if (authHeader.isNotEmpty) {
        options.headers['Authorization'] = authHeader;
      }
      options.headers['Accept'] = 'application/json';
      options.headers['Content-Type'] = 'application/json';
      // 📋 Log outgoing request
      _dioLogger.printOnRequestLogs(options);
    } catch (e) {
      // 📝 Log error if auth header generation fails
      _dioLogger.printErrorLogs(
        DioException(
          requestOptions: options,
          error: 'Failed to generate WooCommerce auth header: $e',
          type: DioExceptionType.unknown,
        ),
      );
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 📥 Log incoming response
    _dioLogger.printOnResponseLogs(response);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 🐞 Log error details for debugging
    _dioLogger.printErrorLogs(err);
    super.onError(err, handler);
  }
}
