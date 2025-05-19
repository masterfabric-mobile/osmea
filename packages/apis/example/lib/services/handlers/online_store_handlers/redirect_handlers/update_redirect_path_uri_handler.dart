import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/redirect/abstract/redirect_service.dart';
import 'package:apis/network/remote/online_store/redirect/freezed_model/request/update_redirect_path_uri_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 🔄 UPDATE REDIRECT PATH/URI *****************
///**************************************************************

class UpdateRedirectPathUriHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle PUT requests for updating redirects
    if (method != 'PUT') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only PUT is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final redirectId = params['redirect_id'];
    final path = params['path'];
    
    // Validate required parameters
    if (redirectId == null || redirectId.isEmpty) {
      return {
        "status": "error",
        "message": "Redirect ID is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    if (path == null || path.isEmpty) {
      return {
        "status": "error",
        "message": "Path is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Create the request using the JSON structure that matches the API
      final requestJson = {
        "redirect": {
          "id": int.tryParse(redirectId),
          "path": path,
        }
      };

      // Convert to proper request model
      final updateRequest = UpdateRedirectPathUriRequest.fromJson(requestJson);

      // Call the API method
      final response = await GetIt.I<RedirectService>().updateRedirectPathUri(
        apiVersion: ApiNetwork.apiVersion,
        redirectId: redirectId,
        body: updateRequest,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Redirect updated successfully",
        "redirect": response.redirect?.toJson(),
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to update redirect: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['PUT'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
    'PUT': [
      const ApiField(
        name: 'redirect_id',
        label: 'Redirect ID',
        hint: 'The ID of the redirect to update',
        isRequired: true,
      ),
      const ApiField(
        name: 'path',
        label: 'Path',
        hint: 'The new path for the redirect (e.g., /old-path)',
        isRequired: true,
      ),
    ],
  };
}
