import 'package:core/core.dart';
import 'package:core/src/views/auth/widgets/auth_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


/// 🔐 **OSMEA Auth View**
///
/// Combined view for Sign In and Sign Up with TabBar
///
/// {@category Views}
/// {@subCategory Auth}

class AuthView extends MasterViewHydratedCubit<AuthCubit, AuthState> {
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

    // Configure callbacks from arguments
    final signInCallback = arguments['onSignIn'] as Future<bool> Function(
      String,
      String,
    )?;
    if (signInCallback != null) {
      viewModel.signInCallback = signInCallback;
      debugPrint('✅ Sign In callback configured');
    } else {
      debugPrint('⚠️ Sign In callback not found');
    }

    final signUpCallback = arguments['onSignUp'] as Future<bool> Function(
      String, // email
      String, // password
      String, // authKey
      String, // firstName
      String, // lastName
      bool, // marketingConsent
    )?;
    if (signUpCallback != null) {
      viewModel.signUpCallback = signUpCallback;
      debugPrint('✅ Sign Up callback configured');
    } else {
      debugPrint('⚠️ Sign Up callback not found - Sign Up is disabled');
    }

    // Initialize authentication (loads config, checks auth status, initializes form)
    final result = await viewModel.initializeAuth(
      initialTab: initialTab,
      defaultRedirectPath: defaultRedirectPath,
    );

    // If user is already authenticated, redirect
    if (result.isAuthenticated && result.redirectPath != null) {
      debugPrint(
          '👤 User already authenticated, redirecting to: ${result.redirectPath}');
      goRoute(result.redirectPath!);
      return;
    }
  }

  @override
  Widget viewContent(BuildContext context, viewModel, state) {
    // Get config from state if available
    final config = state is AuthFormState ? state.config : null;

    // Create wrapper callback that uses defaultRedirectPath if callback is null
    VoidCallback? wrappedOnSignInSuccess;
    if (onSignInSuccess != null) {
      wrappedOnSignInSuccess = onSignInSuccess;
    } else if (defaultRedirectPath != null) {
      // If no callback provided, use defaultRedirectPath
      wrappedOnSignInSuccess = () {
        final path = defaultRedirectPath!;
        debugPrint('✅ Sign in successful! Navigating to default path: $path');
        goRoute(path);
      };
    }

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // Handle authentication state changes
        if (state is AuthAuthenticatedState) {
          if (wrappedOnSignInSuccess != null) {
            debugPrint('✅ Calling onSignInSuccess callback...');
            wrappedOnSignInSuccess.call();
          }
          return;
        }

        // Handle form state changes
        if (state is AuthFormState) {
          // Handle Sign In success/error
          if (state.operationStatus == AuthOperationStatus.success &&
              state.currentTab == 0) {
            if (wrappedOnSignInSuccess != null) {
              debugPrint('✅ Calling onSignInSuccess callback...');
              wrappedOnSignInSuccess.call();
            }
          } else if (state.operationStatus == AuthOperationStatus.error &&
              state.signInErrorMessage != null &&
              state.currentTab == 0) {
            if (onSignInError != null) {
              onSignInError?.call(state.signInErrorMessage!);
            }
          }

          // Handle Sign Up success/error
          if (state.operationStatus == AuthOperationStatus.success &&
              state.currentTab == 1) {
            if (onSignUpSuccess != null) {
              debugPrint('✅ Calling onSignUpSuccess callback...');
              onSignUpSuccess?.call();
            }
          } else if (state.operationStatus == AuthOperationStatus.error &&
              state.signUpErrorMessage != null &&
              state.currentTab == 1) {
            if (onSignUpError != null) {
              onSignUpError?.call(state.signUpErrorMessage!);
            }
          }
        }
      },
      child: AuthWidget(
        onSignInSuccess: wrappedOnSignInSuccess,
        onSignInError: onSignInError,
        onSignUpSuccess: onSignUpSuccess,
        onSignUpError: onSignUpError,
        onForgotPasswordTap: onForgotPasswordTap,
        config: config,
        initialTab: initialTab,
      ),
    );
  }
}
