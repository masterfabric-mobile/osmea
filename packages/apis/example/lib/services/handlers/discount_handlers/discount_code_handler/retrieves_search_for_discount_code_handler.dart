import 'package:apis/apis.dart';
import 'package:apis/network/remote/discounts/discount_code/abstract/discount_code.dart';
import 'package:apis/network/remote/discounts/discount_code/freezed_model/response/discount_code_location_response.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

class SearchDiscountCodeHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'GET':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? code = params['code'];

        if (code == null || code.isEmpty) {
          return {
            "status": "error",
            "message": "Discount code is required for lookup",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final DiscountCodeLocationResponse response =
              await GetIt.I.get<DiscountCodeService>().getDiscountCodeLocation(
                    apiVersion: apiVersion,
                    code: code,
                  );
          return {
            "status": "success",
            "discount_code_location": response.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          print("Error searching for discount code: $e");
          return {
            "status": "error",
            "message": "Failed to search for discount code: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error": "Method $method not supported for Discount Code Lookup API",
        };
    }
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'code',
            label: 'Discount Code',
            hint: 'Enter the discount code to search for',
          ),
        ],
      };
}
