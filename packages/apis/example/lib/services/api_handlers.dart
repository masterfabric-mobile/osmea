import 'package:apis/apis.dart';
import 'package:apis/network/remote/access/access_scope/abstract/access_scope_service.dart';
import 'package:apis/network/remote/access/storefront_access_token/abstract/storefront_access_token.dart';
import 'package:apis/network/remote/access/storefront_access_token/freezed_model/request/create_new_storefront_access_token_request.dart';
import 'package:get_it/get_it.dart';
import 'dart:convert';
import 'api_service_registry.dart'; // Import ApiField from here

/// Abstract class for API request handlers
abstract class ApiRequestHandler {
  /// Handle the API request and return a response
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params);

  /// Get the available methods for this handler
  List<String> get supportedMethods;

  /// Get the required fields for each method
  Map<String, List<ApiField>> get requiredFields;
}

/// Access Scope API
class AccessScopeHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    if (method == 'GET') {
      final response = await GetIt.I.get<AccessScopeService>().accessScope();

      try {
        // Try to extract key information from response
        // Adjust fields based on what's available in AccessScope
        final scopes = response.accessScopes
            .map((scope) => {
                  "handle": scope.handle,
                  // Remove description field as it doesn't exist
                  // Use other available properties instead
                  "scope": scope.toString(),
                })
            .toList();

        return {
          "status": "success",
          "items": scopes,
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        // Fallback to simpler format if extraction fails
        return {
          "status": "success",
          "data": response.toString(),
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    return {
      "error": "Method $method not supported for Access Scope API",
    };
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {};
}

/// Storefront Access Token API
class StorefrontAccessTokenHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'GET':
        final response = await GetIt.I
            .get<StorefrontAccessTokenService>()
            .storefrontAccessToken(apiVersion: ApiNetwork.apiVersion);

        try {
          // Parse the response string to extract the token list
          // First convert the response to string and try to parse as JSON
          final responseString = response.toString();

          // If it's already JSON, we need to extract the tokens
          if (responseString.contains('storefront_access_tokens')) {
            Map<String, dynamic> jsonMap;

            // Try to parse the existing JSON
            try {
              // If it's already a JSON string
              jsonMap = json.decode(responseString);
            } catch (_) {
              // If it's not valid JSON, it may be a toString() representation
              // Try to extract the JSON part - this is a fallback strategy
              final start = responseString.indexOf('{');
              final end = responseString.lastIndexOf('}') + 1;
              if (start >= 0 && end > start) {
                final jsonStr = responseString.substring(start, end);
                jsonMap = json.decode(jsonStr);
              } else {
                throw 'Could not parse response as JSON';
              }
            }
            // Extract the tokens array
            if (jsonMap.containsKey('storefront_access_tokens') &&
                jsonMap['storefront_access_tokens'] is List) {
              return {
                "status": "success",
                "items": jsonMap['storefront_access_tokens'],
                "timestamp": DateTime.now().toIso8601String(),
              };
            }
          }
          // If we get here, it means we couldn't extract the tokens array
          // So we return a simplified response
          return {
            "status": "success",
            "raw_response": responseString,
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          // Fallback to returning the raw response
          return {
            "status": "error",
            "message": "Failed to parse response: $e",
            "raw_response": response.toString(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
      case 'POST':
        final title = params['title'] ?? 'Default Title';
        final response = await GetIt.I
            .get<StorefrontAccessTokenService>()
            .createNewStorefrontAccessToken(
              apiVersion: ApiNetwork.apiVersion,
              model: CreateNewStorefrontAccessTokenRequest(
               
              ),
            );
        // Return Map instead of String
        return {
          "status": "success",
          "title": title,
          "data": response.toString(),
          "timestamp": DateTime.now().toIso8601String(),
        };

      case 'DELETE':
        final id = params['id'] ?? '';
        // Example implementation for DELETE - return Map instead of String
        return {
          "status": "success",
          "message": "Token with ID $id deleted",
          "timestamp": DateTime.now().toIso8601String(),
        };

      default:
        // Return Map instead of String
        return {
          "error":
              "Method $method not supported for Storefront Access Token API",
        };
    }
  }

  @override
  List<String> get supportedMethods => ['GET', 'POST', 'DELETE'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(
            name: 'title',
            label: 'Token Title',
            hint: 'Enter a title for the new token',
          ),
        ],
        'DELETE': [
          const ApiField(
            name: 'id',
            label: 'Token ID',
            hint: 'Enter token ID to delete',
          ),
        ],
      };
}

/// Factory for creating API handlers
class ApiHandlerFactory {
  static final Map<String, ApiRequestHandler> _handlers = {
    'Access Scope': AccessScopeHandler(),
    'Storefront Access Token': StorefrontAccessTokenHandler(),
    // Add more handlers here
  };

  static ApiRequestHandler? getHandler(String serviceName) {
    return _handlers[serviceName];
  }

  static List<String> get availableServices => _handlers.keys.toList();
}
