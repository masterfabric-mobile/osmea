import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/script_tag/abstract/script_tag_service.dart';
import 'package:apis/network/remote/online_store/script_tag/freezed_model/request/create_script_tag_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📝 CREATE SCRIPT TAG ************************
///**************************************************************

class CreateScriptTagHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle POST requests for script tag creation
    if (method != 'POST') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only POST is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final src = params['src'];
    final event = params['event'] ?? 'onload';
    
    // Validate required parameters
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
          "event": event,
          "src": src,
        }
      };

      // Convert to proper request model
      final scriptTagRequest = CreateScriptTagRequest.fromJson(requestJson);

      // Call the API method
      final response = await GetIt.I<ScriptTagService>().createScriptTag(
        apiVersion: ApiNetwork.apiVersion,
        body: scriptTagRequest,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Script tag created successfully",
        "script_tag": response.scriptTag?.toJson(),
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to create script tag: ${e.toString()}",
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
        name: 'src',
        label: 'Source URL',
        hint: 'The URL of the JavaScript file (must be HTTPS)',
        isRequired: true,
      ),
      const ApiField(
        name: 'event',
        label: 'Event',
        hint: 'When to load the script (onload or null)',
        isRequired: true,
      ),

    ],
  };
}
