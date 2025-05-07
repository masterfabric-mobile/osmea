import 'package:apis/apis.dart';
import 'package:apis/network/remote/marketing_event/abstract/marketing_event_service.dart';
import 'package:apis/network/remote/marketing_event/freezed_model/request/creates_marketing_engagements_request_model.dart';
import 'package:get_it/get_it.dart';
import '../../api_service_registry.dart';
import '../../api_request_handler.dart';
import 'dart:convert';

///*******************************************************************
///*************  📊 MARKETING ENGAGEMENTS CREATOR HANDLER 📊 **********
///*******************************************************************

class CreatesMarketingEngagementsHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'POST':
        // ✅ Create marketing engagements for an event
        try {
          // 🔍 Validate required parameters
          final marketingEventId = params['marketing_event_id'] ?? '';
          if (marketingEventId.isEmpty) {
            return {
              "status": "error",
              "message": "Marketing Event ID is required",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          // 📋 Extract engagement fields
          final occurredOn =
              params['occurred_on'] ?? DateTime.now().toIso8601String();
          final viewsCount = int.tryParse(params['views_count'] ?? '0');
          final clicksCount = int.tryParse(params['clicks_count'] ?? '0');
          final favoritesCount = int.tryParse(params['favorites_count'] ?? '0');
          final adSpend = int.tryParse(params['ad_spend'] ?? '0');
          final isCumulativeStr = params['is_cumulative'] ?? 'false';
          final isCumulative = isCumulativeStr.toLowerCase() == 'true';

          // Create engagement
          final engagement = Engagement(
            occurredOn: DateTime.tryParse(occurredOn),
            viewsCount: viewsCount,
            clicksCount: clicksCount,
            favoritesCount: favoritesCount,
            adSpend: adSpend,
            isCumulative: isCumulative,
          );

          // 📞 Call the API to create the engagements
          final response = await GetIt.I
              .get<MarketingEventEvents>()
              .createsMarketingEngagements(
                apiVersion: ApiNetwork.apiVersion,
                marketingEventId: marketingEventId,
                model: CreatesMarketingEngagementsRequestModel(
                  engagements: [engagement],
                ),
              );

          // 🎉 Return successful response
          return {
            "status": "success",
            "message": "Marketing engagements created successfully",
            "engagements":
                response.engagements?.map((e) => e.toJson()).toList(),
            "marketingEventId": marketingEventId,
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
                    "message": "Failed to create marketing engagements",
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
            "message": "Failed to create marketing engagements: $errorMessage",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        // ⚠️ Return error for unsupported methods
        return {
          "status": "error",
          "message":
              "Method $method not supported for Marketing Engagements API. Only POST is allowed.",
          "timestamp": DateTime.now().toIso8601String(),
        };
    }
  }

  @override
  // 🔍 Only POST method is supported for engagement creation
  List<String> get supportedMethods => ['POST'];

  @override
  // 📝 Define required fields for creating engagements
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(
            name: 'marketing_event_id',
            label: 'Marketing Event ID',
            hint: 'ID of the marketing event to create engagements for',
          ),
          const ApiField(
            name: 'occurred_on',
            label: 'Occurred On',
            hint: 'Date when the engagement occurred (ISO format)',
          ),
          const ApiField(
            name: 'views_count',
            label: 'Views Count',
            hint: 'Number of views',
          ),
          const ApiField(
            name: 'clicks_count',
            label: 'Clicks Count',
            hint: 'Number of clicks',
          ),
          const ApiField(
            name: 'favorites_count',
            label: 'Favorites Count',
            hint: 'Number of favorites/likes (optional)',
          ),
          const ApiField(
            name: 'ad_spend',
            label: 'Ad Spend',
            hint: 'Amount spent on advertising (optional)',
          ),
          const ApiField(
            name: 'is_cumulative',
            label: 'Is Cumulative',
            hint: 'Whether the counts are cumulative (true/false)',
          ),
        ],
      };
}
