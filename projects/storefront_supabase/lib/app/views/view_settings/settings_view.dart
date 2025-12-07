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
  }) : super(
          horizontalPadding: const PaddingVisibility.disabled(),
          appBarPadding: const AppBarPaddingVisibility.disabled(),
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text(
              'Settings',
              color: Theme.of(context).colorScheme.onPrimary, // Text color matches onPrimary
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            size: AppBarSize.large,
            elevation: 0,
            titleSpacing: 0.0,
            leading: OsmeaComponents.iconButton(
              onPressed: () => goRoute('/profile'),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        );

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
      return ListView(
        children: [
          OsmeaComponents.listItem(
            title: OsmeaComponents.text('Dark Mode'),
            leading: const Icon(Icons.dark_mode),
            trailing: Switch(
              value: state.darkModeEnabled,
              onChanged: (value) => viewModel.toggleDarkMode(value),
            ),
          ),
        ],
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}