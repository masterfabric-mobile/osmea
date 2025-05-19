import 'package:apis/apis.dart';
import 'package:apis/network/remote/marketing_event/abstract/marketing_event_service.dart';
import 'package:apis/network/remote/marketing_event/freezed_model/request/creates_marketing_event_request_model.dart';
import 'package:get_it/get_it.dart';
import '../../api_service_registry.dart';
import '../../api_request_handler.dart';
import 'dart:convert';

///*******************************************************************
///*************  🏷️ MARKETING EVENT CREATOR HANDLER 🏷️ **************
///*******************************************************************

class CreatesMarketingEventHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'POST':
        // ✅ Create a new marketing event
        try {
          // 📋 Extract marketing event fields
          final eventType = params['event_type'] ?? '';
          final startedAt =
              params['started_at'] ?? DateTime.now().toIso8601String();
          final marketingChannel = params['marketing_channel'] ?? '';
          final paidStr = params['paid'] ?? 'false';
          final paid = paidStr.toLowerCase() == 'true';
          final utmCampaign = params['utm_campaign'];
          final utmSource = params['utm_source'];
          final utmMedium = params['utm_medium'];

          // ⚠️ Validate essential fields
          if (eventType.isEmpty || marketingChannel.isEmpty) {
            return {
              "status": "error",
              "message": "Event type and marketing channel are required",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          // Create marketing event model
          final newEvent = MarketingEvent(
            eventType: eventType,
            startedAt: DateTime.tryParse(startedAt),
            marketingChannel: marketingChannel,
            paid: paid,
            utmCampaign: utmCampaign,
            utmSource: utmSource,
            utmMedium: utmMedium,
            referringDomain: params['referring_domain'],
          );

          // 📞 Call the API to create the marketing event
          final response =
              await GetIt.I.get<MarketingEventEvents>().createsMarketingEvent(
                    apiVersion: ApiNetwork.apiVersion,
                    model: CreatesMarketingEventRequestModel(
                      marketingEvent: newEvent,
                    ),
                  );

          // 🎉 Return successful response
          return {
            "status": "success",
            "message": "Marketing event created successfully",
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
                    "message": "Failed to create marketing event",
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
            "message": "Failed to create marketing event: $errorMessage",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        // ⚠️ Return error for unsupported methods
        return {
          "status": "error",
          "message":
              "Method $method not supported for Marketing Event API. Only POST is allowed.",
          "timestamp": DateTime.now().toIso8601String(),
        };
    }
  }

  @override
  // 🔍 Only POST method is supported for event creation
  List<String> get supportedMethods => ['POST'];

  @override
  // 📝 Define required fields for creating a marketing event
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
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
          const ApiField(
            name: 'referring_domain',
            label: 'Referring Domain',
            hint: 'Domain that referred this marketing event',
          ),
        ],
      };
}
