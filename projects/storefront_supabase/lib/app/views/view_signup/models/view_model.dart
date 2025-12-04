import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import 'states.dart';

@injectable
class SignupViewModel extends BaseViewModelCubit<SignupState> {
  SignupViewModel() : super(SignupInitialState());

  Future<void> initial() async {
    try {
      // Simulate initial loading
      await Future.delayed(const Duration(milliseconds: 300));
      stateChanger(SignupLoadedState());
    } catch (e) {
      stateChanger(SignupErrorState('Failed to initialize signup view: $e'));
    }
  }

  Future<void> signup(String email, String password) async {
    try {
      // Simulate API call
      stateChanger(SignupInitialState()); // Show loading indicator
      await Future.delayed(const Duration(seconds: 1));
      if (email.contains('@') && password.length >= 6) {
        stateChanger(SignupLoadedState());
        // In a real app, navigate to home or login
      } else {
        stateChanger(SignupErrorState('Invalid email or password (min 6 chars)'));
      }
    } catch (e) {
      stateChanger(SignupErrorState('Signup failed: $e'));
    }
  }
}
