import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/redirect/abstract/redirect_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 🔢 COUNT ALL REDIRECTS **********************
///**************************************************************

class CountAllRedirectsHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle GET requests for counting redirects
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only GET is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract optional filter parameters
    final path = params['path'];
    final target = params['target'];

    try {
      // Call the API method
      final response = await GetIt.I<RedirectService>().countAllRedirects(
        apiVersion: ApiNetwork.apiVersion,
        path: path,
        target: target,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Redirects counted successfully",
        "count": response.count,
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to count redirects: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
    'GET': [
      const ApiField(
        name: 'path',
        label: 'Path',
        hint: 'Filter redirects by path',
      ),
      const ApiField(
        name: 'target',
        label: 'Target',
        hint: 'Filter redirects by target',
      ),
    ],
  };
}
