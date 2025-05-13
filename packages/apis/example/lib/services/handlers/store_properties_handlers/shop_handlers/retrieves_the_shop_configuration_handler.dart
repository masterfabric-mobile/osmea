import 'package:apis/apis.dart';
import 'package:apis/network/remote/store_properties/shop/abstract/shop_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';

import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 🏬 RETRIEVE SHOP CONFIGURATION ***************
///**************************************************************

class RetrievesShopConfigurationHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only GET is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    final fields = params['fields'];

    try {
      final response = await GetIt.I<ShopService>().retrieveShopConfiguration(
        apiVersion: ApiNetwork.apiVersion,
        fields: fields,
      );

      return {
        "status": "success",
        "data": response.toJson(),
        "params": {
          "fields": fields,
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        "status": "error",
        "message": "Failed to retrieve shop configuration: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'fields',
            label: 'Fields',
            hint:
                'Comma-separated list of fields to include (e.g. id,name,email)',
            isRequired: false,
          ),
        ],
      };
}
