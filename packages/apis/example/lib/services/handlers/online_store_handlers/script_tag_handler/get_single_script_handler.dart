import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/script_tag/abstract/script_tag_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📋 GET SINGLE SCRIPT TAG ********************
///**************************************************************

class GetSingleScriptHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle GET requests for retrieving a script tag
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only GET is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final scriptTagId = params['script_tag_id'];
    
    // Extract optional parameters
    final fields = params['fields'];

    // Validate required parameters
    if (scriptTagId == null || scriptTagId.isEmpty) {
      return {
        "status": "error",
        "message": "Script Tag ID is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Call the API method
      final response = await GetIt.I<ScriptTagService>().getSingleScript(
        apiVersion: ApiNetwork.apiVersion,
        scriptTagId: scriptTagId,
        fields: fields,
      );

      // Process the script tag data based on fields parameter
      Map<String, dynamic>? scriptTagData;
      if (fields == null || fields.isEmpty) {
        // Return full script tag object if no fields specified
        scriptTagData = response.scriptTag?.toJson();
      } else {
        // Filter the response to only include requested fields
        final json = response.scriptTag?.toJson() ?? {};
        final filteredJson = <String, dynamic>{};
        final fieldsList = fields.split(',').map((f) => f.trim()).toList();
        
        for (final field in fieldsList) {
          if (json.containsKey(field)) {
            filteredJson[field] = json[field];
          }
        }
        
        scriptTagData = filteredJson;
      }

      // Return success response
      return {
        "status": "success",
        "message": "Script tag retrieved successfully",
        "script_tag": scriptTagData,
        "filtered_by_fields": fields != null && fields.isNotEmpty,
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to retrieve script tag: ${e.toString()}",
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
        name: 'script_tag_id',
        label: 'Script Tag ID',
        hint: 'The ID of the script tag to retrieve',
        isRequired: true,
      ),
      const ApiField(
        name: 'fields',
        label: 'Fields',
        hint: 'Comma-separated list of fields to include in the response',
      ),
    ],
  };
}
