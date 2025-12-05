abstract class SettingsState {}

class SettingsInitialState extends SettingsState {}

class SettingsLoadedState extends SettingsState {
  final bool darkModeEnabled;

  SettingsLoadedState({
    required this.darkModeEnabled,
  });
}

class SettingsErrorState extends SettingsState {
  final String message;

  SettingsErrorState(this.message);
}