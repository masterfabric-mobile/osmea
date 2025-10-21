import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:apis/apis.dart'; // WooNetwork için import
import 'package:apis/network/remote/woocommerce/auth/abstract/woo_auth_service.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/request/user_login_request.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/request/user_signup_request.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/request/delete_user_request.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/request/send_reset_password_request.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/response/user_login_response.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/response/user_signup_response.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/response/delete_user_response.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/response/send_reset_password_response.dart';
import 'package:apis/models/auth/woo_jwt_token.dart';
import 'package:apis/services/auth/woo_jwt_signin_manager.dart';

/// 🔐 WooCommerce Authentication Manager
/// High-level authentication service that integrates with JWT storage
@injectable
class WooAuthManager {
  final WooAuthService _authService;

  WooAuthManager(this._authService);

  /// 🔑 User Login with automatic JWT storage
  Future<WooAuthResult<UserLoginData>> login({
    required String email,
    required String password,
    bool rememberMe = false,
    String? deviceId,
    String? deviceName,
  }) async {
    try {
      debugPrint('🔐 Starting user login process...');

      // Create login request
      final request = UserLoginRequest(
        email: email,
        password: password,
        rememberMe: rememberMe,
        deviceId: deviceId,
        deviceName: deviceName,
      );

      // Call authentication API
      debugPrint('📡 Calling authentication API...');
      final response =
          await _authService.userLogin(WooNetwork.storeName, request);

      debugPrint('🔍 Raw response received in WooAuthManager: $response');
      debugPrint('🔍 Response success: ${response.success}');
      debugPrint('🔍 Response data: ${response.data}');
      debugPrint('🔍 Response data type: ${response.data.runtimeType}');
      debugPrint('🔍 Response message: ${response.message}');
      debugPrint('🔍 Response error: ${response.error}');

      if (response.success && response.data != null) {
        // Get JWT token from response (prefer jwt field, fallback to accessToken)
        final jwtTokenString = response.data!.jwt ?? response.data!.accessToken;
        if (jwtTokenString == null || jwtTokenString.isEmpty) {
          throw Exception('No JWT token received from server');
        }

        // Ensure jwtTokenString is not null before proceeding
        final String validJwtTokenString = jwtTokenString;

        debugPrint('🔍 Creating WooJwtToken in WooAuthManager...');
        debugPrint(
            '🔍 Valid JWT token: ${validJwtTokenString.substring(0, 20)}...');
        debugPrint('🔍 Token type: ${response.data!.tokenType}');
        debugPrint('🔍 Expires in: ${response.data!.expiresIn}');
        debugPrint('🔍 Issued at: ${response.data!.issuedAt}');
        debugPrint('🔍 Refresh token: ${response.data!.refreshToken}');
        debugPrint('🔍 Scope: ${response.data!.scope}');
        debugPrint('🔍 User data: ${response.data!.user}');

        try {
          // Convert to JWT token and save to storage
          final jwtToken = WooJwtToken(
            accessToken: validJwtTokenString,
            tokenType: response.data!.tokenType ?? 'Bearer',
            expiresIn: response.data!.expiresIn ?? 3600,
            issuedAt: response.data!.issuedAt ?? DateTime.now(),
            refreshToken: response.data!.refreshToken,
            scope: response.data!.scope,
            userData: response.data!.user != null
                ? response.data!.user!.toJson()
                : <String, dynamic>{},
          );
          debugPrint('🔍 WooJwtToken created successfully in WooAuthManager');

          // Save JWT token to local storage
          await WooJwtTokenStorage.saveToken(jwtToken);

          debugPrint(
              '✅ User login successful - JWT token saved to local storage');
          return WooAuthResult.success(
            data: response.data!,
            message: 'User login successful',
          );
        } catch (e, stackTrace) {
          debugPrint('❌ Error creating WooJwtToken in WooAuthManager: $e');
          debugPrint('❌ Stack trace: $stackTrace');
          debugPrint('🔍 Valid JWT token: $validJwtTokenString');
          debugPrint('🔍 Token type: ${response.data!.tokenType}');
          debugPrint('🔍 Expires in: ${response.data!.expiresIn}');
          debugPrint('🔍 Issued at: ${response.data!.issuedAt}');
          debugPrint('🔍 Refresh token: ${response.data!.refreshToken}');
          debugPrint('🔍 Scope: ${response.data!.scope}');
          debugPrint('🔍 User data: ${response.data!.user}');
          rethrow;
        }
      } else {
        debugPrint('❌ Login failed: ${response.message}');
        return WooAuthResult.failure(
          error: response.error ?? 'Login failed',
          message: response.message ?? 'Login failed',
        );
      }
    } catch (e) {
      debugPrint('❌ Login error: $e');
      return WooAuthResult.failure(
        error: e.toString(),
        message: _getErrorMessage(e),
      );
    }
  }

