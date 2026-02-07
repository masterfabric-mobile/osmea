import 'package:storefront_supabase/app/models/app_user.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileAuthenticated extends ProfileState {
  final AppUser user;
  final bool shouldRedirectToHome; // New field

  const ProfileAuthenticated({
    required this.user,
    this.shouldRedirectToHome = false, // Default to false
  });

  // Add copyWith for convenience
  ProfileAuthenticated copyWith({
    AppUser? user,
    bool? shouldRedirectToHome,
  }) {
    return ProfileAuthenticated(
      user: user ?? this.user,
      shouldRedirectToHome: shouldRedirectToHome ?? this.shouldRedirectToHome,
    );
  }
}

class ProfileUnauthenticated extends ProfileState {
  final bool showLoginView;
  final String? errorMessage;
  const ProfileUnauthenticated({this.showLoginView = true, this.errorMessage});
}