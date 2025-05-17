import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/page/abstract/page_service.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/request/create_page_html_markup_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📝 CREATE PAGE WITH HTML MARKUP *************
///**************************************************************

class CreatePageHtmlMarkupHandler implements ApiRequestHandler {
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
    final htmlMarkup = params['html_markup'];


    // Validate required parameters
    if (title == null || title.isEmpty) {
      return {
        "status": "error",
        "message": "Page title is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    if (htmlMarkup == null || htmlMarkup.isEmpty) {
      return {
        "status": "error",
        "message": "HTML markup content is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Create the request using the JSON structure that matches the API
      final requestJson = {
        "page": {
          "title": title,
          "body_html": htmlMarkup,
        }
      };

      // Convert to proper request model
      final pageRequest = CreatePageHtmlMarkupRequest.fromJson(requestJson);

      // Call the API method
      final response = await GetIt.I<PageService>().createPageHtmlMarkup(
        apiVersion: ApiNetwork.apiVersion,
        model: pageRequest,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Page with HTML markup created successfully",
        "page": response.page?.toJson(),
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to create page with HTML markup: ${e.toString()}",
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
        hint: 'The title of the page',
        isRequired: true,
      ),
      const ApiField(
        name: 'html_markup',
        label: 'HTML Markup',
        hint: 'The HTML content of the page',
        isRequired: true,
      ),
    ],
  };
}