  /// 📝 User Sign Up
  Future<WooAuthResult<UserSignUpData>> signUp({
    required String email,
    required String password,
    required String authKey,
    required String firstName,
    required String lastName,
    String? phone,
    String? company,
    bool acceptTerms = true,
    bool subscribeNewsletter = false,
    String? referralCode,
  }) async {
    try {
      debugPrint('📝 Starting user sign up process...');

      // Create sign up request
      final request = UserSignUpRequest(
        email: email,
        password: password,
        authKey: authKey,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        company: company,
        acceptTerms: acceptTerms,
        subscribeNewsletter: subscribeNewsletter,
        referralCode: referralCode,
      );

      // Call authentication API
      debugPrint('📡 Calling sign up API...');
      final response =
          await _authService.userSignUp(WooNetwork.storeName, request);

      if (response.success && response.data != null) {
        debugPrint('✅ User sign up successful');
        debugPrint('👤 User ID: ${response.data!.userId}');
        debugPrint('📧 Email: ${response.data!.email}');

        return WooAuthResult.success(
          data: response.data!,
          message: response.message ?? 'Sign up successful',
        );
      } else {
        debugPrint('❌ Sign up failed: ${response.message}');
        return WooAuthResult.failure(
          error: response.error ?? 'Sign up failed',
          message: response.message ?? 'Sign up failed',
        );
      }
    } catch (e) {
      debugPrint('❌ Sign up error: $e');
      return WooAuthResult.failure(
        error: e.toString(),
        message: _getErrorMessage(e),
      );
    }
  }

  /// 🗑️ Delete User Account
  Future<WooAuthResult<DeleteUserData>> deleteUser({
    required String userId,
    required String jwt,
    required String authKey,
    String? reason,
    bool deleteOrders = false,
    bool deleteReviews = false,
  }) async {
    try {
      debugPrint('🗑️ Starting user deletion process...');

      // Create delete request
      final request = DeleteUserRequest(
        userId: userId,
        reason: reason,
        deleteOrders: deleteOrders,
        deleteReviews: deleteReviews,
      );

      // Call authentication API
      debugPrint('📡 Calling delete user API...');
      final response = await _authService.deleteUser(
          WooNetwork.storeName, jwt, authKey, request);

      if (response.success && response.data != null) {
        // Clear JWT token from storage
        await WooJwtTokenStorage.clearToken();

        debugPrint('✅ User deletion successful');
        debugPrint('🗑️ User ID: ${response.data!.userId} deleted');

        return WooAuthResult.success(
          data: response.data!,
          message: response.message ?? 'User deletion successful',
        );
      } else {
        debugPrint('❌ User deletion failed: ${response.message}');
        return WooAuthResult.failure(
          error: response.error ?? 'User deletion failed',
          message: response.message ?? 'User deletion failed',
        );
      }
    } catch (e) {
      debugPrint('❌ User deletion error: $e');
      return WooAuthResult.failure(
        error: e.toString(),
        message: _getErrorMessage(e),
      );
    }
  }

  /// 📧 Send Reset Password Email
  Future<WooAuthResult<SendResetPasswordResponse>> sendResetPassword({
    required String email,
  }) async {
    try {
      debugPrint('📧 Starting password reset process...');

      // Call authentication API
      debugPrint('📡 Calling reset password API...');
      final response = await _authService.sendResetPassword(
          WooNetwork.storeName, email);

      if (response.success == true) {
        debugPrint('✅ Password reset email sent successfully');
        debugPrint('📧 Message: ${response.message}');

        return WooAuthResult.success(
          data: response,
          message: response.message ?? 'Password reset email sent successfully',
        );
      } else {
        debugPrint('❌ Password reset failed: ${response.message}');
        return WooAuthResult.failure(
          error: response.message ?? 'Password reset failed',
          message: response.message ?? 'Password reset failed',
        );
      }
    } catch (e) {
      debugPrint('❌ Password reset error: $e');
      return WooAuthResult.failure(
        error: e.toString(),
        message: _getErrorMessage(e),
      );
    }
  }

