import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'states.dart';

@injectable
class ChangePasswordViewModel extends BaseViewModelCubit<ChangePasswordState> {
  final SupabaseClient _supabaseClient;

  late final TextEditingController newPasswordController;
  late final TextEditingController confirmNewPasswordController;

  ChangePasswordViewModel(this._supabaseClient) : super(ChangePasswordInitial()) {
    newPasswordController = TextEditingController();
    confirmNewPasswordController = TextEditingController();
  }

  void initial() {
    stateChanger(ChangePasswordLoaded());
  }

  Future<bool> changePassword() async {
    if (newPasswordController.text.isEmpty || confirmNewPasswordController.text.isEmpty) {
      stateChanger(ChangePasswordError('Please enter both new password and confirmation.'));
      return false;
    }
    
    if (newPasswordController.text != confirmNewPasswordController.text) {
      stateChanger(ChangePasswordError('Passwords do not match.'));
      return false;
    }

    stateChanger(ChangePasswordLoading());
    try {
      await _supabaseClient.auth.updateUser(
        UserAttributes(password: newPasswordController.text),
      );
      
      // Clear fields on success
      newPasswordController.clear();
      confirmNewPasswordController.clear();
      stateChanger(ChangePasswordLoaded()); // Return to loaded state without error
      return true;
    } on AuthException catch (e) {
      stateChanger(ChangePasswordError(e.message));
      return false;
    } catch (e) {
      stateChanger(ChangePasswordError('An unexpected error occurred: $e'));
      return false;
    }
  }

  @override
  Future<void> close() {
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    return super.close();
  }
}
