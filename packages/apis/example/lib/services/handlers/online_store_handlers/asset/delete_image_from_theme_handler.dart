import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/asset/abstract/asset_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import '../../../api_service_registry.dart';

///*******************************************************************
///*************** 🗑️ DELETE IMAGE FROM THEME HANDLER 🗑️ ************
///*******************************************************************

class DeleteImageFromThemeHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    if (method == 'DELETE') {
      // 🔍 Extract required parameters
      final themeId = params['theme_id'] ?? '';
      final key = params['key'] ?? '';

      // ⚠️ Validate required parameters
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
          "message": "Image key is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      try {
        // 🗑️ Delete the image from the theme
        await GetIt.I.get<AssetService>().deleteImageFromTheme(
              apiVersion: ApiNetwork.apiVersion,
              themeId: int.parse(themeId),
              assetKey: key,
            );

        // Return success message
        return {
          "status": "success",
          "message": "Image deleted successfully",
          "themeId": themeId,
          "key": key,
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        // ❌ Error handling
        String errorMessage = e.toString();
        int statusCode = 500;

        // Extract status code if available
        if (errorMessage.contains("status code of")) {
          final regex = RegExp(r"status code of (\d+)");
          final match = regex.firstMatch(errorMessage);
          if (match != null) {
            statusCode = int.tryParse(match.group(1) ?? "500") ?? 500;
          }
        }

        // Provide helpful error messages based on status codes
        String troubleshootingTip = "";
        if (statusCode == 404) {
          troubleshootingTip =
              "The image or theme was not found. Check that the theme ID and image key are correct.";
        } else if (statusCode == 401 || statusCode == 403) {
          troubleshootingTip =
              "You don't have permission to delete assets from this theme. Check your API access scope and authentication.";
        } else if (statusCode == 422) {
          troubleshootingTip = "The asset key is invalid or malformed.";
        }

        return {
          "status": "error",
          "message": "Failed to delete image: $errorMessage",
          "statusCode": statusCode,
          "troubleshooting": troubleshootingTip,
          "requestDetails": {
            "method": "DELETE",
            "themeId": themeId,
            "key": key,
            "apiVersion": ApiNetwork.apiVersion,
          },
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⚠️ Return error for unsupported methods
    return {
      "status": "error",
      "message":
          "Method $method not supported for Delete Image From Theme API. Use DELETE.",
      "timestamp": DateTime.now().toIso8601String(),
    };
  }

  @override
  List<String> get supportedMethods => ['DELETE'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'DELETE': [
          const ApiField(
            name: 'theme_id',
            label: 'Theme ID',
            hint: 'Enter the ID of the theme containing the image',
          ),
          const ApiField(
            name: 'key',
            label: 'Image Key',
            hint: 'Enter the key path of the image (e.g., assets/logo.png)',
          ),
        ],
      };
}
