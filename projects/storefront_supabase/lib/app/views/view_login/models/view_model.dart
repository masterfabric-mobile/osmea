import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'states.dart';

@injectable
class LoginViewModel extends BaseViewModelCubit<LoginState> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  bool isPasswordVisible = false;

  LoginViewModel() : super(LoginInitialState()) {
    _initControllers();
  }

  void _initControllers() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    emailController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
  }

  Future<void> initial() async {
    try {
      stateChanger(LoginLoadedState(
        isFormValid: _isFormValid(),
        isPasswordVisible: isPasswordVisible,
        isLoading: false,
      ));
    } catch (e) {
      stateChanger(LoginErrorState('Failed to initialize login view: $e'));
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    if (state is LoginLoadedState) {
      stateChanger(
        (state as LoginLoadedState).copyWith(
          isPasswordVisible: isPasswordVisible,
        ),
      );
    }
  }

  void _validateForm() {
    if (state is LoginLoadedState) {
      stateChanger(
        (state as LoginLoadedState).copyWith(
          isFormValid: _isFormValid(),
        ),
      );
    }
  }

  bool _isFormValid() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    return email.isNotEmpty &&
        password.isNotEmpty &&
        _isValidEmail(email) &&
        password.length >= 6;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (!_isFormValid()) {
      stateChanger(LoginErrorState('Please enter valid email and password (min 6 chars).'));
      return;
    }

    try {
      stateChanger(LoginLoadedState(
        isFormValid: false, // Disable form during loading
        isPasswordVisible: isPasswordVisible,
        isLoading: true,
      ));
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      if (email == 'test@example.com' && password == 'password') { // Use mock credentials
        stateChanger(LoginLoadedState(
          isFormValid: true,
          isPasswordVisible: isPasswordVisible,
          isLoading: false,
        ));
        // TODO: Navigate to home or dashboard on successful login
      } else {
        stateChanger(LoginErrorState('Invalid email or password. Use test@example.com / password'));
      }
    } catch (e) {
      stateChanger(LoginErrorState('Login failed: $e'));
    }
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}