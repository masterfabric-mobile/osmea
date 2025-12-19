import 'dart:async';
import 'package:core/core.dart' hide AuthState;
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/models/app_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'states.dart';

@injectable
class ProfileViewModel extends BaseViewModelCubit<ProfileState> {
  final SupabaseClient _supabaseClient;
  late final StreamSubscription<AuthState> _authSubscription;

  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  late final TextEditingController usernameController;

  ProfileViewModel(this._supabaseClient) : super(ProfileInitial()) {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    usernameController = TextEditingController();

    _authSubscription =
        _supabaseClient.auth.onAuthStateChange.listen((data) async {
      final session = data.session;
      if (session != null) {
        await _fetchUserProfile(session.user.id);
      } else {
        stateChanger(const ProfileUnauthenticated());
      }
    });
  }

  Future<void> initial() async {
    stateChanger(ProfileLoading());
    final currentUser = _supabaseClient.auth.currentUser;
    if (currentUser != null) {
      await _fetchUserProfile(currentUser.id);
    } else {
      stateChanger(const ProfileUnauthenticated());
    }
  }

  Future<void> _fetchUserProfile(String userId) async {
    try {
      final response = await _supabaseClient
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      final user = AppUser.fromJson(response);
      
      // Populate controllers immediately when data is fetched
      usernameController.text = user.username ?? '';
      emailController.text = user.email ?? '';

      stateChanger(ProfileAuthenticated(user: user));
    } catch (e) {
      stateChanger(const ProfileUnauthenticated(errorMessage: "Failed to load profile"));
    }
  }

  void populateUserInfo() {
    if (state is ProfileAuthenticated) {
      final user = (state as ProfileAuthenticated).user;
      usernameController.text = user.username ?? '';
      emailController.text = user.email ?? '';
    }
  }

  Future<void> updateProfile() async {
    if (state is! ProfileAuthenticated) return;
    
    final currentUser = (state as ProfileAuthenticated).user;
    final newUsername = usernameController.text.trim();
    // Email update requires Supabase Auth API and verification usually
    // final newEmail = emailController.text.trim(); 

    stateChanger(ProfileLoading());

    try {
      // 1. Update public.users table (Username, Full Name, etc.)
      final updates = {
        'username': newUsername,
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      final response = await _supabaseClient
          .from('users')
          .update(updates)
          .eq('id', currentUser.id)
          .select()
          .single();

      final updatedUser = AppUser.fromJson(response);
      stateChanger(ProfileAuthenticated(user: updatedUser));

      // 2. Note: Email update is separate in Supabase
      // if (newEmail != currentUser.email) {
      //   await _supabaseClient.auth.updateUser(UserAttributes(email: newEmail));
      //   // This triggers a confirmation email
      // }

    } catch (e) {
       // Restore previous state if error, but we need to keep the user object.
       // Ideally we have a copy. For now, re-fetch.
       stateChanger(ProfileAuthenticated(user: currentUser)); 
       // You might want to use a transient error state or snackbar mechanism here
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
        confirmPasswordController.text.isEmpty ||
        usernameController.text.isEmpty) {
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
        data: {'username': usernameController.text.trim()},
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
    usernameController.clear();
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
    return super.close();
  }
}