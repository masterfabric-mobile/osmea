import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:storefront_supabase/app/core/bloc/language/language_cubit.dart';
import 'package:storefront_supabase/l10n/app_localizations.dart';

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
            title: OsmeaComponents.text(AppLocalizations.of(context)!.language),
            leading: const Icon(Icons.language),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageSheet(context),
          ),
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

  void _showLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇺🇸'),
              title: const Text('English'),
              onTap: () {
                context.read<LanguageCubit>().changeLanguage(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text('🇹🇷'),
              title: const Text('Türkçe'),
              onTap: () {
                context.read<LanguageCubit>().changeLanguage(const Locale('tr'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text('🇩🇪'),
              title: const Text('Deutsch'),
              onTap: () {
                context.read<LanguageCubit>().changeLanguage(const Locale('de'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text('🇫🇷'),
              title: const Text('Français'),
              onTap: () {
                context.read<LanguageCubit>().changeLanguage(const Locale('fr'));
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}