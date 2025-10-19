import 'package:equatable/equatable.dart';

/// 🔐 **OSMEA Sign Up State**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// State management for Sign Up Cubit
///
/// {@category States}
/// {@subCategory SignUpState}

/// 🔐 Sign up status enum
enum SignUpStatus {
  /// Initial state
  initial,

  /// Loading - processing sign up
  loading,

  /// Sign up successful
  success,

  /// Error occurred during sign up
  error,

  /// Validating input
  validating,
}

/// 🔐 Sign up state class
class SignUpState extends Equatable {
  /// Current status
  final SignUpStatus status;

  /// Email input
  final String email;

  /// Password input
  final String password;

  /// Password confirmation input
  final String passwordConfirm;

  /// Whether to show password
  final bool obscurePassword;

  /// Whether to show password confirmation
  final bool obscurePasswordConfirm;

  /// Email validation error
  final String? emailError;

  /// Password validation error
  final String? passwordError;

  /// Password confirmation validation error
  final String? passwordConfirmError;

  /// General error message
  final String? errorMessage;

  /// JWT token after successful registration
  final String? token;

  /// User data after successful registration
  final Map<String, dynamic>? userData;

  const SignUpState({
    this.status = SignUpStatus.initial,
    this.email = '',
    this.password = '',
    this.passwordConfirm = '',
    this.obscurePassword = true,
    this.obscurePasswordConfirm = true,
    this.emailError,
    this.passwordError,
    this.passwordConfirmError,
    this.errorMessage,
    this.token,
    this.userData,
  });

  /// Create a copy of this state with some fields changed
  SignUpState copyWith({
    SignUpStatus? status,
    String? email,
    String? password,
    String? passwordConfirm,
    bool? obscurePassword,
    bool? obscurePasswordConfirm,
    String? emailError,
    String? passwordError,
    String? passwordConfirmError,
    String? errorMessage,
    String? token,
    Map<String, dynamic>? userData,
  }) {
    return SignUpState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscurePasswordConfirm:
          obscurePasswordConfirm ?? this.obscurePasswordConfirm,
      emailError: emailError,
      passwordError: passwordError,
      passwordConfirmError: passwordConfirmError,
      errorMessage: errorMessage,
      token: token ?? this.token,
      userData: userData ?? this.userData,
    );
  }

  /// Check if form is valid
  bool get isValid =>
      email.isNotEmpty &&
      password.isNotEmpty &&
      passwordConfirm.isNotEmpty &&
      password == passwordConfirm &&
      emailError == null &&
      passwordError == null &&
      passwordConfirmError == null;

  /// Check if there are any validation errors
  bool get hasError =>
      emailError != null ||
      passwordError != null ||
      passwordConfirmError != null ||
      errorMessage != null;

  /// Check if password field has content
  bool get hasPassword => password.isNotEmpty;

  @override
  List<Object?> get props => [
    status,
    email,
    password,
    passwordConfirm,
    obscurePassword,
    obscurePasswordConfirm,
    emailError,
    passwordError,
    passwordConfirmError,
    errorMessage,
    token,
    userData,
  ];

  @override
  String toString() {
    return 'SignUpState('
        'status: $status, '
        'email: $email, '
        'hasPassword: ${password.isNotEmpty}, '
        'passwordsMatch: ${password == passwordConfirm}, '
        'hasError: ${errorMessage != null}'
        ')';
  }
}
