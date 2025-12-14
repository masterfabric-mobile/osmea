/*
 * AuthState
 * ---------
 * State definitions for authentication management.
 * Base implementation for authentication state.
 * Includes form states for sign in and sign up.
 */

import 'package:equatable/equatable.dart';

/// Base state for authentication
abstract class AuthState extends Equatable {
  const AuthState();

  /// Factory method to create initial state
  static AuthState initialState() => const AuthUnauthenticatedState();

  @override
  List<Object?> get props => [];
}

/// Initial state - no tokens loaded
class AuthInitialState extends AuthState {
  const AuthInitialState();

  @override
  List<Object?> get props => [];
}

/// Authentication form state - for sign in and sign up forms
class AuthFormState extends AuthState {
  // Sign In form fields
  final String signInEmail;
  final String signInPassword;
  final bool signInRememberMe;
  final bool signInObscurePassword;
  final String? signInEmailError;
  final String? signInPasswordError;
  final String? signInErrorMessage;

  // Sign Up form fields
  final String signUpEmail;
  final String signUpPassword;
  final String signUpPasswordConfirm;
  final String signUpFirstName;
  final String signUpLastName;
  final bool signUpObscurePassword;
  final bool signUpObscurePasswordConfirm;
  // Dynamic checklists: Map<checklistId, isChecked>
  final Map<String, bool> signUpChecklists;
  final String? signUpEmailError;
  final String? signUpPasswordError;
  final String? signUpPasswordConfirmError;
  final String? signUpFirstNameError;
  final String? signUpLastNameError;
  final String? signUpErrorMessage;

  // Operation status
  final AuthOperationStatus operationStatus;
  final int currentTab; // 0 = Sign In, 1 = Sign Up

  // Config
  final Map<String, dynamic>? config;

  const AuthFormState({
    this.signInEmail = '',
    this.signInPassword = '',
    this.signInRememberMe = false,
    this.signInObscurePassword = true,
    this.signInEmailError,
    this.signInPasswordError,
    this.signInErrorMessage,
    this.signUpEmail = '',
    this.signUpPassword = '',
    this.signUpPasswordConfirm = '',
    this.signUpFirstName = '',
    this.signUpLastName = '',
    this.signUpObscurePassword = true,
    this.signUpObscurePasswordConfirm = true,
    this.signUpChecklists = const {},
    this.signUpEmailError,
    this.signUpPasswordError,
    this.signUpPasswordConfirmError,
    this.signUpFirstNameError,
    this.signUpLastNameError,
    this.signUpErrorMessage,
    this.operationStatus = AuthOperationStatus.idle,
    this.currentTab = 0,
    this.config,
  });

  /// Copy with method for state updates
  AuthFormState copyWith({
    String? signInEmail,
    String? signInPassword,
    bool? signInRememberMe,
    bool? signInObscurePassword,
    String? signInEmailError,
    String? signInPasswordError,
    String? signInErrorMessage,
    String? signUpEmail,
    String? signUpPassword,
    String? signUpPasswordConfirm,
    String? signUpFirstName,
    String? signUpLastName,
    bool? signUpObscurePassword,
    bool? signUpObscurePasswordConfirm,
    Map<String, bool>? signUpChecklists,
    String? signUpEmailError,
    String? signUpPasswordError,
    String? signUpPasswordConfirmError,
    String? signUpFirstNameError,
    String? signUpLastNameError,
    String? signUpErrorMessage,
    AuthOperationStatus? operationStatus,
    int? currentTab,
    Map<String, dynamic>? config,
  }) {
    return AuthFormState(
      signInEmail: signInEmail ?? this.signInEmail,
      signInPassword: signInPassword ?? this.signInPassword,
      signInRememberMe: signInRememberMe ?? this.signInRememberMe,
      signInObscurePassword:
          signInObscurePassword ?? this.signInObscurePassword,
      signInEmailError: signInEmailError,
      signInPasswordError: signInPasswordError,
      signInErrorMessage: signInErrorMessage,
      signUpEmail: signUpEmail ?? this.signUpEmail,
      signUpPassword: signUpPassword ?? this.signUpPassword,
      signUpPasswordConfirm:
          signUpPasswordConfirm ?? this.signUpPasswordConfirm,
      signUpFirstName: signUpFirstName ?? this.signUpFirstName,
      signUpLastName: signUpLastName ?? this.signUpLastName,
      signUpObscurePassword:
          signUpObscurePassword ?? this.signUpObscurePassword,
      signUpObscurePasswordConfirm:
          signUpObscurePasswordConfirm ?? this.signUpObscurePasswordConfirm,
      signUpChecklists: signUpChecklists ?? this.signUpChecklists,
      signUpEmailError: signUpEmailError,
      signUpPasswordError: signUpPasswordError,
      signUpPasswordConfirmError: signUpPasswordConfirmError,
      signUpFirstNameError: signUpFirstNameError,
      signUpLastNameError: signUpLastNameError,
      signUpErrorMessage: signUpErrorMessage,
      operationStatus: operationStatus ?? this.operationStatus,
      currentTab: currentTab ?? this.currentTab,
      config: config ?? this.config,
    );
  }

