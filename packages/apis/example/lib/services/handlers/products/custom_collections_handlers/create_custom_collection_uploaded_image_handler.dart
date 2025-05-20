import 'package:apis/apis.dart';
import 'package:apis/network/remote/products/custom_collection/abstract/custom_collections_service.dart';
import 'package:apis/network/remote/products/custom_collection/freezed_model/request/create_custom_collection_uploaded_image_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 🖼️ CREATE COLLECTION WITH UPLOADED IMAGE ****
///**************************************************************

class CreateCustomCollectionUploadedImageHandler implements ApiRequestHandler {
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
    final imageSrc = params['image_src']; // URL to the image
    final imageAlt = params['image_alt'] ??
        title; // Alt text, defaults to title if not provided

    // Validate required parameters
    if (title == null || title.isEmpty) {
      return {
        "status": "error",
        "message": "Collection title is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    if (imageSrc == null || imageSrc.isEmpty) {
      return {
        "status": "error",
        "message": "Image source URL is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Create request with the proper structure matching the Shopify API format
      final collectionRequest = CreateCustomCollectionUploadedImageRequest(
        customCollection: CustomCollection(
          title: title,
          image: Image(
            src: imageSrc, // URL to the image
            alt: imageAlt, // Alt text for the image
          ),
        ),
      );

      // Call the API method and handle the response safely
      try {
        final response = await GetIt.I<CustomCollectionsService>()
            .createCustomCollectionUploadedImage(
          apiVersion: ApiNetwork.apiVersion,
          model: collectionRequest,
        );

        // Return success response without trying to convert anything to JSON
        return {
          "status": "success",
          "message":
              "Custom collection with uploaded image created successfully",
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
    } catch (e) {
      // Handle errors with status code detection
      String errorMessage = e.toString();

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
          "message": "Validation error. Check that the image format is valid.",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      return {
        "status": "error",
        "message":
            "Failed to create custom collection with uploaded image: ${e.toString()}",
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
            name: 'image_src',
            label: 'Image URL',
            hint: 'The URL of the image to use for the collection',
            isRequired: true,
          ),
          const ApiField(
            name: 'image_alt',
            label: 'Image Alt Text',
            hint:
                'Alternative text for the image (defaults to title if not provided)',
          ),
        ],
      };
}
