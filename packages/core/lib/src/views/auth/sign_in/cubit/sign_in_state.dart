import 'package:equatable/equatable.dart';

/// 🔐 **OSMEA Sign In State**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// State management for Sign In Cubit
///
/// {@category States}
/// {@subCategory SignInState}

/// 🔐 Sign in status enum
enum SignInStatus {
  /// Initial state
  initial,

  /// Loading - processing sign in
  loading,

  /// Sign in successful
  success,

  /// Error occurred during sign in
  error,

  /// Validating input
  validating,
}

/// 🔐 Sign in state class
class SignInState extends Equatable {
  /// Current status
  final SignInStatus status;

  /// Email/username input
  final String email;

  /// Password input
  final String password;

  /// Error message
  final String? errorMessage;

  /// Email validation error
  final String? emailError;

  /// Password validation error
  final String? passwordError;

  /// Whether to show password
  final bool obscurePassword;

  /// Whether remember me is checked
  final bool rememberMe;

  /// JWT token after successful login
  final String? token;

  /// User data after successful login
  final Map<String, dynamic>? userData;

  const SignInState({
    this.status = SignInStatus.initial,
    this.email = '',
    this.password = '',
    this.errorMessage,
    this.emailError,
    this.passwordError,
    this.obscurePassword = true,
    this.rememberMe = false,
    this.token,
    this.userData,
  });

  /// Create a copy of this state with some fields changed
  SignInState copyWith({
    SignInStatus? status,
    String? email,
    String? password,
    String? errorMessage,
    String? emailError,
    String? passwordError,
    bool? obscurePassword,
    bool? rememberMe,
    String? token,
    Map<String, dynamic>? userData,
  }) {
    return SignInState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage,
      emailError: emailError,
      passwordError: passwordError,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      rememberMe: rememberMe ?? this.rememberMe,
      token: token ?? this.token,
      userData: userData ?? this.userData,
    );
  }

  /// Check if form is valid
  bool get isValid =>
      email.isNotEmpty &&
      password.isNotEmpty &&
      emailError == null &&
      passwordError == null;

  @override
  List<Object?> get props => [
        status,
        email,
        password,
        errorMessage,
        emailError,
        passwordError,
        obscurePassword,
        rememberMe,
        token,
        userData,
      ];

  @override
  String toString() {
    return 'SignInState('
        'status: $status, '
        'email: $email, '
        'hasPassword: ${password.isNotEmpty}, '
        'hasError: ${errorMessage != null}, '
        'rememberMe: $rememberMe'
        ')';
  }
}
