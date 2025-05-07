import 'package:apis/apis.dart';
import 'package:apis/network/remote/marketing_event/abstract/marketing_event_service.dart';
import 'package:get_it/get_it.dart';
import '../../api_service_registry.dart';
import '../../api_request_handler.dart';
import 'dart:convert';

///*******************************************************************
///**************** 🗑️ MARKETING EVENT DELETE HANDLER 🗑️ **************
///*******************************************************************

class DeletesAMarketingEventHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'DELETE':
        // ✅ Delete an existing marketing event
        try {
          // 🔍 Validate required parameters
          final marketingEventId = params['id'] ?? '';
          if (marketingEventId.isEmpty) {
            return {
              "status": "error",
              "message": "Marketing Event ID is required",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          // 📞 Call the API to delete the marketing event
          await GetIt.I.get<MarketingEventEvents>().deletesAMarketingEvent(
                apiVersion: ApiNetwork.apiVersion,
                marketingEventId: marketingEventId,
              );

          // 🎉 Return successful response
          return {
            "status": "success",
            "message": "Marketing event deleted successfully",
            "id": marketingEventId,
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          // ❌ Handle specific error patterns
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

          // Parse error JSON if present
          if (errorMessage.contains('"errors"')) {
            try {
              // Extract JSON part from error message
              final jsonStart = errorMessage.indexOf('{');
              final jsonEnd = errorMessage.lastIndexOf('}') + 1;

              if (jsonStart >= 0 && jsonEnd > jsonStart) {
                final jsonStr = errorMessage.substring(jsonStart, jsonEnd);
                final errorJson = json.decode(jsonStr);

                // Check if we have the specific error format
                if (errorJson is Map && errorJson.containsKey('errors')) {
                  final errors = errorJson['errors'];
                  return {
                    "status": "error",
                    "message": "Failed to delete marketing event",
                    "errors": errors,
                    "timestamp": DateTime.now().toIso8601String(),
                  };
                }
              }
            } catch (_) {
              // Failed to parse JSON, fall through to general error handling
            }
          }

          // Provide troubleshooting info based on status code
          String troubleshootingTip = "";
          if (statusCode == 403) {
            troubleshootingTip = "This may be due to insufficient permissions. "
                "Ensure your Shopify API credentials have proper access.";
          } else if (statusCode == 401) {
            troubleshootingTip =
                "Authentication failed. Check your API credentials and make sure they're valid.";
          } else if (statusCode == 404) {
            troubleshootingTip =
                "Marketing event not found. It may have been already deleted or the ID is invalid.";
          }

          // ❌ Handle authentication errors specially
          if (errorMessage.contains('session has expired') ||
              errorMessage.contains('login?errorHint=no_identity_session') ||
              errorMessage.contains('Invalid API key or access token')) {
            return {
              "status": "auth_error",
              "message":
                  "Your authentication session has expired. Please log in again to continue.",
              "details":
                  "This occurs when your admin authentication token is no longer valid.",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          // ❌ Handle other errors
          return {
            "status": "error",
            "message": "Failed to delete marketing event: $errorMessage",
            "statusCode": statusCode,
            "troubleshooting": troubleshootingTip,
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        // ⚠️ Return error for unsupported methods
        return {
          "status": "error",
          "message":
              "Method $method not supported for Marketing Event API. Only DELETE is allowed.",
          "timestamp": DateTime.now().toIso8601String(),
        };
    }
  }

  @override
  // 🔍 Only DELETE method is supported for event deletion
  List<String> get supportedMethods => ['DELETE'];

  @override
  // 📝 Define required fields for deleting a marketing event
  Map<String, List<ApiField>> get requiredFields => {
        'DELETE': [
          const ApiField(
            name: 'id',
            label: 'Marketing Event ID',
            hint: 'ID of the marketing event to delete',
          ),
        ],
      };
}
