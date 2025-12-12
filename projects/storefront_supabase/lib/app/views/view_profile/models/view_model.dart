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
        _supabaseClient.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      final userRole = session?.user.role;
      stateChanger(state.copyWith(isLoggedIn: session != null, userRole: userRole));
    });
  }

  Future<void> initial() async {
    final currentUser = _supabaseClient.auth.currentUser;
    stateChanger(
        state.copyWith(isLoggedIn: currentUser != null, userRole: currentUser?.role));
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
            isLoading: false, errorMessage: 'Login failed. Please check your credentials.'));
      } else {
        _clearFieldsAndErrors();
        final userRole = response.user?.role;
        stateChanger(state.copyWith(isLoading: false, isLoggedIn: true, userRole: userRole));
      }
    } on AuthException catch (e) {
      stateChanger(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      stateChanger(
          state.copyWith(isLoading: false, errorMessage: 'An unexpected error occurred.'));
    }
  }

  Future<void> signup() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      stateChanger(state.copyWith(
          errorMessage: 'Please fill all fields.'));
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
      // We will treat it as logged in for simplicity, but a real app should handle email verification.
      if (response.user != null) {
         _clearFieldsAndErrors();
         stateChanger(state.copyWith(isLoading: false, isLoggedIn: true, showLoginView: true, errorMessage: 'Success! Please check your email to confirm your registration.'));
      } else {
         stateChanger(state.copyWith(isLoading: false, errorMessage: 'Signup failed. Please try again.'));
      }
    } on AuthException catch (e) {
      stateChanger(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      stateChanger(
          state.copyWith(isLoading: false, errorMessage: 'An unexpected error occurred.'));
    }
  }

  Future<void> logout() async {
    stateChanger(state.copyWith(isLoading: true));
    await _supabaseClient.auth.signOut();
    _clearFieldsAndErrors();
    stateChanger(const ProfileState(isLoggedIn: false, showLoginView: true, userRole: null));
  }

  void _clearFieldsAndErrors() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    stateChanger(state.copyWith(errorMessage: null));
  }

  void dispose() {
    _authSubscription.cancel();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}