import 'package:apis/apis.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:apis/dio_config/dio_client/api_dio_client.dart';
import 'package:apis/network/remote/woocommerce/auth/abstract/woo_auth_service.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/request/delete_user_request.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/request/password_update_request.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/request/user_login_request.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/request/user_signup_request.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/response/delete_user_response.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/response/password_update_response.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/response/send_reset_password_response.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/response/user_login_response.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/response/user_signup_response.dart';

part 'api_woo_auth_service.g.dart';

/// 🔐 WooCommerce Authentication API Service
/// Retrofit client for WooCommerce Authentication API.
/// Make sure WooNetwork.storeUrl is set before using! 🏬🔑
@RestApi()
@Injectable(as: WooAuthService)
abstract class ApiWooAuthService implements WooAuthService {
  @factoryMethod
  factory ApiWooAuthService(Dio dio) => _ApiWooAuthService(
        ApiDioClient.wooDio(
            useJwtAuth: false), // Use Basic Auth for auth endpoints
        baseUrl: WooNetwork.baseUrl,
      );

  /// 🔑 User Login
  /// Authenticates a user with email and password
  @POST('/?rest_route=/{brand_name}-auth-login/v1/auth')
  @override
  Future<UserLoginResponse> userLogin(
    @Path('brand_name') String brandName,
    @Body() UserLoginRequest request,
  );

  /// 📝 User Sign Up
  /// Creates a new user account
  @POST('/?rest_route=/{brand_name}-auth-login/v1/users')
  @override
  Future<UserSignUpResponse> userSignUp(
    @Path('brand_name') String brandName,
    @Body() UserSignUpRequest request,
  );

  /// 🗑️ Delete User
  /// Deletes a user account
  @DELETE('/?rest_route=/{brand_name}-auth-login/v1/users')
  @override
  Future<DeleteUserResponse> deleteUser(
    @Path('brand_name') String brandName,
    @Query('JWT') String jwt,
    @Query('AUTH_KEY') String authKey,
    @Body() DeleteUserRequest request,
  );

  /// 📧 Send Reset Password
  /// Sends a password reset email to the user
  @POST('/?rest_route=/{brand_name}-auth-login/v1/user/reset_password')
  @override
  Future<SendResetPasswordResponse> sendResetPassword(
    @Path('brand_name') String brandName,
    @Query('email') String email,
  );

  /// 🔐 Update Password
  /// Updates user password with JWT authentication
  @POST('/?rest_route=/{brand_name}-auth-login/v1/user/reset_password')
  @override
  Future<PasswordUpdateResponse> updatePassword(
    @Path('brand_name') String brandName,
    @Body() PasswordUpdateRequest request,
  );

  /// 🔑 User Login with Query Parameters (Alternative method)
  /// Authenticates a user with email and password using query parameters
  @POST('/?rest_route=/{brand_name}-auth-login/v1/auth')
  Future<UserLoginResponse> userLoginWithQuery(
    @Query('email') String email,
    @Query('password') String password,
    @Path('brand_name') String brandName,
  );

  /// 🔐 Update Password (PUT + Query) — mirrors Postman
  @PUT('/?rest_route=/{brand_name}-auth-login/v1/user/reset_password')
  @override
  Future<PasswordUpdateResponse> updatePasswordPutQuery(
    @Path('brand_name') String brandName,
    @Query('email') String email,
    @Query('new_password') String newPassword,
    @Query('jwt') String? jwt,
  );

  /// 🔄 Refresh Token
  /// Refreshes the user's access token
  @POST('/?rest_route=/{brand_name}-auth-refresh/v1/auth')
  Future<UserLoginResponse> refreshToken(
    @Path('brand_name') String brandName,
    @Query('refresh_token') String refreshToken,
  );
}
