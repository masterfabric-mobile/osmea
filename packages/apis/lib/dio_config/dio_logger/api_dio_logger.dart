import 'package:apis/dio_config/dio_logger/abstract/api_base_logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

/// 🌐 Open Source API Logger
/// Logs API requests, responses, and errors in a developer-friendly way.
/// Uses [Logger] for pretty output.
/// 
/// Contribute or customize as you wish! 🚀
@Singleton(as: ApiBaseLogger)
class ApiDioLogger extends ApiBaseLogger {
  /// Logger instance for outputting logs 📋
  final Logger logger;

  ApiDioLogger({required this.logger});

  /// Logs error details from DioException 🚨
  @override
  void printErrorLogs(DioException error) {
    if (kDebugMode) {
      final stringsToLog = <String>[
        "==========Error Start==========",
        ":::${error.message} ${error.response?.requestOptions.baseUrl ?? ''}${error.response?.requestOptions.path ?? ''}",
        ":::${error.response?.data ?? 'Unknown Error'}",
        "==========Error End============"
      ];
      printErrorLog(stringsToLog);
    }
  }

  /// Logs outgoing request details 🌍
  @override
  void printOnRequestLogs(RequestOptions options) {
    if (kDebugMode) {
      final stringsToLog = <String>[
        "==========Request Start==========",
        "${options.method.toUpperCase()} ${options.baseUrl}${options.path}"
      ];

      // Log headers if present 🏷️
      if (options.headers.isNotEmpty) {
        stringsToLog.add(":::Headers:");
        options.headers.forEach((k, v) => stringsToLog.add('$k: $v'));
      }

      // Log query parameters if present 🔎
      if (options.queryParameters.isNotEmpty) {
        stringsToLog.add(":::Query Parameters:");
        options.queryParameters.forEach((k, v) => stringsToLog.add('$k: $v'));
      }

      // Log body if present 📝
      if (options.data != null) {
        stringsToLog.add(":::Body: ${options.data}");
      }

      stringsToLog.add("==========Request End============");
      printRequestResponseLog(stringsToLog);
    }
  }

  /// Logs incoming response details ✅
  @override
  void printOnResponseLogs(Response response) {
    if (kDebugMode) {
      final stringsToLog = <String>[
        "==========Response Start==========",
        "${response.statusCode} ${response.requestOptions.baseUrl}${response.requestOptions.path}",
        ":::Headers:"
      ];

      // Log response headers 📦
      response.headers.forEach((k, v) => stringsToLog.add('$k: $v'));

      stringsToLog.add(":::Response: ${response.data}");
      stringsToLog.add("==========Response End============");

      printRequestResponseLog(stringsToLog);
    }
  }

  /// Outputs request/response logs using Logger 🖨️
  @override
  void printRequestResponseLog(List<String> logs) {
    if (kDebugMode) {
      logger.d(logs.join("\n"));
    }
  }

  /// Outputs error logs using Logger ❗
  @override
  void printErrorLog(List<String> logs) {
    if (kDebugMode) {
      logger.e(logs.join("\n"));
    }
  }
}