  /// Check if sign in form is valid
  bool get isSignInValid =>
      signInEmail.isNotEmpty &&
      signInPassword.isNotEmpty &&
      signInEmailError == null &&
      signInPasswordError == null;

  /// Check if sign up form is valid
  bool get isSignUpValid {
    // Basic field validations
    final basicFieldsValid = signUpEmail.isNotEmpty &&
        signUpPassword.isNotEmpty &&
        signUpPasswordConfirm.isNotEmpty &&
        signUpFirstName.isNotEmpty &&
        signUpLastName.isNotEmpty &&
        signUpPassword == signUpPasswordConfirm &&
        signUpEmailError == null &&
        signUpPasswordError == null &&
        signUpPasswordConfirmError == null &&
        signUpFirstNameError == null &&
        signUpLastNameError == null;

    if (!basicFieldsValid) return false;

    // Check required checklists from config
    final signUpConfig = config?['sign_up'] as Map<String, dynamic>?;
    final checklists = signUpConfig?['checklists'] as List<dynamic>?;

    if (checklists != null) {
      for (final checklist in checklists) {
        final checklistMap = checklist as Map<String, dynamic>;
        final id = checklistMap['id'] as String?;
        final required = checklistMap['required'] as bool? ?? false;
        final enabled = checklistMap['enabled'] as bool? ?? true;

        if (enabled && required && id != null) {
          final isChecked = signUpChecklists[id] ?? false;
          if (!isChecked) {
            return false;
          }
        }
      }
    }

    return true;
  }

  @override
  List<Object?> get props => [
        signInEmail,
        signInPassword,
        signInRememberMe,
        signInObscurePassword,
        signInEmailError,
        signInPasswordError,
        signInErrorMessage,
        signUpEmail,
        signUpPassword,
        signUpPasswordConfirm,
        signUpFirstName,
        signUpLastName,
        signUpObscurePassword,
        signUpObscurePasswordConfirm,
        signUpChecklists,
        signUpEmailError,
        signUpPasswordError,
        signUpPasswordConfirmError,
        signUpFirstNameError,
        signUpLastNameError,
        signUpErrorMessage,
        operationStatus,
        currentTab,
        config,
      ];
}

/// Authentication operation status
enum AuthOperationStatus {
  idle,
  loading,
  success,
  error,
}

/// Authentication state with tokens
class AuthAuthenticatedState extends AuthState {
  final String? jwtToken;
  final Map<String, dynamic>? userData;
  final bool isAuthenticated;
  final String? role;

  /// Additional metadata for platform-specific implementations (e.g., WooCommerce tokens)
  final Map<String, dynamic>? metadata;

  const AuthAuthenticatedState({
    this.jwtToken,
    this.userData,
    required this.isAuthenticated,
    this.role,
    this.metadata,
  });

  /// Create from JSON for HydratedCubit persistence
  factory AuthAuthenticatedState.fromJson(Map<String, dynamic> json) {
    final jwtToken = json['jwtToken'] as String?;
    // isAuthenticated should be derived from jwtToken, not from JSON
    // This ensures state is never authenticated without a valid token
    final isAuthenticated = jwtToken != null && jwtToken.isNotEmpty;
    final userData = json['userData'] as Map<String, dynamic>?;

    return AuthAuthenticatedState(
      jwtToken: jwtToken,
      userData: userData,
      isAuthenticated: isAuthenticated, // Always derived from jwtToken
      role: userData?['role'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON for HydratedCubit persistence
  Map<String, dynamic> toJson() {
    return {
      'jwtToken': jwtToken,
      'userData': userData,
      'isAuthenticated': isAuthenticated,
      'metadata': metadata,
    };
  }

  /// Copy with method for state updates
  AuthAuthenticatedState copyWith({
    String? jwtToken,
    Map<String, dynamic>? userData,
    bool? isAuthenticated,
    String? role,
    Map<String, dynamic>? metadata,
  }) {
    return AuthAuthenticatedState(
      jwtToken: jwtToken ?? this.jwtToken,
      userData: userData ?? this.userData,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      role: role ?? this.role,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [jwtToken, userData, isAuthenticated, role, metadata];
}

/// Unauthenticated state - user logged out
class AuthUnauthenticatedState extends AuthState {
  const AuthUnauthenticatedState();

  @override
  List<Object?> get props => [];
}

/// Loading state - tokens are being loaded
class AuthLoadingState extends AuthState {
  const AuthLoadingState();

  @override
  List<Object?> get props => [];
}

/// Authentication initialization result
class AuthInitializationResult {
  final bool isAuthenticated;
  final String? redirectPath;
  final Map<String, dynamic>? config;

  const AuthInitializationResult({
    required this.isAuthenticated,
    this.redirectPath,
    this.config,
  });
}
