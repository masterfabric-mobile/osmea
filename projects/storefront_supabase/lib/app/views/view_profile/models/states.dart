import 'package:storefront_supabase/app/models/app_user.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileAuthenticated extends ProfileState {
  final AppUser user;
  const ProfileAuthenticated({required this.user});
}

class ProfileUnauthenticated extends ProfileState {
  final bool showLoginView;
  final String? errorMessage;
  const ProfileUnauthenticated({this.showLoginView = true, this.errorMessage});
}