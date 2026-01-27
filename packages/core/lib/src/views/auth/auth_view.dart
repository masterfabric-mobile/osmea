import 'package:core/core.dart';
import 'package:core/src/views/auth/widgets/auth_enterprise_widget.dart';
import 'package:core/src/views/auth/widgets/auth_startup_widget.dart';
import 'package:core/src/views/auth/widgets/auth_space_widget.dart';
import 'package:core/src/views/auth/enums/auth_design_variant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
  // Use instance variable instead of static to allow proper reset on sign out
  bool _hasNavigated = false;

  /// Reset navigation flag (useful for testing or re-authentication)
  void resetNavigationFlag() {
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
    // Disable app bar padding to match other views
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
          coreAppBar: (context, cubit) {
            // Get variant from config to determine back button color
            final config = cubit.state is AuthFormState
                ? (cubit.state as AuthFormState).config
                : null;

            // Get variant from config inline (can't use instance method in initializer)
            AuthDesignVariant variant = AuthDesignVariant.enterprise; // Default
            if (config != null && config.containsKey('ui_style')) {
              final uiStyle = config['ui_style'] as Map<String, dynamic>?;
              if (uiStyle != null) {
                final variantString = uiStyle['style'] as String? ??
                    uiStyle['design_variant'] as String?;
                if (variantString != null) {
                  switch (variantString.toLowerCase()) {
                    case 'startup':
                      variant = AuthDesignVariant.startup;
                      break;
                    case 'space':
                      variant = AuthDesignVariant.space;
                      break;
                    case 'enterprise':
                    default:
                      variant = AuthDesignVariant.enterprise;
                      break;
                  }
                }
              }
            }

            // Determine colors based on variant
            // For all variants, use white background for better visibility
            final backgroundColor = OsmeaColors.white;

            // Use dark icon for visibility on white background
            final foregroundColor = OsmeaColors.black;

            // Get title from config based on current tab
            final currentTab = cubit.state is AuthFormState
                ? (cubit.state as AuthFormState).currentTab
                : initialTab;

            // Get title from config
            String titleText = 'Sign In to Your Account'; // Default
            if (config != null) {
              if (currentTab == 0) {
                final signInConfig = config['sign_in'] as Map<String, dynamic>?;
                titleText = signInConfig?['title']?.toString() ??
                    'Sign In to Your Account';
              } else {
                final signUpConfig = config['sign_up'] as Map<String, dynamic>?;
                titleText =
                    signUpConfig?['title']?.toString() ?? 'Create Your Account';
              }
            }

            // App bar with white background and dark icons for visibility
            return OsmeaComponents.appBar(
              title: OsmeaComponents.text(
                titleText,
                color: foregroundColor,
                textStyle: OsmeaTextStyle.titleLarge(context),
              ),
              backgroundColor: backgroundColor,
              elevation: 2,
              foregroundColor: foregroundColor,
              variant: AppBarVariant.standard,
              size: AppBarSize.standard,
              leading: OsmeaComponents.iconButton(
                onPressed: () {
                  // Use app router to go back, following cart view pattern
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/home');
                  }
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: foregroundColor,
                  size: context.iconSizeNormal,
                ),
              ),
            );
          },
        );

  /// Get design variant from config (using 'style' instead of 'design_variant')
  AuthDesignVariant _getDesignVariantFromConfig(Map<String, dynamic>? config) {
    if (config != null && config.containsKey('ui_style')) {
      final uiStyle = config['ui_style'] as Map<String, dynamic>?;
      if (uiStyle != null) {
        // Check for 'style' first (new format), fallback to 'design_variant' for backward compatibility
        final variantString =
            uiStyle['style'] as String? ?? uiStyle['design_variant'] as String?;
        if (variantString != null) {
          switch (variantString.toLowerCase()) {
            case 'startup':
              return AuthDesignVariant.startup;
            case 'space':
              return AuthDesignVariant.space;
            case 'enterprise':
            default:
              return AuthDesignVariant.enterprise;
          }
        }
      }
    }
    return AuthDesignVariant.enterprise; // Default
  }

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

    // Reset navigation flag if we're in unauthenticated state
    // This ensures navigation works after sign out -> sign in flow
    if (state is AuthUnauthenticatedState) {
      if (_hasNavigated) {
        debugPrint(
            '🔄 AuthView: viewContent rebuild - AuthUnauthenticatedState detected, resetting navigation flag...');
        _hasNavigated = false;
      }
    }

    // Create wrapper callback that uses defaultRedirectPath if callback is null
    VoidCallback? wrappedOnSignInSuccess;
    if (onSignInSuccess != null) {
      wrappedOnSignInSuccess = onSignInSuccess;
      debugPrint('✅ AuthView: onSignInSuccess callback is available');
    } else if (defaultRedirectPath != null) {
      // If no callback provided, use defaultRedirectPath
      wrappedOnSignInSuccess = () {
        final path = defaultRedirectPath!;
        debugPrint('✅ Sign in successful! Navigating to default path: $path');
        goRoute(path);
      };
      debugPrint('✅ AuthView: Using defaultRedirectPath: $defaultRedirectPath');
    } else {
      debugPrint(
          '⚠️ AuthView: No onSignInSuccess callback and no defaultRedirectPath');
    }

    // Use the same AuthCubit instance from BaseViewHydratedCubit (GetIt singleton)
    // This ensures we're listening to the same instance used throughout the app
    return BlocListener<AuthCubit, AuthState>(
      bloc:
          viewModel, // Explicitly use the viewModel from BaseViewHydratedCubit
      // Always listen to state changes to ensure navigation works after sign out -> sign in
      listenWhen: (previous, current) {
        // Always trigger listener for state changes
        return true;
      },
      listener: (context, state) {
        debugPrint(
            '🔔 AuthView: BlocListener triggered - state type: ${state.runtimeType}');
        debugPrint('🔍 AuthView: Previous navigation flag: $_hasNavigated');

        // Reset navigation flag when user signs out
        // This allows navigation to work again after sign out -> sign in flow
        if (state is AuthUnauthenticatedState) {
          if (_hasNavigated) {
            debugPrint(
                '🔄 AuthView: AuthUnauthenticatedState detected in listener, resetting navigation flag...');
            _hasNavigated = false;
            debugPrint('✅ AuthView: Navigation flag reset to false');
          }
          return;
        }

        // Handle authentication state changes
        // Only navigate once when AuthAuthenticatedState is reached
        // This is the primary navigation trigger after successful signin/signup
        if (state is AuthAuthenticatedState) {
          debugPrint('✅ AuthView: AuthAuthenticatedState detected in listener');

          // Use instance variable directly instead of local closure to avoid stale references
          final callback = onSignInSuccess;
          final redirectPath = defaultRedirectPath;

          debugPrint(
              '🔍 AuthView: onSignInSuccess is ${callback != null ? "not null" : "null"}');
          debugPrint(
              '🔍 AuthView: defaultRedirectPath is ${redirectPath ?? "null"}');
          debugPrint('🔍 AuthView: _hasNavigated is $_hasNavigated');

          if (!_hasNavigated) {
            _hasNavigated = true;
            debugPrint(
                '✅ AuthView: AuthAuthenticatedState detected (after sign in/sign up), calling navigation callback...');
            // Use postFrameCallback to ensure state is fully updated before navigation
            WidgetsBinding.instance.addPostFrameCallback((_) {
              try {
                if (!context.mounted) {
                  debugPrint(
                      '⚠️ AuthView: Context not mounted, skipping navigation');
                  _hasNavigated = false;
                  return;
                }

                // Show success snackbar
                context.snackbarSuccess(
                  'Redirecting to Home Page',
                  title: 'Login Successful',
                  duration: const Duration(seconds: 3),
                );

                // Use callback if available, otherwise use defaultRedirectPath
                if (callback != null) {
                  callback();
                  debugPrint('✅ AuthView: onSignInSuccess callback executed');
                } else if (redirectPath != null) {
                  debugPrint(
                      '✅ AuthView: Navigating to defaultRedirectPath: $redirectPath');
                  goRoute(redirectPath);
                } else {
                  debugPrint(
                      '⚠️ AuthView: No callback and no defaultRedirectPath, cannot navigate');
                  _hasNavigated = false;
                }
              } catch (e, stackTrace) {
                debugPrint('❌ AuthView: Error in navigation callback: $e');
                debugPrint('❌ AuthView: Stack trace: $stackTrace');
                // Reset flag on error so user can try again
                _hasNavigated = false;
              }
            });
          } else {
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
            return; // Prevent duplicate error handling below
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
            // Note: Sign in error is already handled above, so we don't check it again here
          }
        }
      },
      child: _getAuthWidget(
        config: config,
        wrappedOnSignInSuccess: wrappedOnSignInSuccess,
      ),
    );
  }

  /// Get appropriate auth widget based on design variant (like splash_view)
  Widget _getAuthWidget({
    Map<String, dynamic>? config,
    VoidCallback? wrappedOnSignInSuccess,
  }) {
    final variant = _getDesignVariantFromConfig(config);

    switch (variant) {
      case AuthDesignVariant.startup:
        return AuthStartupWidget(
          onSignInSuccess: wrappedOnSignInSuccess,
          onSignInError: onSignInError,
          onSignUpSuccess: onSignUpSuccess,
          onSignUpError: onSignUpError,
          onForgotPasswordTap: onForgotPasswordTap,
          config: config,
          initialTab: initialTab,
        );
      case AuthDesignVariant.space:
        return AuthSpaceWidget(
          onSignInSuccess: wrappedOnSignInSuccess,
          onSignInError: onSignInError,
          onSignUpSuccess: onSignUpSuccess,
          onSignUpError: onSignUpError,
          onForgotPasswordTap: onForgotPasswordTap,
          config: config,
          initialTab: initialTab,
        );
      case AuthDesignVariant.enterprise:
        return AuthEnterpriseWidget(
          onSignInSuccess: wrappedOnSignInSuccess,
          onSignInError: onSignInError,
          onSignUpSuccess: onSignUpSuccess,
          onSignUpError: onSignUpError,
          onForgotPasswordTap: onForgotPasswordTap,
          config: config,
          initialTab: initialTab,
        );
    }
  }
}
