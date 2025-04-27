import 'package:apis/apis.dart';
import 'package:apis/network/remote/access/storefront_access_token/abstract/storefront_access_token.dart';
import 'package:apis/network/remote/access/storefront_access_token/freezed_model/request/create_new_storefront_access_token_request.dart';
import 'dart:convert';
import 'package:get_it/get_it.dart';
import '../../api_service_registry.dart';
import '../../api_request_handler.dart';

///*******************************************************************
///*************** 🔑 STOREFRONT ACCESS TOKEN API 🔑 ****************
///*******************************************************************

class StorefrontAccessTokenHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'GET':
        return await _handleGetRequest(params);
      case 'POST':
        return await _handlePostRequest(params);
      case 'DELETE':
        return await _handleDeleteRequest(params);
      default:
        // ⚠️ Return error for unsupported methods
        return {
          "status": "error",
          "message":
              "Method $method not supported for Storefront Access Token API. Use GET, POST, or DELETE.",
          "timestamp": DateTime.now().toIso8601String(),
        };
    }
  }

  // 📋 Handle GET request to retrieve all tokens
  Future<Map<String, dynamic>> _handleGetRequest(
      Map<String, String> params) async {
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
            "totalTokens": tokens.length,
            "responseData": jsonMap,
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
      // ❌ Enhanced error handling
      String errorMessage = e.toString();
      int statusCode = 500;

      // Extract status code if available
      if (errorMessage.contains("status code of")) {
        final regex = RegExp(r"status code of (\d+)");
        final match = regex.firstMatch(errorMessage);
        if (match != null) {
          statusCode = int.tryParse(match.group(1) ?? "500") ?? 500;
        }
      }

      // Provide troubleshooting info based on status code
      String troubleshootingTip = "";
      if (statusCode == 403) {
        troubleshootingTip = "This may be due to insufficient permissions. "
            "Ensure your Shopify API credentials have proper access to storefront tokens.";
      } else if (statusCode == 401) {
        troubleshootingTip =
            "Authentication failed. Check your API credentials and make sure they're valid.";
      }

      return {
        "status": "error",
        "message": "Failed to retrieve tokens: $errorMessage",
        "statusCode": statusCode,
        "troubleshooting": troubleshootingTip,
        "requestDetails": {
          "method": "GET",
          "apiVersion": ApiNetwork.apiVersion,
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  // 🆕 Handle POST request to create a new token
  Future<Map<String, dynamic>> _handlePostRequest(
      Map<String, String> params) async {
    final title = params['title'] ?? 'Default Title';
    try {
      final response = await GetIt.I
          .get<StorefrontAccessTokenService>()
          .createNewStorefrontAccessToken(
            apiVersion: ApiNetwork.apiVersion,
            model: CreateNewStorefrontAccessTokenRequest(
              storefrontAccessToken: CreateNewStorefrontAccessTokenRequestBody(
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
          "responseData": jsonMap,
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (_) {
        // 🚨 Fall back to standard response if parsing fails
        return {
          "status": "success",
          "title": title,
          "responseData": response.toString(),
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    } catch (e) {
      // ❌ Enhanced error handling
      String errorMessage = e.toString();
      int statusCode = 500;

      // Extract status code if available
      if (errorMessage.contains("status code of")) {
        final regex = RegExp(r"status code of (\d+)");
        final match = regex.firstMatch(errorMessage);
        if (match != null) {
          statusCode = int.tryParse(match.group(1) ?? "500") ?? 500;
        }
      }

      // Provide troubleshooting info based on status code
      String troubleshootingTip = "";
      if (statusCode == 422) {
        troubleshootingTip =
            "The request was rejected due to validation errors. "
            "Check if a token with this title already exists or if the title format is invalid.";
      } else if (statusCode == 403) {
        troubleshootingTip =
            "You don't have permission to create storefront access tokens. "
            "Check your API credentials and scope.";
      }

      return {
        "status": "error",
        "message": "Failed to create token: $errorMessage",
        "statusCode": statusCode,
        "troubleshooting": troubleshootingTip,
        "requestDetails": {
          "method": "POST",
          "title": title,
          "apiVersion": ApiNetwork.apiVersion,
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  // 🗑️ Handle DELETE request to remove a token
  Future<Map<String, dynamic>> _handleDeleteRequest(
      Map<String, String> params) async {
    final id = params['id'] ?? '';
    if (id.isEmpty) {
      return {
        "status": "error",
        "message": "Token ID is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // 🔗 Construct the API URL for reference
      final apiUrl =
          '${ApiNetwork.baseUrl}/admin/api/${ApiNetwork.apiVersion}/storefront_access_tokens/$id.json';

      // 🗑️ Attempt to delete the token
      await GetIt.I
          .get<StorefrontAccessTokenService>()
          .deleteStorefrontAccessToken(
            apiVersion: ApiNetwork.apiVersion,
            storefrontAccessTokenId: id,
          );

      return {
        "status": "success",
        "message": "Token with ID $id has been deleted",
        "url": apiUrl,
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Enhanced error handling
      String errorMessage = e.toString();
      int statusCode = 500;

      // Extract status code if available
      if (errorMessage.contains("status code of")) {
        final regex = RegExp(r"status code of (\d+)");
        final match = regex.firstMatch(errorMessage);
        if (match != null) {
          statusCode = int.tryParse(match.group(1) ?? "500") ?? 500;
        }
      }

      // 🔗 Construct the API URL for debugging
      final apiUrl =
          '${ApiNetwork.baseUrl}/admin/api/${ApiNetwork.apiVersion}/storefront_access_tokens/$id.json';

      // 🔍 Special handling for common delete errors
      if (statusCode == 404 || errorMessage.contains('404')) {
        return {
          "status": "warning",
          "message":
              "Token with ID $id was not found. It may have already been deleted or never existed.",
          "url": apiUrl,
          "statusCode": 404,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      // ✅ Check for "Unexpected null value" error which may indicate successful deletion
      if (errorMessage.contains('Unexpected null value')) {
        return {
          "status": "success",
          "message":
              "Token with ID $id was likely deleted successfully (server returned empty response).",
          "url": apiUrl,
          "note":
              "The API returned an empty response, which is normal for successful DELETE operations.",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      // Provide troubleshooting tips based on status code
      String troubleshootingTip = "";
      if (statusCode == 403) {
        troubleshootingTip = "You don't have permission to delete this token. "
            "Check your API credentials and scope.";
      }

      // ⚠️ Return other error types with standard format
      return {
        "status": "error",
        "message": "Failed to delete token: $errorMessage",
        "statusCode": statusCode,
        "troubleshooting": troubleshootingTip,
        "url": apiUrl,
        "requestDetails": {
          "method": "DELETE",
          "tokenId": id,
          "apiVersion": ApiNetwork.apiVersion,
        },
        "timestamp": DateTime.now().toIso8601String(),
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
