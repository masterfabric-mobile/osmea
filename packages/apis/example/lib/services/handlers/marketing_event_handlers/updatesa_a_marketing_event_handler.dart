import 'package:apis/apis.dart';
import 'package:apis/network/remote/marketing_event/abstract/marketing_event_service.dart';
import 'package:apis/network/remote/marketing_event/freezed_model/request/updates_a_marketing_event_request_model.dart';
import 'package:get_it/get_it.dart';
import '../../api_service_registry.dart';
import '../../api_request_handler.dart';
import 'dart:convert';

///*******************************************************************
///*************  📝 MARKETING EVENT UPDATE HANDLER 📝 **************
///*******************************************************************

class UpdatesAMarketingEventHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'PUT':
        // ✅ Update an existing marketing event
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

          // 📋 Extract marketing event fields
          final eventType = params['event_type'];
          final startedAt = params['started_at'];
          final budget = params['budget'] != null
              ? double.tryParse(params['budget']!)
              : null;
          final currency = params['currency'];
          final utmCampaign = params['utm_campaign'];
          final utmSource = params['utm_source'];
          final utmMedium = params['utm_medium'];

          // Create marketing event update model
          final updatedEvent = MarketingEvent(
            eventType: eventType,
            startedAt: startedAt, // String is expected, not DateTime
            budget: budget?.toString(), // Convert to String
            currency: currency,
            utmCampaign: utmCampaign,
            utmSource: utmSource,
            utmMedium: utmMedium,
          );

          // 📞 Call the API to update the marketing event
          final response =
              await GetIt.I.get<MarketingEventEvents>().updatesAMarketingEvent(
                    apiVersion: ApiNetwork.apiVersion,
                    marketingEventId: marketingEventId,
                    model: UpdatesAMarketingEventRequestModel(
                      marketingEvent: updatedEvent,
                    ),
                  );

          // 🎉 Return successful response
          return {
            "status": "success",
            "message": "Marketing event updated successfully",
            "marketingEvent": response.marketingEvent?.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          // ❌ Handle specific error patterns
          String errorMessage = e.toString();

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
                    "message": "Failed to update marketing event",
                    "errors": errors,
                    "timestamp": DateTime.now().toIso8601String(),
                  };
                }
              }
            } catch (_) {
              // Failed to parse JSON, fall through to general error handling
            }
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
            "message": "Failed to update marketing event: $errorMessage",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        // ⚠️ Return error for unsupported methods
        return {
          "status": "error",
          "message":
              "Method $method not supported for Marketing Event Update API. Only PUT is allowed.",
          "timestamp": DateTime.now().toIso8601String(),
        };
    }
  }

  @override
  // 🔍 Only PUT method is supported for event updates
  List<String> get supportedMethods => ['PUT'];

  @override
  // 📝 Define required fields for updating a marketing event
  Map<String, List<ApiField>> get requiredFields => {
        'PUT': [
          const ApiField(
            name: 'id',
            label: 'Marketing Event ID',
            hint: 'ID of the marketing event to update',
          ),
          const ApiField(
            name: 'event_type',
            label: 'Event Type',
            hint: 'Type of marketing event (e.g., ad, post, email)',
          ),
          const ApiField(
            name: 'started_at',
            label: 'Started At',
            hint: 'Date when the event started (ISO format)',
          ),
          const ApiField(
            name: 'description',
            label: 'Description',
            hint: 'Description of the marketing event',
          ),
          const ApiField(
            name: 'marketing_channel',
            label: 'Marketing Channel',
            hint: 'Channel used for marketing (e.g., social, email)',
          ),
          const ApiField(
            name: 'paid',
            label: 'Paid',
            hint: 'Whether this was a paid campaign (true/false)',
          ),
          const ApiField(
            name: 'budget',
            label: 'Budget',
            hint: 'Budget allocated for this event',
          ),
          const ApiField(
            name: 'currency',
            label: 'Currency',
            hint: 'Currency code for the budget (e.g., USD)',
          ),
          const ApiField(
            name: 'utm_campaign',
            label: 'UTM Campaign',
            hint: 'UTM campaign parameter',
          ),
          const ApiField(
            name: 'utm_source',
            label: 'UTM Source',
            hint: 'UTM source parameter',
          ),
          const ApiField(
            name: 'utm_medium',
            label: 'UTM Medium',
            hint: 'UTM medium parameter',
          ),
        ],
      };
}
