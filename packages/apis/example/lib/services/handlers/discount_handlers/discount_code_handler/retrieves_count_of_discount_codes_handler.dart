import 'package:apis/apis.dart';
import 'package:apis/network/remote/discounts/discount_code/abstract/discount_code.dart';
import 'package:apis/network/remote/discounts/discount_code/freezed_model/response/discount_code_count_response.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import '../../../api_service_registry.dart';

class GetDiscountCodesCountHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'GET':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? timesUsed = params['times_used'];
        final String? timesUsedMax = params['times_used_max'];
        final String? timesUsedMin = params['times_used_min'];

        try {
          final DiscountCodeCountResponse response = await GetIt.I
              .get<DiscountCodeService>()
              .getCountDiscountCodes(
                apiVersion: apiVersion,
                timesUsed: timesUsed != null ? int.tryParse(timesUsed) : null,
                timesUsedMax: timesUsedMax,
                timesUsedMin: timesUsedMin,
              );
          return {
            "status": "success",
            "count": response.count,
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message": "Failed to fetch discount codes count: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error": "Method $method not supported for Discount Code Count API",
        };
    }
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'times_used',
            label: 'Times Used',
            hint: 'Filter by number of times used (optional)',
          ),
          const ApiField(
            name: 'times_used_max',
            label: 'Times Used Max',
            hint: 'Filter by maximum number of times used (optional)',
          ),
          const ApiField(
            name: 'times_used_min',
            label: 'Times Used Min',
            hint: 'Filter by minimum number of times used (optional)',
          ),
        ],
      };
}
