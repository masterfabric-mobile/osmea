/*
 * AuthCubit
 * ---------
 * Central authentication state management using HydratedCubit.
 * Base implementation for authentication state management.
 * Specific implementations should extend this cubit.
 */

import 'package:flutter/foundation.dart';
import 'package:core/src/base/base_view_model_hydrated_cubit.dart';
import 'package:core/src/helper/auth_storage_helper.dart';
import 'package:core/src/helper/asset_config_helper.dart';
import 'package:core/src/helper/local_storage/local_storage_helper.dart';
import 'package:core/src/views/auth/cubit/auth_state.dart';
import 'package:injectable/injectable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

/// 🔐 **OSMEA Auth Cubit**
///
/// Base authentication cubit using HydratedCubit storage.
/// This cubit manages core authentication state and persists it across app restarts.
/// Specific implementations (e.g., WooCommerce) should extend this cubit.
///
/// {@category ViewModels}
/// {@subCategory AuthCubit}

@injectable
class AuthCubit extends BaseViewModelHydratedCubit<AuthState> {
  AuthCubit() : super(AuthState.initialState());

  final AuthStorageHelper _authStorage = AuthStorageHelper();
  final AssetConfigHelper _configHelper = AssetConfigHelper();
  final LocalStorageHelper _localStorage = LocalStorageHelper();

  // Prevent multiple concurrent loadTokens() calls
  bool _isLoadingTokens = false;
  DateTime? _lastLoadTime;
  static const Duration _loadDebounceDuration =
      Duration(seconds: 2); // Minimum 2 seconds between loads

  // Prevent recursive sign in calls during sign up auto sign-in
  bool _isAutoSigningIn = false;

  // Callbacks for authentication
  Future<bool> Function(String email, String password, {bool? rememberMe})?
      signInCallback;
  Future<bool> Function(
    String email,
    String password,
    String firstName,
    String lastName,
    bool marketingConsent,
  )? signUpCallback;

  // Callback for post-sign-in success (platform-specific token loading)
  // This is called after successful sign in, before emitting AuthAuthenticatedState
  // The AuthCubit instance is passed as parameter so the callback can call saveJwtToken
  Future<void> Function(AuthCubit authCubit)? onSignInSuccess;

  // Callback for remember me preference changes
  // This is called when user toggles remember me checkbox
  Future<void> Function(bool rememberMe)? onRememberMeChanged;

  // Callback for checklist changes
  // This is called when user toggles any checklist item
  // Parameters: checklistId, isChecked
  Future<void> Function(String checklistId, bool isChecked)? onChecklistChanged;

  /// Check if user is authenticated
  bool get isAuthenticated {
    final currentState = state;
    if (currentState is AuthAuthenticatedState) {
      return currentState.isAuthenticated;
    }
    return false;
  }

  /// Get current JWT token string
  String? get jwtTokenString {
    final currentState = state;
    if (currentState is AuthAuthenticatedState) {
      return currentState.jwtToken;
    }
    return null;
  }

  /// Get current JWT token with Bearer prefix
  String? get jwtTokenHeader {
    final token = jwtTokenString;
    if (token != null && token.isNotEmpty) {
      return token.startsWith('Bearer ') ? token : 'Bearer $token';
    }
    return null;
  }

  /// Get current user data
  Map<String, dynamic>? get userData {
    final currentState = state;
    if (currentState is AuthAuthenticatedState) {
      return currentState.userData;
    }
    return null;
  }

  /// Get current metadata (platform-specific data like WooCommerce tokens)
  Map<String, dynamic>? get metadata {
    final currentState = state;
    if (currentState is AuthAuthenticatedState) {
      return currentState.metadata;
    }
    return null;
  }

  /// Get a specific metadata value by key
  T? getMetadataValue<T>(String key) {
    final meta = metadata;
    if (meta != null && meta.containsKey(key)) {
      return meta[key] as T?;
    }
    return null;
  }

