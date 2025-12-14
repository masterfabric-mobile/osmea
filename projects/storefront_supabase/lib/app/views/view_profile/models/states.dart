class ProfileState {
  final bool isLoggedIn;
  final bool isLoading;
  final bool showLoginView;
  final String? errorMessage;
  final bool isFormValid;
  final String? userRole;

  const ProfileState({
    this.isLoggedIn = false,
    this.isLoading = false,
    this.showLoginView = true,
    this.errorMessage,
    this.isFormValid = false,
    this.userRole,
  });

  ProfileState copyWith({
    bool? isLoggedIn,
    bool? isLoading,
    bool? showLoginView,
    String? errorMessage,
    bool? isFormValid,
    String? userRole,
  }) {
    return ProfileState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      showLoginView: showLoginView ?? this.showLoginView,
      errorMessage: errorMessage,
      isFormValid: isFormValid ?? this.isFormValid,
      userRole: userRole ?? this.userRole,
    );
  }
}