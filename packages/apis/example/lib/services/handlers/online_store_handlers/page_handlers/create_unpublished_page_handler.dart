import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/page/abstract/page_service.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/request/create_unpublished_page_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📝 CREATE UNPUBLISHED PAGE ******************
///**************************************************************

class CreateUnpublishedPageHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle POST requests for page creation
    if (method != 'POST') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only POST is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final title = params['title'];
    final bodyHtml = params['body_html'];
    
    // Validate required parameters
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
      final requestJson = {
        "page": {
          "title": title,
          "body_html": bodyHtml,
          "published": false
        }
      };

      // Convert to proper request model
      final pageRequest = CreateUnpublishedPageRequest.fromJson(requestJson);

      // Call the API method
      final response = await GetIt.I<PageService>().createUnpublishedPage(
        apiVersion: ApiNetwork.apiVersion,
        model: pageRequest,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Unpublished page created successfully",
        "page": response.page?.toJson(),
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to create unpublished page: ${e.toString()}",
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
        name: 'title',
        label: 'Title',
        hint: 'The title of the unpublished page',
        isRequired: true,
      ),
      const ApiField(
        name: 'body_html',
        label: 'Content',
        hint: 'The HTML content of the unpublished page',
        isRequired: true,
      ),
    ],
  };
}
