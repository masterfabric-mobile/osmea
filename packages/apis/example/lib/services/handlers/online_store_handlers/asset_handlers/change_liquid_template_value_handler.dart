import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/asset/abstract/asset_service.dart';
import 'package:apis/network/remote/online_store/asset/freezed_model/request/change_liquid_template_value_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import '../../../api_service_registry.dart';

///*******************************************************************
///************* 📝 CHANGE LIQUID TEMPLATE HANDLER 📝 ***************
///*******************************************************************

class ChangeLiquidTemplateValueHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    if (method == 'PUT') {
      // 🔍 Extract required parameters
      final themeId = params['theme_id'] ?? '';
      final key = params['key'] ?? '';
      final value = params['value'] ?? '';

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

      if (value.isEmpty) {
        return {
          "status": "error",
          "message": "Template value cannot be empty",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      try {
        // Create request model for updating the template
        final updateRequest = ChangeLiquidTemplateValueRequest(
          asset: Asset(
            key: key,
            value: value,
          ),
        );

        // 📞 Call the Asset service to update the template
        final response =
            await GetIt.I.get<AssetService>().changeLiquidTemplateValue(
                  apiVersion: ApiNetwork.apiVersion,
                  themeId: int.parse(themeId),
                  model: updateRequest,
                );

        // ✅ Extract the updated asset data
        final updatedAsset = response.asset;

        // Return the updated asset information
        return {
          "status": "success",
          "message": "Template updated successfully",
          "asset": updatedAsset.toJson(),
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
              "You don't have permission to modify this template. Check your API access scope and authentication.";
        } else if (statusCode == 422) {
          troubleshootingTip =
              "The template content is invalid or contains syntax errors.";
        }

        return {
          "status": "error",
          "message": "Failed to update template: $errorMessage",
          "statusCode": statusCode,
          "troubleshooting": troubleshootingTip,
          "requestDetails": {
            "method": "PUT",
            "themeId": themeId,
            "key": key,
            "valueLength": value.length,
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
          "Method $method not supported for Changing Liquid Template API. Use PUT.",
      "timestamp": DateTime.now().toIso8601String(),
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
            hint: 'Enter the ID of the theme containing the template',
          ),
          const ApiField(
            name: 'key',
            label: 'Template Key',
            hint: 'Enter the key path (e.g., templates/index.liquid)',
          ),
          const ApiField(
            name: 'value',
            label: 'Template Content',
            hint: 'Enter the new template content',
          ),
        ],
      };
}
