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
  /// Address count for this user from Supabase `user_addresses` table.
  final int addressCount;

  const ProfileAuthenticated({
    required this.user,
    this.shouldRedirectToHome = false,
    this.orderCount = 0,
    this.addressCount = 0,
  });

  ProfileAuthenticated copyWith({
    AppUser? user,
    bool? shouldRedirectToHome,
    int? orderCount,
    int? addressCount,
  }) {
    return ProfileAuthenticated(
      user: user ?? this.user,
      shouldRedirectToHome: shouldRedirectToHome ?? this.shouldRedirectToHome,
      orderCount: orderCount ?? this.orderCount,
      addressCount: addressCount ?? this.addressCount,
    );
  }
}

class ProfileUnauthenticated extends ProfileState {
  final bool showLoginView;
  final String? errorMessage;
  const ProfileUnauthenticated({this.showLoginView = true, this.errorMessage});
}