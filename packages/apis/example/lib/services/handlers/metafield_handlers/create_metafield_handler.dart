import 'package:apis/apis.dart';
import 'package:apis/network/remote/metafield/abstract/metafield_service.dart';
import 'package:apis/network/remote/metafield/freezed_model/request/create_metafield_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';
import 'dart:convert';

///*******************************************************************
///************** 🏷️ CREATE METAFIELD HANDLER 🏷️ ****************
///*******************************************************************

class CreateMetafieldHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle POST requests for creating metafields
    if (method == 'POST') {
      // 🔍 Check if required parameters are provided
      final ownerId = params['owner_id'] ?? '';
      final ownerResource = params['owner_resource'] ?? '';
      final key = params['key'] ?? '';
      final namespace = params['namespace'] ?? '';
      final valueType = params['value_type'] ?? '';
      final value = params['value'] ?? '';

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

      if (key.isEmpty) {
        return {
          "status": "error",
          "message": "Key is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      if (namespace.isEmpty) {
        return {
          "status": "error",
          "message": "Namespace is required",
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

      const validValueTypes = {
        'single_line_text_field',
        'multi_line_text_field',
        'number_integer',
        'number_decimal',
        'boolean',
        'date',
        'date_time',
        'json',
        'url',
        'color',
        'weight',
        'volume',
        'dimension',
        'rating',
        'money'
      };
      if (!validValueTypes.contains(valueType)) {
        return {
          "status": "error",
          "message":
              "Invalid value_type provided. Must be one of: ${validValueTypes.join(', ')}",
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

      // Format the value based on type to match Shopify's expected format
      String formattedValue = value;

      try {
        if (valueType == 'number_integer') {
          // Ensure it's a valid integer
          int.parse(value);
        } else if (valueType == 'number_decimal') {
          // Ensure it's a valid decimal
          double.parse(value);
        } else if (valueType == 'boolean') {
          // Convert string "true"/"false" to boolean value
          formattedValue = value.toLowerCase() == 'true' ? 'true' : 'false';
        } else if (valueType == 'json') {
          // Validate JSON format
          json.decode(value);
          formattedValue = value;
        }
      } catch (e) {
        return {
          "status": "error",
          "message":
              "Value format doesn't match the specified type '$valueType'",
          "details": "The value '$value' is not valid for type '$valueType'",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      try {
        // 🔄 Create request model for creating a metafield
        final request = CreateMetafieldRequest(
          metafield: Metafield(
            namespace: namespace,
            key: key,
            type: valueType,
            // Properly escape the value using JSON encoding, as Shopify expects a quoted string for text fields.
            value: (valueType == 'single_line_text_field' || valueType == 'multi_line_text_field')
                ? jsonEncode(value)
                : formattedValue,
          ),
        );

        // 📞 Call the metafield service API to create the metafield
        final response = await GetIt.I.get<MetafieldService>().createMetafield(
              apiVersion: ApiNetwork.apiVersion,
              ownerResource: ownerResource,
              ownerId: ownerId.toString(),
              model: request,
            );

        // 📋 Return the metafield data
        return {
          "status": "success",
          "metafield": response.toJson(),
          "message": "Metafield successfully created",
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
            "message": "Owner resource not found",
            "ownerId": ownerId,
            "ownerResource": ownerResource,
            "details":
                "The specified owner resource with the given ID does not exist.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        } else if (errorMessage.contains('422')) {
          statusCode = 422;
          return {
            "status": "error",
            "statusCode": 422,
            "message": "The request was well-formed but contains invalid data.",
            "details":
                "Check that the value_type matches the format of the value provided.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        } else if (errorMessage.contains('406')) {
          statusCode = 406;

          // Check for common formatting issues based on value type
          String detailedError = "The server rejected the request format.";

          if (valueType == 'single_line_text_field' ||
              valueType == 'multi_line_text_field') {
            detailedError =
                "Text field values must be properly escaped strings.";
          } else if (valueType == 'number_integer') {
            detailedError =
                "Integer values must be valid numbers without decimals.";
          } else if (valueType == 'json') {
            detailedError =
                "JSON values must be valid, properly formatted JSON strings.";
          }

          // Check for URLs with double 'admin'
          if (errorMessage.contains("/admin/admin/")) {
            detailedError +=
                " Additionally, there appears to be a URL formatting issue with duplicate 'admin' in the path.";
          }

          return {
            "status": "error",
            "statusCode": 406,
            "message":
                "Not Acceptable - The server rejected the metafield format",
            "details": detailedError,
            "requestDetails": {
              "ownerResource": ownerResource,
              "ownerId": ownerId,
              "namespace": namespace,
              "key": key,
              "valueType": valueType,
              "value": value
            },
            "troubleshooting": [
              "Verify that Shopify supports this metafield type for $ownerResource",
              "Check your API access scopes include metafield permissions",
              "Try a simpler value format first to test the connection",
              "Review Shopify's metafield documentation for proper formatting"
            ],
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // Default error response
        return {
          "status": "error",
          "statusCode": statusCode,
          "message": "Failed to create metafield: $errorMessage",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error": "Method $method not supported for Create Metafield API",
    };
  }

  @override
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(
            name: 'owner_id',
            label: 'Owner ID',
            hint: 'ID of the resource that owns this metafield',
          ),
          const ApiField(
            name: 'owner_resource',
            label: 'Owner Resource',
            hint: 'Type of resource (product, collection, etc.)',
          ),
          const ApiField(
            name: 'namespace',
            label: 'Namespace',
            hint: 'Namespace for the metafield',
          ),
          const ApiField(
            name: 'key',
            label: 'Key',
            hint: 'Key name for the metafield',
          ),
          const ApiField(
            name: 'value_type',
            label: 'Value Type',
            hint: 'Data type (single_line_text_field, number_integer, etc.)',
          ),
          const ApiField(
            name: 'value',
            label: 'Value',
            hint: 'The value to store in the metafield',
          ),
        ],
      };
}
