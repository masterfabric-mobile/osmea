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

  // Track if navigation has been triggered to prevent duplicate calls
  static bool _hasNavigated = false;

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
  }) : super(
          coreAppBar: (context, cubit) => OsmeaComponents.appBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: OsmeaComponents.iconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  goRoute('/home');
                }
              },
              variant: ButtonVariant.ghost,
              size: ButtonSize.medium,
              backgroundColor: Colors.transparent,
            ),
          ),
        );

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

    // Configure onSignInSuccess callback for platform-specific token loading
    final onSignInSuccessTokenLoad = arguments['onSignInSuccessTokenLoad']
        as Future<void> Function(AuthCubit)?;
    if (onSignInSuccessTokenLoad != null) {
      viewModel.onSignInSuccess = onSignInSuccessTokenLoad;
      debugPrint('✅ onSignInSuccessTokenLoad callback configured');
    } else {
      debugPrint('⚠️ onSignInSuccessTokenLoad callback not found');
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
        // Only navigate once when AuthAuthenticatedState is reached
        // This is the primary navigation trigger after successful signin
        if (state is AuthAuthenticatedState) {
          if (wrappedOnSignInSuccess != null && !_hasNavigated) {
            _hasNavigated = true;
            debugPrint(
                '✅ AuthView: AuthAuthenticatedState detected, calling navigation callback...');
            // Use postFrameCallback to ensure state is fully updated before navigation
            WidgetsBinding.instance.addPostFrameCallback((_) {
              try {
                wrappedOnSignInSuccess?.call();
                debugPrint('✅ AuthView: Navigation callback executed');
              } catch (e) {
                debugPrint('❌ AuthView: Error in navigation callback: $e');
              }
            });
          }
          return;
        }

        // Handle form state changes
        // Don't navigate from AuthFormState.success - navigation is handled by AuthAuthenticatedState
        // This prevents double navigation
        if (state is AuthFormState) {
          // Handle Sign In success/error
          if (state.operationStatus == AuthOperationStatus.success &&
              state.currentTab == 0) {
            // Don't navigate here - wait for AuthAuthenticatedState
            // This prevents double navigation
            debugPrint(
                '✅ AuthView: SignIn success detected, waiting for AuthAuthenticatedState...');
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
