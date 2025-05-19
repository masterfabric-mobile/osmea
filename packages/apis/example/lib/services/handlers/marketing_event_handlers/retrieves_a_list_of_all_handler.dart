import 'package:apis/apis.dart';
import 'package:apis/network/remote/marketing_event/abstract/marketing_event_service.dart';
import 'package:apis/network/remote/marketing_event/freezed_model/response/retrieves_a_list_of_all_response_model.dart';
import 'package:get_it/get_it.dart';
import '../../api_service_registry.dart';
import '../../api_request_handler.dart';

///*******************************************************************
///****************** 🔐 MARKETING EVENTS LIST HANDLER 🔐 ******************
///*******************************************************************

class RetrievesAListOfAllHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔍 Validate method
    if (method == 'GET') {
      try {
        // 🚀 Make API call to get all marketing events
        final response =
            await GetIt.I.get<MarketingEventEvents>().retrievesAListOfAll(
                  apiVersion: ApiNetwork.apiVersion,
                );

        // Process the marketing events data
        List<Map<String, dynamic>> formattedEvents = [];
        if (response.marketingEvents != null) {
          for (final event in response.marketingEvents!) {
            formattedEvents.add({
              "id": event.id,
              "event_type": event.eventType,
              "marketing_channel": event.marketingChannel,
              "started_at": event.startedAt
                  ?.toIso8601String(), // Convert DateTime to String
              "ended_at": event.endedAt
                  ?.toIso8601String(), // This is already dynamic so it should be fine
              "budget": event.budget,
              "currency": event.currency,
              "description": event.description,
              "utm_campaign": event.utmCampaign,
              "utm_source": event.utmSource,
              "utm_medium": event.utmMedium,
              "admin_graphql_api_id": event.adminGraphqlApiId,
            });
          }
        }

        // ✅ Return successful response with marketing events
        return {
          "status": "success",
          "marketingEvents": formattedEvents,
          "total": formattedEvents.length,
          // Convert the entire response to a serializable Map instead of using response.toJson()
          "responseData": _sanitizeJsonData(response),
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        // 🚨 Error handling
        String errorMessage = e.toString();
        int statusCode = 500;

        // Check for JSON error format
        if (errorMessage.contains("Invalid API key or access token")) {
          statusCode = 401;
          errorMessage =
              "Invalid API key or access token (unrecognized login or wrong password)";
        }
        // Extract status code if available
        else if (errorMessage.contains("status code of")) {
          final regex = RegExp(r"status code of (\d+)");
          final match = regex.firstMatch(errorMessage);
          if (match != null) {
            statusCode = int.tryParse(match.group(1) ?? "500") ?? 500;
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
        }

        // Return error response
        return {
          "status": "error",
          "message": "Failed to fetch marketing events: $errorMessage",
          "statusCode": statusCode,
          "troubleshooting": troubleshootingTip,
          "requestDetails": {
            "method": "GET",
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
          "Method $method not supported for Marketing Events API. Use GET instead.",
      "timestamp": DateTime.now().toIso8601String(),
    };
  }

  // Helper method to convert response to serializable Map
  Map<String, dynamic> _sanitizeJsonData(
      RetrievesAListOfAllResponseModel response) {
    final Map<String, dynamic> serializedData = {};

    if (response.marketingEvents != null) {
      serializedData['marketing_events'] =
          response.marketingEvents!.map((event) {
        return {
          "id": event.id,
          "event_type": event.eventType,
          "remote_id": event.remoteId,
          "started_at": event.startedAt?.toIso8601String(),
          "ended_at": event.endedAt,
          "scheduled_to_end_at": event.scheduledToEndAt,
          "budget": event.budget,
          "currency": event.currency,
          "manage_url": event.manageUrl,
          "preview_url": event.previewUrl,
          "utm_campaign": event.utmCampaign,
          "utm_source": event.utmSource,
          "utm_medium": event.utmMedium,
          "budget_type": event.budgetType,
          "description": event.description,
          "marketing_channel": event.marketingChannel,
          "paid": event.paid,
          "referring_domain": event.referringDomain,
          "breadcrumb_id": event.breadcrumbId,
          "marketing_activity_id": event.marketingActivityId,
          "admin_graphql_api_id": event.adminGraphqlApiId,
          "marketed_resources": event.marketedResources,
        };
      }).toList();
    }

    return serializedData;
  }

  @override
  // Support only GET method
  List<String> get supportedMethods => ['GET'];

  @override
  // No required fields for this endpoint
  Map<String, List<ApiField>> get requiredFields => {
        "GET": [],
      };
}
