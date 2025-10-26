import 'package:core/src/base/master_view_cubit/master_view_cubit.dart';
import 'package:flutter/material.dart';
import 'package:core/src/views/auth/sign_in/cubit/sign_in_cubit.dart';
import 'package:core/src/views/auth/sign_in/cubit/sign_in_state.dart';
import 'package:core/src/views/auth/sign_in/widgets/sign_in_startup_widget.dart';

/// 🔐 **OSMEA Sign In View**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Main sign in view - Handles user authentication
/// Uses MasterViewCubit for lifecycle management
///
/// {@category Views}
/// {@subCategory SignInView}

class SignInView extends MasterViewCubit<SignInCubit, SignInState> {
  /// Callback triggered when sign in is successful
  final VoidCallback? onSignInSuccess;

  /// Callback triggered when sign in fails
  final Function(String error)? onSignInError;

  /// Callback triggered when navigating to sign up
  final VoidCallback? onSignUpTap;

  /// Callback triggered when navigating to forgot password
  final VoidCallback? onForgotPasswordTap;

  SignInView({
    required super.goRoute,
    super.arguments = const {'sign_in': true},
    this.onSignInSuccess,
    this.onSignInError,
    this.onSignUpTap,
    this.onForgotPasswordTap,
  });

  @override
  Future<void> initialContent(viewModel, BuildContext context) async {
    debugPrint('🔐 Sign In View initializing...');

    // Extract and set authentication callback from arguments
    final authCallback =
        arguments['onSignIn'] as Future<bool> Function(String, String)?;
    if (authCallback != null) {
      viewModel.authenticationCallback = authCallback;
      debugPrint('✅ Authentication callback configured');
    } else {
      debugPrint('⚠️ Authentication callback not found');
    }

    // Check if user is already authenticated
    final isAuthenticated = await viewModel.checkAuthStatus();

    if (isAuthenticated) {
      debugPrint('👤 User already authenticated, navigating to home');
      onSignInSuccess?.call();
    } else {
      debugPrint('🔓 User not authenticated, showing sign in screen');
    }
  }

  @override
  Widget viewContent(BuildContext context, viewModel, state) {
    return Scaffold(
      body: SafeArea(
        child: SignInStartupWidget(
          viewModel: viewModel,
          state: state,
          onSignInSuccess: onSignInSuccess,
          onSignInError: onSignInError,
          onSignUpTap: onSignUpTap,
          onForgotPasswordTap: onForgotPasswordTap,
        ),
      ),
    );
  }
}
