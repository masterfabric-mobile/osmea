import 'package:apis/apis.dart';
import 'package:apis/network/remote/products/custom_collection/abstract/custom_collections_service.dart';
import 'package:apis/network/remote/products/custom_collection/freezed_model/request/create_custom_collection_with_metafield_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 🏷️ CREATE COLLECTION WITH METAFIELD *********
///**************************************************************

class CreateCustomCollectionWithMetafieldHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle POST requests for collection creation
    if (method != 'POST') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only POST is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final title = params['title'];
    final metafieldKey = params['metafield_key'];
    final metafieldValue = params['metafield_value'];
    final metafieldType = params['metafield_type'];
    final metafieldNamespace = params['metafield_namespace'];

    // Validate required parameters
    if (title == null || title.isEmpty) {
      return {
        "status": "error",
        "message": "Collection title is required",
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

    if (metafieldType == null || metafieldType.isEmpty) {
      return {
        "status": "error",
        "message": "Metafield type is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    if (metafieldNamespace == null || metafieldNamespace.isEmpty) {
      return {
        "status": "error",
        "message": "Metafield namespace is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Create a single metafield
      final metafield = Metafield(
        key: metafieldKey,
        value: metafieldValue,
        type: metafieldType,
        namespace: metafieldNamespace,
      );

      // Create request with the proper structure
      final collectionRequest = CreateCustomCollectionWithMetafieldRequest(
        customCollection: CustomCollection(
          title: title,
          metafields: [metafield],
        ),
      );

      // Call the API method and handle the response safely
      try {
        try {
          final response = await GetIt.I<CustomCollectionsService>()
              .createCustomCollectionWithMetafield(
            apiVersion: ApiNetwork.apiVersion,
            model: collectionRequest,
          );

          // Successfully created collection
          return {
            "status": "success",
            "message": "Custom collection with metafield created successfully",
            "custom_collection": response.customCollection?.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } on TypeError catch (e) {
          // Handle the specific type error related to null JSON conversion
          if (e.toString().contains(
              "type 'Null' is not a subtype of type 'Map<String, dynamic>'")) {
            // This is likely due to the API sending a response structure that doesn't match our model
            return {
              "status": "partial_success",
              "message":
                  "Request was processed but response format was unexpected.",
              "error_details": "Model mapping error: ${e.toString()}",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }
          rethrow; // If it's a different TypeError, rethrow it
        }
      } catch (apiError) {
        // More robust error handling with status code detection
        String errorMessage = apiError.toString();

        if (errorMessage.contains('404')) {
          return {
            "status": "error",
            "statusCode": 404,
            "message": "Resource not found. Please verify the parameters.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        } else if (errorMessage.contains('422')) {
          return {
            "status": "error",
            "statusCode": 422,
            "message": "Validation error. Check that all parameters are valid.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        return {
          "status": "error",
          "message": "API request failed: ${apiError.toString()}",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    } catch (e) {
      return {
        "status": "error",
        "message":
            "Failed to create custom collection with metafield: ${e.toString()}",
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
            hint: 'The name of the custom collection',
            isRequired: true,
          ),
          const ApiField(
            name: 'metafield_key',
            label: 'Metafield Key',
            hint: 'The key for the metafield',
            isRequired: true,
          ),
          const ApiField(
            name: 'metafield_value',
            label: 'Metafield Value',
            hint: 'The value for the metafield',
            isRequired: true,
          ),
          const ApiField(
            name: 'metafield_type',
            label: 'Metafield Type',
            hint: 'The type of the metafield (e.g., single_line_text_field)',
            isRequired: true,
          ),
          const ApiField(
            name: 'metafield_namespace',
            label: 'Metafield Namespace',
            hint: 'The namespace for the metafield (e.g., global)',
            isRequired: true,
          ),
        ],
      };
}