  /// 🚪 User Logout
  Future<WooAuthResult<void>> logout() async {
    try {
      debugPrint('🚪 Starting user logout process...');

      // Get current token
      final token = await WooJwtTokenStorage.loadToken();
      if (token != null) {
        // Call logout API if available
        try {
          // Note: userLogout method needs to be added to WooAuthService interface
          debugPrint('⚠️ Logout API call not implemented yet');
        } catch (e) {
          debugPrint(
              '⚠️ Logout API call failed (server may not support it): $e');
        }
      }

      // Clear JWT token from storage
      await WooJwtTokenStorage.clearToken();

      debugPrint('✅ User logout successful');

      return WooAuthResult.success(
        data: null,
        message: 'Logout successful',
      );
    } catch (e) {
      debugPrint('❌ Logout error: $e');
      return WooAuthResult.failure(
        error: e.toString(),
        message: 'Logout failed: $e',
      );
    }
  }

  /// 🔍 Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      return await WooJwtTokenStorage.hasToken() &&
          !(await WooJwtTokenStorage.isTokenExpired());
    } catch (e) {
      debugPrint('❌ Error checking login status: $e');
      return false;
    }
  }

  /// 👤 Get current user info
  Future<UserInfo?> getCurrentUser() async {
    try {
      final token = await WooJwtTokenStorage.loadToken();
      if (token != null && token.userData != null) {
        return UserInfo.fromJson(token.userData!);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error getting current user: $e');
      return null;
    }
  }

  /// 🔄 Refresh token if needed
  Future<bool> refreshTokenIfNeeded() async {
    try {
      return await WooJwtSignInManager.instance.autoRefreshIfNeeded();
    } catch (e) {
      debugPrint('❌ Error refreshing token: $e');
      return false;
    }
  }

  /// 📊 Get authentication status
  Future<WooAuthStatus> getAuthStatus() async {
    try {
      final tokenInfo = await WooJwtTokenStorage.getTokenInfo();
      final isLoggedIn = await this.isLoggedIn();
      final currentUser = await getCurrentUser();

      return WooAuthStatus(
        isLoggedIn: isLoggedIn,
        hasToken: tokenInfo?['hasToken'] == true,
        isExpired: tokenInfo?['isExpired'] == true,
        needsRefresh: tokenInfo?['needsRefresh'] == true,
        currentUser: currentUser,
        tokenInfo: tokenInfo,
      );
    } catch (e) {
      debugPrint('❌ Error getting auth status: $e');
      return WooAuthStatus(
        isLoggedIn: false,
        hasToken: false,
        isExpired: true,
        needsRefresh: false,
        error: e.toString(),
      );
    }
  }

  /// 🔧 Get user-friendly error message
  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('401')) {
      return 'Invalid email or password';
    } else if (error.toString().contains('403')) {
      return 'Access denied. Please check your permissions';
    } else if (error.toString().contains('404')) {
      return 'Authentication service not found';
    } else if (error.toString().contains('409')) {
      return 'User already exists';
    } else if (error.toString().contains('422')) {
      return 'Invalid input data';
    } else if (error.toString().contains('Network')) {
      return 'Network error. Please check your internet connection';
    } else {
      return 'Authentication failed. Please try again';
    }
  }
}

/// 🔐 Authentication Result
class WooAuthResult<T> {
  final bool isSuccess;
  final T? data;
  final String message;
  final String? error;

  WooAuthResult._({
    required this.isSuccess,
    this.data,
    required this.message,
    this.error,
  });

  factory WooAuthResult.success({
    required T data,
    required String message,
  }) {
    return WooAuthResult._(
      isSuccess: true,
      data: data,
      message: message,
    );
  }

  factory WooAuthResult.failure({
    required String error,
    required String message,
  }) {
    return WooAuthResult._(
      isSuccess: false,
      message: message,
      error: error,
    );
  }
}

/// 📊 Authentication Status
class WooAuthStatus {
  final bool isLoggedIn;
  final bool hasToken;
  final bool isExpired;
  final bool needsRefresh;
  final UserInfo? currentUser;
  final Map<String, dynamic>? tokenInfo;
  final String? error;

  WooAuthStatus({
    required this.isLoggedIn,
    required this.hasToken,
    required this.isExpired,
    required this.needsRefresh,
    this.currentUser,
    this.tokenInfo,
    this.error,
  });
}
