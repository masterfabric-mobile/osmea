import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/redirect/abstract/redirect_service.dart';
import 'package:apis/network/remote/online_store/redirect/freezed_model/request/create_redirect_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 🔀 CREATE REDIRECT **************************
///**************************************************************

class CreateRedirectHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle POST requests for redirect creation
    if (method != 'POST') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only POST is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final path = params['path'];
    final target = params['target'];
    
    // Validate required parameters
    if (path == null || path.isEmpty) {
      return {
        "status": "error",
        "message": "Path is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    if (target == null || target.isEmpty) {
      return {
        "status": "error",
        "message": "Target is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Create the request using the JSON structure that matches the API
      final requestJson = {
        "redirect": {
          "path": path,
          "target": target
        }
      };

      // Convert to proper request model
      final redirectRequest = CreateRedirectRequest.fromJson(requestJson);

      // Call the API method
      final response = await GetIt.I<RedirectService>().createRedirect(
        apiVersion: ApiNetwork.apiVersion,
        body: redirectRequest,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Redirect created successfully",
        "redirect": response.redirect?.toJson(),
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to create redirect: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
    'POST': [
      const ApiField(
        name: 'path',
        label: 'Path',
        hint: 'The path to be redirected (e.g., /old-path)',
        isRequired: true,
      ),
      const ApiField(
        name: 'target',
        label: 'Target',
        hint: 'The destination of the redirect (e.g., /new-path)',
        isRequired: true,
      ),
    ],
  };
}
