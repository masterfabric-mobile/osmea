import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/page/abstract/page_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📄 GET SINGLE PAGE **************************
///**************************************************************

class GetSinglePageHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle GET requests for retrieving a page
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only GET is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final pageId = params['page_id'];
    
    // Extract optional parameters
    final fields = params['fields'];

    // Validate required parameters
    if (pageId == null || pageId.isEmpty) {
      return {
        "status": "error",
        "message": "Page ID is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Call the API method
      final response = await GetIt.I<PageService>().getSinglePage(
        apiVersion: ApiNetwork.apiVersion,
        pageId: pageId,
        fields: fields,
      );

      // Process the page data based on fields parameter
      Map<String, dynamic>? pageData;
      if (fields == null || fields.isEmpty) {
        // Return full page object if no fields specified
        pageData = response.page?.toJson();
      } else {
        // Filter the response to only include requested fields
        final json = response.page?.toJson() ?? {};
        final filteredJson = <String, dynamic>{};
        final fieldsList = fields.split(',').map((f) => f.trim()).toList();
        
        for (final field in fieldsList) {
          if (json.containsKey(field)) {
            filteredJson[field] = json[field];
          }
        }
        
        pageData = filteredJson;
      }

      // Return success response
      return {
        "status": "success",
        "message": "Page retrieved successfully",
        "page": pageData,
        "filtered_by_fields": fields != null && fields.isNotEmpty,
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to retrieve page: ${e.toString()}",
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
        name: 'page_id',
        label: 'Page ID',
        hint: 'The ID of the page to retrieve',
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
