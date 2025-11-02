import 'package:core/core.dart';
import 'package:core/src/base/master_view_cubit/master_view_cubit.dart';
import 'package:flutter/material.dart';
import 'package:core/src/helper/asset_config_helper.dart';
import 'package:core/src/views/auth/sign_in/cubit/sign_in_cubit.dart';
import 'package:core/src/views/auth/sign_in/cubit/sign_in_state.dart';
import 'package:core/src/views/auth/auth_widget.dart';

/// 🔐 **OSMEA Auth View**
///
/// Combined view for Sign In and Sign Up with TabBar
///
/// {@category Views}
/// {@subCategory Auth}

class AuthView extends MasterViewCubit<SignInCubit, SignInState> {
  final VoidCallback? onSignInSuccess;
  final Function(String error)? onSignInError;
  final VoidCallback? onSignUpSuccess;
  final Function(String error)? onSignUpError;
  final VoidCallback? onForgotPasswordTap;
  final int initialTab; // 0 = Sign In, 1 = Sign Up
  final String?
      defaultRedirectPath; // Default path to redirect after successful sign in

  AuthView({
    required super.goRoute,
    super.arguments = const {'auth': true},
    super.horizontalPadding = const PaddingVisibility.disabled(),
    super.verticalPadding = const PaddingVisibility.disabled(),
    super.useSafeArea = false,
    super.navbarSpacer = const SpacerVisibility.disabled(),
    super.footerSpacer = const SpacerVisibility.disabled(),
    super.appBarPadding = const AppBarPaddingVisibility.disabled(),
    super.backgroundColor = Colors.transparent,
    this.onSignInSuccess,
    this.onSignInError,
    this.onSignUpSuccess,
    this.onSignUpError,
    this.onForgotPasswordTap,
    this.initialTab = 0,
    this.defaultRedirectPath,
  });

  @override
  Future<void> initialContent(viewModel, BuildContext context) async {
    debugPrint('🔐 Auth View initializing...');

    // Check if user is already authenticated - redirect to default path
    final authStorage = AuthStorageHelper();
    final isAuthenticated = await authStorage.isAuthenticated();
    if (isAuthenticated) {
      final redirectPath = defaultRedirectPath ?? '/home';
      debugPrint(
          '👤 User already authenticated, redirecting to: $redirectPath');
      // Navigate using goRoute if available
      goRoute(redirectPath);
      return;
    }

    // Configure Sign In callback
    final signInCallback = arguments['onSignIn'] as Future<bool> Function(
      String,
      String,
    )?;

    if (signInCallback != null) {
      viewModel.authenticationCallback = signInCallback;
      debugPrint('✅ Sign In callback configured');
    } else {
      debugPrint('⚠️ Sign In callback not found');
    }

    // Check if Sign Up is disabled - if no sign up callback, sign up tab should redirect to profile
    final signUpCallback = arguments['onSignUp'] as Future<bool> Function(
      String,
      String,
      bool,
    )?;
    if (signUpCallback == null) {
      debugPrint('⚠️ Sign Up callback not found - Sign Up is disabled');
    }
  }

  @override
  Widget viewContent(BuildContext context, viewModel, state) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _loadAuthConfig(),
      builder: (context, snapshot) {
        final config = snapshot.data;

        // Get Sign Up callback
        final signUpCallback = arguments['onSignUp'] as Future<bool> Function(
          String,
          String,
          bool,
        )?;

        // Create wrapper callback that uses defaultRedirectPath if callback is null
        VoidCallback? wrappedOnSignInSuccess;
        if (onSignInSuccess != null) {
          wrappedOnSignInSuccess = onSignInSuccess;
        } else if (defaultRedirectPath != null) {
          // If no callback provided, use defaultRedirectPath
          wrappedOnSignInSuccess = () {
            final path = defaultRedirectPath!;
            debugPrint(
                '✅ Sign in successful! Navigating to default path: $path');
            goRoute(path);
          };
        }

        return AuthWidget(
          signInViewModel: viewModel,
          signInState: state,
          signUpCallback: signUpCallback,
          onSignInSuccess: wrappedOnSignInSuccess,
          onSignInError: onSignInError,
          onSignUpSuccess: onSignUpSuccess,
          onSignUpError: onSignUpError,
          onForgotPasswordTap: onForgotPasswordTap,
          config: config,
          initialTab: initialTab,
        );
      },
    );
  }

  Future<Map<String, dynamic>?> _loadAuthConfig() async {
    try {
      final configHelper = AssetConfigHelper();
      // Try to load project-specific config first, fallback to core package config
      await configHelper.loadConfig('assets/app_config.json');
      final allConfig = configHelper.getAllConfig();
      final authConfig =
          allConfig?['auth_configuration'] as Map<String, dynamic>?;
      debugPrint('✅ Auth configuration loaded from project config');
      return authConfig;
    } catch (e) {
      debugPrint('⚠️ Could not load auth config, using defaults: $e');
      return null;
    }
  }
}
