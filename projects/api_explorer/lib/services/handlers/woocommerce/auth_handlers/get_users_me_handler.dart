import 'package:api_explorer/services/api_request_handler.dart';
import 'package:api_explorer/services/api_service_registry.dart';
import 'package:apis/models/auth/woo_jwt_token.dart';
import 'package:apis/network/remote/woocommerce/auth/abstract/woo_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
///********************** 👤 GET USERS ME HANDLER ******************
///*******************************************************************

class GetUsersMeHandler implements ApiRequestHandler {
  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          // No required fields - uses stored JWT token automatically
        ],
      };

  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported for Get Users Me API",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      debugPrint('👤 Getting WordPress authenticated user information...');
      debugPrint('🔐 Checking stored JWT token...');
      
      // Check if JWT token exists
      final hasToken = await WooJwtTokenStorage.hasToken();
      if (!hasToken) {
        debugPrint('❌ No JWT token found in storage');
        return {
          "status": "error",
          "message": "No JWT token found. Please login first.",
          "error_details": {
            "type": "authentication_error",
            "suggestion": "Please login first using the 'User Login' endpoint to get a JWT token",
            "how_to_login": "Use the 'User Login' endpoint in the auth section to get JWT token",
            "auth_source": "local_storage"
          },
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      // Check if token is expired
      final isExpired = await WooJwtTokenStorage.isTokenExpired();
      if (isExpired) {
        debugPrint('❌ JWT token is expired');
        return {
          "status": "error",
          "message": "JWT token is expired. Please login again.",
          "error_details": {
            "type": "authentication_error",
            "suggestion": "Please login again to get a fresh JWT token",
            "how_to_login": "Use the 'User Login' endpoint in the auth section to get fresh JWT token",
            "auth_source": "local_storage"
          },
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      // Load the JWT token
      final jwtToken = await WooJwtTokenStorage.loadToken();
      if (jwtToken?.accessToken == null || jwtToken!.accessToken.isEmpty) {
        debugPrint('❌ JWT token is null or empty');
        return {
          "status": "error",
          "message": "Invalid JWT token. Please login again.",
          "error_details": {
            "type": "authentication_error",
            "suggestion": "Please login again to get a valid JWT token",
            "auth_source": "local_storage"
          },
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      debugPrint('✅ Valid JWT token found, making API request...');
      debugPrint('🔐 Token preview: ${jwtToken.accessToken.substring(0, 20)}...');

      // Get WooAuthService and make the request
      final authService = GetIt.I<WooAuthService>();
      final authHeader = 'Bearer ${jwtToken.accessToken}';
      
      debugPrint('📡 Making getUsersMe request with Authorization: Bearer [TOKEN]');
      final userResponse = await authService.getUsersMe(authHeader);
      
      debugPrint('✅ WordPress user information retrieved successfully');
      debugPrint('👤 User: ${userResponse.name} (ID: ${userResponse.id})');
      
      return {
        "status": "success",
        "message": "WordPress authenticated user information retrieved using stored JWT token",
        "endpoint_used": "/wp-json/wp/v2/users/me",
        "authentication": "Bearer JWT Token from Local Storage",
        "user_data": userResponse.toJson(),
        "user_summary": {
          "id": userResponse.id,
          "name": userResponse.name,
          "url": userResponse.url,
          "description": userResponse.description,
          "slug": userResponse.slug,
          "is_super_admin": userResponse.isSuperAdmin,
          "avatar_urls": userResponse.avatarUrls?.toJson(),
          "woocommerce_meta": userResponse.woocommerceMeta != null ? {
            "homepage_layout": userResponse.woocommerceMeta?.homepageLayout,
            "dashboard_chart_type": userResponse.woocommerceMeta?.dashboardChartType,
            "activity_panel_inbox_last_read": userResponse.woocommerceMeta?.activityPanelInboxLastRead,
            "variable_product_tour_shown": userResponse.woocommerceMeta?.variableProductTourShown,
            "dashboard_sections": userResponse.woocommerceMeta?.dashboardSections,
          } : null,
        },
        "auth_source": "jwt_local_storage",
        "token_info": {
          "has_token": hasToken,
          "is_expired": isExpired,
          "expires_at": jwtToken.issuedAt.add(Duration(seconds: jwtToken.expiresIn)).toIso8601String(),
          "user_info": jwtToken.userData != null ? {
            "id": jwtToken.userData!["id"],
            "email": jwtToken.userData!["email"],
            "display_name": jwtToken.userData!["display_name"] ?? jwtToken.userData!["name"],
          } : null,
        },
        "timestamp": DateTime.now().toIso8601String(),
      };

    } catch (e) {
      debugPrint('❌ WordPress user fetch error: $e');

      String errorMessage = "Failed to get WordPress user information";
      Map<String, dynamic> errorDetails = {"type": "unknown_error"};

      // Handle specific error types
      if (e.toString().contains('401')) {
        errorMessage = "Authentication failed - JWT token invalid or expired";
        errorDetails = {
          "type": "authentication_error",
          "status_code": 401,
          "suggestion": "Please login again to get a fresh JWT token",
          "curl_example": "curl -X GET '{{base_url}}/wp-json/wp/v2/users/me' -H 'Authorization: Bearer YOUR_JWT_TOKEN'"
        };
      } else if (e.toString().contains('403')) {
        errorMessage = "Access forbidden - insufficient permissions";
        errorDetails = {
          "type": "permission_error", 
          "status_code": 403,
          "suggestion": "Check user roles and permissions in WordPress"
        };
      } else if (e.toString().contains('404')) {
        errorMessage = "WordPress REST API endpoint not found";
        errorDetails = {
          "type": "endpoint_error",
          "status_code": 404,
          "suggestion": "Check if WordPress REST API is enabled and endpoint exists"
        };
      } else if (e.toString().contains('DioException') || e.toString().contains('SocketException')) {
        errorMessage = "Network connection error";
        errorDetails = {
          "type": "network_error",
          "suggestion": "Check your internet connection and base URL configuration"
        };
      } else if (e.toString().contains('not registered')) {
        errorMessage = "Authentication service not available";
        errorDetails = {
          "type": "service_error",
          "suggestion": "Please restart the application or check service configuration"
        };
      }

      return {
        "status": "error",
        "message": errorMessage,
        "error_details": errorDetails,
        "full_error": e.toString(),
        "params": params,
        "debugging_info": {
          "error_type": e.runtimeType.toString(),
          "stack_trace_preview": e.toString().length > 200 
              ? e.toString().substring(0, 200) + "..."
              : e.toString(),
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  /// 📋 Get usage information
  static Map<String, dynamic> getUsageInfo() {
    return {
      "api_name": "Get WordPress Authenticated User (Me)",
      "description": "Get current authenticated user information from WordPress REST API using stored JWT token",
      "method": "GET",
      "endpoint": "/wp-json/wp/v2/users/me", 
      "authentication": "Stored JWT Bearer Token (automatic)",
      "parameters": "None required - uses stored JWT token from login",
      "workflow": [
        "1. Login using 'User Login' endpoint",
        "2. JWT token is automatically stored",
        "3. Call 'Get Users Me' endpoint",
        "4. Stored JWT token is automatically used"
      ],
      "curl_example": "curl -X GET '{{base_url}}/wp-json/wp/v2/users/me' -H 'Authorization: Bearer STORED_JWT_TOKEN'",
      "response_format": {
        "id": "User ID (integer)",
        "name": "Display name (string)",
        "url": "User website URL (string)",
        "description": "User description (string)",
        "slug": "User slug (string)",
        "avatar_urls": "Avatar URLs object",
        "is_super_admin": "Super admin status (boolean)",
        "woocommerce_meta": "WooCommerce specific metadata (object)"
      },
      "example_response": {
        "id": 32,
        "name": "sultandenemedgmail.com",
        "url": "",
        "description": "",
        "slug": "sultandenememedgmail-com",
        "avatar_urls": {
          "24": "https://secure.gravatar.com/avatar/...",
          "48": "https://secure.gravatar.com/avatar/...",
          "96": "https://secure.gravatar.com/avatar/..."
        },
        "is_super_admin": false,
        "woocommerce_meta": {
          "homepage_layout": "dashboard",
          "dashboard_chart_type": "line"
        }
      },
      "requirements": [
        "Prior authentication using 'User Login' endpoint",
        "Valid JWT token stored automatically",
        "WordPress REST API enabled",
        "User must have proper permissions"
      ],
      "error_codes": {
        "authentication_error": "No valid JWT token found - login first",
        "401": "Invalid or expired JWT token",
        "403": "Insufficient permissions",
        "404": "WordPress REST API not found"
      }
    };
  }

  /// 🧪 Get test scenarios
  static Map<String, dynamic> getTestScenarios() {
    return {
      "scenarios": [
        {
          "name": "With Valid Stored JWT",
          "description": "Test with valid JWT token from previous login",
          "params": {},
          "expected": "Success with user information using stored JWT token"
        },
        {
          "name": "No Login Session",
          "description": "Test without prior login or expired token",
          "params": {},
          "expected": "Authentication error - no valid JWT token found"
        }
      ],
      "integration_tests": [
        {
          "step": 1,
          "action": "Login using 'User Login' handler",
          "expected": "Get JWT token stored automatically"
        },
        {
          "step": 2, 
          "action": "Call 'Get Users Me' endpoint (no params needed)",
          "expected": "Get authenticated user information using stored JWT"
        },
        {
          "step": 3,
          "action": "Verify response matches Postman results",
          "expected": "Same user data structure and values"
        }
      ],
      "workflow_example": {
        "description": "Complete authentication flow",
        "steps": [
          "1. Use 'User Login' endpoint with email/password",
          "2. JWT token is automatically stored in WooAuthManager",  
          "3. Use 'Get Users Me' endpoint (no parameters needed)",
          "4. Stored JWT token is automatically used for authentication",
          "5. WordPress user information is returned"
        ]
      }
    };
  }
}
