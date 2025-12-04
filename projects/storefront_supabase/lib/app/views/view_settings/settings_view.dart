import 'package:flutter/material.dart';
import 'package:core/core.dart';

import 'models/view_model.dart';
import 'models/states.dart';

class SettingsView
    extends MasterViewCubit<SettingsViewModel, SettingsState> {
  SettingsView({
    super.key,
    super.arguments = const {'init': true},
    required super.goRoute,
  });

  @override
  void initialContent(
    SettingsViewModel viewModel,
    BuildContext context,
  ) {
    viewModel.initial();
  }

  @override
  Widget viewContent(
    BuildContext context,
    SettingsViewModel viewModel,
    SettingsState state,
  ) {
    if (state is SettingsErrorState) {
      return buildError(
        state.message,
        onRetry: () => viewModel.initial(),
      );
    }

    if (state is SettingsLoadedState) {
      return OsmeaComponents.scaffold(
        body: OsmeaComponents.center(
          child: OsmeaComponents.text('Settings Page Content'),
        ),
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
