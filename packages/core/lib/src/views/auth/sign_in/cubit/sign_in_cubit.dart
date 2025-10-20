import 'package:flutter/material.dart';
import 'package:core/src/base/base_view_model_cubit.dart';
import 'package:core/src/views/auth/sign_in/cubit/sign_in_state.dart';
import 'package:core/src/helper/auth_storage_helper.dart';

/// 🔐 **OSMEA Sign In Cubit**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Cubit that manages sign in operations with MVVM pattern
///
/// {@category ViewModels}
/// {@subCategory SignInCubit}

class SignInCubit extends BaseViewModelCubit<SignInState> {
  SignInCubit() : super(const SignInState());

  final AuthStorageHelper _authStorage = AuthStorageHelper();

  /// Callback for successful sign in - can be set externally
  Future<bool> Function(String username, String password)?
      authenticationCallback;

  /// 📧 Update email field
  void updateEmail(String email) {
    stateChanger(state.copyWith(
      email: email,
      emailError: null, // Clear error while typing
    ));
  }

  /// 🔑 Update password field
  void updatePassword(String password) {
    stateChanger(state.copyWith(
      password: password,
      passwordError: null, // Clear error while typing
    ));
  }

  /// 👁️ Toggle password visibility
  void togglePasswordVisibility() {
    stateChanger(state.copyWith(
      obscurePassword: !state.obscurePassword,
    ));
  }

  /// ☑️ Toggle remember me
  void toggleRememberMe() {
    stateChanger(state.copyWith(
      rememberMe: !state.rememberMe,
    ));
  }

  /// ✅ Validate email
  String? _validateEmail(String email) {
    if (email.isEmpty) {
      return null; // Don't show error for empty field until submit
    }

    // Basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// ✅ Validate password
  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return null; // Don't show error for empty field until submit
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  /// 🔐 Perform sign in
  Future<void> signIn() async {
    try {
      debugPrint('🔐 Starting sign in process...');

      // Validate inputs
      final emailError = _validateEmail(state.email);
      final passwordError = _validatePassword(state.password);

      if (state.email.isEmpty) {
        stateChanger(state.copyWith(
          status: SignInStatus.error,
          errorMessage: 'Please enter your email',
          emailError: 'Email is required',
        ));
        return;
      }

      if (state.password.isEmpty) {
        stateChanger(state.copyWith(
          status: SignInStatus.error,
          errorMessage: 'Please enter your password',
          passwordError: 'Password is required',
        ));
        return;
      }

      if (emailError != null || passwordError != null) {
        stateChanger(state.copyWith(
          status: SignInStatus.error,
          errorMessage: 'Please fix the errors before continuing',
          emailError: emailError,
          passwordError: passwordError,
        ));
        return;
      }

      stateChanger(state.copyWith(
        status: SignInStatus.loading,
        errorMessage: null,
      ));

      debugPrint('🔍 Calling sign in service...');
      debugPrint('📧 Email: ${state.email}');

      // Call authentication service
      if (authenticationCallback != null) {
        final success =
            await authenticationCallback!(state.email, state.password);

        if (success) {
          debugPrint('✅ Sign in successful');

          // Load token from storage (should be saved by the service)
          final token = await _authStorage.getToken();
          final userData = await _authStorage.getUserData();

          stateChanger(state.copyWith(
            status: SignInStatus.success,
            token: token,
            userData: userData,
            errorMessage: null,
          ));
        } else {
          debugPrint('❌ Sign in failed');
          stateChanger(state.copyWith(
            status: SignInStatus.error,
            errorMessage: 'Invalid email or password',
          ));
        }
      } else {
        debugPrint('❌ Sign in service not configured');
        stateChanger(state.copyWith(
          status: SignInStatus.error,
          errorMessage: 'Authentication service not configured',
        ));
      }
    } catch (e) {
      debugPrint('❌ Error during sign in: $e');
      stateChanger(state.copyWith(
        status: SignInStatus.error,
        errorMessage: 'An error occurred during sign in: ${e.toString()}',
      ));
    }
  }

  /// 🔄 Reset form
  void resetForm() {
    debugPrint('🔄 Resetting sign in form');
    stateChanger(const SignInState());
  }

  /// 🚪 Sign out
  Future<void> signOut() async {
    try {
      debugPrint('🚪 Signing out...');

      await _authStorage.clearToken();

      stateChanger(const SignInState());

      debugPrint('✅ Sign out successful');
    } catch (e) {
      debugPrint('❌ Error during sign out: $e');
    }
  }

  /// 🔍 Check if user is already signed in
  Future<bool> checkAuthStatus() async {
    try {
      debugPrint('🔍 Checking authentication status...');

      final token = await _authStorage.getToken();

      if (token != null && token.isNotEmpty) {
        final userData = await _authStorage.getUserData();

        stateChanger(state.copyWith(
          status: SignInStatus.success,
          token: token,
          userData: userData,
        ));

        debugPrint('✅ User already signed in');
        return true;
      }

      debugPrint('ℹ️ User not signed in');
      return false;
    } catch (e) {
      debugPrint('❌ Error checking auth status: $e');
      return false;
    }
  }
}
