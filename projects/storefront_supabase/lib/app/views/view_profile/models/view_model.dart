import 'dart:async';
import 'package:core/core.dart' hide AuthState;
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'states.dart';

@injectable
class ProfileViewModel extends BaseViewModelCubit<ProfileState> {
  final SupabaseClient _supabaseClient;
  late final StreamSubscription<AuthState> _authSubscription;

  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  ProfileViewModel(this._supabaseClient) : super(const ProfileState()) {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    _authSubscription =
        _supabaseClient.auth.onAuthStateChange.listen((data) async {
      final session = data.session;
      if (session != null) {
        await _fetchAndSetUserRole(session.user.id);
      } else {
        stateChanger(
            const ProfileState(isLoggedIn: false, userRole: null));
      }
    });
  }

  Future<void> initial() async {
    final currentUser = _supabaseClient.auth.currentUser;
    if (currentUser != null) {
      await _fetchAndSetUserRole(currentUser.id);
    } else {
      stateChanger(const ProfileState(isLoggedIn: false, userRole: null));
    }
  }

  Future<void> _fetchAndSetUserRole(String userId) async {
    try {
      final response = await _supabaseClient
          .from('users')
          .select('role')
          .eq('id', userId)
          .single();

      final userRole = response['role'] as String?;
      stateChanger(state.copyWith(isLoggedIn: true, userRole: userRole));
    } catch (e) {
      // If fetching profile fails, still log them in but with a default role
      stateChanger(state.copyWith(isLoggedIn: true, userRole: 'customer'));
    }
  }

  void switchToLogin() {
    _clearFieldsAndErrors();
    stateChanger(state.copyWith(showLoginView: true));
  }

  void switchToSignup() {
    _clearFieldsAndErrors();
    stateChanger(state.copyWith(showLoginView: false));
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      stateChanger(
          state.copyWith(errorMessage: 'Please enter email and password.'));
      return;
    }
    stateChanger(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (response.user == null) {
        stateChanger(state.copyWith(
            isLoading: false,
            errorMessage: 'Login failed. Please check your credentials.'));
      } else {
        _clearFieldsAndErrors();
        // The onAuthStateChange listener will handle fetching the role.
        // We just need to set loading to false.
        stateChanger(state.copyWith(isLoading: false));
      }
    } on AuthException catch (e) {
      stateChanger(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      stateChanger(state.copyWith(
          isLoading: false, errorMessage: 'An unexpected error occurred.'));
    }
  }

  Future<void> signup() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      stateChanger(state.copyWith(errorMessage: 'Please fill all fields.'));
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      stateChanger(state.copyWith(errorMessage: 'Passwords do not match.'));
      return;
    }
    stateChanger(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final response = await _supabaseClient.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // Supabase sends a confirmation email by default.
      if (response.user != null) {
        _clearFieldsAndErrors();
        stateChanger(state.copyWith(
            isLoading: false,
            isLoggedIn: false, // User is not logged in until email confirmed
            showLoginView: true,
            errorMessage:
                'Success! Please check your email to confirm your registration.'));
      } else {
        stateChanger(state.copyWith(
            isLoading: false, errorMessage: 'Signup failed. Please try again.'));
      }
    } on AuthException catch (e) {
      stateChanger(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      stateChanger(state.copyWith(
          isLoading: false, errorMessage: 'An unexpected error occurred.'));
    }
  }

  Future<void> logout() async {
    stateChanger(state.copyWith(isLoading: true));
    await _supabaseClient.auth.signOut();
    _clearFieldsAndErrors();
    // The onAuthStateChange listener will catch this and update the state
    // to logged out.
  }

  void _clearFieldsAndErrors() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    if (state.errorMessage != null) {
        stateChanger(ProfileState(
          isLoggedIn: state.isLoggedIn,
          isLoading: state.isLoading,
          showLoginView: state.showLoginView,
          isFormValid: state.isFormValid,
          userRole: state.userRole,
          errorMessage: null,
        ));
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}