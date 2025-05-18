import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/script_tag/abstract/script_tag_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 🗑️ DELETE SCRIPT TAG ***********************
///**************************************************************

class DeleteScriptTagHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle DELETE requests for deleting script tags
    if (method != 'DELETE') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only DELETE is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final scriptTagId = params['script_tag_id'];
    
    // Validate required parameters
    if (scriptTagId == null || scriptTagId.isEmpty) {
      return {
        "status": "error",
        "message": "Script Tag ID is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Call the API method to delete the script tag
      await GetIt.I<ScriptTagService>().deleteScriptTag(
        apiVersion: ApiNetwork.apiVersion,
        scriptTagId: scriptTagId,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Script tag deleted successfully",
        "params": {
          "script_tag_id": scriptTagId,
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to delete script tag: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['DELETE'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
    'DELETE': [
      const ApiField(
        name: 'script_tag_id',
        label: 'Script Tag ID',
        hint: 'The ID of the script tag to delete',
        isRequired: true,
      ),
    ],
  };
}
