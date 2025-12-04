abstract class SignupState {}

class SignupInitialState extends SignupState {}

class SignupLoadedState extends SignupState {}

class SignupErrorState extends SignupState {
  final String message;

  SignupErrorState(this.message);
}
