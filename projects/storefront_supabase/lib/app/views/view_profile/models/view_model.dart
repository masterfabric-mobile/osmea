import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'states.dart';

@injectable
class ProfileViewModel extends BaseViewModelCubit<ProfileState> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  ProfileViewModel() : super(const ProfileState()) {
    emailController = TextEditingController()..addListener(_validateForm);
    passwordController = TextEditingController()..addListener(_validateForm);
    confirmPasswordController = TextEditingController()..addListener(_validateForm);
  }

  @override
  Future<void> initial() async {
    // In a real app, you would check the actual authentication status here.
    _validateForm();
  }

  void _validateForm() {
    final pass = passwordController.text;
    final isPasswordValid = pass.length >= 10 &&
        pass.contains(RegExp(r'[A-Z]')) &&
        pass.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));

    final arePasswordsMatching =
        !state.showLoginView ? pass == confirmPasswordController.text : true;

    stateChanger(state.copyWith(
      isFormValid: isPasswordValid && arePasswordsMatching && emailController.text.isNotEmpty,
    ));
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
    if (!state.isFormValid) return;
    stateChanger(state.copyWith(isLoading: true, errorMessage: null));
    await Future.delayed(const Duration(seconds: 1));

    if (emailController.text == 'test@osmea.com' &&
        passwordController.text == 'Password123!') {
      stateChanger(state.copyWith(isLoading: false, isLoggedIn: true));
    } else {
      stateChanger(state.copyWith(
          isLoading: false, errorMessage: 'Invalid credentials. Please try again.'));
    }
  }

  Future<void> signup() async {
    if (!state.isFormValid) return;
    stateChanger(state.copyWith(isLoading: true, errorMessage: null));
    await Future.delayed(const Duration(seconds: 1));

    // Final check before "API call"
    if (passwordController.text != confirmPasswordController.text) {
      stateChanger(state.copyWith(isLoading: false, errorMessage: 'Passwords do not match.'));
      return;
    }
    // Simulate successful signup
    stateChanger(state.copyWith(isLoading: false, isLoggedIn: true));
  }

  Future<void> logout() async {
    stateChanger(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(seconds: 1));
    _clearFieldsAndErrors();
    stateChanger(const ProfileState(isLoggedIn: false, showLoginView: true));
  }

  void _clearFieldsAndErrors() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    stateChanger(state.copyWith(errorMessage: null, isFormValid: false));
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}