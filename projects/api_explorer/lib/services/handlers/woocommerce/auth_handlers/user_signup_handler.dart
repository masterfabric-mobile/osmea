import 'package:api_explorer/services/api_request_handler.dart';
import 'package:api_explorer/services/api_service_registry.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:apis/network/remote/woocommerce/auth/abstract/woo_auth_service.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/request/user_signup_request.dart';
import 'package:apis/apis.dart';

///*******************************************************************
///******************* 📝 USER SIGNUP HANDLER **********************
///*******************************************************************

class UserSignUpHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'POST') {
      return {
        "status": "error",
        "message": "Method $method not supported for User Sign Up API",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Validate required parameters (Postman parameters)
    if (!params.containsKey('rest_route') || params['rest_route']!.isEmpty) {
      return {
        "status": "error",
        "message": "REST route is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    if (!params.containsKey('email') || params['email']!.isEmpty) {
      return {
        "status": "error",
        "message": "Email is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    if (!params.containsKey('password') || params['password']!.isEmpty) {
      return {
        "status": "error",
        "message": "Password is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    if (!params.containsKey('AUTH_KEY') || params['AUTH_KEY']!.isEmpty) {
      return {
        "status": "error",
        "message": "AUTH_KEY is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      final restRoute = params['rest_route']!;
      final email = params['email']!;
      final password = params['password']!;
      final authKey = params['AUTH_KEY']!;

      debugPrint('📝 Starting user sign up for: $email');
      debugPrint('📝 REST Route: $restRoute');
      debugPrint('📝 Auth Key: ${authKey.substring(0, 10)}...');

      // Extract brand name from rest_route
      final brandName = restRoute.split('-')[0].replaceAll('/', '');
      debugPrint('📝 Extracted brand name: $brandName');

      // Debug network configuration
      debugPrint('🌐 Base URL: ${WooNetwork.baseUrl}');
      debugPrint(
          '🌐 Full endpoint will be: ${WooNetwork.baseUrl}/?rest_route=/$brandName-auth-login/v1/users');

      // Use WooAuthService from the package
      final authService = GetIt.I<WooAuthService>();

      // Create signup request with minimal required fields
      final signupRequest = UserSignUpRequest(
        email: email,
        password: password,
        authKey: authKey,
        firstName: '', // Not required in Postman
        lastName: '', // Not required in Postman
        phone: null,
        company: null,
        userMeta: const UserMeta(
          acceptTerms: true,
          subscribeNewsletter: false,
        ),
        referralCode: null,
      );

      // Use brand name from rest_route
      final response = await authService.userSignUp(brandName, signupRequest);

      if (response.success) {
        debugPrint('✅ User sign up successful');

        return {
          "status": "success",
          "message": response.message,
          "user_data": {
            "user_id": response.data?.userId,
            "email": response.data?.email,
            "first_name": response.data?.firstName,
            "last_name": response.data?.lastName,
            "phone": response.data?.phone,
            "company": response.data?.company,
            "created_at": response.data?.createdAt?.toIso8601String(),
          },
          "metadata": response.metadata,
          "params": params,
          "timestamp": DateTime.now().toIso8601String(),
        };
      } else {
        debugPrint('❌ User sign up failed: ${response.message}');

        return {
          "status": "error",
          "message": response.message,
          "error_details": {
            "type": "signup_failed",
            "error": response.error,
          },
          "metadata": response.metadata,
          "params": params,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    } catch (e) {
      debugPrint("🚨 User Sign Up Error Details: $e");

      String errorMessage = "Failed to sign up user: ${e.toString()}";
      Map<String, dynamic> errorDetails = {};

      // Check if it's a network/HTTP related error
      if (e.toString().contains('DioException') ||
          e.toString().contains('DioError')) {
        debugPrint("🔍 Network Error detected");

        if (e.toString().contains('409')) {
          errorDetails['status_code'] = 409;
          errorMessage = "User already exists with this email";
        } else if (e.toString().contains('422')) {
          errorDetails['status_code'] = 422;
          errorMessage = "Invalid input data - check all fields";
        } else if (e.toString().contains('400')) {
          errorDetails['status_code'] = 400;
          errorMessage = "Bad request - invalid signup data";
        } else {
          errorMessage = "Network error occurred while signing up";
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
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(
            name: 'rest_route',
            label: 'REST Route',
            hint: 'API endpoint route',
            isRequired: true,
          ),
          const ApiField(
            name: 'email',
            label: 'Email',
            hint: 'User email address',
            isRequired: true,
          ),
          const ApiField(
            name: 'password',
            label: 'Password',
            hint: 'User password',
            isRequired: true,
          ),
          const ApiField(
            name: 'AUTH_KEY',
            label: 'Auth Key',
            hint: 'Authentication key for API access',
            isRequired: true,
          ),
        ],
      };
}