  /// Load tokens from storage and update state
  /// This method reads from core AuthStorageHelper and syncs to HydratedCubit state
  /// Includes debounce to prevent excessive calls
  Future<void> loadTokens() async {
    // Prevent concurrent calls
    if (_isLoadingTokens) {
      debugPrint('⏸️ AuthCubit: Already loading tokens, skipping...');
      return;
    }

    // Debounce: Prevent calls within 2 seconds of last load
    if (_lastLoadTime != null) {
      final timeSinceLastLoad = DateTime.now().difference(_lastLoadTime!);
      if (timeSinceLastLoad < _loadDebounceDuration) {
        debugPrint(
            '⏸️ AuthCubit: Too soon since last load (${timeSinceLastLoad.inMilliseconds}ms), skipping...');
        return;
      }
    }

    _isLoadingTokens = true;
    _lastLoadTime = DateTime.now();

    try {
      debugPrint('🔄 AuthCubit: Loading tokens from storage...');
      emit(const AuthLoadingState());

      // Load JWT token from Core AuthStorageHelper
      final jwtToken = await _authStorage.getToken();
      final userData = await _authStorage.getUserData();

      // Determine authentication status
      final authenticated = jwtToken != null && jwtToken.isNotEmpty;
      final isExpired =
          authenticated ? await _authStorage.isTokenExpired() : true;

      if (authenticated && !isExpired) {
        emit(
          AuthAuthenticatedState(
            jwtToken: jwtToken,
            userData: userData,
            isAuthenticated: true,
            metadata: null,
          ),
        );
        debugPrint('✅ AuthCubit: Tokens loaded and state updated');
      } else {
        emit(const AuthUnauthenticatedState());
        debugPrint(
            'ℹ️ AuthCubit: No valid tokens found, user not authenticated');
      }
    } catch (e) {
      debugPrint('❌ AuthCubit: Error loading tokens: $e');
      emit(const AuthUnauthenticatedState());
    } finally {
      _isLoadingTokens = false;
    }
  }

  /// Save JWT token to cubit state and storage
  /// This should be called after successful sign in
  /// [metadata] can be used for platform-specific data (e.g., WooCommerce tokens)
  Future<void> saveJwtToken({
    String? jwtToken,
    Map<String, dynamic>? userData,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      debugPrint('💾 AuthCubit: Saving JWT token...');

      // Save to storage for backward compatibility
      if (jwtToken != null) {
        await _authStorage.saveToken(jwtToken);
        if (userData != null) {
          await _authStorage.saveUserData(userData);
        }
      }

      // Update cubit state
      final currentState = state;
      debugPrint(
          '🔍 AuthCubit: Current state before save: ${currentState.runtimeType}');

      if (currentState is AuthAuthenticatedState) {
        // Merge metadata if provided
        final mergedMetadata = metadata != null
            ? {...?currentState.metadata, ...metadata}
            : currentState.metadata;

        final newState = currentState.copyWith(
          jwtToken: jwtToken ?? currentState.jwtToken,
          userData: userData ?? currentState.userData,
          isAuthenticated: jwtToken != null && jwtToken.isNotEmpty,
          metadata: mergedMetadata,
        );

        debugPrint('🔄 AuthCubit: Emitting updated AuthAuthenticatedState');
        debugPrint(
            '🔍 AuthCubit: isAuthenticated = ${newState.isAuthenticated}');
        emit(newState);
      } else {
        final newState = AuthAuthenticatedState(
          jwtToken: jwtToken,
          userData: userData,
          isAuthenticated: jwtToken != null && jwtToken.isNotEmpty,
          metadata: metadata,
        );

        debugPrint('🔄 AuthCubit: Emitting new AuthAuthenticatedState');
        debugPrint(
            '🔍 AuthCubit: isAuthenticated = ${newState.isAuthenticated}');
        debugPrint('🔍 AuthCubit: jwtToken = ${jwtToken?.substring(0, 20)}...');
        emit(newState);
      }

      debugPrint('✅ AuthCubit: JWT token saved and state emitted');
      debugPrint('🔍 AuthCubit: New state type: ${state.runtimeType}');
    } catch (e) {
      debugPrint('❌ AuthCubit: Error saving JWT token: $e');
    }
  }

