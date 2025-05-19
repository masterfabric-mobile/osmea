import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/script_tag/abstract/script_tag_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📋 LIST ALL SCRIPT TAGS *********************
///**************************************************************

class ListAllScriptTagsHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle GET requests for listing script tags
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only GET is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract optional parameters
    final limit = params['limit'] != null ? int.tryParse(params['limit']!) : null;
    final sinceId = params['since_id'];
    final createdAtMin = params['created_at_min'];
    final createdAtMax = params['created_at_max'];
    final updatedAtMin = params['updated_at_min'];
    final updatedAtMax = params['updated_at_max'];
    final src = params['src'];
    final fields = params['fields'];

    try {
      // Call the API method
      final response = await GetIt.I<ScriptTagService>().listAllScriptTags(
        apiVersion: ApiNetwork.apiVersion,
        limit: limit,
        sinceId: sinceId,
        createdAtMin: createdAtMin,
        createdAtMax: createdAtMax,
        updatedAtMin: updatedAtMin,
        updatedAtMax: updatedAtMax,
        src: src,
        fields: fields,
      );

      // Process the response based on fields parameter
      List<Map<String, dynamic>> scriptTagsData;
      if (fields == null || fields.isEmpty) {
        // Return full script tag objects if no fields specified
        scriptTagsData = response.scriptTags?.map((tag) => tag.toJson()).toList() ?? [];
      } else {
        // Filter the response to only include requested fields
        scriptTagsData = response.scriptTags?.map((tag) {
          final json = tag.toJson();
          final filteredJson = <String, dynamic>{};
          final fieldsList = fields.split(',').map((f) => f.trim()).toList();
          
          for (final field in fieldsList) {
            if (json.containsKey(field)) {
              filteredJson[field] = json[field];
            }
          }
          
          return filteredJson;
        }).toList() ?? [];
      }

      // Return success response
      return {
        "status": "success",
        "message": "Script tags retrieved successfully",
        "script_tags": scriptTagsData,
        "count": response.scriptTags?.length ?? 0,
        "filtered_by_fields": fields != null && fields.isNotEmpty,
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to retrieve script tags: ${e.toString()}",
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
        name: 'limit',
        label: 'Limit',
        hint: 'Maximum number of script tags to retrieve (max: 250)',
      ),
      const ApiField(
        name: 'since_id',
        label: 'Since ID',
        hint: 'Retrieve script tags after the specified ID',
      ),
      const ApiField(
        name: 'created_at_min',
        label: 'Created At Min',
        hint: 'Filter script tags created after date (format: 2023-01-01T00:00:00Z)',
      ),
      const ApiField(
        name: 'created_at_max',
        label: 'Created At Max',
        hint: 'Filter script tags created before date (format: 2023-01-01T00:00:00Z)',
      ),
      const ApiField(
        name: 'updated_at_min',
        label: 'Updated At Min',
        hint: 'Filter script tags updated after date (format: 2023-01-01T00:00:00Z)',
      ),
      const ApiField(
        name: 'updated_at_max',
        label: 'Updated At Max',
        hint: 'Filter script tags updated before date (format: 2023-01-01T00:00:00Z)',
      ),
      const ApiField(
        name: 'src',
        label: 'Source URL',
        hint: 'Filter script tags by source URL',
      ),
      const ApiField(
        name: 'fields',
        label: 'Fields',
        hint: 'Comma-separated list of fields to include in the response',
      ),
    ],
  };
}
