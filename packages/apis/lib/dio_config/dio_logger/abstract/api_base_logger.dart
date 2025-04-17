import 'package:dio/dio.dart';

abstract class ApiBaseLogger {
  void printOnRequestLogs(RequestOptions options);
  void printOnResponseLogs(Response response);
  void printErrorLogs(DioException error);
  void printRequestResponseLog(List<String> logs);
  void printErrorLog(List<String> logs);
}
