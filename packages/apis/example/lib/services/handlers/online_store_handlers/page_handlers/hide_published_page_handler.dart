import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/page/abstract/page_service.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/request/hide_published_page_request.dart' 
    as page_request;
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 🙈 HIDE PUBLISHED PAGE **********************
///**************************************************************

class HidePublishedPageHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle PUT requests for hiding pages
    if (method != 'PUT') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only PUT is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final pageId = params['page_id'];
    
    // Validate required parameters
    if (pageId == null || pageId.isEmpty) {
      return {
        "status": "error",
        "message": "Page ID is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Create the request using the JSON structure that matches the API
      final requestJson = {
        "page": {
          "id": int.tryParse(pageId),
          "published": false
        }
      };

      // Convert to proper request model
      final hideRequest = page_request.HidePublishedPageRequest.fromJson(requestJson);

      // Call the API method
      final response = await GetIt.I<PageService>().hidePublishedPage(
        apiVersion: ApiNetwork.apiVersion,
        pageId: pageId,
        model: hideRequest,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Published page is now hidden",
        "page": response.page?.toJson(),
        "params": {
          "page_id": pageId,
          "published": false,
          "updated_at": response.page?.updatedAt,
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to hide published page: ${e.toString()}",
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
        name: 'page_id',
        label: 'Page ID',
        hint: 'The ID of the published page to hide',
        isRequired: true,
      ),
    ],
  };
}
