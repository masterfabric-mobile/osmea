import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/asset/abstract/asset_service.dart';
import 'package:apis/network/remote/online_store/asset/freezed_model/request/create_image_asset_source_url_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
///************** 🔗 CREATE IMAGE ASSET FROM URL HANDLER 🔗 **********
///*******************************************************************

class CreateImageAssetSourceUrlHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle PUT requests for creating image assets from URLs
    if (method == 'PUT') {
      // 🔍 Check if required parameters are provided
      final themeId = params['theme_id'] ?? '';
      final key = params['key'] ?? '';
      final src = params['src'] ?? '';

      // Validate required parameters
      if (themeId.isEmpty) {
        return {
          "status": "error",
          "message": "Theme ID is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      if (key.isEmpty) {
        return {
          "status": "error",
          "message": "Asset key is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      if (src.isEmpty) {
        return {
          "status": "error",
          "message": "Source URL is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      try {
        int themeIdInt;

        // Convert theme ID to integer
        try {
          themeIdInt = int.parse(themeId);
        } catch (_) {
          return {
            "status": "error",
            "message": "Theme ID must be a valid number",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // Create request model for uploading an image asset from URL
        final request = CreateImageAssetSourceUrlRequest(
          asset: Asset(
            key: key,
            src: src,
          ),
        );

        // 📞 Call the asset service API to create the asset
        final response = await GetIt.I.get<AssetService>().createImageAssetSourceUrl(
              apiVersion: ApiNetwork.apiVersion,
              themeId: themeIdInt,
              model: request,
            );

        // 📋 Return the created asset data
        return {
          "status": "success",
          "themeId": themeId,
          "asset": response.asset.toJson(),
          "message": "Image asset from URL successfully created",
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        // ❌ Error handling with status code detection
        String errorMessage = e.toString();
        int statusCode = 406;

        if (errorMessage.contains('404')) {
          statusCode = 404;
          return {
            "status": "error",
            "statusCode": statusCode,
            "message": "Theme not found or source URL is invalid",
            "themeId": themeId,
            "timestamp": DateTime.now().toIso8601String(),
          };
        } else if (errorMessage.contains('422')) {
          statusCode = 422;
          return {
            "status": "error",
            "statusCode": statusCode,
            "message": "Validation error. Check that the URL is accessible and valid.",
            "themeId": themeId,
            "timestamp": DateTime.now().toIso8601String(),
          };
        } else if (errorMessage.contains('429')) {
          statusCode = 429;
          return {
            "status": "error",
            "statusCode": statusCode,
            "message": "Rate limit exceeded. Please try again later.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // Default error response
        return {
          "status": "error",
          "statusCode": statusCode,
          "message": "Failed to create image asset from URL: $errorMessage",
          "themeId": themeId,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error": "Method $method not supported for Create Image Asset from URL API",
      "supportedMethods": supportedMethods,
    };
  }

  @override
  List<String> get supportedMethods => ['PUT'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'PUT': [
          const ApiField(
            name: 'theme_id',
            label: 'Theme ID',
            hint: 'Enter theme ID where the asset will be created',
          ),
          const ApiField(
            name: 'key',
            label: 'Asset Key',
            hint: 'Enter the asset key (e.g., assets/logo.png)',
          ),
          const ApiField(
            name: 'src',
            label: 'src',
            hint: 'Enter the URL of the image to be used as source',
            isRequired: true,
          ),
        ],
      };
}
