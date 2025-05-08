import 'package:apis/apis.dart';
import 'package:apis/network/remote/metafield/abstract/metafield_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
///************** 📋 LIST METAFIELDS BY QUERY PARAMETERS HANDLER 📋 *
///*******************************************************************

class ListMetafieldsQueryParametersHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle GET requests for listing metafields by query params
    if (method == 'GET') {
      try {
        // 📞 Call the metafield service API to list metafields by query params
        final response = await GetIt.I
            .get<MetafieldService>()
            .listMetafieldsByQueryParameters(
              apiVersion: ApiNetwork.apiVersion,
              metafieldOwnerId: params['metafield_owner_id'],
              metafieldOwnerResource: params['metafield_owner_resource'],
            );

        // 📋 Return the metafields data directly without field filtering
        return {
          "status": "success",
          "metafields": response.toJson(),
          "count": response.metafields?.length ?? 0,
          "message": "Metafields by query parameters successfully retrieved",
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        // ❌ Enhanced error handling
        String errorMessage = e.toString();
        int statusCode = 500;

        // Check for specific error types
        if (errorMessage.contains('404')) {
          statusCode = 404;
          return {
            "status": "error",
            "statusCode": 404,
            "message": "Resource not found",
            "details": "The specified resource does not exist.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        } else if (errorMessage.contains('403')) {
          statusCode = 403;
          return {
            "status": "error",
            "statusCode": 403,
            "message": "Access denied",
            "details":
                "Your API credentials don't have permission to access these metafields.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // Default error response
        return {
          "status": "error",
          "statusCode": statusCode,
          "message":
              "Failed to retrieve metafields by query parameters: $errorMessage",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error":
          "Method $method not supported for List Metafields By Query Parameters API",
    };
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'metafield_owner_id',
            label: 'Metafield Owner ID',
            hint: 'ID of the resource that owns the metafields',
          ),
          const ApiField(
            name: 'metafield_owner_resource',
            label: 'Metafield Owner Resource',
            hint: 'Type of resource (product, collection, etc.)',
          ),
        ],
      };
}
