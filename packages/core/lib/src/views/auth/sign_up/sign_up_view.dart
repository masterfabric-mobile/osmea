import 'package:core/src/base/master_view_cubit/master_view_cubit.dart';
import 'package:flutter/material.dart';
import 'package:core/src/helper/asset_config_helper.dart';
import 'package:core/src/views/auth/sign_up/cubit/sign_up_cubit.dart';
import 'package:core/src/views/auth/sign_up/cubit/sign_up_state.dart';
import 'package:core/src/views/auth/sign_up/widgets/sign_up_startup_widget.dart';

/// 🔐 **OSMEA Sign Up View**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// {@category Views}
/// {@subCategory Auth}

class SignUpView extends MasterViewCubit<SignUpCubit, SignUpState> {
  /// Callback triggered when sign up is successful
  final VoidCallback? onSignUpSuccess;

  /// Callback triggered when sign up fails
  final Function(String error)? onSignUpError;

  /// Callback triggered when navigating to sign in
  final VoidCallback? onSignInTap;

  SignUpView({
    required super.goRoute,
    super.arguments = const {'sign_up': true},
    this.onSignUpSuccess,
    this.onSignUpError,
    this.onSignInTap,
  });

  @override
  Future<void> initialContent(viewModel, BuildContext context) async {
    debugPrint('🔐 Sign Up View initializing...');

    // Extract and set authentication callback from arguments
    final authCallback = arguments['onSignUp'] as Future<bool> Function(
      String,
      String,
    )?;

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
      onSignUpSuccess?.call();
    } else {
      debugPrint('🔓 User not authenticated, showing sign up screen');
    }
  }

  @override
  Widget viewContent(BuildContext context, viewModel, state) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _loadAuthConfig(),
      builder: (context, snapshot) {
        final config = snapshot.data;
        return SignUpStartupWidget(
          viewModel: viewModel,
          state: state,
          onSignUpSuccess: onSignUpSuccess,
          onSignUpError: onSignUpError,
          onSignInTap: onSignInTap,
          config: config,
        );
      },
    );
  }

  /// Load auth configuration from app_config.json
  Future<Map<String, dynamic>?> _loadAuthConfig() async {
    try {
      final configHelper = AssetConfigHelper();
      await configHelper.loadConfig();
      final allConfig = configHelper.getAllConfig();
      final authConfig =
          allConfig?['auth_configuration']?['sign_up'] as Map<String, dynamic>?;
      debugPrint('✅ Auth configuration loaded: ${authConfig?.keys}');
      return authConfig;
    } catch (e) {
      debugPrint('⚠️ Could not load auth config, using defaults: $e');
      return null;
    }
  }
}
