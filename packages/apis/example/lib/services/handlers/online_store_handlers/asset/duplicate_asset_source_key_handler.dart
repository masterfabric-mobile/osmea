import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/asset/abstract/asset_service.dart';
import 'package:apis/network/remote/online_store/asset/freezed_model/request/duplicate_asset_source_key_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import '../../../api_service_registry.dart';

///*******************************************************************
///************* 🔄 DUPLICATE ASSET SOURCE KEY HANDLER 🔄 ***********
///*******************************************************************

class DuplicateAssetSourceKeyHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    if (method == 'POST') {
      // 🔍 Extract required parameters
      final themeId = params['theme_id'] ?? '';
      final sourceKey = params['source_key'] ?? '';
      final targetKey = params['target_key'] ?? '';

      // ⚠️ Validate required parameters
      if (themeId.isEmpty) {
        return {
          "status": "error",
          "message": "Theme ID is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      if (sourceKey.isEmpty) {
        return {
          "status": "error",
          "message": "Source key is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      if (targetKey.isEmpty) {
        return {
          "status": "error",
          "message": "Target key is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      if (sourceKey == targetKey) {
        return {
          "status": "error",
          "message": "Source and target keys cannot be the same",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      // Create the request with the correct structure
      final request = DuplicateAssetSourceKeyRequest(
        asset: Asset(
          sourceKey: sourceKey,
          key: targetKey
        ),
      );

      try {
        // Use the dedicated duplicateAssetSourceKey method
        final response =
            await GetIt.I.get<AssetService>().duplicateAssetSourceKey(
                  apiVersion: ApiNetwork.apiVersion,
                  themeId: int.parse(themeId),
                  model: request,
                );

        // Return success with the newly created asset
        return {
          "status": "success",
          "message": "Asset duplicated successfully",
          "sourceKey": sourceKey,
          "targetKey": targetKey,
          "asset": response.asset.toJson(),
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
              "The source asset or theme was not found. Check that the theme ID and source key are correct.";
        } else if (statusCode == 401 || statusCode == 403) {
          troubleshootingTip =
              "You don't have permission to access or modify assets in this theme. Check your API access scope and authentication.";
        } else if (statusCode == 422) {
          troubleshootingTip =
              "The target key may already exist or is invalid. Try a different target key.";
        }

        return {
          "status": "error",
          "message": "Failed to duplicate asset: $errorMessage",
          "statusCode": statusCode,
          "troubleshooting": troubleshootingTip,
          "requestDetails": {
            "method": "POST",
            "themeId": themeId,
            "sourceKey": sourceKey,
            "targetKey": targetKey,
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
          "Method $method not supported for Duplicate Asset Source Key API. Use POST.",
      "timestamp": DateTime.now().toIso8601String(),
    };
  }

  @override
  List<String> get supportedMethods => ['PUT'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(
            name: 'theme_id',
            label: 'Theme ID',
            hint: 'Enter the ID of the theme containing the asset',
          ),
          const ApiField(
            name: 'source_key',
            label: 'Source Key',
            hint:
                'Enter the key of the asset to duplicate (e.g., templates/index.liquid)',
          ),
          const ApiField(
            name: 'target_key',
            label: 'Target Key',
            hint:
                'Enter the new key for the duplicated asset (e.g., templates/index_copy.liquid)',
          ),
        ],
      };
}