  /// Clear all tokens and sign out
  Future<void> signOut() async {
    try {
      debugPrint('🚪 AuthCubit: Signing out...');

      // Step 1: Clear storage FIRST (before state change)
      await _authStorage.clearToken();
      debugPrint('✅ AuthCubit: Token cleared from storage');

      // Step 2: Clear remember me from storage
      try {
        await _localStorage.init();
        await _localStorage.removeItem('remember_me');
        debugPrint('✅ AuthCubit: Remember me cleared from storage');
      } catch (e) {
        debugPrint('❌ AuthCubit: Error clearing remember me from storage: $e');
      }

      // Step 3: Clear HydratedBloc persisted state manually
      try {
        // HydratedBloc uses the cubit's runtimeType as the storage key
        final cubitId = runtimeType.toString();
        await HydratedBloc.storage.delete(cubitId);
        debugPrint('✅ AuthCubit: HydratedBloc storage cleared for $cubitId');
      } catch (e) {
        debugPrint('⚠️ AuthCubit: Error clearing HydratedBloc storage: $e');
        // Continue even if storage clear fails
      }

      // Step 4: Reset form state to clear any form data
      resetForm();
      debugPrint('✅ AuthCubit: Form state reset');

      // Step 5: Update cubit state to unauthenticated
      // This will be persisted by HydratedCubit (toJson returns null for unauthenticated, which clears persistence)
      emit(const AuthUnauthenticatedState());
      debugPrint('✅ AuthCubit: AuthUnauthenticatedState emitted');

      // Step 6: Force a state change to ensure HydratedCubit persistence is cleared
      // Emit again to ensure state is properly persisted (or cleared)
      await Future.delayed(const Duration(milliseconds: 100));
      emit(const AuthUnauthenticatedState());
      debugPrint(
          '✅ AuthCubit: AuthUnauthenticatedState emitted again (persistence cleared)');

      // Step 7: Verify state is correct
      await Future.delayed(const Duration(milliseconds: 50));
      if (state is! AuthUnauthenticatedState) {
        debugPrint('⚠️ AuthCubit: State is not unauthenticated, forcing again...');
        emit(const AuthUnauthenticatedState());
      }

      debugPrint(
          '✅ AuthCubit: Sign out successful - state set to unauthenticated');
      debugPrint(
          '🔍 AuthCubit: Current state after signOut = ${state.runtimeType}');
      debugPrint(
          '🔍 AuthCubit: isAuthenticated = ${state is AuthAuthenticatedState}');
    } catch (e, stackTrace) {
      debugPrint('❌ AuthCubit: Error signing out: $e');
      debugPrint('❌ AuthCubit: Stack trace: $stackTrace');
      // Even on error, emit unauthenticated state and clear form
      resetForm();
      emit(const AuthUnauthenticatedState());
    }
  }

  /// Refresh tokens from storage
  /// This is useful when tokens might have been updated externally
  Future<void> refreshTokens() async {
    await loadTokens();
  }

  /// Update metadata (for platform-specific implementations)
  /// This allows adding/updating metadata without changing the JWT token
  void updateMetadata(Map<String, dynamic> newMetadata) {
    final currentState = state;
    if (currentState is AuthAuthenticatedState) {
      final mergedMetadata = {...?currentState.metadata, ...newMetadata};
      emit(currentState.copyWith(metadata: mergedMetadata));
    }
  }

  /// Clear metadata
  void clearMetadata() {
    final currentState = state;
    if (currentState is AuthAuthenticatedState) {
      emit(currentState.copyWith(metadata: null));
    }
  }

  // ============================================================================
  // INITIALIZATION
  // ============================================================================

  /// Initialize authentication view
  /// Loads config, checks authentication status, and initializes form state
  Future<AuthInitializationResult> initializeAuth({
    required int initialTab,
    String? defaultRedirectPath,
  }) async {
    try {
      debugPrint('🔐 AuthCubit: Initializing authentication...');

      // Check if user is already authenticated
      final isAuthenticated = await _authStorage.isAuthenticated();
      if (isAuthenticated) {
        debugPrint('👤 AuthCubit: User already authenticated');
        return AuthInitializationResult(
          isAuthenticated: true,
          redirectPath: defaultRedirectPath ?? '/home',
        );
      }

      // Load auth config using AssetConfigHelper
      Map<String, dynamic>? config;
      try {
        await _configHelper.loadConfig('assets/app_config.json');
        config = _configHelper.getObject('auth_configuration');
        debugPrint('✅ AuthCubit: Auth configuration loaded');
      } catch (e) {
        debugPrint('⚠️ AuthCubit: Could not load auth config: $e');
        config = null;
      }

      // Load remember me state from storage
      bool rememberMe = false;
      try {
        await _localStorage.init();
        final savedRememberMe = await _localStorage.getItem('remember_me');
        if (savedRememberMe is bool) {
          rememberMe = savedRememberMe;
        } else if (savedRememberMe is String) {
          rememberMe = savedRememberMe.toLowerCase() == 'true';
        }
        debugPrint('✅ Remember me loaded from storage: $rememberMe');
      } catch (e) {
        debugPrint('❌ Error loading remember me from storage: $e');
      }

      // Initialize form state with config, initial tab, and remember me state
      emit(AuthFormState(
        currentTab: initialTab,
        config: config,
        signInRememberMe: rememberMe,
      ));

      debugPrint('✅ AuthCubit: Authentication initialized');
      return AuthInitializationResult(
        isAuthenticated: false,
        config: config,
      );
    } catch (e) {
      debugPrint('❌ AuthCubit: Error initializing authentication: $e');
      // Initialize with empty form state on error
      emit(AuthFormState(currentTab: initialTab));
      return AuthInitializationResult(
        isAuthenticated: false,
        config: null,
      );
    }
  }

