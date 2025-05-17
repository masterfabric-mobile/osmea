import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/page/abstract/page_service.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/request/add_metafield_to_page_request.dart' 
    as metafield_request;
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*********** 🏷️ ADD METAFIELD TO PAGE **********************
///**************************************************************

class AddMetafieldToPageHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle PUT requests for adding metafields
    if (method != 'PUT') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only PUT is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final pageId = params['page_id'];
    final metafieldKey = params['metafield_key'];
    final metafieldValue = params['metafield_value'];
    final metafieldType = params['metafield_type'] ?? 'single_line_text_field';
    final metafieldNamespace = params['metafield_namespace'] ?? 'global';

    // Validate required parameters
    if (pageId == null || pageId.isEmpty) {
      return {
        "status": "error",
        "message": "Page ID is required",
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
      // Create metafield object
      final metafield = metafield_request.Metafield(
        key: metafieldKey,
        value: metafieldValue,
        type: metafieldType,
        namespace: metafieldNamespace,
      );
      
      // Create the page object with ID and metafields
      final page = metafield_request.Page(
        id: int.parse(pageId),
        metafields: [metafield],
      );
      
      // Create the request model with the page object
      final metafieldRequest = metafield_request.AddMetafieldToPageRequest(
        page: page,
      );

      // Call the API method
      final response = await GetIt.I<PageService>().addMetafieldToPage(
        apiVersion: ApiNetwork.apiVersion,
        pageId: pageId,
        model: metafieldRequest,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Metafield added to page successfully",
        "page": response.page?.toJson(),
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to add metafield to page: ${e.toString()}",
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
        hint: 'The ID of the page to add the metafield to',
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
      ),
      const ApiField(
        name: 'metafield_namespace',
        label: 'Metafield Namespace',
        hint: 'The namespace for the metafield (default: global)',
      ),
    ],
  };
}
