abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadedState extends LoginState {
  final bool isFormValid;
  final bool isPasswordVisible;
  final bool isLoading;

  LoginLoadedState({
    this.isFormValid = false,
    this.isPasswordVisible = false,
    this.isLoading = false,
  });

  LoginLoadedState copyWith({
    bool? isFormValid,
    bool? isPasswordVisible,
    bool? isLoading,
  }) {
    return LoginLoadedState(
      isFormValid: isFormValid ?? this.isFormValid,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class LoginErrorState extends LoginState {
  final String message;

  LoginErrorState(this.message);
}