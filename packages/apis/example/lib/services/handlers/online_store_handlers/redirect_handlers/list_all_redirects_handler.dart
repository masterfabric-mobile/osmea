import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/redirect/abstract/redirect_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📋 LIST ALL REDIRECTS ***********************
///**************************************************************

class ListAllRedirectsHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle GET requests for listing redirects
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
    final path = params['path'];
    final target = params['target'];
    final fields = params['fields'];

    try {
      // Call the API method
      final response = await GetIt.I<RedirectService>().listAllRedirects(
        apiVersion: ApiNetwork.apiVersion,
        limit: limit,
        sinceId: sinceId,
        path: path,
        target: target,
        fields: fields,
      );

      // Process the response based on fields parameter
      List<Map<String, dynamic>> redirectsData;
      if (fields == null || fields.isEmpty) {
        // Return full redirect objects if no fields specified
        redirectsData = response.redirects?.map((redirect) => redirect.toJson()).toList() ?? [];
      } else {
        // Filter the response to only include requested fields
        redirectsData = response.redirects?.map((redirect) {
          final json = redirect.toJson();
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
        "message": "Redirects retrieved successfully",
        "redirects": redirectsData,
        "filtered_by_fields": fields != null && fields.isNotEmpty,
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to retrieve redirects: ${e.toString()}",
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
        hint: 'Maximum number of redirects to retrieve (max: 250)',
      ),
      const ApiField(
        name: 'since_id',
        label: 'Since ID',
        hint: 'Retrieve redirects after the specified ID',
      ),
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
      const ApiField(
        name: 'fields',
        label: 'Fields',
        hint: 'Comma-separated list of fields to include in the response',
      ),
    ],
  };
}
