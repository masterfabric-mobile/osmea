import 'package:apis/apis.dart';
import 'package:apis/network/remote/metafield/abstract/metafield_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
///************** 🗑️ DELETE METAFIELD HANDLER 🗑️ ******************
///*******************************************************************

class DeleteMetafieldHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle DELETE requests for removing metafields
    if (method == 'DELETE') {
      // 🔍 Check if required parameters are provided
      final ownerId = params['owner_id'] ?? '';
      final ownerResource = params['owner_resource'] ?? '';
      final metafieldId = params['metafield_id'] ?? '';

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

      if (metafieldId.isEmpty) {
        return {
          "status": "error",
          "message": "Metafield ID is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      try {
        // 📞 Call the metafield service API to delete the metafield
        await GetIt.I.get<MetafieldService>().deleteMetafield(
              apiVersion: ApiNetwork.apiVersion,
              ownerResource: ownerResource,
              ownerId: ownerId,
              metafieldId: metafieldId,
            );

        // 📋 Return success response
        return {
          "status": "success",
          "message": "Metafield successfully deleted",
          "metafieldId": metafieldId,
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
            "message": "Metafield not found",
            "metafieldId": metafieldId,
            "ownerId": ownerId,
            "ownerResource": ownerResource,
            "details":
                "The specified metafield does not exist for this resource.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        } else if (errorMessage.contains('403')) {
          statusCode = 403;
          return {
            "status": "error",
            "statusCode": 403,
            "message": "Access denied",
            "details":
                "Your API credentials don't have permission to delete this metafield.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // Default error response
        return {
          "status": "error",
          "statusCode": statusCode,
          "message": "Failed to delete metafield: $errorMessage",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error": "Method $method not supported for Delete Metafield API",
    };
  }

  @override
  List<String> get supportedMethods => ['DELETE'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'DELETE': [
          const ApiField(
            name: 'owner_id',
            label: 'Owner ID',
            hint: 'ID of the resource that owns the metafield',
          ),
          const ApiField(
            name: 'owner_resource',
            label: 'Owner Resource',
            hint: 'Type of resource (product, collection, etc.)',
          ),
          const ApiField(
            name: 'metafield_id',
            label: 'Metafield ID',
            hint: 'ID of the metafield to delete',
          ),
        ],
      };
}