  // ============================================================================
  // FORM STATE MANAGEMENT
  // ============================================================================

  /// Get current form state - returns null if state is not AuthFormState
  AuthFormState? get _formState {
    final currentState = state;
    if (currentState is AuthFormState) {
      return currentState;
    }
    return null;
  }

  /// Switch between Sign In (0) and Sign Up (1) tabs
  /// Only works if current state is AuthFormState
  void switchTab(int tab) {
    final formState = _formState;
    if (formState != null) {
      emit(formState.copyWith(currentTab: tab));
    } else {
      // If not in form state, initialize with form state
      // Preserve config if available from current form state
      final currentConfig = formState?.config;
      emit(AuthFormState(currentTab: tab, config: currentConfig));
    }
  }

  // ============================================================================
  // SIGN IN FORM METHODS
  // ============================================================================

  /// Update sign in email field
  void updateSignInEmail(String email) {
    final formState = _formState;
    if (formState != null) {
      emit(formState.copyWith(
        signInEmail: email,
        signInEmailError: null, // Clear error while typing
      ));
    } else {
      // If not in form state, initialize with form state
      emit(AuthFormState(signInEmail: email));
    }
  }

  /// Update sign in password field
  void updateSignInPassword(String password) {
    final formState = _formState;
    if (formState != null) {
      emit(formState.copyWith(
        signInPassword: password,
        signInPasswordError: null, // Clear error while typing
      ));
    } else {
      // If not in form state, initialize with form state
      emit(AuthFormState(signInPassword: password));
    }
  }

  /// Toggle sign in password visibility
  void toggleSignInPasswordVisibility() {
    final formState = _formState;
    if (formState != null) {
      emit(formState.copyWith(
        signInObscurePassword: !formState.signInObscurePassword,
      ));
    }
  }

  /// Toggle remember me
  void toggleRememberMe() async {
    final formState = _formState;
    if (formState != null) {
      final newValue = !formState.signInRememberMe;

      // Save to local storage
      try {
        await _localStorage.init();
        await _localStorage.setItem('remember_me', newValue);
        debugPrint('✅ Remember me saved to storage: $newValue');
      } catch (e) {
        debugPrint('❌ Error saving remember me to storage: $e');
      }

      emit(formState.copyWith(
        signInRememberMe: newValue,
      ));
    }
    return null; // Return null if not found
  }

