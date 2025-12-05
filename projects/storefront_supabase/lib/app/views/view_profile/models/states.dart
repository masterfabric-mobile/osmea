class ProfileState {
  final bool isLoggedIn;
  final bool isLoading;
  final bool showLoginView;
  final String? errorMessage;
  final bool isFormValid;

  const ProfileState({
    this.isLoggedIn = false,
    this.isLoading = false,
    this.showLoginView = true,
    this.errorMessage,
    this.isFormValid = false,
  });

  ProfileState copyWith({
    bool? isLoggedIn,
    bool? isLoading,
    bool? showLoginView,
    String? errorMessage,
    bool? isFormValid,
  }) {
    return ProfileState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      showLoginView: showLoginView ?? this.showLoginView,
      errorMessage: errorMessage, // Allow setting null error message
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }
}