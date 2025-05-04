import 'package:apis/apis.dart';
import 'package:apis/network/remote/events/abstract/events_service.dart';
import 'package:get_it/get_it.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';

///*******************************************************************
///******************* 🔢 EVENT COUNT HANDLER 🔢 *******************
///*******************************************************************

class RetrievesCountEventsHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, dynamic> params) async {
    // 🔍 Validate method
    if (method == 'GET') {
      try {
        final apiVersion = ApiNetwork.apiVersion;
        final createdAtMin = params['created_at_min'] as String?;
        final createdAtMax = params['created_at_max'] as String?;

        // 🚀 Make API call to get events count
        final response =
            await GetIt.I.get<RetrievesCountEvents>().retrievesCountEvents(
                  apiVersion: apiVersion,
                  createdAtMin: createdAtMin,
                  createdAtMax: createdAtMax,
                );

        final count = response.count ?? 0;

        return {
          "status": "success",
          "count": count,
          "params": {
            "created_at_min": createdAtMin,
            "created_at_max": createdAtMax,
          },
          "responseData": response.toJson(),
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
          "message": "Failed to fetch events count: $errorMessage",
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
          "Method $method not supported for Events Count API. Use GET instead.",
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
        ],
      };
}
