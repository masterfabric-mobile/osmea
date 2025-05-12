import 'package:apis/apis.dart';
import 'package:apis/network/remote/events/abstract/events_service.dart';
import 'package:get_it/get_it.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';

///*******************************************************************
///******************* 📅 EVENTS LIST HANDLER 📅 *******************
///*******************************************************************

class RetrievesListOfEventsHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, dynamic> params) async {
    // 🔍 Validate method
    if (method == 'GET') {
      try {
        // Let's properly get the parameters
        final createdAtMin = params['created_at_min'] as String?;
        final createdAtMax = params['created_at_max'] as String?;
        final limitStr = params['limit'] as String?;
        final limit = limitStr != null ? int.tryParse(limitStr) : null;
        final sinceId = params['since_id'] as String?;
        final filter = params['filter'] as String?;
        final sortBy = params['sort_by'] as String?;

        // 🚀 Make API call to get events list using ApiNetwork.apiVersion
        final response =
            await GetIt.I.get<RetrievesListOfEvents>().retrievesListOfEvents(
                  apiVersion: ApiNetwork.apiVersion,
                  createdAtMin: createdAtMin,
                  createdAtMax: createdAtMax,
                  limit: limit,
                  sinceId: sinceId,
                  filter: filter,
                  sortBy: sortBy,
                );

        final events = response.events ?? [];

        // 📊 Group events by type
        final Map<String, List<dynamic>> categorizedEvents = {};

        for (final event in events) {
          final type = event.verb ?? 'other';
          String category = type.isNotEmpty
              ? type[0].toUpperCase() + type.substring(1)
              : 'Other';

          if (category.contains('_')) {
            category = category
                .split('_')
                .map((word) => word.isNotEmpty
                    ? word[0].toUpperCase() + word.substring(1)
                    : '')
                .join(' ');
          }

          if (!categorizedEvents.containsKey(category)) {
            categorizedEvents[category] = [];
          }

          categorizedEvents[category]!.add(event);
        }

        final List<Map<String, dynamic>> categories =
            categorizedEvents.entries.map((entry) {
          return {
            "category": entry.key,
            "events": entry.value,
          };
        }).toList();

        return {
          "status": "success",
          "categories": categories,
          "totalEvents": events.length,
          "responseData": response.toJson(),
          "params": params,
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        String errorMessage = e.toString();
        int statusCode = 500;

        if (errorMessage.contains("status code of")) {
          final regex = RegExp(r"status code of (\d+)");
          final match = regex.firstMatch(errorMessage);
          if (match != null) {
            statusCode = int.tryParse(match.group(1) ?? "500") ?? 500;
          }
        }

        String troubleshootingTip = "";
        if (statusCode == 403) {
          troubleshootingTip = "This may be due to insufficient permissions. "
              "Ensure your API credentials have proper access.";
        } else if (statusCode == 401) {
          troubleshootingTip =
              "Authentication failed. Check your API credentials and make sure they're valid.";
        } else {
          troubleshootingTip =
              "An unexpected error occurred. Check connection and retry.";
        }

        return {
          "status": "error",
          "message": "Failed to fetch events: $errorMessage",
          "statusCode": statusCode,
          "troubleshooting": troubleshootingTip,
          "requestDetails": {
            "method": "GET",
            "params": params,
            "apiVersion": ApiNetwork.apiVersion,
          },
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    return {
      "status": "error",
      "message":
          "Method $method not supported for Events API. Use GET instead.",
      "timestamp": DateTime.now().toIso8601String(),
    };
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'created_at_min',
            label: 'Created At Min',
            hint: 'Filter by minimum created date (optional)',
          ),
          const ApiField(
            name: 'created_at_max',
            label: 'Created At Max',
            hint: 'Filter by maximum created date (optional)',
          ),
          const ApiField(
            name: 'limit',
            label: 'Limit',
            hint: 'Maximum number of events to return (optional)',
          ),
          const ApiField(
            name: 'since_id',
            label: 'Since ID',
            hint: 'Events after this ID (optional)',
          ),
          const ApiField(
            name: 'filter',
            label: 'Filter',
            hint: 'Filter expression (optional)',
          ),
          const ApiField(
            name: 'sort_by',
            label: 'Sort By',
            hint: 'Field to sort by (optional)',
          ),
        ],
      };
}
