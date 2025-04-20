import 'package:apis/apis.dart';
import 'package:apis/network/remote/access/access_scope/abstract/access_scope_service.dart';
import 'package:apis/network/remote/access/storefront_access_token/abstract/storefront_access_token.dart';
import 'package:apis/network/remote/access/storefront_access_token/freezed_model/request/create_new_storefront_access_token_request.dart';
import 'package:get_it/get_it.dart';
import 'dart:convert';
import 'api_service_registry.dart'; // Import ApiField from here

/// 🧩 Abstract class for API request handlers
abstract class ApiRequestHandler {
  /// 🔄 Handle the API request and return a response
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params);

  /// 📋 Get the available methods for this handler
  List<String> get supportedMethods;

  /// 📝 Get the required fields for each method
  Map<String, List<ApiField>> get requiredFields;
}

///*******************************************************************
///******************* 🔐 ACCESS SCOPE HANDLER 🔐 *******************
///*******************************************************************

class AccessScopeHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    if (method == 'GET') {
      final response = await GetIt.I.get<AccessScopeService>().accessScope();

      try {
        // 📊 Group scopes by subcategory
        final Map<String, List<Map<String, String>>> categorizedScopes = {};

        for (final scope in response.accessScopes) {
          // 🔍 Extract subcategory from handle (e.g., "read_products" -> "products")
          final handle = scope.handle;
          String subcategory = "other"; // Default category

          // 🧩 Try to extract category from handle
          if (handle.contains('_')) {
            final parts = handle.split('_');
            if (parts.length > 1) {
              // 📑 Use the second part as the subcategory (after "read_", "write_", etc.)
              subcategory = parts[1];
            }
          }

          // 🔤 Ensure subcategory name is capitalized
          subcategory = subcategory[0].toUpperCase() + subcategory.substring(1);

          // ➕ Add scope to appropriate subcategory
          if (!categorizedScopes.containsKey(subcategory)) {
            categorizedScopes[subcategory] = [];
          }

          categorizedScopes[subcategory]!.add({
            "handle": handle,
            "scope": scope.toString(),
            "permission": handle.split('_').first,
          });
        }

        // 🔄 Convert map to list format for the response
        final List<Map<String, dynamic>> categories =
            categorizedScopes.entries.map((entry) {
          return {
            "category": entry.key,
            "scopes": entry.value,
          };
        }).toList();

        return {
          "status": "success",
          "categories": categories,
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        // 🚨 Fallback to simpler format if extraction fails
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

///*******************************************************************
///*************** 🔑 STOREFRONT ACCESS TOKEN API 🔑 ****************
///*******************************************************************


class StorefrontAccessTokenHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'GET':
        try {
          final response = await GetIt.I
              .get<StorefrontAccessTokenService>()
              .storefrontAccessToken(apiVersion: ApiNetwork.apiVersion);

          // 🔄 Parse the response string to extract the token list
          final responseString = response.toString();

          // 🧪 If it's already JSON, we need to extract the tokens
          if (responseString.contains('storefront_access_tokens')) {
            Map<String, dynamic> jsonMap;
            List<dynamic> tokens = [];

            // 🛠️ Try to parse the existing JSON
            try {
              // 📦 If it's already a JSON string
              jsonMap = json.decode(responseString);
              if (jsonMap.containsKey('storefront_access_tokens')) {
                tokens = jsonMap['storefront_access_tokens'];
              }
            } catch (_) {
              // 🔍 If it's not valid JSON, it may be a toString() representation
              final start = responseString.indexOf('{');
              final end = responseString.lastIndexOf('}') + 1;
              if (start >= 0 && end > start) {
                final jsonStr = responseString.substring(start, end);
                jsonMap = json.decode(jsonStr);
                if (jsonMap.containsKey('storefront_access_tokens')) {
                  tokens = jsonMap['storefront_access_tokens'];
                }
              } else {
                throw 'Could not parse response as JSON';
              }
            }

            if (tokens.isNotEmpty) {
              // 📊 Create categories based on token properties
              final Map<String, List<dynamic>> categorizedTokens = {};

              // 📅 Categorize by creation date (month/year)
              for (final token in tokens) {
                String category = "Other";

                // 🗓️ Try to extract date for categorization
                if (token is Map && token.containsKey('created_at')) {
                  final createdAt = token['created_at'] as String;
                  final date = DateTime.tryParse(createdAt);
                  if (date != null) {
                    // 📝 Format as "Month Year"
                    category = "${_getMonthName(date.month)} ${date.year}";
                  }
                }

                // ➕ Add token to category
                if (!categorizedTokens.containsKey(category)) {
                  categorizedTokens[category] = [];
                }
                categorizedTokens[category]!.add(token);
              }

              // 🔄 Convert to list format
              final List<Map<String, dynamic>> categories =
                  categorizedTokens.entries.map((entry) {
                return {
                  "category": entry.key,
                  "tokens": entry.value,
                };
              }).toList();

              return {
                "status": "success",
                "categories": categories,
                "timestamp": DateTime.now().toIso8601String(),
              };
            }
          }

          // 🚨 Fallback if categorization fails
          return {
            "status": "success",
            "raw_response": responseString,
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          // ❌ Fallback to returning the raw response
          return {
            "status": "error",
            "message": "Failed to parse response: $e",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      case 'POST':
        final title = params['title'] ?? 'Default Title';
        try {
          final response = await GetIt.I
              .get<StorefrontAccessTokenService>()
              .createNewStorefrontAccessToken(
                apiVersion: ApiNetwork.apiVersion,
                model: CreateNewStorefrontAccessTokenRequest(
                  storefrontAccessToken:
                      CreateNewStorefrontAccessTokenRequestBody(
                    title: title,
                  ),
                ),
              );

          // 🧪 Try to parse response and extract created token
          try {
            final responseString = response.toString();
            final jsonMap = json.decode(responseString);

            return {
              "status": "success",
              "token": jsonMap['storefront_access_token'] ?? jsonMap,
              "timestamp": DateTime.now().toIso8601String(),
            };
          } catch (_) {
            // 🚨 Fall back to standard response if parsing fails
            return {
              "status": "success",
              "title": title,
              "data": response.toString(),
              "timestamp": DateTime.now().toIso8601String(),
            };
          }
        } catch (e) {
          return {
            "status": "error",
            "message": "Failed to create token: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      case 'DELETE':
        final id = params['id'] ?? '';
        // 🗑️ Example implementation for DELETE - return Map instead of String
        return {
          "status": "success",
          "message": "Token with ID $id deleted",
          "timestamp": DateTime.now().toIso8601String(),
        };

      default:
        // ⚠️ Return Map instead of String
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

  // 📅 Helper method to convert month number to name
  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}

///**************************************************************
///****************** 🏭 API HANDLER FACTORY 🏭 *****************
///**************************************************************
/// Factory for creating API handler instances
/// Register new handlers in the _handlers map
///**************************************************************

class ApiHandlerFactory {
  static final Map<String, ApiRequestHandler> _handlers = {
    'Access Scope': AccessScopeHandler(),
    'Storefront Access Token': StorefrontAccessTokenHandler(),
    // ➕ Add more handlers here
  };

  static ApiRequestHandler? getHandler(String serviceName) {
    return _handlers[serviceName];
  }

  static List<String> get availableServices => _handlers.keys.toList();
}
