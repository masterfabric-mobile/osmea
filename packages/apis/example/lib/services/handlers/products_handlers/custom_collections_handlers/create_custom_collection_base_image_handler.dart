import 'package:apis/apis.dart';
import 'package:apis/network/remote/products/custom_collection/abstract/custom_collections_service.dart';
import 'package:apis/network/remote/products/custom_collection/freezed_model/request/create_custom_collection_base_image_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 🖼️ CREATE CUSTOM COLLECTION WITH IMAGE *******
///**************************************************************

class CreateCustomCollectionBaseImageHandler implements ApiRequestHandler {
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
    final attachment = params['attachment'];
    final altText = params['alt_text'];

    // Validate required parameters
    if (title == null || title.isEmpty) {
      return {
        "status": "error",
        "message": "Collection title is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    if (attachment == null || attachment.isEmpty) {
      return {
        "status": "error",
        "message": "Base64 image attachment is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      final collectionRequest = CreateCustomCollectionBaseImageRequest(
          customCollection: CustomCollection(
              title: title,
              image: Image(attachment: attachment, alt: altText)));

      // Call the API method
      final response = await GetIt.I<CustomCollectionsService>()
          .createCustomCollectionBaseImage(
        apiVersion: ApiNetwork.apiVersion,
        model: collectionRequest,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Custom collection with image created successfully",
        "custom_collection": response.customCollection?.toJson(),
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message":
            "Failed to create custom collection with image: ${e.toString()}",
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
            name: 'attachment',
            label: 'Image Attachment',
            hint: 'The base64-encoded image data',
            isRequired: true,
          ),
          const ApiField(
            name: 'alt_text',
            label: 'Alt Text',
            hint: 'Alternative text for the image',
            isRequired: false,
          ),
        ],
      };
}
