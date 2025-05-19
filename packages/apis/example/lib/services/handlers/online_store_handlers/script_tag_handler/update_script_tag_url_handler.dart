import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/script_tag/abstract/script_tag_service.dart';
import 'package:apis/network/remote/online_store/script_tag/freezed_model/request/update_script_tag_url_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 🔄 UPDATE SCRIPT TAG URL ********************
///**************************************************************

class UpdateScriptTagUrlHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle PUT requests for updating script tags
    if (method != 'PUT') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only PUT is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final scriptTagId = params['script_tag_id'];
    final src = params['src'];
    
    // Validate required parameters
    if (scriptTagId == null || scriptTagId.isEmpty) {
      return {
        "status": "error",
        "message": "Script Tag ID is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    if (src == null || src.isEmpty) {
      return {
        "status": "error",
        "message": "Script source URL is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Create the request using the JSON structure that matches the API
      final requestJson = {
        "script_tag": {
          "id": int.tryParse(scriptTagId),
          "src": src
        }
      };

      // Convert to proper request model
      final updateRequest = UpdateScriptTagUrlRequest.fromJson(requestJson);

      // Call the API method
      final response = await GetIt.I<ScriptTagService>().updateScriptTagUrl(
        apiVersion: ApiNetwork.apiVersion,
        scriptTagId: scriptTagId,
        body: updateRequest,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Script tag URL updated successfully",
        "script_tag": response.scriptTag?.toJson(),
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to update script tag URL: ${e.toString()}",
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
        name: 'script_tag_id',
        label: 'Script Tag ID',
        hint: 'The ID of the script tag to update',
        isRequired: true,
      ),
      const ApiField(
        name: 'src',
        label: 'Source URL',
        hint: 'The new URL for the JavaScript file (must be HTTPS)',
        isRequired: true,
      ),
    ],
  };
}
