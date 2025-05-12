import 'package:apis/apis.dart';
import 'package:apis/network/remote/store_properties/policy/abstract/shop_policy_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///****************** 📜 GET SHOP POLICIES **********************
///**************************************************************

class RetrievesShopPoliciesHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'GET') {
      return {
        'status': 'error',
        'message': 'Method $method not supported. Only GET is allowed.',
        'timestamp': DateTime.now().toIso8601String(),
      };
    }

    try {
      final response = await GetIt.I<ShopPolicyService>()
          .retrieveListOfShopPolicies(apiVersion: ApiNetwork.apiVersion);

      return {
        'status': 'success',
        'message': 'Shop policies retrieved successfully.',
        'policies': response.toJson(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Failed to retrieve shop policies: ${e.toString()}',
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [],
      };
}
