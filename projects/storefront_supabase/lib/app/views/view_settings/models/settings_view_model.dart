import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:injectable/injectable.dart';

import 'module/states.dart';

@injectable
class SettingsViewModel extends BaseViewModelCubit<SettingsState> {
  SettingsViewModel() : super(SettingsInitialState());

  Future<void> initial() async {
    try {
      // Simulate fetching user settings
      await Future.delayed(const Duration(milliseconds: 300));
      stateChanger(
        SettingsLoadedState(
          darkModeEnabled: false, // Default value
        ),
      );
    } catch (e) {
      stateChanger(SettingsErrorState('Failed to load settings: $e'));
    }
  }

  void toggleDarkMode(bool value) {
    if (state is SettingsLoadedState) {
      stateChanger(
        SettingsLoadedState(
          darkModeEnabled: value,
        ),
      );
      // In a real app, you would save this setting to preferences/backend
    }
  }
}