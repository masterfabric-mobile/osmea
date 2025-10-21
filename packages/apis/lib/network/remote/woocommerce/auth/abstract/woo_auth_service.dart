import 'package:apis/network/remote/woocommerce/auth/freezed_model/request/delete_user_request.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/request/password_update_request.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/request/user_login_request.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/request/user_signup_request.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/response/delete_user_response.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/response/password_update_response.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/response/send_reset_password_response.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/response/user_login_response.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/response/user_signup_response.dart';

/// 🔐 Abstract WooCommerce Authentication Service
/// Defines the contract for authentication operations
abstract class WooAuthService {
  /// 🔑 User Login
  /// Authenticates a user with email and password
  Future<UserLoginResponse> userLogin(
      String brandName, UserLoginRequest request);

  /// 📝 User Sign Up
  /// Creates a new user account
  Future<UserSignUpResponse> userSignUp(
      String brandName, UserSignUpRequest request);

  /// 🗑️ Delete User
  /// Deletes a user account
  Future<DeleteUserResponse> deleteUser(
      String brandName, String jwt, String authKey, DeleteUserRequest request);

  /// 📧 Send Reset Password
  /// Sends a password reset email to the user
  Future<SendResetPasswordResponse> sendResetPassword(
      String brandName, String email);

  /// 🔐 Update Password
  /// Updates user password with JWT authentication
  Future<PasswordUpdateResponse> updatePassword(
      String brandName, PasswordUpdateRequest request);

  Future<UserLoginResponse> userLoginWithQuery(
      String email, String password, String brandName);

  /// 🔐 Update Password (PUT + Query) — mirrors Postman
  /// Sends email & new_password as query string. JWT is optional and omitted when null.
  Future<PasswordUpdateResponse> updatePasswordPutQuery(
      String brandName, String email, String newPassword, String? jwt);
}
