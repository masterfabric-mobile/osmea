import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/page/abstract/page_service.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/request/update_existing_page_completely_request.dart' as request;
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📝 UPDATE EXISTING PAGE COMPLETELY ***********
///**************************************************************

class UpdateExistingPageCompletelyHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle PUT requests for updating pages
    if (method != 'PUT') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only PUT is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final pageId = params['page_id'];
    final title = params['title'];
    final bodyHtml = params['body_html'];
    final author = params['author'];
    final handle = params['handle'];



    // Validate required parameters
    if (pageId == null || pageId.isEmpty) {
      return {
        "status": "error",
        "message": "Page ID is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    if (title == null || title.isEmpty) {
      return {
        "status": "error",
        "message": "Page title is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    if (bodyHtml == null || bodyHtml.isEmpty) {
      return {
        "status": "error",
        "message": "Page content is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Create the JSON request structure
      final requestJson = {
        "page": {
          "id": int.tryParse(pageId),
          "title": title,
          "body_html": bodyHtml,
          "author": author,
          "handle": handle,
        }
      };

      // Convert to proper request model
      final updateRequest = request.UpdateExistingPageCompletelyRequest.fromJson(requestJson);

      // Call the API method
      final response = await GetIt.I<PageService>().updateExistingPageCompletely(
        apiVersion: ApiNetwork.apiVersion,
        pageId: pageId,
        model: updateRequest,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Page updated successfully",
        "page": response.page?.toJson(),
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to update page: ${e.toString()}",
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
        name: 'title',
        label: 'Title',
        hint: 'The title of the page',
        isRequired: true,
      ),
      const ApiField(
        name: 'body_html',
        label: 'Content',
        hint: 'The HTML content of the page',
        isRequired: true,
      ),
      const ApiField(
        name: 'author',
        label: 'Author',
        hint: 'The author of the page',
      ),
      const ApiField(
        name: 'handle',
        label: 'Handle',
        hint: 'The URL handle for the page',
      ),
    ],
  };
}
