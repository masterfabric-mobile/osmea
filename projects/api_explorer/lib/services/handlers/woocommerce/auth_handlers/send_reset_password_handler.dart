import 'package:api_explorer/services/api_request_handler.dart';
import 'package:api_explorer/services/api_service_registry.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:apis/network/remote/woocommerce/auth/abstract/woo_auth_service.dart';
import 'package:apis/network/remote/woocommerce/auth/api/api_woo_auth_service.dart';
import 'package:apis/dio_config/dio_client/api_dio_client.dart';

///*******************************************************************
//*************** 📧 SEND RESET PASSWORD HANDLER ******************
///*******************************************************************

class SendResetPasswordHandler implements ApiRequestHandler {
  @override
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
    'POST': [
      ApiField(
        name: 'email',
        label: 'Email Address',
        hint: 'user@example.com',
      ),
      ApiField(
        name: 'brand_name',
        label: 'Brand Name',
        hint: 'brandname',
      ),
    ],
  };
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'POST') {
      return {
        "status": "error",
        "message": "Method $method not supported for Send Reset Password API",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Validate required parameters
    if (!params.containsKey('email') || params['email']!.isEmpty) {
      return {
        "status": "error",
        "message": "Email is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    if (!params.containsKey('brand_name') || params['brand_name']!.isEmpty) {
      return {
        "status": "error",
        "message": "Brand name (store name) is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      final email = params['email']!;
      final brandName = params['brand_name']!;

      debugPrint('📧 Starting send reset password:');
      debugPrint('  - Email: $email');
      debugPrint('  - Brand Name: $brandName');

      // Get WooAuthService from DI with fallback
      late WooAuthService authService;
      
      try {
        authService = GetIt.I<WooAuthService>();
        debugPrint('✅ WooAuthService obtained from DI');
      } catch (e) {
        debugPrint('❌ Failed to get WooAuthService from DI: $e');
        debugPrint('🔄 Creating fallback WooAuthService...');
        
        // Create a fallback service directly
        authService = ApiWooAuthService(ApiDioClient.wooDio(useJwtAuth: false));
        debugPrint('✅ Fallback WooAuthService created');
      }

      // Call the service
      final response = await authService.sendResetPassword(brandName, email);

      debugPrint('📧 Send Reset Password Response received successfully');
      debugPrint('  - Success: ${response.success}');
      debugPrint('  - Message: ${response.message}');

      final responseJson = response.toJson();
      debugPrint('  - Available Fields: ${responseJson.keys.join(', ')}');

      if (response.success == true) {
        debugPrint('✅ Reset password email sent successfully');

        return {
          "status": "success",
          "message": "Password reset email sent successfully",
          "data": responseJson,
          "request_info": {
            "email": email,
            "brand_name": brandName,
            "endpoint": "/?rest_route/$brandName-auth-login/v1/user/reset_password",
            "method": "POST",
          },
          "params": params,
          "timestamp": DateTime.now().toIso8601String(),
        };
      } else {
        debugPrint('❌ Failed to send reset password email');

        return {
          "status": "error",
          "message": response.message ?? "Failed to send reset password email",
          "data": responseJson,
          "request_info": {
            "email": email,
            "brand_name": brandName,
            "endpoint": "/?rest_route/$brandName-auth-login/v1/user/reset_password",
            "method": "POST",
          },
          "params": params,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

    } catch (e) {
      debugPrint("🚨 Send Reset Password Error Details: $e");

      String errorMessage = "Failed to send reset password email: ${e.toString()}";
      Map<String, dynamic> errorDetails = {};

      // Check if it's a network/HTTP related error
      if (e.toString().contains('DioException') ||
          e.toString().contains('DioError')) {
        debugPrint("🔍 Network Error detected");

        if (e.toString().contains('400')) {
          errorDetails['status_code'] = 400;
          errorMessage = "Bad Request - Please check email format and brand name";
        } else if (e.toString().contains('401')) {
          errorDetails['status_code'] = 401;
          errorMessage = "Unauthorized - Invalid credentials or expired session";
        } else if (e.toString().contains('403')) {
          errorDetails['status_code'] = 403;
          errorMessage = "Forbidden - Access denied";
        } else if (e.toString().contains('404')) {
          errorDetails['status_code'] = 404;
          errorMessage = "Not Found - Invalid endpoint or brand name not found";
        } else if (e.toString().contains('422')) {
          errorDetails['status_code'] = 422;
          errorMessage = "Unprocessable Entity - Invalid email address";
        } else if (e.toString().contains('500')) {
          errorDetails['status_code'] = 500;
          errorMessage = "Internal Server Error - Please try again later";
        } else if (e.toString().contains('Connection refused') ||
                   e.toString().contains('Network is unreachable')) {
          errorMessage = "Network connection failed - Please check your internet connection";
        } else if (e.toString().contains('timeout')) {
          errorMessage = "Request timeout - Please try again";
        }

        errorDetails['network_error'] = true;
        errorDetails['error_type'] = 'DioException';
      } else if (e.toString().contains('FormatException')) {
        errorMessage = "Invalid response format from server";
        errorDetails['error_type'] = 'FormatException';
      } else if (e.toString().contains('TypeError')) {
        errorMessage = "Data type error - Unexpected response structure";
        errorDetails['error_type'] = 'TypeError';
      }

      return {
        "status": "error",
        "message": errorMessage,
        "error_details": errorDetails,
        "raw_error": e.toString(),
        "request_info": {
          "email": params['email'] ?? 'not_provided',
          "brand_name": params['brand_name'] ?? 'not_provided',
          "endpoint": "/?rest_route/${params['brand_name'] ?? 'unknown'}-auth-login/v1/user/reset_password",
          "method": "POST",
        },
        "params": params,
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  /// 📧 Get detailed usage information for the Send Reset Password API
  static Map<String, dynamic> getUsageInfo() {
    return {
      "api_name": "Send Reset Password",
      "description": "Sends a password reset email to the specified user",
      "method": "POST",
      "endpoint_pattern": "/?rest_route/{brand_name}-auth-login/v1/user/reset_password",
      "required_parameters": [
        {
          "name": "email",
          "type": "String",
          "description": "User's email address to send reset link",
          "example": "user@example.com"
        },
        {
          "name": "brand_name", 
          "type": "String",
          "description": "Store/brand identifier for the auth system",
          "example": "osmea"
        }
      ],
      "optional_parameters": [],
      "response_format": {
        "success": "boolean - Whether the email was sent successfully",
        "message": "string - Response message from the server"
      },
      "example_request": {
        "email": "user@example.com",
        "brand_name": "osmea"
      },
      "example_response_success": {
        "success": true,
        "message": "Reset password email has been sent."
      },
      "example_response_error": {
        "success": false,
        "message": "User not found or email is invalid."
      },
      "common_errors": [
        {
          "code": 400,
          "message": "Bad Request - Invalid email format"
        },
        {
          "code": 404,
          "message": "User not found with provided email"
        },
        {
          "code": 422,
          "message": "Unprocessable Entity - Invalid data"
        },
        {
          "code": 500,
          "message": "Internal Server Error"
        }
      ],
      "notes": [
        "This endpoint sends an email with password reset instructions",
        "The reset link will be valid for a limited time",
        "Check your spam folder if email doesn't arrive",
        "Endpoint uses query parameter for email, not request body"
      ]
    };
  }
}
