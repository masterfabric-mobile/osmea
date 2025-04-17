import 'package:apis/apis.dart';
import 'package:apis/dio_config/dio_logger/abstract/api_base_logger.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

/// 🌐 Default API Interceptor for Dio
/// Handles logging, request/response modification, and error mapping.
/// Open-source friendly! Contribute and improve! 🚀
class ApiInterceptorDefault extends Interceptor {
  final _dioLogger = GetIt.I.get<ApiBaseLogger>();
  final String shopifyAccessToken;

  ApiInterceptorDefault({ required this.shopifyAccessToken });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 🐞 Log error details for debugging
    _dioLogger.printErrorLogs(err);

    // 404 is handled in onResponse, nothing to do here
    super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 🌐 Pre-request hook for network checks or analytics
    await ApiNetwork.onRequestInterceptor();

    // 🛡️ Always use the latest access token from ApiNetwork
    final token = ApiNetwork.shopifyAccessToken.isNotEmpty
        ? ApiNetwork.shopifyAccessToken
        : shopifyAccessToken;

    if (token.isEmpty) {
      // ⚠️ Warn if access token is missing
      _dioLogger.printErrorLogs("X-Shopify-Access-Token is missing! Set it before making requests. 🔑" as DioException);
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
    final errorMessages = <int, String>{
      400: "Bad Request",
      401: "Unauthorized",
      403: "Forbidden",
      404: "Not Found",
      405: "Method Not Allowed",
      406: "Not Acceptable",
      409: "Conflict",
      422: "Unprocessable Entity",
      429: "Too Many Requests",
      500: "Internal Server Error",
      503: "Service Unavailable",
      504: "Gateway Timeout",
      301: "Moved Permanently",
    };

    final statusCode = response.statusCode;
    if (statusCode != null && errorMessages.containsKey(statusCode)) {
      return handler.reject(DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: errorMessages[statusCode],
      ));
    }

    super.onResponse(response, handler);
  }
}
