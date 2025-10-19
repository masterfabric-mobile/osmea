import 'package:flutter/material.dart';
import 'package:core/src/base/base_view_model_cubit.dart';
import 'package:core/src/helper/auth_storage_helper.dart';
import 'package:core/src/views/auth/sign_up/cubit/sign_up_state.dart';

/// 🔐 **Sign Up Cubit**
///
/// Manages sign up business logic including:
/// - Form field updates and validation
/// - Sign up API calls
/// - Token storage
/// - User data management
///
/// {@category Cubit}
/// {@subCategory Auth}
class SignUpCubit extends BaseViewModelCubit<SignUpState> {
  SignUpCubit() : super(const SignUpState());

  final AuthStorageHelper _authStorage = AuthStorageHelper();

  /// Callback for authentication - injected from app_routes
  Future<bool> Function(String email, String password)? authenticationCallback;

  /// Update email field
  void updateEmail(String email) {
    stateChanger(
      state.copyWith(
        email: email,
        emailError: null, // Clear error while typing
      ),
    );
  }

  /// Update password field
  void updatePassword(String password) {
    stateChanger(
      state.copyWith(
        password: password,
        passwordError: null, // Clear error while typing
      ),
    );
  }

  /// Update password confirmation field
  void updatePasswordConfirm(String passwordConfirm) {
    stateChanger(
      state.copyWith(
        passwordConfirm: passwordConfirm,
        passwordConfirmError: null, // Clear error while typing
      ),
    );
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    stateChanger(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  /// Toggle password confirmation visibility
  void togglePasswordConfirmVisibility() {
    stateChanger(
      state.copyWith(obscurePasswordConfirm: !state.obscurePasswordConfirm),
    );
  }

  /// Validate email
  String? _validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validate password
  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Validate password confirmation
  String? _validatePasswordConfirm(String password, String passwordConfirm) {
    if (passwordConfirm.isEmpty) {
      return 'Please confirm your password';
    }
    if (password != passwordConfirm) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Perform sign up
  Future<void> signUp() async {
    try {
      debugPrint('🔐 Starting sign up process...');

      // Validate all fields
      final emailError = _validateEmail(state.email);
      final passwordError = _validatePassword(state.password);
      final passwordConfirmError = _validatePasswordConfirm(
        state.password,
        state.passwordConfirm,
      );

      // If any validation fails, update state with errors
      if (emailError != null ||
          passwordError != null ||
          passwordConfirmError != null) {
        debugPrint('❌ Validation failed');
        stateChanger(
          state.copyWith(
            emailError: emailError,
            passwordError: passwordError,
            passwordConfirmError: passwordConfirmError,
            status: SignUpStatus.initial,
          ),
        );
        return;
      }

      // Set loading state
      stateChanger(
        state.copyWith(status: SignUpStatus.loading, errorMessage: null),
      );

      // Call authentication callback
      if (authenticationCallback != null) {
        final success = await authenticationCallback!(
          state.email,
          state.password,
        );

        if (success) {
          debugPrint('✅ Sign up successful');
          final token = await _authStorage.getToken();
          final userData = await _authStorage.getUserData();

          stateChanger(
            state.copyWith(
              status: SignUpStatus.success,
              token: token,
              userData: userData,
              errorMessage: null,
            ),
          );
        } else {
          debugPrint('❌ Sign up failed');
          stateChanger(
            state.copyWith(
              status: SignUpStatus.error,
              errorMessage: 'Sign up failed. Please try again.',
            ),
          );
        }
      } else {
        debugPrint('❌ Sign up service not configured');
        stateChanger(
          state.copyWith(
            status: SignUpStatus.error,
            errorMessage: 'Sign up service not configured',
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Error during sign up: $e');
      stateChanger(
        state.copyWith(
          status: SignUpStatus.error,
          errorMessage: 'An error occurred during sign up: ${e.toString()}',
        ),
      );
    }
  }

  /// Check if user is already authenticated
  Future<bool> checkAuthStatus() async {
    try {
      final isAuthenticated = await _authStorage.isAuthenticated();
      debugPrint('🔍 Auth check result: $isAuthenticated');
      return isAuthenticated;
    } catch (e) {
      debugPrint('❌ Error checking auth status: $e');
      return false;
    }
  }
}
