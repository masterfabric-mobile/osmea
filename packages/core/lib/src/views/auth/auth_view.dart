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

  /// Reset navigation flag (useful for testing or re-authentication)
  static void resetNavigationFlag() {
    _hasNavigated = false;
    debugPrint('🔄 AuthView: Navigation flag reset');
  }

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
    // Accept both old signature (without rememberMe) and new signature (with optional rememberMe)
    final signInCallbackRaw = arguments['onSignIn'];
    if (signInCallbackRaw != null) {
      // Check if it's the new signature with optional rememberMe parameter
      if (signInCallbackRaw is Future<bool> Function(String, String,
          {bool? rememberMe})) {
        viewModel.signInCallback = signInCallbackRaw;
        debugPrint('✅ Sign In callback configured (with rememberMe support)');
      }
      // Fallback to old signature (without rememberMe) for backward compatibility
      else if (signInCallbackRaw is Future<bool> Function(String, String)) {
        // Wrap old callback to add optional rememberMe parameter
        viewModel.signInCallback =
            (String email, String password, {bool? rememberMe}) async {
          // ignore: unnecessary_cast
          return await (signInCallbackRaw as Future<bool> Function(
              String, String))(email, password);
        };
        debugPrint('✅ Sign In callback configured (backward compatible)');
      } else {
        debugPrint('⚠️ Sign In callback type mismatch');
      }
    } else {
      debugPrint('⚠️ Sign In callback not found');
    }

    final signUpCallback = arguments['onSignUp'] as Future<bool> Function(
      String, // email
      String, // password
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

    // Configure onRememberMeChanged callback for custom remember me handling
    final onRememberMeChanged =
        arguments['onRememberMeChanged'] as Future<void> Function(bool)?;
    if (onRememberMeChanged != null) {
      viewModel.onRememberMeChanged = onRememberMeChanged;
      debugPrint('✅ onRememberMeChanged callback configured');
    } else {
      debugPrint(
          'ℹ️ onRememberMeChanged callback not provided (using default behavior)');
    }

    // Configure onChecklistChanged callback for custom checklist handling
    final onChecklistChanged = arguments['onChecklistChanged'] as Future<void>
        Function(String checklistId, bool isChecked)?;
    if (onChecklistChanged != null) {
      viewModel.onChecklistChanged = onChecklistChanged;
      debugPrint('✅ onChecklistChanged callback configured');
    } else {
      debugPrint(
          'ℹ️ onChecklistChanged callback not provided (using default behavior)');
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

    // Use the same AuthCubit instance from BaseViewHydratedCubit (GetIt singleton)
    // This ensures we're listening to the same instance used throughout the app
    return BlocListener<AuthCubit, AuthState>(
      bloc:
          viewModel, // Explicitly use the viewModel from BaseViewHydratedCubit
      listener: (context, state) {
        // Handle authentication state changes
        // Only navigate once when AuthAuthenticatedState is reached
        // This is the primary navigation trigger after successful signin/signup
        if (state is AuthAuthenticatedState) {
          if (wrappedOnSignInSuccess != null && !_hasNavigated) {
            _hasNavigated = true;
            debugPrint(
                '✅ AuthView: AuthAuthenticatedState detected (after sign in/sign up), calling navigation callback...');
            // Use postFrameCallback to ensure state is fully updated before navigation
            WidgetsBinding.instance.addPostFrameCallback((_) {
              try {
                wrappedOnSignInSuccess?.call();
                debugPrint(
                    '✅ AuthView: Navigation callback executed - navigating to home');
              } catch (e) {
                debugPrint('❌ AuthView: Error in navigation callback: $e');
                // Reset flag on error so user can try again
                _hasNavigated = false;
              }
            });
          } else if (_hasNavigated) {
            debugPrint(
                '⏸️ AuthView: Navigation already triggered, skipping...');
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
          // Note: After sign up success, currentTab changes to 0 for auto sign-in
          // So we check for sign up success by checking if we just came from sign up tab
          // or by checking sign up success message
          if (state.operationStatus == AuthOperationStatus.success) {
            // Check if this is sign up success (either currentTab is 1 or we have sign up email)
            final isSignUpSuccess = state.currentTab == 1 ||
                (state.signUpEmail.isNotEmpty && state.signInEmail.isEmpty);

            if (isSignUpSuccess) {
              debugPrint(
                  '✅ AuthView: Sign up success detected, auto sign-in will follow...');
              if (onSignUpSuccess != null) {
                debugPrint('✅ Calling onSignUpSuccess callback...');
                onSignUpSuccess?.call();
              }
              // Don't navigate here - wait for AuthAuthenticatedState after auto sign-in
              // This prevents double navigation
            } else if (state.currentTab == 0) {
              // Sign in success - wait for AuthAuthenticatedState
              debugPrint(
                  '✅ AuthView: SignIn success detected, waiting for AuthAuthenticatedState...');
            }
          } else if (state.operationStatus == AuthOperationStatus.error) {
            // Handle sign up error
            if (state.signUpErrorMessage != null &&
                (state.currentTab == 1 || state.signUpEmail.isNotEmpty)) {
              if (onSignUpError != null) {
                onSignUpError?.call(state.signUpErrorMessage!);
              }
            }
            // Handle sign in error
            if (state.signInErrorMessage != null && state.currentTab == 0) {
              if (onSignInError != null) {
                onSignInError?.call(state.signInErrorMessage!);
              }
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
