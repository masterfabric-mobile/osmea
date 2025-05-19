import 'package:apis/apis.dart';
import 'package:apis/network/remote/metafield/abstract/metafield_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
///************** 🧮 COUNT METAFIELDS HANDLER 🧮 ******************
///*******************************************************************

class CountMetafieldHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle GET requests for counting metafields
    if (method == 'GET') {
      // 🔍 Check if required parameters are provided
      final ownerId = params['owner_id'] ?? '';
      final ownerResource = params['owner_resource'] ?? '';

      // Validate required parameters
      if (ownerId.isEmpty) {
        return {
          "status": "error",
          "message": "Owner ID is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      if (ownerResource.isEmpty) {
        return {
          "status": "error",
          "message": "Owner resource is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      try {
        // 📞 Call the metafield service API to count metafields
        final response = await GetIt.I.get<MetafieldService>().countMetafields(
              apiVersion: ApiNetwork.apiVersion,
              ownerResource: ownerResource,
              ownerId: ownerId,
            );

        // Extract count from response (Shopify returns {"count": 3})
        return {
          "count": response,
        };
      } catch (e) {
        // ❌ Simple error handling like customer count handler
        return {
          "error": "Failed to count metafields: ${e.toString()}",
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error": "Method $method not supported for Count Metafields API",
    };
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'owner_id',
            label: 'Owner ID',
            hint: 'ID of the resource to count metafields for',
          ),
          const ApiField(
            name: 'owner_resource',
            label: 'Owner Resource',
            hint: 'Type of resource (product, collection, etc.)',
          ),
        ],
      };
}
