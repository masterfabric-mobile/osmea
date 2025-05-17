import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/page/abstract/page_service.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/request/create_page_with_metafield_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📝 CREATE PAGE WITH METAFIELD ***************
///**************************************************************

class CreatePageWithMetafieldHandler implements ApiRequestHandler {
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
    final metafieldKey = params['metafield_key'];
    final metafieldValue = params['metafield_value'];
    final metafieldType = params['metafield_type'] ?? 'single_line_text_field';
    final metafieldNamespace = params['metafield_namespace'] ?? 'global';

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

    if (metafieldKey == null || metafieldKey.isEmpty) {
      return {
        "status": "error",
        "message": "Metafield key is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    if (metafieldValue == null || metafieldValue.isEmpty) {
      return {
        "status": "error",
        "message": "Metafield value is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Create the request using the JSON structure that matches the API
      final requestJson = {
        "page": {
          "title": title,
          "body_html": bodyHtml,
          "metafields": [
            {
              "key": metafieldKey,
              "value": metafieldValue,
              "type": metafieldType,
              "namespace": metafieldNamespace
            }
          ]
        }
      };

      // Convert to proper request model
      final pageRequest = CreatePageWithMetafieldRequest.fromJson(requestJson);

      // Call the API method
      final response = await GetIt.I<PageService>().createPageWithMetafield(
        apiVersion: ApiNetwork.apiVersion,
        model: pageRequest,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Page with metafield created successfully",
        "page": response.page?.toJson(),
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to create page with metafield: ${e.toString()}",
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
        name: 'body_html',
        label: 'HTML Content',
        hint: 'The HTML content of the page',
        isRequired: true,
      ),
      const ApiField(
        name: 'metafield_key',
        label: 'Metafield Key',
        hint: 'The key for the page metafield',
        isRequired: true,
      ),
      const ApiField(
        name: 'metafield_value',
        label: 'Metafield Value',
        hint: 'The value for the page metafield',
        isRequired: true,
      ),
      const ApiField(
        name: 'metafield_type',
        label: 'Metafield Type',
        hint: 'The type of the metafield (default: single_line_text_field)',
        isRequired: true,
      ),
      const ApiField(
        name: 'metafield_namespace',
        label: 'Metafield Namespace',
        hint: 'The namespace for the metafield (default: global)',
        isRequired: true,
      ),
    ],
  };
}
