/// 🛡️ API Error Utilities
///
/// Provides centralized error message mapping for HTTP status codes.
/// Used by interceptors and view models for consistent error handling.
class ApiErrorUtils {
  /// 🛑 Map of HTTP status codes to user-friendly error messages
  /// Used by ApiInterceptorDefault and other interceptors
  static const Map<int, String> httpErrorMessages = {
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

  /// 🔧 Get user-friendly error message from HTTP status code
  ///
  /// Returns the error message for the given status code, or null if not found.
  static String? getErrorMessageForStatusCode(int? statusCode) {
    if (statusCode == null) return null;
    return httpErrorMessages[statusCode];
  }

  /// 🔧 Get user-friendly error message from error object
  ///
  /// Follows the same pattern as WooAuthManager and WooJwtSigninManager.
  /// Checks error string for HTTP status codes and common error patterns.
  static String getErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();

    // Check for specific HTTP status codes
    if (errorString.contains('400') || errorString.contains('bad request')) {
      return httpErrorMessages[400] ?? 'Bad Request';
    } else if (errorString.contains('401') ||
        errorString.contains('unauthorized')) {
      return httpErrorMessages[401] ?? 'Unauthorized';
    } else if (errorString.contains('403') ||
        errorString.contains('forbidden')) {
      return httpErrorMessages[403] ?? 'Forbidden';
    } else if (errorString.contains('404') ||
        errorString.contains('not found')) {
      return httpErrorMessages[404] ?? 'Not Found';
    } else if (errorString.contains('405') ||
        errorString.contains('method not allowed')) {
      return httpErrorMessages[405] ?? 'Method Not Allowed';
    } else if (errorString.contains('406') ||
        errorString.contains('not acceptable')) {
      return httpErrorMessages[406] ?? 'Not Acceptable';
    } else if (errorString.contains('409') ||
        errorString.contains('conflict')) {
      return httpErrorMessages[409] ?? 'Conflict';
    } else if (errorString.contains('422') ||
        errorString.contains('unprocessable')) {
      return httpErrorMessages[422] ?? 'Unprocessable Entity';
    } else if (errorString.contains('429') ||
        errorString.contains('too many requests')) {
      return httpErrorMessages[429] ?? 'Too Many Requests';
    } else if (errorString.contains('500') ||
        errorString.contains('internal server error')) {
      return httpErrorMessages[500] ?? 'Internal Server Error';
    } else if (errorString.contains('503') ||
        errorString.contains('service unavailable')) {
      return httpErrorMessages[503] ?? 'Service Unavailable';
    } else if (errorString.contains('504') ||
        errorString.contains('gateway timeout')) {
      return httpErrorMessages[504] ?? 'Gateway Timeout';
    } else if (errorString.contains('network') ||
        errorString.contains('connection')) {
      return 'Network error. Please check your internet connection';
    } else if (errorString.contains('timeout')) {
      return 'Request timeout. Please try again';
    } else {
      return 'An error occurred. Please try again';
    }
  }
}
