import 'package:storefront_supabase/app/models/app_user.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileAuthenticated extends ProfileState {
  final AppUser user;
  final bool shouldRedirectToHome;
  /// Order count for this user from Supabase `orders` table.
  final int orderCount;

  const ProfileAuthenticated({
    required this.user,
    this.shouldRedirectToHome = false,
    this.orderCount = 0,
  });

  ProfileAuthenticated copyWith({
    AppUser? user,
    bool? shouldRedirectToHome,
    int? orderCount,
  }) {
    return ProfileAuthenticated(
      user: user ?? this.user,
      shouldRedirectToHome: shouldRedirectToHome ?? this.shouldRedirectToHome,
      orderCount: orderCount ?? this.orderCount,
    );
  }
}

class ProfileUnauthenticated extends ProfileState {
  final bool showLoginView;
  final String? errorMessage;
  const ProfileUnauthenticated({this.showLoginView = true, this.errorMessage});
}