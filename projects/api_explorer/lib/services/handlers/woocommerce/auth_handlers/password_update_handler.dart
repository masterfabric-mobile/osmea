import 'package:api_explorer/services/api_request_handler.dart';
import 'package:api_explorer/services/api_service_registry.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:apis/network/remote/woocommerce/auth/abstract/woo_auth_service.dart';

///*******************************************************************
///******************* 🔐 PASSWORD UPDATE HANDLER *******************
///*******************************************************************

class PasswordUpdateHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'POST' && method != 'PUT') {
      return {
        "status": "error",
        "message": "Method $method not supported for Password Update API",
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

    if (!params.containsKey('new_password') ||
        params['new_password']!.isEmpty) {
      return {
        "status": "error",
        "message": "New password is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    if (!params.containsKey('brand_name') || params['brand_name']!.isEmpty) {
      return {
        "status": "error",
        "message": "Store name is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Validate JWT token
    if (!params.containsKey('JWT') ||
        params['JWT']!.isEmpty ||
        params['JWT'] == 'no_jwt_token') {
      return {
        "status": "error",
        "message": "JWT token is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      final email = params['email']!;
      final newPassword = params['new_password']!;
      final storeName = params['brand_name']!;
      final jwtToken = params['JWT']!;

      debugPrint(
          '🔐 Starting password update for: $email in store: $storeName');
      debugPrint(
          '🔐 JWT: ${jwtToken == 'no_jwt_token' ? 'No JWT token' : (jwtToken.length > 20 ? '${jwtToken.substring(0, 20)}...' : jwtToken)}');

      // Use WooAuthService from the package
      final authService = GetIt.I<WooAuthService>();

      // Call API exactly like Postman: PUT + query params (send JWT as required by server)
      final response = await authService.updatePasswordPutQuery(
        storeName,
        email,
        newPassword,
        jwtToken, // send JWT as required by server
      );

      if (response.success) {
        debugPrint('✅ Password update successful');

        return {
          "status": "success",
          "message": response.message,
          "password_update_data": {
            "email": response.data?.email,
            "password_updated": response.data?.passwordUpdated,
            "updated_at": response.data?.updatedAt?.toIso8601String(),
          },
          "metadata": response.metadata,
          "params": params,
          "timestamp": DateTime.now().toIso8601String(),
        };
      } else {
        debugPrint('❌ Password update failed: ${response.message}');

        return {
          "status": "error",
          "message": response.message,
          "error_details": {
            "type": "password_update_failed",
            "error": response.error,
          },
          "metadata": response.metadata,
          "params": params,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    } catch (e) {
      debugPrint("🚨 Password Update Error Details: $e");

      String errorMessage = "Failed to update password: ${e.toString()}";
      Map<String, dynamic> errorDetails = {};

      // Check if it's a network/HTTP related error
      if (e.toString().contains('DioException') ||
          e.toString().contains('DioError')) {
        debugPrint("🔍 Network Error detected");

        if (e.toString().contains('401')) {
          errorDetails['status_code'] = 401;
          errorMessage = "Invalid or expired JWT token. Please login again";
        } else if (e.toString().contains('403')) {
          errorDetails['status_code'] = 403;
          errorMessage =
              "Access denied. You don't have permission to update password";
        } else if (e.toString().contains('404')) {
          errorDetails['status_code'] = 404;
          errorMessage = "User not found with this email";
        } else if (e.toString().contains('422')) {
          errorDetails['status_code'] = 422;
          errorMessage = "Invalid password format or requirements not met";
        } else {
          errorMessage = "Network error occurred while updating password";
        }

        errorDetails['type'] = 'network_error';
      } else {
        errorDetails['type'] = 'unknown_error';
      }

      return {
        "status": "error",
        "message": errorMessage,
        "error_details": errorDetails,
        "full_error": e.toString(),
        "params": params,
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['POST', 'PUT'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(
            name: 'brand_name',
            label: 'Store Name',
            hint: 'WooCommerce store name',
            isRequired: true,
          ),
          const ApiField(
            name: 'email',
            label: 'Email',
            hint: 'User email address',
            isRequired: true,
          ),
          const ApiField(
            name: 'new_password',
            label: 'New Password',
            hint: 'New password for the user',
            isRequired: true,
          ),
          const ApiField(
            name: 'JWT',
            label: 'JWT Token',
            hint: 'JWT authentication token',
            isRequired: true,
          ),
        ],
        'PUT': [
          const ApiField(
            name: 'brand_name',
            label: 'Store Name',
            hint: 'WooCommerce store name',
            isRequired: true,
          ),
          const ApiField(
            name: 'email',
            label: 'Email',
            hint: 'User email address',
            isRequired: true,
          ),
          const ApiField(
            name: 'new_password',
            label: 'New Password',
            hint: 'New password for the user',
            isRequired: true,
          ),
          const ApiField(
            name: 'JWT',
            label: 'JWT Token',
            hint: 'JWT authentication token',
            isRequired: true,
          ),
        ],
      };
}
