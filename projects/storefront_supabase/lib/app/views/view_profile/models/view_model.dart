import 'dart:async';
import 'package:core/core.dart' hide AuthState;
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'states.dart';

@injectable
@injectable
class ProfileViewModel extends BaseViewModelCubit<ProfileState> {
  final SupabaseClient _supabaseClient;
  late final StreamSubscription<AuthState> _authSubscription;

  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  ProfileViewModel(this._supabaseClient) : super(ProfileInitial()) {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    _authSubscription =
        _supabaseClient.auth.onAuthStateChange.listen((data) async {
      final session = data.session;
      if (session != null) {
        await _fetchAndSetUserRole(session.user.id);
      } else {
        stateChanger(const ProfileUnauthenticated());
      }
    });
  }

  Future<void> initial() async {
    stateChanger(ProfileLoading());
    final currentUser = _supabaseClient.auth.currentUser;
    if (currentUser != null) {
      await _fetchAndSetUserRole(currentUser.id);
    } else {
      stateChanger(const ProfileUnauthenticated());
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
      stateChanger(ProfileAuthenticated(userRole: userRole));
    } catch (e) {
      stateChanger(const ProfileAuthenticated(userRole: 'customer'));
    }
  }

  void switchToLogin() {
    _clearFieldsAndErrors();
    stateChanger(const ProfileUnauthenticated(showLoginView: true));
  }

  void switchToSignup() {
    _clearFieldsAndErrors();
    stateChanger(const ProfileUnauthenticated(showLoginView: false));
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      stateChanger(const ProfileUnauthenticated(
          errorMessage: 'Please enter email and password.'));
      return;
    }
    stateChanger(ProfileLoading());
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (response.user == null) {
        stateChanger(const ProfileUnauthenticated(
            errorMessage: 'Login failed. Please check your credentials.'));
      } else {
        _clearFieldsAndErrors();
        // The listener will handle the state change
      }
    } on AuthException catch (e) {
      stateChanger(ProfileUnauthenticated(errorMessage: e.message));
    } catch (e) {
      stateChanger(const ProfileUnauthenticated(
          errorMessage: 'An unexpected error occurred.'));
    }
  }

  Future<void> signup() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      stateChanger(
          const ProfileUnauthenticated(errorMessage: 'Please fill all fields.'));
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      stateChanger(
          const ProfileUnauthenticated(errorMessage: 'Passwords do not match.'));
      return;
    }
    stateChanger(ProfileLoading());

    try {
      final response = await _supabaseClient.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (response.user != null) {
        _clearFieldsAndErrors();
        stateChanger(const ProfileUnauthenticated(
            showLoginView: true,
            errorMessage:
                'Success! Please check your email to confirm your registration.'));
      } else {
        stateChanger(const ProfileUnauthenticated(
            errorMessage: 'Signup failed. Please try again.'));
      }
    } on AuthException catch (e) {
      stateChanger(ProfileUnauthenticated(errorMessage: e.message));
    } catch (e) {
      stateChanger(const ProfileUnauthenticated(
          errorMessage: 'An unexpected error occurred.'));
    }
  }

  Future<void> logout() async {
    stateChanger(ProfileLoading());
    await _supabaseClient.auth.signOut();
    _clearFieldsAndErrors();
  }

  void _clearFieldsAndErrors() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
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