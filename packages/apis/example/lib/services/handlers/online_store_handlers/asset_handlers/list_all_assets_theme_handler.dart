import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/asset/abstract/asset_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
///************** 🎨 LIST ALL THEME ASSETS HANDLER 🎨 **************
///*******************************************************************

class ListAllAssetsThemeHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle GET requests for listing theme assets
    if (method == 'GET') {
      // 🔍 Check if theme ID is provided - required parameter
      final themeId = params['theme_id'] ?? '';
      if (themeId.isEmpty) {
        return {
          "status": "error",
          "message": "Theme ID is required",
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

        // Extract optional query parameters
        final fields = params['fields']?.isNotEmpty == true ? params['fields'] : null;
        
        // 📞 Call the asset service API to get all assets for the theme
        final response = await GetIt.I.get<AssetService>().listAllAssetTheme(
              apiVersion: ApiNetwork.apiVersion,
              themeId: themeIdInt,
              fields: fields,
            );

        // Prepare the base response
        final successResponse = {
          "status": "success",
          "themeId": themeId,
          "count": response.assets?.length ?? 0,
          "message": "Theme assets successfully retrieved",
          "timestamp": DateTime.now().toIso8601String(),
        };
        
        // If fields parameter was provided, filter the assets to include only those fields
        if (fields != null) {
          final fieldsList = fields.split(',');
          
          // Filter each asset to only include the requested fields
          final filteredAssets = response.assets?.map((asset) {
            final assetMap = asset.toJson();
            final filteredAsset = <String, dynamic>{};
            
            for (final field in fieldsList) {
              final trimmedField = field.trim();
              if (assetMap.containsKey(trimmedField)) {
                filteredAsset[trimmedField] = assetMap[trimmedField];
              }
            }
            
            return filteredAsset;
          }).toList();
          
          successResponse["assets"] = filteredAssets ?? [];
          successResponse["requestedFields"] = fields;
        } else {
          // No fields filter - include all asset data
          successResponse["assets"] = response.assets?.map((asset) => asset.toJson()).toList() ?? [];
        }
        
        return successResponse;
      } catch (e) {
        // ❌ Error handling with status code detection
        String errorMessage = e.toString();
        int statusCode = 500;

        if (errorMessage.contains('404')) {
          statusCode = 404;
          return {
            "status": "error",
            "statusCode": statusCode,
            "message": "Theme not found. Please verify the theme ID exists.",
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
          "message": "Failed to retrieve theme assets: $errorMessage",
          "themeId": themeId,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error": "Method $method not supported for List All Theme Assets API",
      "supportedMethods": supportedMethods,
    };
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'theme_id',
            label: 'Theme ID',
            hint: 'Enter theme ID to retrieve assets',
          ),
          const ApiField(
            name: 'fields',
            label: 'Fields',
            hint: 'Comma-separated list of fields to include in the response',
            isRequired: false,
          ),
        ],
      };
}
