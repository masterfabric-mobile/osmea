abstract class ChangePasswordState {}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordLoaded extends ChangePasswordState {
  final String? errorMessage;
  ChangePasswordLoaded({this.errorMessage});
}

class ChangePasswordError extends ChangePasswordState {
  final String message;
  ChangePasswordError(this.message);
}
