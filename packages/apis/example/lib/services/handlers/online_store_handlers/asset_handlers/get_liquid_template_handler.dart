import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/asset/abstract/asset_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import '../../../api_service_registry.dart';

///*******************************************************************
///******************* 📄 GET LIQUID TEMPLATE HANDLER 📄 *****************
///*******************************************************************

class GetLiquidTemplateHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    if (method == 'GET') {
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
          "message": "Template key is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      try {
        // 📞 Call the Asset service to retrieve the template
        final response = await GetIt.I.get<AssetService>().getLiquidTemplate(
              apiVersion: ApiNetwork.apiVersion,
              themeId: int.parse(themeId), // Parse string to int as required
              assetKey:
                  key, // Use 'assetKey' parameter name as specified in the interface
            );

        // ✅ Extract the asset data from the response
        final asset = response.asset;

        // 🔍 Check if the asset contains a value (there is no attachment field in this model)
        // For text-based assets like .liquid files
        return {
          "status": "success",
          "asset": asset.toJson(),
          "content": asset.value,
          "contentType": "text",
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
              "The template or theme was not found. Check that the theme ID and key are correct.";
        } else if (statusCode == 401 || statusCode == 403) {
          troubleshootingTip =
              "You don't have permission to access this template. Check your API access scope and authentication.";
        }

        return {
          "status": "error",
          "message": "Failed to retrieve template: $errorMessage",
          "statusCode": statusCode,
          "troubleshooting": troubleshootingTip,
          "requestDetails": {
            "method": "GET",
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
          "Method $method not supported for Liquid Template API. Use GET.",
      "timestamp": DateTime.now().toIso8601String(),
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
            hint: 'Enter the ID of the theme containing the template',
          ),
          const ApiField(
            name: 'key',
            label: 'Template Key',
            hint: 'Enter the key path (e.g., templates/index.liquid)',
          ),
        ],
      };
}
