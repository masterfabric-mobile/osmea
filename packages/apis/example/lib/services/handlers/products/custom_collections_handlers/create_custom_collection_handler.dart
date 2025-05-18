import 'package:apis/apis.dart';
import 'package:apis/network/remote/products/custom_collection/abstract/custom_collections_service.dart';
import 'package:apis/network/remote/products/custom_collection/freezed_model/request/create_custom_collection_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 🆕 CREATE CUSTOM COLLECTION *****************
///**************************************************************

class CreateCustomCollectionHandler implements ApiRequestHandler {
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

    // Validate required parameters
    if (title == null || title.isEmpty) {
      return {
        "status": "error",
        "message": "Collection title is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      final collectionRequest =
          CreateCustomCollectionRequest(
        customCollection: CustomCollection(title: title));

      // Call the API method
      final response =
          await GetIt.I<CustomCollectionsService>().createCustomCollection(
        apiVersion: ApiNetwork.apiVersion,
        model: collectionRequest,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Custom collection created successfully",
        "custom_collection": response.customCollection?.toJson(),
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to create custom collection: ${e.toString()}",
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
        ],
      };
}
