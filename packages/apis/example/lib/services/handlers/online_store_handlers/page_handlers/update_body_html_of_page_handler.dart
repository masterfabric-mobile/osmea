import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/page/abstract/page_service.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/request/update_body_html_of_page_request.dart' 
    as page_request;
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📝 UPDATE PAGE BODY HTML ********************
///**************************************************************

class UpdateBodyHtmlOfPageHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle PUT requests for updating page content
    if (method != 'PUT') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only PUT is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final pageId = params['page_id'];
    final bodyHtml = params['body_html'];
    
    // Validate required parameters
    if (pageId == null || pageId.isEmpty) {
      return {
        "status": "error",
        "message": "Page ID is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    if (bodyHtml == null || bodyHtml.isEmpty) {
      return {
        "status": "error",
        "message": "Page HTML content is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Create the request with only the HTML content being updated
      final requestJson = {
        "page": {
          "id": int.tryParse(pageId),
          "body_html": bodyHtml
        }
      };

      // Convert to proper request model
      final updateRequest = page_request.UpdateBodyHtmlOfPageRequest.fromJson(requestJson);

      // Call the API method
      final response = await GetIt.I<PageService>().updateBodyHtmlOfPage(
        apiVersion: ApiNetwork.apiVersion,
        pageId: pageId,
        model: updateRequest,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Page HTML content updated successfully",
        "page": response.page?.toJson(),
        "params": {
          "page_id": pageId,
          "updated_at": response.page?.updatedAt,
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to update page HTML content: ${e.toString()}",
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
        hint: 'The ID of the page to update',
        isRequired: true,
      ),
      const ApiField(
        name: 'body_html',
        label: 'HTML Content',
        hint: 'The new HTML content for the page',
        isRequired: true,
      ),
    ],
  };
}
