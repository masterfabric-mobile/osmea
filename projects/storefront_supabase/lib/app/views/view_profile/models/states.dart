abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileAuthenticated extends ProfileState {
  final String? userRole;
  const ProfileAuthenticated({required this.userRole});
}

class ProfileUnauthenticated extends ProfileState {
  final bool showLoginView;
  final String? errorMessage;
  const ProfileUnauthenticated({this.showLoginView = true, this.errorMessage});
}