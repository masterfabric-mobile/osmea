import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/redirect/abstract/redirect_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📋 GET SINGLE REDIRECT **********************
///**************************************************************

class GetSingleRedirectHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle GET requests for retrieving a redirect
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only GET is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final redirectId = params['redirect_id'];
    
    // Extract optional parameters
    final fields = params['fields'];

    // Validate required parameters
    if (redirectId == null || redirectId.isEmpty) {
      return {
        "status": "error",
        "message": "Redirect ID is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Call the API method
      final response = await GetIt.I<RedirectService>().getSingleRedirect(
        apiVersion: ApiNetwork.apiVersion,
        redirectId: redirectId,
        fields: fields,
      );

      // Process the redirect data based on fields parameter
      Map<String, dynamic>? redirectData;
      if (fields == null || fields.isEmpty) {
        // Return full redirect object if no fields specified
        redirectData = response.redirect?.toJson();
      } else {
        // Filter the response to only include requested fields
        final json = response.redirect?.toJson() ?? {};
        final filteredJson = <String, dynamic>{};
        final fieldsList = fields.split(',').map((f) => f.trim()).toList();
        
        for (final field in fieldsList) {
          if (json.containsKey(field)) {
            filteredJson[field] = json[field];
          }
        }
        
        redirectData = filteredJson;
      }

      // Return success response
      return {
        "status": "success",
        "message": "Redirect retrieved successfully",
        "redirect": redirectData,
        "filtered_by_fields": fields != null && fields.isNotEmpty,
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to retrieve redirect: ${e.toString()}",
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
        name: 'redirect_id',
        label: 'Redirect ID',
        hint: 'The ID of the redirect to retrieve',
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