  /// Validate sign in email
  String? _validateSignInEmail(String email) {
    if (email.isEmpty) {
      return null; // Don't show error for empty field until submit
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validate sign in password
  String? _validateSignInPassword(String password) {
    if (password.isEmpty) {
      return null; // Don't show error for empty field until submit
    }
    return null;
  }

  /// Perform sign in
  Future<void> signIn() async {
    try {
      debugPrint('🔐 Starting sign in process...');

      final formState = _formState;
      if (formState == null) {
        debugPrint('❌ AuthCubit: Cannot sign in - not in form state');
        return;
      }

      final emailError = _validateSignInEmail(formState.signInEmail);
      final passwordError = _validateSignInPassword(formState.signInPassword);

      if (formState.signInEmail.isEmpty) {
        emit(formState.copyWith(
          operationStatus: AuthOperationStatus.error,
          signInErrorMessage: 'Please enter your email',
          signInEmailError: 'Email is required',
        ));
        return;
      }

      if (formState.signInPassword.isEmpty) {
        emit(formState.copyWith(
          operationStatus: AuthOperationStatus.error,
          signInErrorMessage: 'Please enter your password',
          signInPasswordError: 'Password is required',
        ));
        return;
      }

      if (emailError != null || passwordError != null) {
        emit(formState.copyWith(
          operationStatus: AuthOperationStatus.error,
          signInErrorMessage: 'Please fix the errors before continuing',
          signInEmailError: emailError,
          signInPasswordError: passwordError,
        ));
        return;
      }

      emit(formState.copyWith(
        operationStatus: AuthOperationStatus.loading,
        signInErrorMessage: null,
      ));

      debugPrint('🔍 Calling sign in service...');
      debugPrint('📧 Email: ${formState.signInEmail}');

      // Call authentication service with optional rememberMe parameter
      if (signInCallback != null) {
        final success = await signInCallback!(
          formState.signInEmail,
          formState.signInPassword,
          rememberMe: formState.signInRememberMe,
        );

        if (success) {
          debugPrint('✅ Sign in successful');

          // Call platform-specific onSignInSuccess callback if provided
          // This allows platforms (e.g., WooCommerce) to load tokens from their storage
          // This callback should call saveJwtToken() which will emit AuthAuthenticatedState
          if (onSignInSuccess != null) {
            try {
              debugPrint('🔄 Calling onSignInSuccess callback...');
              await onSignInSuccess!(this);
              debugPrint('✅ onSignInSuccess callback completed');

              // Check if state was updated by onSignInSuccess callback
              // If not, load token from storage and save it
              if (state is! AuthAuthenticatedState) {
                debugPrint(
                    '⚠️ State not updated by onSignInSuccess, loading from storage...');
                final token = await _authStorage.getToken();
                final userData = await _authStorage.getUserData();

                if (token != null && token.isNotEmpty) {
                  // Save token using saveJwtToken which will emit AuthAuthenticatedState
                  await saveJwtToken(
                    jwtToken: token,
                    userData: userData,
                  );
                } else {
                  debugPrint('⚠️ No token found in storage after signin');
                  emit(const AuthUnauthenticatedState());
                }
              } else {
                debugPrint(
                    '✅ State already updated to AuthAuthenticatedState by onSignInSuccess');
              }
            } catch (e) {
              debugPrint('⚠️ Error in onSignInSuccess callback: $e');
              // Try to load token from storage as fallback
              try {
                final token = await _authStorage.getToken();
                final userData = await _authStorage.getUserData();

                if (token != null && token.isNotEmpty) {
                  await saveJwtToken(
                    jwtToken: token,
                    userData: userData,
                  );
                } else {
                  emit(const AuthUnauthenticatedState());
                }
              } catch (e2) {
                debugPrint('❌ Error loading token from storage: $e2');
                emit(const AuthUnauthenticatedState());
              }
            }
          } else {
            // No onSignInSuccess callback, load token from storage directly
            debugPrint(
                '⚠️ No onSignInSuccess callback, loading token from storage...');
            final token = await _authStorage.getToken();
            final userData = await _authStorage.getUserData();

            if (token != null && token.isNotEmpty) {
              // Save token using saveJwtToken which will emit AuthAuthenticatedState
              await saveJwtToken(
                jwtToken: token,
                userData: userData,
              );
            } else {
              debugPrint('⚠️ No token found in storage');
              emit(const AuthUnauthenticatedState());
            }
          }
        } else {
          debugPrint('❌ Sign in failed');
          final currentFormState = _formState;
          if (currentFormState != null) {
            emit(currentFormState.copyWith(
              operationStatus: AuthOperationStatus.error,
              signInErrorMessage: 'Invalid email or password',
            ));
          }
        }
      } else {
        debugPrint('❌ Sign in service not configured');
        final currentFormState = _formState;
        if (currentFormState != null) {
          emit(currentFormState.copyWith(
            operationStatus: AuthOperationStatus.error,
            signInErrorMessage: 'Authentication service not configured',
          ));
        }
      }
    } catch (e) {
      debugPrint('❌ Error during sign in: $e');
      final currentFormState = _formState;
      if (currentFormState != null) {
        emit(currentFormState.copyWith(
          operationStatus: AuthOperationStatus.error,
          signInErrorMessage:
              'An error occurred during sign in: ${e.toString()}',
        ));
      }
    }
  }

  // ============================================================================
  // SIGN UP FORM METHODS
  // ============================================================================

  /// Update sign up email field
  void updateSignUpEmail(String email) {
    final formState = _formState;
    if (formState != null) {
      emit(formState.copyWith(
        signUpEmail: email,
        signUpEmailError: null, // Clear error while typing
      ));
    } else {
      // If not in form state, initialize with form state
      emit(AuthFormState(signUpEmail: email));
    }
  }

  /// Update sign up password field
  void updateSignUpPassword(String password) {
    final formState = _formState;
    if (formState != null) {
      emit(formState.copyWith(
        signUpPassword: password,
        signUpPasswordError: null, // Clear error while typing
      ));
    } else {
      // If not in form state, initialize with form state
      emit(AuthFormState(signUpPassword: password));
    }
  }

  /// Update sign up password confirmation field
  void updateSignUpPasswordConfirm(String passwordConfirm) {
    final formState = _formState;
    if (formState != null) {
      emit(formState.copyWith(
        signUpPasswordConfirm: passwordConfirm,
        signUpPasswordConfirmError: null, // Clear error while typing
      ));
    } else {
      // If not in form state, initialize with form state
      emit(AuthFormState(signUpPasswordConfirm: passwordConfirm));
    }
  }

  /// Update sign up first name field
  void updateSignUpFirstName(String firstName) {
    final formState = _formState;
    if (formState != null) {
      emit(formState.copyWith(
        signUpFirstName: firstName,
        signUpFirstNameError: null, // Clear error while typing
      ));
    } else {
      // If not in form state, initialize with form state
      emit(AuthFormState(signUpFirstName: firstName));
    }
  }

  /// Update sign up last name field
  void updateSignUpLastName(String lastName) {
    final formState = _formState;
    if (formState != null) {
      emit(formState.copyWith(
        signUpLastName: lastName,
        signUpLastNameError: null, // Clear error while typing
      ));
    } else {
      // If not in form state, initialize with form state
      emit(AuthFormState(signUpLastName: lastName));
    }
  }

  /// Toggle sign up password visibility
  void toggleSignUpPasswordVisibility() {
    final formState = _formState;
    if (formState != null) {
      emit(formState.copyWith(
        signUpObscurePassword: !formState.signUpObscurePassword,
      ));
    }
  }

  /// Toggle sign up password confirmation visibility
  void toggleSignUpPasswordConfirmVisibility() {
    final formState = _formState;
    if (formState != null) {
      emit(formState.copyWith(
        signUpObscurePasswordConfirm: !formState.signUpObscurePasswordConfirm,
      ));
    }
  }

  /// Toggle a checklist item by ID
  Future<void> toggleChecklist(String checklistId) async {
    final formState = _formState;
    if (formState != null) {
      final currentValue = formState.signUpChecklists[checklistId] ?? false;
      final newValue = !currentValue;

      final updatedChecklists =
          Map<String, bool>.from(formState.signUpChecklists);
      updatedChecklists[checklistId] = newValue;

      emit(formState.copyWith(
        signUpChecklists: updatedChecklists,
      ));

      // Call custom callback if provided
      if (onChecklistChanged != null) {
        try {
          await onChecklistChanged!(checklistId, newValue);
          debugPrint(
              '✅ onChecklistChanged callback executed for $checklistId: $newValue');
        } catch (e) {
          debugPrint('⚠️ Error in onChecklistChanged callback: $e');
        }
      }
    }
  }

  /// Toggle marketing consent (backward compatibility)
  @Deprecated('Use toggleChecklist("marketing_consent") instead')
  void toggleMarketingConsent() {
    toggleChecklist('marketing_consent');
  }

  /// Toggle privacy policy acceptance (backward compatibility)
  @Deprecated('Use toggleChecklist("privacy_policy") instead')
  void togglePrivacyPolicy() {
    toggleChecklist('privacy_policy');
  }

  /// Toggle terms of service acceptance (backward compatibility)
  @Deprecated('Use toggleChecklist("terms") instead')
  void toggleTerms() {
    toggleChecklist('terms');
  }

  /// Validate sign up email
  String? _validateSignUpEmail(String email) {
    if (email.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validate sign up password
  /// - Minimum 8 characters
  /// - At least one uppercase letter
  /// - At least one lowercase letter
  /// - At least one special character
  String? _validateSignUpPassword(String password) {
    if (password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>\-_+=\[\]\\|/~`]').hasMatch(password)) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  /// Validate sign up password confirmation
  String? _validateSignUpPasswordConfirm(
      String password, String passwordConfirm) {
    if (passwordConfirm.isEmpty) {
      return 'Please confirm your password';
    }
    if (password != passwordConfirm) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validate sign up first name
  String? _validateSignUpFirstName(String firstName) {
    if (firstName.isEmpty) {
      return 'First name is required';
    }
    if (firstName.length < 2) {
      return 'First name must be at least 2 characters';
    }
    return null;
  }

  /// Validate sign up last name
  String? _validateSignUpLastName(String lastName) {
    if (lastName.isEmpty) {
      return 'Last name is required';
    }
    if (lastName.length < 2) {
      return 'Last name must be at least 2 characters';
    }
    return null;
  }

  /// Perform sign up
  Future<void> signUp() async {
    try {
      debugPrint('🔐 Starting sign up process...');

      final formState = _formState;
      if (formState == null) {
        debugPrint('❌ AuthCubit: Cannot sign up - not in form state');
        return;
      }

      final emailError = _validateSignUpEmail(formState.signUpEmail);
      final passwordError = _validateSignUpPassword(formState.signUpPassword);
      final passwordConfirmError = _validateSignUpPasswordConfirm(
        formState.signUpPassword,
        formState.signUpPasswordConfirm,
      );
      final firstNameError =
          _validateSignUpFirstName(formState.signUpFirstName);
      final lastNameError = _validateSignUpLastName(formState.signUpLastName);

      // If any validation fails, update state with errors
      if (emailError != null ||
          passwordError != null ||
          passwordConfirmError != null ||
          firstNameError != null ||
          lastNameError != null) {
        debugPrint('❌ Validation failed');
        emit(formState.copyWith(
          operationStatus: AuthOperationStatus.idle,
          signUpEmailError: emailError,
          signUpPasswordError: passwordError,
          signUpPasswordConfirmError: passwordConfirmError,
          signUpFirstNameError: firstNameError,
          signUpLastNameError: lastNameError,
        ));
        return;
      }

      // Set loading state
      emit(formState.copyWith(
        operationStatus: AuthOperationStatus.loading,
        signUpErrorMessage: null,
      ));

      // Call authentication callback
      if (signUpCallback != null) {
        // Get marketing consent from checklists (backward compatibility)
        final marketingConsent =
            formState.signUpChecklists['marketing_consent'] ?? false;

        bool success = false;
        try {
          debugPrint('📞 AuthCubit: Calling sign up callback...');
          success = await signUpCallback!(
            formState.signUpEmail,
            formState.signUpPassword,
            formState.signUpFirstName,
            formState.signUpLastName,
            marketingConsent,
          );
          debugPrint('📞 AuthCubit: Sign up callback returned: $success');
        } catch (e, stackTrace) {
          debugPrint(
              '❌ AuthCubit: Exception in sign up callback: ${e.runtimeType}');
          debugPrint('❌ AuthCubit: Error: $e');
          debugPrint('❌ AuthCubit: Stack trace: $stackTrace');
          // Emit error state instead of continuing
          emit(formState.copyWith(
            operationStatus: AuthOperationStatus.error,
            signUpErrorMessage: 'Sign up failed: ${e.toString()}',
          ));
          return; // Exit early to prevent further processing
        }

        if (success) {
          debugPrint('✅ Sign up successful');

          // After successful sign up, automatically sign in to get JWT token
          debugPrint('🔄 Auto sign-in after successful sign up...');

          // Store email and password temporarily
          final email = formState.signUpEmail;
          final password = formState.signUpPassword;

          // Update form state to show sign up success
          emit(formState.copyWith(
            operationStatus: AuthOperationStatus.success,
            signUpErrorMessage: null,
          ));

          // Wait a moment for UI to update
          await Future.delayed(const Duration(milliseconds: 100));

          // Prevent recursive calls - check flag before auto sign-in
          if (_isAutoSigningIn) {
            debugPrint(
                '⏸️ AuthCubit: Already auto-signing in, skipping duplicate call...');
            return;
          }

          // Now perform auto sign-in
          // Update form state with sign-in credentials
          emit(formState.copyWith(
            currentTab: 0, // Switch to sign in tab (for state tracking)
            signInEmail: email,
            signInPassword: password,
            operationStatus: AuthOperationStatus.loading,
          ));

          // Set flag to prevent recursive calls
          _isAutoSigningIn = true;
          try {
            debugPrint('🔄 AuthCubit: Starting auto sign-in after sign up...');
            debugPrint('📧 Auto sign-in email: $email');
            // Call sign in method which will handle token loading
            await signIn();
            debugPrint('✅ AuthCubit: Auto sign-in completed');

            // Check if AuthAuthenticatedState was emitted
            final currentState = state;
            debugPrint(
                '🔍 AuthCubit: State after auto sign-in: ${currentState.runtimeType}');
            if (currentState is! AuthAuthenticatedState) {
              debugPrint(
                  '⚠️ AuthCubit: AuthAuthenticatedState not emitted after auto sign-in!');
              debugPrint('⚠️ AuthCubit: Current state: $currentState');

              // Try to load token manually as fallback
              try {
                final token = await _authStorage.getToken();
                final userData = await _authStorage.getUserData();
                debugPrint(
                    '🔍 AuthCubit: Token from storage: ${token != null ? "exists" : "null"}');

                if (token != null && token.isNotEmpty) {
                  debugPrint(
                      '🔄 AuthCubit: Manually saving token after auto sign-in...');
                  await saveJwtToken(
                    jwtToken: token,
                    userData: userData,
                  );
                  debugPrint(
                      '✅ AuthCubit: Token saved manually, state should be AuthAuthenticatedState now');
                } else {
                  debugPrint(
                      '❌ AuthCubit: No token found in storage after auto sign-in');
                }
              } catch (e) {
                debugPrint('❌ AuthCubit: Error loading token manually: $e');
              }
            } else {
              debugPrint(
                  '✅ AuthCubit: AuthAuthenticatedState successfully emitted after auto sign-in');
            }
          } catch (e, stackTrace) {
            debugPrint('❌ AuthCubit: Error during auto sign-in: $e');
            debugPrint('❌ Stack trace: $stackTrace');
            // Emit error state
            final currentFormState = _formState;
            if (currentFormState != null) {
              emit(currentFormState.copyWith(
                operationStatus: AuthOperationStatus.error,
                signInErrorMessage:
                    'Auto sign-in failed after sign up. Please sign in manually.',
              ));
            }
          } finally {
            // Always reset flag after sign in completes (success or failure)
            _isAutoSigningIn = false;
            debugPrint('🔄 AuthCubit: Auto sign-in flag reset');
          }
        } else {
          debugPrint('❌ Sign up failed');
          final currentFormState = _formState;
          if (currentFormState != null) {
            emit(currentFormState.copyWith(
              operationStatus: AuthOperationStatus.error,
              signUpErrorMessage: 'Sign up failed. Please try again.',
            ));
          }
        }
      } else {
        debugPrint('❌ Sign up service not configured');
        final currentFormState = _formState;
        if (currentFormState != null) {
          emit(currentFormState.copyWith(
            operationStatus: AuthOperationStatus.error,
            signUpErrorMessage: 'Sign up service not configured',
          ));
        }
      }
    } catch (e) {
      debugPrint('❌ Error during sign up: $e');
      final currentFormState = _formState;
      if (currentFormState != null) {
        emit(currentFormState.copyWith(
          operationStatus: AuthOperationStatus.error,
          signUpErrorMessage:
              'An error occurred during sign up: ${e.toString()}',
        ));
      }
    }
  }

  /// Reset form
  void resetForm() {
    debugPrint('🔄 Resetting auth form');
    emit(const AuthFormState());
  }

  /// Serialize state to JSON for HydratedCubit persistence
  @override
  Map<String, dynamic>? toJson(AuthState state) {
    if (state is AuthAuthenticatedState) {
      // Only persist if jwtToken is valid
      if (state.jwtToken != null && state.jwtToken!.isNotEmpty) {
        return state.toJson();
      }
      // Don't persist authenticated state without valid token
      return null;
    }
    // Don't persist initial, loading, or unauthenticated states
    // Returning null clears the persisted state
    return null;
  }

  /// Deserialize state from JSON for HydratedCubit persistence
  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    try {
      // Check if state has valid authentication data
      // jwtToken must be non-null and non-empty to be considered authenticated
      final jwtToken = json['jwtToken'] as String?;
      final isAuthenticated = json['isAuthenticated'] as bool? ?? false;

      // Only restore authenticated state if jwtToken exists and is not empty
      if (isAuthenticated && jwtToken != null && jwtToken.isNotEmpty) {
        return AuthAuthenticatedState.fromJson(json);
      }
      // If jwtToken is null/empty but state says authenticated, don't restore it
      // This prevents restoring invalid authenticated states after signout
      debugPrint(
          '⚠️ AuthCubit: Restoring unauthenticated state (jwtToken is null/empty)');
      return const AuthUnauthenticatedState();
    } catch (e) {
      debugPrint('❌ AuthCubit: Error deserializing state: $e');
      return const AuthUnauthenticatedState();
    }
  }
}
