import 'package:apis/apis.dart';
import 'package:apis/network/remote/metafield/abstract/metafield_service.dart';
import 'package:apis/network/remote/metafield/freezed_model/request/update_metafield_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
///************** 🔄 UPDATE METAFIELD HANDLER 🔄 ******************
///*******************************************************************

class UpdateMetafieldHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle PUT requests for updating metafields
    if (method == 'PUT') {
      // 🔍 Check if required parameters are provided
      final ownerId = params['owner_id'] ?? '';
      final ownerResource = params['owner_resource'] ?? '';
      final metafieldId = params['metafield_id'] ?? '';
      final value = params['value'] ?? '';
      final valueType = params['value_type'] ?? '';

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

      if (value.isEmpty) {
        return {
          "status": "error",
          "message": "Value is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      if (valueType.isEmpty) {
        return {
          "status": "error",
          "message": "Value type is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      try {
        // 🔄 Create request model for updating a metafield
        final request = UpdateMetafieldRequest(
          metafield: Metafield(
            id: int.tryParse(metafieldId),
            value: value,
            type: valueType, // No longer checking if empty since it's required
          ),
        );

        // 📞 Call the metafield service API to update the metafield
        final response = await GetIt.I.get<MetafieldService>().updateMetafield(
              apiVersion: ApiNetwork.apiVersion,
              ownerResource: ownerResource,
              ownerId: ownerId,
              metafieldId: metafieldId,
              model: request,
            );

        // 📋 Return the updated metafield data
        return {
          "status": "success",
          "metafield": response.toJson(),
          "message": "Metafield successfully updated",
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
        } else if (errorMessage.contains('422')) {
          statusCode = 422;
          return {
            "status": "error",
            "statusCode": 422,
            "message": "The request was well-formed but contains invalid data.",
            "details":
                "Check that the value type matches the format of the value provided.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // Default error response
        return {
          "status": "error",
          "statusCode": statusCode,
          "message": "Failed to update metafield: $errorMessage",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error": "Method $method not supported for Update Metafield API",
    };
  }

  @override
  List<String> get supportedMethods => ['PUT'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'PUT': [
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
            hint: 'ID of the metafield to update',
          ),
          const ApiField(
            name: 'value',
            label: 'Value',
            hint: 'The new value to update the metafield with',
          ),
          const ApiField(
            name: 'value_type',
            label: 'Value Type (Optional)',
            hint: 'Data type if changing the value type',
          ),
        ],
      };
}
